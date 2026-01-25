package com.example.springbootdemo.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {

    @GetMapping("/")
    public String root() {
        return "Welcome to Spring Boot Demo";
    }

    @GetMapping("/hello")
    public String hello() {
        return "Hello from Spring Boot";
    }
}
