package com.example.wholesalesapp.model;

import com.fasterxml.jackson.annotation.JsonIgnore;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.Data;

@Entity
@Table(name = "supplier_products")
@Data
public class SupplierProduct {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "supplier_id")
    @JsonIgnore
    private Supplier supplier;

    @Column(name = "product_id")
    private Long productId;

    @Column(name = "supplier_sku")
    private String supplierSku;

    @Column(name = "lead_time_days")
    private Integer leadTimeDays;

    @Column(name = "min_order_qty")
    private Integer minOrderQty;

    @Column(name = "purchase_price")
    private java.math.BigDecimal purchasePrice;

    private String status;
}