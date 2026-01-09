# expense_tracker

# miladinovicem

A new Flutter project.

## Getting Started

# Expense Tracker (Flutter)

Mobile expense tracking application built with Flutter.

## Features
- User authentication (Firebase Authentication)
- Expense and income tracking (CRUD)
- Balance overview with pie chart
- REST API communication using Firebase Realtime Database

## Tech Stack
- Flutter
- Firebase Authentication
- Firebase Realtime Database (REST API)
- HTTP client

## Architecture
The mobile application communicates with Firebase Realtime Database exclusively through REST API calls.
Firestore SDK is not used.
Authentication is handled via Firebase Authentication, and ID tokens are attached to each REST request.

## Screens
- Login / Register
- Balance dashboard
- Expenses (add, edit, delete)
- Incomes (add, edit, delete)
