package com.example.demo;

import org.springframework.boot.SpringApplication;
import com.google.common.cache.CacheBuilder;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class DockerSpringDemoAppApplication {

	public static void main(String[] args) {
		SpringApplication.run(DockerSpringDemoAppApplication.class, args);
		var cache = CacheBuilder.newBuilder().build();
		cache.put("Hello", "Welcome to Java");
		System.out.println(cache.getIfPresent("Hello"));
	}

}
