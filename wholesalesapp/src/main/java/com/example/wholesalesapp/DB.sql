-- ============================================================
-- WHOLESALE SUPPLIER - CUSTOMER APPLICATION
-- 35 TABLE DATABASE
-- MySQL Version
-- ============================================================


-- ============================================================
-- 1. ORGANIZATION & USERS
-- ============================================================

CREATE TABLE organizations (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200),
    type VARCHAR(50),
    gst_number VARCHAR(30),
    pan_number VARCHAR(20),
    address VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100),
    pincode VARCHAR(10),
    phone VARCHAR(20),
    email VARCHAR(150),
    website VARCHAR(150),
    status VARCHAR(20),
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);


CREATE TABLE branches (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    organization_id BIGINT,
    name VARCHAR(150),
    code VARCHAR(50),
    address VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    pincode VARCHAR(10),
    phone VARCHAR(20),
    email VARCHAR(150),
    is_head_office BOOLEAN,
    status VARCHAR(20),
    created_at TIMESTAMP,
    updated_at TIMESTAMP,

    CONSTRAINT fk_branches_organization
        FOREIGN KEY (organization_id)
        REFERENCES organizations(id)
);


CREATE TABLE users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    branch_id BIGINT,
    name VARCHAR(100),
    email VARCHAR(150),
    mobile VARCHAR(20),
    password_hash VARCHAR(255),
    status VARCHAR(20),
    last_login TIMESTAMP,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,

    CONSTRAINT fk_users_branch
        FOREIGN KEY (branch_id)
        REFERENCES branches(id)
);


CREATE TABLE roles (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    description VARCHAR(255),
    status VARCHAR(20),
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);


CREATE TABLE user_roles (
    user_id BIGINT,
    role_id BIGINT,
    created_at TIMESTAMP,

    PRIMARY KEY (user_id, role_id),

    CONSTRAINT fk_user_roles_user
        FOREIGN KEY (user_id)
        REFERENCES users(id),

    CONSTRAINT fk_user_roles_role
        FOREIGN KEY (role_id)
        REFERENCES roles(id)
);


-- ============================================================
-- 2. PRODUCT CATALOGUE
-- ============================================================

CREATE TABLE categories (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    parent_id BIGINT,
    name VARCHAR(100),
    description TEXT,
    image_url VARCHAR(255),
    sort_order INT,
    status VARCHAR(20),
    created_at TIMESTAMP,
    updated_at TIMESTAMP,

    CONSTRAINT fk_categories_parent
        FOREIGN KEY (parent_id)
        REFERENCES categories(id)
);


CREATE TABLE brands (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    description TEXT,
    logo_url VARCHAR(255),
    status VARCHAR(20),
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);


CREATE TABLE products (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    category_id BIGINT,
    brand_id BIGINT,
    name VARCHAR(150),
    product_code VARCHAR(50),
    description TEXT,
    hsn_code VARCHAR(20),
    gst_rate DECIMAL(5,2),
    status VARCHAR(20),
    created_at TIMESTAMP,
    updated_at TIMESTAMP,

    CONSTRAINT fk_products_category
        FOREIGN KEY (category_id)
        REFERENCES categories(id),

    CONSTRAINT fk_products_brand
        FOREIGN KEY (brand_id)
        REFERENCES brands(id)
);


CREATE TABLE units (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    short_name VARCHAR(20),
    unit_type VARCHAR(30),
    conversion_factor DECIMAL(13,4),
    status VARCHAR(20)
);


CREATE TABLE product_variants (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    product_id BIGINT,
    unit_id BIGINT,
    sku VARCHAR(100),
    variant_name VARCHAR(100),
    pack_size DECIMAL(12,2),
    barcode VARCHAR(100),
    mrp DECIMAL(12,2),
    status VARCHAR(20),
    created_at TIMESTAMP,
    updated_at TIMESTAMP,

    CONSTRAINT fk_product_variants_product
        FOREIGN KEY (product_id)
        REFERENCES products(id),

    CONSTRAINT fk_product_variants_unit
        FOREIGN KEY (unit_id)
        REFERENCES units(id)
);


CREATE TABLE product_images (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    product_id BIGINT,
    image_url VARCHAR(255),
    image_type VARCHAR(30),
    is_primary BOOLEAN,
    sort_order INT,

    CONSTRAINT fk_product_images_product
        FOREIGN KEY (product_id)
        REFERENCES products(id)
);


-- ============================================================
-- 3. CUSTOMERS & SUPPLIERS
-- ============================================================

CREATE TABLE customer_groups (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    description VARCHAR(250),
    status VARCHAR(20),
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);


CREATE TABLE customers (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    customer_group_id BIGINT,
    customer_code VARCHAR(50),
    name VARCHAR(200),
    mobile VARCHAR(20),
    email VARCHAR(150),
    gst_number VARCHAR(30),
    pan_number VARCHAR(20),
    credit_limit DECIMAL(15,2),
    credit_days INT,
    status VARCHAR(20),
    created_at TIMESTAMP,
    updated_at TIMESTAMP,

    CONSTRAINT fk_customers_customer_group
        FOREIGN KEY (customer_group_id)
        REFERENCES customer_groups(id)
);


CREATE TABLE customer_addresses (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    customer_id BIGINT,
    address_type VARCHAR(20),
    address_line1 VARCHAR(255),
    address_line2 VARCHAR(255),
    city VARCHAR(100),
    district VARCHAR(100),
    state VARCHAR(100),
    pincode VARCHAR(10),
    is_default BOOLEAN,

    CONSTRAINT fk_customer_addresses_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(id)
);


CREATE TABLE suppliers (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    supplier_code VARCHAR(50),
    name VARCHAR(200),
    contact_person VARCHAR(100),
    mobile VARCHAR(20),
    email VARCHAR(150),
    gst_number VARCHAR(30),
    pan_number VARCHAR(20),
    address VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    pincode VARCHAR(10),
    status VARCHAR(20),
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);


CREATE TABLE supplier_products (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    supplier_id BIGINT,
    product_id BIGINT,
    lead_time_days INT,
    min_order_qty DECIMAL(12,2),
    status VARCHAR(20),

    CONSTRAINT fk_supplier_products_supplier
        FOREIGN KEY (supplier_id)
        REFERENCES suppliers(id),

    CONSTRAINT fk_supplier_products_product
        FOREIGN KEY (product_id)
        REFERENCES products(id)
);


-- ============================================================
-- 4. PRICING
-- ============================================================

CREATE TABLE price_lists (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    description VARCHAR(255),
    customer_group_id BIGINT,
    is_default BOOLEAN,
    status VARCHAR(20),
    created_at TIMESTAMP,
    updated_at TIMESTAMP,

    CONSTRAINT fk_price_lists_customer_group
        FOREIGN KEY (customer_group_id)
        REFERENCES customer_groups(id)
);


CREATE TABLE product_prices (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    product_variant_id BIGINT,
    price_list_id BIGINT,
    min_quantity DECIMAL(12,3),
    max_quantity DECIMAL(12,3),
    price DECIMAL(12,2),
    effective_from DATE,
    effective_to DATE,
    status VARCHAR(20),

    CONSTRAINT fk_product_prices_variant
        FOREIGN KEY (product_variant_id)
        REFERENCES product_variants(id),

    CONSTRAINT fk_product_prices_price_list
        FOREIGN KEY (price_list_id)
        REFERENCES price_lists(id)
);


CREATE TABLE customer_product_prices (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    customer_id BIGINT,
    product_variant_id BIGINT,
    price DECIMAL(12,2),
    effective_from DATE,
    effective_to DATE,
    status VARCHAR(20),

    CONSTRAINT fk_customer_product_prices_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(id),

    CONSTRAINT fk_customer_product_prices_variant
        FOREIGN KEY (product_variant_id)
        REFERENCES product_variants(id)
);


-- ============================================================
-- 5. WAREHOUSE & INVENTORY
-- ============================================================

CREATE TABLE warehouses (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    branch_id BIGINT,
    name VARCHAR(150),
    location VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    pincode VARCHAR(10),
    capacity DECIMAL(15,2),
    type VARCHAR(30),
    status VARCHAR(20),
    created_at TIMESTAMP,
    updated_at TIMESTAMP,

    CONSTRAINT fk_warehouses_branch
        FOREIGN KEY (branch_id)
        REFERENCES branches(id)
);


CREATE TABLE inventory (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    warehouse_id BIGINT,
    product_variant_id BIGINT,
    available_qty DECIMAL(15,3),
    reserved_qty DECIMAL(15,3),
    damaged_qty DECIMAL(15,3),
    reorder_level DECIMAL(15,3),
    updated_at TIMESTAMP,

    CONSTRAINT fk_inventory_warehouse
        FOREIGN KEY (warehouse_id)
        REFERENCES warehouses(id),

    CONSTRAINT fk_inventory_product_variant
        FOREIGN KEY (product_variant_id)
        REFERENCES product_variants(id)
);


CREATE TABLE product_batches (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    product_variant_id BIGINT,
    warehouse_id BIGINT,
    batch_number VARCHAR(100),
    lot_number VARCHAR(100),
    manufacturing_date DATE,
    expiry_date DATE,
    quantity DECIMAL(15,3),
    purchase_price DECIMAL(12,2),
    status VARCHAR(20),

    CONSTRAINT fk_product_batches_product_variant
        FOREIGN KEY (product_variant_id)
        REFERENCES product_variants(id),

    CONSTRAINT fk_product_batches_warehouse
        FOREIGN KEY (warehouse_id)
        REFERENCES warehouses(id)
);


CREATE TABLE stock_transactions (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    warehouse_id BIGINT,
    product_variant_id BIGINT,
    transaction_type VARCHAR(30),
    quantity DECIMAL(15,3),
    reference_type VARCHAR(50),
    reference_id BIGINT,
    transaction_date TIMESTAMP,
    created_by BIGINT,

    CONSTRAINT fk_stock_transactions_warehouse
        FOREIGN KEY (warehouse_id)
        REFERENCES warehouses(id),

    CONSTRAINT fk_stock_transactions_product_variant
        FOREIGN KEY (product_variant_id)
        REFERENCES product_variants(id),

    CONSTRAINT fk_stock_transactions_created_by
        FOREIGN KEY (created_by)
        REFERENCES users(id)
);


-- ============================================================
-- 6. PROCUREMENT (PURCHASE)
-- ============================================================

CREATE TABLE purchase_orders (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    po_number VARCHAR(50),
    supplier_id BIGINT,
    warehouse_id BIGINT,
    order_date DATE,
    expected_delivery DATE,
    subtotal DECIMAL(15,2),
    tax_amount DECIMAL(15,2),
    total_amount DECIMAL(15,2),
    status VARCHAR(30),
    created_by BIGINT,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,

    CONSTRAINT fk_purchase_orders_supplier
        FOREIGN KEY (supplier_id)
        REFERENCES suppliers(id),

    CONSTRAINT fk_purchase_orders_warehouse
        FOREIGN KEY (warehouse_id)
        REFERENCES warehouses(id),

    CONSTRAINT fk_purchase_orders_created_by
        FOREIGN KEY (created_by)
        REFERENCES users(id)
);


CREATE TABLE purchase_order_items (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    purchase_order_id BIGINT,
    product_variant_id BIGINT,
    quantity DECIMAL(15,3),
    unit_price DECIMAL(12,2),
    tax_amount DECIMAL(12,2),
    expected_date DATE,

    CONSTRAINT fk_purchase_order_items_order
        FOREIGN KEY (purchase_order_id)
        REFERENCES purchase_orders(id),

    CONSTRAINT fk_purchase_order_items_product_variant
        FOREIGN KEY (product_variant_id)
        REFERENCES product_variants(id)
);


CREATE TABLE goods_receipts (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    gr_number VARCHAR(50),
    purchase_order_id BIGINT,
    receipt_date DATE,
    status VARCHAR(20),
    created_by BIGINT,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,

    CONSTRAINT fk_goods_receipts_purchase_order
        FOREIGN KEY (purchase_order_id)
        REFERENCES purchase_orders(id),

    CONSTRAINT fk_goods_receipts_created_by
        FOREIGN KEY (created_by)
        REFERENCES users(id)
);


CREATE TABLE goods_receipt_items (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    goods_receipt_id BIGINT,
    purchase_order_item_id BIGINT,
    product_variant_id BIGINT,
    batch_id BIGINT,
    quantity DECIMAL(15,3),
    unit_price DECIMAL(12,2),
    expiry_date DATE,

    CONSTRAINT fk_goods_receipt_items_receipt
        FOREIGN KEY (goods_receipt_id)
        REFERENCES goods_receipts(id),

    CONSTRAINT fk_goods_receipt_items_po_item
        FOREIGN KEY (purchase_order_item_id)
        REFERENCES purchase_order_items(id),

    CONSTRAINT fk_goods_receipt_items_product_variant
        FOREIGN KEY (product_variant_id)
        REFERENCES product_variants(id),

    CONSTRAINT fk_goods_receipt_items_batch
        FOREIGN KEY (batch_id)
        REFERENCES product_batches(id)
);


-- ============================================================
-- 7. SALES
-- ============================================================

CREATE TABLE sales_orders (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    order_number VARCHAR(50),
    customer_id BIGINT,
    warehouse_id BIGINT,
    order_date DATE,
    required_delivery DATE,
    subtotal DECIMAL(15,2),
    discount_amount DECIMAL(15,2),
    tax_amount DECIMAL(15,2),
    total_amount DECIMAL(15,2),
    status VARCHAR(30),
    created_by BIGINT,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,

    CONSTRAINT fk_sales_orders_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(id),

    CONSTRAINT fk_sales_orders_warehouse
        FOREIGN KEY (warehouse_id)
        REFERENCES warehouses(id),

    CONSTRAINT fk_sales_orders_created_by
        FOREIGN KEY (created_by)
        REFERENCES users(id)
);


CREATE TABLE sales_order_items (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    sales_order_id BIGINT,
    product_variant_id BIGINT,
    quantity DECIMAL(15,3),
    unit_price DECIMAL(12,2),
    discount_amount DECIMAL(12,2),
    tax_amount DECIMAL(12,2),
    total_amount DECIMAL(15,2),

    CONSTRAINT fk_sales_order_items_order
        FOREIGN KEY (sales_order_id)
        REFERENCES sales_orders(id),

    CONSTRAINT fk_sales_order_items_product_variant
        FOREIGN KEY (product_variant_id)
        REFERENCES product_variants(id)
);


CREATE TABLE sales_invoices (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    invoice_number VARCHAR(50),
    sales_order_id BIGINT,
    customer_id BIGINT,
    invoice_date DATE,
    due_date DATE,
    subtotal DECIMAL(15,2),
    tax_amount DECIMAL(15,2),
    grand_total DECIMAL(15,2),
    status VARCHAR(20),
    created_by BIGINT,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,

    CONSTRAINT fk_sales_invoices_sales_order
        FOREIGN KEY (sales_order_id)
        REFERENCES sales_orders(id),

    CONSTRAINT fk_sales_invoices_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(id),

    CONSTRAINT fk_sales_invoices_created_by
        FOREIGN KEY (created_by)
        REFERENCES users(id)
);


CREATE TABLE sales_invoice_items (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    sales_invoice_id BIGINT,
    sales_order_item_id BIGINT,
    product_variant_id BIGINT,
    batch_id BIGINT,
    quantity DECIMAL(15,3),
    unit_price DECIMAL(12,2),
    discount_amount DECIMAL(12,2),
    tax_amount DECIMAL(12,2),
    total_amount DECIMAL(15,2),

    CONSTRAINT fk_sales_invoice_items_invoice
        FOREIGN KEY (sales_invoice_id)
        REFERENCES sales_invoices(id),

    CONSTRAINT fk_sales_invoice_items_order_item
        FOREIGN KEY (sales_order_item_id)
        REFERENCES sales_order_items(id),

    CONSTRAINT fk_sales_invoice_items_product_variant
        FOREIGN KEY (product_variant_id)
        REFERENCES product_variants(id),

    CONSTRAINT fk_sales_invoice_items_batch
        FOREIGN KEY (batch_id)
        REFERENCES product_batches(id)
);


-- ============================================================
-- 8. DELIVERY
-- ============================================================

CREATE TABLE delivery_orders (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    delivery_number VARCHAR(50),
    sales_order_id BIGINT,
    warehouse_id BIGINT,
    delivery_date DATE,
    vehicle_id BIGINT,
    driver_id BIGINT,
    status VARCHAR(20),
    created_by BIGINT,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,

    CONSTRAINT fk_delivery_orders_sales_order
        FOREIGN KEY (sales_order_id)
        REFERENCES sales_orders(id),

    CONSTRAINT fk_delivery_orders_warehouse
        FOREIGN KEY (warehouse_id)
        REFERENCES warehouses(id),

    CONSTRAINT fk_delivery_orders_created_by
        FOREIGN KEY (created_by)
        REFERENCES users(id)
);


CREATE TABLE delivery_order_items (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    delivery_order_id BIGINT,
    product_variant_id BIGINT,
    batch_id BIGINT,
    quantity DECIMAL(15,3),
    delivered_qty DECIMAL(15,3),

    CONSTRAINT fk_delivery_order_items_delivery_order
        FOREIGN KEY (delivery_order_id)
        REFERENCES delivery_orders(id),

    CONSTRAINT fk_delivery_order_items_product_variant
        FOREIGN KEY (product_variant_id)
        REFERENCES product_variants(id),

    CONSTRAINT fk_delivery_order_items_batch
        FOREIGN KEY (batch_id)
        REFERENCES product_batches(id)
);


-- ============================================================
-- 9. PAYMENTS & LEDGER
-- ============================================================

CREATE TABLE payments (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    payment_number VARCHAR(50),
    customer_id BIGINT,
    invoice_id BIGINT,
    payment_date DATE,
    amount DECIMAL(15,2),
    payment_method VARCHAR(20),
    reference_number VARCHAR(50),
    status VARCHAR(20),
    created_by BIGINT,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,

    CONSTRAINT fk_payments_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(id),

    CONSTRAINT fk_payments_invoice
        FOREIGN KEY (invoice_id)
        REFERENCES sales_invoices(id),

    CONSTRAINT fk_payments_created_by
        FOREIGN KEY (created_by)
        REFERENCES users(id)
);


CREATE TABLE customer_ledger (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    customer_id BIGINT,
    invoice_id BIGINT,
    payment_id BIGINT,
    transaction_date DATE,
    transaction_type VARCHAR(20),
    debit_amount DECIMAL(12,2),
    credit_amount DECIMAL(12,2),
    balance DECIMAL(15,2),
    description VARCHAR(255),
    created_at TIMESTAMP,

    CONSTRAINT fk_customer_ledger_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(id),

    CONSTRAINT fk_customer_ledger_invoice
        FOREIGN KEY (invoice_id)
        REFERENCES sales_invoices(id),

    CONSTRAINT fk_customer_ledger_payment
        FOREIGN KEY (payment_id)
        REFERENCES payments(id)
);

-- ============================================================
-- END OF 35 TABLE DATABASE
-- ============================================================



-- ============================================================
-- DUMMY DATA FOR WHOLESALE SUPPLIER - CUSTOMER APPLICATION
-- ALL 35 TABLES
-- ============================================================

-- ============================================================
-- 1. ORGANIZATION & USERS
-- ============================================================

INSERT INTO organizations
(id, name, type, gst_number, pan_number, address, city, state, country, pincode, phone, email, website, status, created_at, updated_at)
VALUES
(1, 'ABC Wholesale Pvt Ltd', 'Wholesale', '29ABCDE1234F1Z5', 'ABCDE1234F',
 'MG Road', 'Bengaluru', 'Karnataka', 'India', '560001',
 '9876543210', 'info@abcwholesale.com', 'www.abcwholesale.com',
 'Active', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

(2, 'XYZ Distribution Pvt Ltd', 'Distributor', '37XYZDE5678G1Z2', 'XYZDE5678G',
 'Main Market Road', 'Vijayawada', 'Andhra Pradesh', 'India', '520001',
 '9876501234', 'info@xyzdistribution.com', 'www.xyzdistribution.com',
 'Active', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);


INSERT INTO branches
(id, organization_id, name, code, address, city, state, pincode, phone, email, is_head_office, status, created_at, updated_at)
VALUES
(1, 1, 'Bengaluru Head Office', 'BLR-HO', 'MG Road', 'Bengaluru',
 'Karnataka', '560001', '9876543210', 'blr@abcwholesale.com',
 TRUE, 'Active', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

(2, 1, 'Bengaluru Warehouse Branch', 'BLR-WH', 'Peenya Industrial Area',
 'Bengaluru', 'Karnataka', '560058', '9876543211',
 'warehouse@abcwholesale.com', FALSE, 'Active',
 CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

(3, 2, 'Vijayawada Branch', 'VJA-01', 'Main Market Road',
 'Vijayawada', 'Andhra Pradesh', '520001', '9876501234',
 'vijayawada@xyzdistribution.com', TRUE, 'Active',
 CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);


INSERT INTO users
(id, branch_id, name, email, mobile, password_hash, status, last_login, created_at, updated_at)
VALUES
(1, 1, 'Admin User', 'admin@abcwholesale.com', '9000000001',
 'HASH_ADMIN', 'Active', CURRENT_TIMESTAMP,
 CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

(2, 2, 'Warehouse Manager', 'warehouse.manager@abcwholesale.com',
 '9000000002', 'HASH_MANAGER', 'Active', CURRENT_TIMESTAMP,
 CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

(3, 3, 'Sales Manager', 'sales@xyzdistribution.com',
 '9000000003', 'HASH_SALES', 'Active', CURRENT_TIMESTAMP,
 CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);


INSERT INTO roles
(id, name, description, status, created_at, updated_at)
VALUES
(1, 'Administrator', 'Full system access', 'Active',
 CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

(2, 'Warehouse Manager', 'Warehouse and inventory management',
 'Active', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

(3, 'Sales Manager', 'Customer and sales management',
 'Active', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);


INSERT INTO user_roles
(user_id, role_id, created_at)
VALUES
(1, 1, CURRENT_TIMESTAMP),
(2, 2, CURRENT_TIMESTAMP),
(3, 3, CURRENT_TIMESTAMP);


-- ============================================================
-- 2. PRODUCT CATALOGUE
-- ============================================================

INSERT INTO categories
(id, parent_id, name, description, image_url, sort_order, status, created_at, updated_at)
VALUES
(1, NULL, 'Groceries', 'General grocery products',
 'groceries.jpg', 1, 'Active',
 CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

(2, 1, 'Rice & Grains', 'Rice and grain products',
 'rice.jpg', 2, 'Active',
 CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

(3, 1, 'Edible Oils', 'Cooking and edible oils',
 'oil.jpg', 3, 'Active',
 CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);


INSERT INTO brands
(id, name, description, logo_url, status, created_at, updated_at)
VALUES
(1, 'India Foods', 'Indian grocery brand',
 'indiafoods.jpg', 'Active',
 CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

(2, 'Fresh Harvest', 'Fresh food products',
 'freshharvest.jpg', 'Active',
 CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

(3, 'Golden Oil', 'Edible oil products',
 'goldenoil.jpg', 'Active',
 CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);


INSERT INTO products
(id, category_id, brand_id, name, product_code, description, hsn_code, gst_rate, status, created_at, updated_at)
VALUES
(1, 2, 1, 'Basmati Rice', 'RICE-001',
 'Premium Basmati Rice', '10063020', 5.00,
 'Active', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

(2, 2, 2, 'Sona Masoori Rice', 'RICE-002',
 'Premium Sona Masoori Rice', '10063010', 5.00,
 'Active', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

(3, 3, 3, 'Sunflower Oil', 'OIL-001',
 'Refined Sunflower Cooking Oil', '15121910', 5.00,
 'Active', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);


INSERT INTO units
(id, name, short_name, unit_type, conversion_factor, status)
VALUES
(1, 'Kilogram', 'KG', 'Weight', 1.0000, 'Active'),
(2, 'Liter', 'L', 'Volume', 1.0000, 'Active'),
(3, 'Piece', 'PCS', 'Count', 1.0000, 'Active');


INSERT INTO product_variants
(id, product_id, unit_id, sku, variant_name, pack_size, barcode, mrp, status, created_at, updated_at)
VALUES
(1, 1, 1, 'BAS-RICE-25KG', 'Basmati Rice 25 KG',
 25.00, '890100000001', 1800.00,
 'Active', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

(2, 1, 1, 'BAS-RICE-10KG', 'Basmati Rice 10 KG',
 10.00, '890100000002', 780.00,
 'Active', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

(3, 2, 1, 'SONA-RICE-25KG', 'Sona Masoori Rice 25 KG',
 25.00, '890100000003', 1300.00,
 'Active', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

(4, 3, 2, 'SUN-OIL-5L', 'Sunflower Oil 5 Liter',
 5.00, '890100000004', 850.00,
 'Active', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);


INSERT INTO product_images
(id, product_id, image_url, image_type, is_primary, sort_order)
VALUES
(1, 1, 'basmati-rice.jpg', 'Product', TRUE, 1),
(2, 2, 'sona-rice.jpg', 'Product', TRUE, 1),
(3, 3, 'sunflower-oil.jpg', 'Product', TRUE, 1);


-- ============================================================
-- 3. CUSTOMERS & SUPPLIERS
-- ============================================================

INSERT INTO customer_groups
(id, name, description, status, created_at, updated_at)
VALUES
(1, 'Retailer', 'Retail shop customers',
 'Active', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

(2, 'Distributor', 'Large distribution customers',
 'Active', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

(3, 'Institutional', 'Institutional customers',
 'Active', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);


INSERT INTO customers
(
    id,
    customer_group_id,
    customer_code,
    name,
    mobile,
    email,
    gst_number,
    pan_number,
    credit_limit,
    credit_days,
    status,
    created_at,
    updated_at
)
VALUES
(
    1,
    1,
    'CUS-001',
    'Sri Lakshmi Supermarket',
    '9000010001',
    'lakshmi@gmail.com',
    '37AAAAA1111A1Z1',
    'AAAAA1111A',
    200000.00,
    30,
    'Active',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
),
(
    2,
    2,
    'CUS-002',
    'Vijaya Distributors',
    '9000010002',
    'vijaya@gmail.com',
    '37BBBBB2222B1Z2',
    'BBBBB2222B',
    500000.00,
    45,
    'Active',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
),
(
    3,
    3,
    'CUS-003',
    'City Hostel',
    '9000010003',
    'cityhostel@gmail.com',
    '37CCCCC3333C1Z3',
    'CCCCC3333C',
    100000.00,
    15,
    'Active',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
),
(
    4,
    1,
    'CUS-004',
    'Ruchi vanam',
    '9876543221',
    'ruchivanam@gmail.com',
    '37RUCHI1234L1Z1',
    'RUCHI1234L',
    100000.00,
    30,
    'Active',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
),
(
    5,
    1,
    'CUS-005',
    'Rice Counter',
    '9876543222',
    'ricecounter@gmail.com',
    '37RICEC1234M1Z2',
    'RICEC1234M',
    150000.00,
    30,
    'Active',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
),
(
    6,
    2,
    'CUS-006',
    'Varahi Tiffins',
    '9876543223',
    'varahitiffins@gmail.com',
    '37VARAH1234N1Z3',
    'VARAH1234N',
    75000.00,
    15,
    'Active',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
),
(
    7,
    2,
    'CUS-007',
    'Lakshmi Tiffins',
    '9876543224',
    'lakshmitiffins@gmail.com',
    '37LAKSH1234P1Z4',
    'LAKSH1234P',
    75000.00,
    15,
    'Active',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);


INSERT INTO customer_addresses
(id, customer_id, address_type, address_line1, address_line2, city, district, state, pincode, is_default)
VALUES
(1, 1, 'Billing', 'Main Road', 'Near Market',
 'Vijayawada', 'NTR', 'Andhra Pradesh', '520002', TRUE),

(2, 2, 'Billing', 'Wholesale Market',
 'Shop No 12', 'Guntur', 'Guntur', 'Andhra Pradesh',
 '522001', TRUE),

(3, 3, 'Delivery', 'Hostel Road',
 'University Campus', 'Vijayawada', 'NTR',
 'Andhra Pradesh', '520008', TRUE);


INSERT INTO suppliers
(
    id,
    supplier_code,
    name,
    contact_person,
    mobile,
    email,
    gst_number,
    pan_number,
    address,
    city,
    state,
    pincode,
    status,
    created_at,
    updated_at
)
VALUES
(
    1,
    'SUP-001',
    'ABC Rice Suppliers',
    'Ramesh Kumar',
    '9100000001',
    'abc.rice@gmail.com',
    '29SUPPL1111A1Z1',
    'SUPPL1111A',
    'Rice Market Road',
    'Bengaluru',
    'Karnataka',
    '560010',
    'Active',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
),
(
    2,
    'SUP-002',
    'Fresh Foods Suppliers',
    'Suresh Kumar',
    '9100000002',
    'freshfoods@gmail.com',
    '29SUPPL2222B1Z2',
    'SUPPL2222B',
    'Industrial Area',
    'Bengaluru',
    'Karnataka',
    '560020',
    'Active',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
),
(
    3,
    'SUP-003',
    'Harinifoods wholesale supplier',
    'Harini',
    '9876543211',
    'harinifoods@gmail.com',
    '37HARIN1234F1Z5',
    'HARIN1234F',
    'Main Market Road',
    'Guntur',
    'Andhra Pradesh',
    '522001',
    'Active',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
),
(
    4,
    'SUP-004',
    'Gayathri millets',
    'Gayathri',
    '9876543212',
    'gayathrimillets@gmail.com',
    '37GAYAT1234G1Z6',
    'GAYAT1234G',
    'Market Road',
    'Guntur',
    'Andhra Pradesh',
    '522002',
    'Active',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
),
(
    5,
    'SUP-005',
    'Annapurna wholesale',
    'Annapurna',
    '9876543213',
    'annapurnawholesale@gmail.com',
    '37ANNAP1234H1Z7',
    'ANNAP1234H',
    'Wholesale Market',
    'Vijayawada',
    'Andhra Pradesh',
    '520001',
    'Active',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
),
(
    6,
    'SUP-006',
    'Gokul wholesale',
    'Gokul',
    '9876543214',
    'gokulwholesale@gmail.com',
    '37GOKUL1234J1Z8',
    'GOKUL1234J',
    'Main Bazaar',
    'Tenali',
    'Andhra Pradesh',
    '522201',
    'Active',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
),
(
    7,
    'SUP-007',
    'SLN Group',
    'SLN',
    '9876543215',
    'sln.group@gmail.com',
    '37SLNGR1234K1Z9',
    'SLNGR1234K',
    'Industrial Area',
    'Guntur',
    'Andhra Pradesh',
    '522003',
    'Active',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);
 


INSERT INTO supplier_products
(id, supplier_id, product_id, lead_time_days, min_order_qty, status)
VALUES
(1, 1, 1, 5, 100.00, 'Active'),
(2, 1, 2, 4, 100.00, 'Active'),
(3, 2, 3, 7, 50.00, 'Active');


-- ============================================================
-- 4. PRICING
-- ============================================================

INSERT INTO price_lists
(id, name, description, customer_group_id, is_default, status, created_at, updated_at)
VALUES
(1, 'Retail Price List', 'Standard retailer pricing',
 1, TRUE, 'Active', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

(2, 'Distributor Price List', 'Distributor special pricing',
 2, FALSE, 'Active', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

(3, 'Institutional Price List', 'Institutional customer pricing',
 3, FALSE, 'Active', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);


INSERT INTO product_prices
(id, product_variant_id, price_list_id, min_quantity, max_quantity, price, effective_from, effective_to, status)
VALUES
(1, 1, 1, 1, 50, 1700.00, '2026-01-01', NULL, 'Active'),
(2, 1, 2, 51, 500, 1600.00, '2026-01-01', NULL, 'Active'),
(3, 2, 1, 1, 50, 740.00, '2026-01-01', NULL, 'Active'),
(4, 3, 2, 1, 500, 1200.00, '2026-01-01', NULL, 'Active'),
(5, 4, 1, 1, 100, 800.00, '2026-01-01', NULL, 'Active');


INSERT INTO customer_product_prices
(id, customer_id, product_variant_id, price, effective_from, effective_to, status)
VALUES
(1, 1, 1, 1650.00, '2026-01-01', NULL, 'Active'),
(2, 2, 1, 1550.00, '2026-01-01', NULL, 'Active'),
(3, 3, 4, 780.00, '2026-01-01', NULL, 'Active');


-- ============================================================
-- 5. WAREHOUSE & INVENTORY
-- ============================================================

INSERT INTO warehouses
(id, branch_id, name, location, city, state, pincode, capacity, type, status, created_at, updated_at)
VALUES
(1, 2, 'Bengaluru Central Warehouse',
 'Peenya Industrial Area', 'Bengaluru',
 'Karnataka', '560058', 100000.00,
 'Main', 'Active', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

(2, 3, 'Vijayawada Warehouse',
 'Auto Nagar', 'Vijayawada',
 'Andhra Pradesh', '520007', 75000.00,
 'Regional', 'Active', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);


INSERT INTO inventory
(id, warehouse_id, product_variant_id, available_qty, reserved_qty, damaged_qty, reorder_level, updated_at)
VALUES
(1, 1, 1, 500.000, 50.000, 5.000, 100.000, CURRENT_TIMESTAMP),
(2, 1, 2, 300.000, 20.000, 2.000, 75.000, CURRENT_TIMESTAMP),
(3, 2, 3, 400.000, 40.000, 3.000, 100.000, CURRENT_TIMESTAMP),
(4, 2, 4, 250.000, 25.000, 1.000, 50.000, CURRENT_TIMESTAMP);


INSERT INTO product_batches
(id, product_variant_id, warehouse_id, batch_number, lot_number, manufacturing_date, expiry_date, quantity, purchase_price, status)
VALUES
(1, 1, 1, 'BAS-2026-001', 'LOT-001',
 '2026-01-10', '2027-01-10',
 300.000, 1500.00, 'Active'),

(2, 2, 1, 'BAS-2026-002', 'LOT-002',
 '2026-02-01', '2027-02-01',
 200.000, 680.00, 'Active'),

(3, 3, 2, 'SONA-2026-001', 'LOT-003',
 '2026-01-15', '2027-01-15',
 250.000, 1100.00, 'Active'),

(4, 4, 2, 'OIL-2026-001', 'LOT-004',
 '2026-02-10', '2027-02-10',
 150.000, 700.00, 'Active');


INSERT INTO stock_transactions
(id, warehouse_id, product_variant_id, transaction_type, quantity, reference_type, reference_id, transaction_date, created_by)
VALUES
(1, 1, 1, 'IN', 300.000, 'Purchase', 1,
 CURRENT_TIMESTAMP, 2),

(2, 1, 2, 'IN', 200.000, 'Purchase', 1,
 CURRENT_TIMESTAMP, 2),

(3, 2, 3, 'IN', 250.000, 'Purchase', 2,
 CURRENT_TIMESTAMP, 2),

(4, 2, 4, 'IN', 150.000, 'Purchase', 2,
 CURRENT_TIMESTAMP, 2);


-- ============================================================
-- 6. PROCUREMENT / PURCHASE
-- ============================================================

INSERT INTO purchase_orders
(id, po_number, supplier_id, warehouse_id, order_date, expected_delivery, subtotal, tax_amount, total_amount, status, created_by, created_at, updated_at)
VALUES
(1, 'PO-2026-001', 1, 1,
 '2026-02-01', '2026-02-06',
 218000.00, 10900.00, 228900.00,
 'Received', 2, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

(2, 'PO-2026-002', 2, 2,
 '2026-02-05', '2026-02-12',
 105000.00, 5250.00, 110250.00,
 'Received', 2, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);


INSERT INTO purchase_order_items
(id, purchase_order_id, product_variant_id, quantity, unit_price, tax_amount, expected_date)
VALUES
(1, 1, 1, 100.000, 1500.00, 7500.00, '2026-02-06'),
(2, 1, 2, 100.000, 680.00, 3400.00, '2026-02-06'),
(3, 2, 3, 50.000, 1100.00, 2750.00, '2026-02-12'),
(4, 2, 4, 50.000, 700.00, 2500.00, '2026-02-12');


INSERT INTO goods_receipts
(id, gr_number, purchase_order_id, receipt_date, status, created_by, created_at, updated_at)
VALUES
(1, 'GR-2026-001', 1, '2026-02-06',
 'Received', 2, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

(2, 'GR-2026-002', 2, '2026-02-12',
 'Received', 2, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);


INSERT INTO goods_receipt_items
(id, goods_receipt_id, purchase_order_item_id, product_variant_id, batch_id, quantity, unit_price, expiry_date)
VALUES
(1, 1, 1, 1, 1, 100.000, 1500.00, '2027-01-10'),
(2, 1, 2, 2, 2, 100.000, 680.00, '2027-02-01'),
(3, 2, 3, 3, 3, 50.000, 1100.00, '2027-01-15'),
(4, 2, 4, 4, 4, 50.000, 700.00, '2027-02-10');


-- ============================================================
-- 7. SALES
-- ============================================================

INSERT INTO sales_orders
(id, order_number, customer_id, warehouse_id, order_date, required_delivery, subtotal, discount_amount, tax_amount, total_amount, status, created_by, created_at, updated_at)
VALUES
(1, 'SO-2026-001', 1, 1,
 '2026-03-01', '2026-03-03',
 165000.00, 5000.00, 8000.00, 168000.00,
 'Confirmed', 3, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

(2, 'SO-2026-002', 2, 2,
 '2026-03-02', '2026-03-05',
 120000.00, 3000.00, 5850.00, 122850.00,
 'Confirmed', 3, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);


INSERT INTO sales_order_items
(id, sales_order_id, product_variant_id, quantity, unit_price, discount_amount, tax_amount, total_amount)
VALUES
(1, 1, 1, 100.000, 1650.00, 5000.00, 7750.00, 167750.00),
(2, 2, 3, 100.000, 1200.00, 3000.00, 5850.00, 122850.00);


INSERT INTO sales_invoices
(id, invoice_number, sales_order_id, customer_id, invoice_date, due_date, subtotal, tax_amount, grand_total, status, created_by, created_at, updated_at)
VALUES
(1, 'INV-2026-001', 1, 1,
 '2026-03-01', '2026-03-31',
 160000.00, 8000.00, 168000.00,
 'Issued', 3, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

(2, 'INV-2026-002', 2, 2,
 '2026-03-02', '2026-04-16',
 117000.00, 5850.00, 122850.00,
 'Issued', 3, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);


INSERT INTO sales_invoice_items
(id, sales_invoice_id, sales_order_item_id, product_variant_id, batch_id, quantity, unit_price, discount_amount, tax_amount, total_amount)
VALUES
(1, 1, 1, 1, 1, 100.000, 1650.00,
 5000.00, 8000.00, 168000.00),

(2, 2, 2, 3, 3, 100.000, 1200.00,
 3000.00, 5850.00, 122850.00);


-- ============================================================
-- 8. DELIVERY
-- ============================================================

INSERT INTO delivery_orders
(id, delivery_number, sales_order_id, warehouse_id, delivery_date, vehicle_id, driver_id, status, created_by, created_at, updated_at)
VALUES
(1, 'DO-2026-001', 1, 1,
 '2026-03-03', 101, 201,
 'Delivered', 2, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

(2, 'DO-2026-002', 2, 2,
 '2026-03-05', 102, 202,
 'Delivered', 2, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);


INSERT INTO delivery_order_items
(id, delivery_order_id, product_variant_id, batch_id, quantity, delivered_qty)
VALUES
(1, 1, 1, 1, 100.000, 100.000),
(2, 2, 3, 3, 100.000, 100.000);


-- ============================================================
-- 9. PAYMENTS & LEDGER
-- ============================================================

INSERT INTO payments
(id, payment_number, customer_id, invoice_id, payment_date, amount, payment_method, reference_number, status, created_by, created_at, updated_at)
VALUES
(1, 'PAY-2026-001', 1, 1,
 '2026-03-10', 100000.00,
 'Bank Transfer', 'UTR100001',
 'Completed', 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),

(2, 'PAY-2026-002', 2, 2,
 '2026-03-15', 122850.00,
 'UPI', 'UPI100002',
 'Completed', 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);


INSERT INTO customer_ledger
(id, customer_id, invoice_id, payment_id, transaction_date, transaction_type, debit_amount, credit_amount, balance, description, created_at)
VALUES
(1, 1, 1, NULL,
 '2026-03-01', 'Invoice',
 168000.00, 0.00, 168000.00,
 'Sales invoice generated',
 CURRENT_TIMESTAMP),

(2, 1, 1, 1,
 '2026-03-10', 'Payment',
 0.00, 100000.00, 68000.00,
 'Customer payment received',
 CURRENT_TIMESTAMP),

(3, 2, 2, NULL,
 '2026-03-02', 'Invoice',
 122850.00, 0.00, 122850.00,
 'Sales invoice generated',
 CURRENT_TIMESTAMP),

(4, 2, 2, 2,
 '2026-03-15', 'Payment',
 0.00, 122850.00, 0.00,
 'Customer payment received',
 CURRENT_TIMESTAMP);


-- ============================================================
-- END OF DUMMY DATA
-- ============================================================