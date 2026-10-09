package com.example.wholesalesapp.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.wholesalesapp.model.Supplier;
import com.example.wholesalesapp.repo.SupplierRepo;

@Service
public class SupplierService {

    private final SupplierRepo supplierRepo;

    public SupplierService(SupplierRepo supplierRepo) {
        this.supplierRepo = supplierRepo;
    }

    @Transactional(readOnly = true)
    public List<Supplier> getAllSuppliers() {
        return supplierRepo.findAllSuppliersWithProducts();
    }
}