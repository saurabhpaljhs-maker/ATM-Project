const express = require('express');
require('dotenv').config();

const app = express();
app.use(express.json());

const PORT = process.env.APP_PORT || 8081;

const accounts = {
    "account-ramji-101": {
        pin: process.env.ATM_SECURE_PIN || "1234",
        balance: 50000,
        holder: "Saurabh Pal"
    }
};

// 1. Root route - Isse browser mein error nahi aayega
app.get('/', (req, res) => {
    res.status(200).send("<h1>ATM-Project is Running Successfully!</h1><p>Use /api/atm/health for status check.</p>");
});

// 2. Health check endpoint
app.get('/api/atm/health', (req, res) => {
    res.status(200).json({ status: "UP", project: "ATM-Project", timestamp: new Date() });
});

// 3. Balance Enquiry API
app.post('/api/atm/balance', (req, res) => {
    const { accountId, pin } = req.body;
    if (!accounts[accountId]) return res.status(404).json({ error: "Invalid Account Number" });
    if (accounts[accountId].pin !== pin) return res.status(401).json({ error: "Unauthorized! Incorrect ATM PIN" });

    res.status(200).json({
        accountHolder: accounts[accountId].holder,
        currentBalance: `₹${accounts[accountId].balance}`
    });
});

// 4. Cash Withdrawal API
app.post('/api/atm/withdraw', (req, res) => {
    const { accountId, pin, amount } = req.body;
    if (!accounts[accountId]) return res.status(404).json({ error: "Invalid Account Number" });
    if (accounts[accountId].pin !== pin) return res.status(401).json({ error: "Unauthorized! Incorrect ATM PIN" });
    if (amount <= 0 || accounts[accountId].balance < amount) return res.status(400).json({ error: "Invalid amount or Insufficient Balance" });

    accounts[accountId].balance -= amount;
    res.status(200).json({
        status: "Success",
        msg: `Please collect your cash: ₹${amount}`,
        remainingBalance: `₹${accounts[accountId].balance}`
    });
});

app.listen(PORT, () => {
    console.log(`🚀 ATM-Project Application Gateway active on port: ${PORT}`);
});
