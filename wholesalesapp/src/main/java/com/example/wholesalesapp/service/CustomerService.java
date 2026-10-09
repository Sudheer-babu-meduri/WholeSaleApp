package com.example.wholesalesapp.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.example.wholesalesapp.model.Customer;
import com.example.wholesalesapp.repo.CustomerRepository;

@Service
public class CustomerService {

	private final CustomerRepository customerRepo;
	
	public CustomerService(CustomerRepository customerRepo) {
		this.customerRepo = customerRepo;
	}
	
	
	public List<Customer> getAllCustomers(){
		return customerRepo.findAll();
	}
}
