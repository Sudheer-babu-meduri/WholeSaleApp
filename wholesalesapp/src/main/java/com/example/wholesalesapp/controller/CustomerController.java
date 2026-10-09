package com.example.wholesalesapp.controller;

import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.wholesalesapp.model.Customer;
import com.example.wholesalesapp.service.CustomerService;

@RestController
@RequestMapping("api/customers")
public class CustomerController {

	private final CustomerService customerService;
	
	public CustomerController(CustomerService customerService) {
		this.customerService = customerService;
	}
	
	@GetMapping()
	public List<Customer> getAllCustomers() {
        return customerService.getAllCustomers();
    }
}


