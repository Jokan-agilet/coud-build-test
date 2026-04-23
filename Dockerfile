# --- ステージ1: ビルド（Maven環境） ---
FROM maven:3.9-eclipse-temurin-21-alpine AS builder
WORKDIR /app

# 1. 設定ファイルとラッパーをコピー
# Maven Wrapperに関連するファイル一式を先にコピーするのがコツです
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .

# 2.Mavenファイル実行の権限を付与
RUN chmod +x mvnw

# 3. 依存ライブラリをダウンロード（キャッシュ利用）
RUN ./mvnw dependency:go-offline -B

# 4. ソースコードをコピーしてビルド
COPY src src
RUN ./mvnw package -DskipTests

# --- ステージ2: 実行（軽量JRE） ---
FROM eclipse-temurin:25-jre-alpine
WORKDIR /app

# ステージ1で作成されたJAR（通常 target/ フォルダ内）をコピー
# ※JAR名は pom.xml の設定に依存するため、ワイルドカードを使うのが安全です
COPY --from=builder /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]