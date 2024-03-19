package com.example.isproject.controllers;

import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.util.MimeType;
import org.springframework.util.MimeTypeUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import java.net.URI;
import java.util.List;

@Controller
@RequestMapping("/")
public class RootController {

    @GetMapping("")
    public ResponseEntity<Object> resolveDefaultLocation(HttpServletRequest request){
        String acceptTypeString = request.getHeader(HttpHeaders.ACCEPT);
        if (acceptTypeString != null) {
            List<MimeType> expectedMimeTypes = MimeTypeUtils.parseMimeTypes(acceptTypeString);
            if (expectedMimeTypes.stream().anyMatch(t -> t.equalsTypeAndSubtype(MimeTypeUtils.TEXT_HTML))) {
                return ResponseEntity.status(HttpStatus.FOUND).location(URI.create("/index")).build();
            }
        }
        return ResponseEntity.status(HttpStatus.FOUND).location(URI.create("/index")).build();
    }

}