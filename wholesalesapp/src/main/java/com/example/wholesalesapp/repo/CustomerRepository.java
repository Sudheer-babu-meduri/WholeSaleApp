package com.example.wholesalesapp.repo;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.wholesalesapp.model.Customer;

public interface CustomerRepository extends JpaRepository<Customer, Long> {


	
}
