package com.example.coud_build_test.controller;

import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.GetMapping;


@RestController
public class TestController {

    @GetMapping("test")
    public String test() throws Exception {
        System.err.println("★★★★クラウドビルドテストです！！");
        return "★夜の星★";
    }
}
