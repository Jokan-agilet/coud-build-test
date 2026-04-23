# --- ステージ1: ビルド（重いJDKを使用） ---
FROM eclipse-temurin:21-jdk-alpine AS builder
WORKDIR /app

# 1. Gradleの実行環境（ラッパー）をコピー
COPY gradlew .
COPY gradle gradle
COPY build.gradle settings.gradle ./

# 2. 依存関係のキャッシュ（ライブラリのDL時間を短縮）
RUN ./gradlew build -x test --no-daemon > /dev/null 2>&1 || true

# 3. ソースコードをコピーしてJARを作成
COPY src src
RUN ./gradlew bootJar --no-daemon -x test

# --- ステージ2: 実行（軽量なJREのみを使用） ---
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

# ステージ1で作成されたJARファイルだけを抽出してコピー
COPY --from=builder /app/build/libs/*.jar app.jar

# 実行ポートを明示（Spring Bootのデフォルトは8080）
EXPOSE 8080

# アプリケーションの起動コマンド
ENTRYPOINT ["java", "-jar", "app.jar"]