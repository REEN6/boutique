const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const jwt = require('jsonwebtoken');

const app = express();
const PORT = process.env.PORT || 3000;
const SECRET_KEY = 'luxury_boutique_secret_key';

app.use(cors());
app.use(bodyParser.json());

// --- MOCK DATABASE (In-memory for demonstration, replace with SQL in production) ---
let users = [
    { id: 1, username: 'admin', password: 'admin123', role: 'SUPER_ADMIN', name: 'Super Admin' },
    { id: 2, username: 'manager', password: 'password123', role: 'MANAGER', name: 'Boutique Manager' },
    { id: 3, username: 'cashier', password: 'password123', role: 'CASHIER', name: 'Cashier One' }
];

let products = [
    { id: 1, sku: 'BTQ-001', name: 'Silk Evening Gown', category: 'Dresses', brand: 'Vogue', cost: 150, price: 450, stock: 12, minStock: 5 },
    { id: 2, sku: 'BTQ-002', name: 'Leather Stilettos', category: 'Shoes', brand: 'Elise', cost: 80, price: 220, stock: 8, minStock: 3 }
];

let customers = [
    { id: 1, name: 'John Doe', phone: '123456789', points: 120, tier: 'Gold' }
];

let sales = [];
let purchaseOrders = [];
let suppliers = [{ id: 1, name: 'Elite Fabrics', contact: 'supply@elite.com' }];

// --- AUTHENTICATION ---
app.post('/api/auth/login', (req, res) => {
    const { username, password } = req.body;
    const user = users.find(u => u.username === username && u.password === password);
    if (user) {
        const token = jwt.sign({ id: user.id, role: user.role }, SECRET_KEY);
        res.json({ token, user: { id: user.id, name: user.name, role: user.role } });
    } else {
        res.status(401).json({ message: 'Invalid credentials' });
    }
});

// --- PRODUCT MANAGEMENT ---
app.get('/api/products', (req, res) => res.json(products));
app.post('/api/products', (req, res) => {
    const newProduct = { id: products.length + 1, ...req.body };
    products.push(newProduct);
    res.status(201).json(newProduct);
});

// --- POS & SALES ---
app.post('/api/sales', (req, res) => {
    const sale = {
        id: sales.length + 1,
        invoiceNo: 'INV-' + Date.now(),
        date: new Date(),
        ...req.body
    };
    // Deduct stock
    sale.items.forEach(item => {
        const product = products.find(p => p.id === item.productId);
        if (product) product.stock -= item.quantity;
    });
    sales.push(sale);
    res.status(201).json(sale);
});

app.get('/api/sales/report', (req, res) => {
    const totalRevenue = sales.reduce((sum, s) => sum + s.total, 0);
    res.json({ totalRevenue, totalSales: sales.length, sales });
});

// --- CUSTOMER MANAGEMENT ---
app.get('/api/customers', (req, res) => res.json(customers));
app.post('/api/customers', (req, res) => {
    const customer = { id: customers.length + 1, ...req.body, points: 0, tier: 'Bronze' };
    customers.push(customer);
    res.status(201).json(customer);
});

// --- INVENTORY & SUPPLIERS ---
app.get('/api/suppliers', (req, res) => res.json(suppliers));
app.post('/api/purchase-orders', (req, res) => {
    const po = { id: purchaseOrders.length + 1, status: 'Ordered', date: new Date(), ...req.body };
    purchaseOrders.push(po);
    res.status(201).json(po);
});

// --- DASHBOARD ANALYTICS ---
app.get('/api/dashboard/summary', (req, res) => {
    const lowStock = products.filter(p => p.stock <= p.minStock).length;
    res.json({
        todaySales: sales.filter(s => new Date(s.date).toDateString() === new Date().toDateString()).reduce((sum, s) => sum + s.total, 0),
        totalProducts: products.length,
        totalCustomers: customers.length,
        lowStockItems: lowStock
    });
});

app.listen(PORT, () => console.log(`Boutique API running on port ${PORT}`));
