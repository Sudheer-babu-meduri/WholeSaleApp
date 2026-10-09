package com.example.wholesalesapp.repo;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import com.example.wholesalesapp.model.Supplier;

public interface SupplierRepo extends JpaRepository<Supplier, Long> {

	@Query("""
	        SELECT DISTINCT s
	        FROM Supplier s
	        LEFT JOIN FETCH s.supplierProducts
	        """)
	    List<Supplier> findAllSuppliersWithProducts();
	
}