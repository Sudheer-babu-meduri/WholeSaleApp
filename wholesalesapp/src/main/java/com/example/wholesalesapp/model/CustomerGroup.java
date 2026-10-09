package com.example.wholesalesapp.model;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Data;

@Entity
@Table(name = "customer_groups")
@Data
public class CustomerGroup {

    @Id
    private Long id;

    private String name;

    private String description;

    private String status;
}