import random
from faker import Faker
import pandas as pd
from datetime import timedelta

fake = Faker("en_IN")

random.seed(42)
Faker.seed(42)

def generate_customers(n=10000):

    customers = []

    for customer_id in range(1, n + 1):

        customers.append({

            "CustomerID": customer_id,

            "CustomerName": fake.name(),

            "Gender": random.choice(["Male", "Female"]),

            "Age": random.randint(18, 70),

            "City": fake.city(),

            "State": fake.state(),

            "JoinDate": fake.date_between(
                start_date="-5y",
                end_date="today"
            )

        })

    return pd.DataFrame(customers)

categories = {

    "Electronics": [
        "Laptop",
        "Phone",
        "Tablet",
        "Headphones"
    ],

    "Clothing": [
        "Shirt",
        "Jeans",
        "Jacket",
        "Shoes"
    ],

    "Home": [
        "Chair",
        "Table",
        "Lamp",
        "Fan"
    ],

    "Sports": [
        "Football",
        "Cricket Bat",
        "Helmet",
        "Gloves"
    ]

}

def generate_products(n=500):

    products = []

    for product_id in range(1, n + 1):

        category = random.choice(list(categories.keys()))

        subcategory = random.choice(categories[category])

        cost = random.randint(100, 5000)

        price = round(cost * random.uniform(1.2, 2.0), 2)

        products.append({

            "ProductID": product_id,

            "ProductName": f"{subcategory} {product_id}",

            "Category": category,

            "SubCategory": subcategory,

            "CostPrice": cost,

            "SellingPrice": price

        })

    return pd.DataFrame(products)

def generate_sales(products_df, n=100000):

    sales = []

    for order_id in range(1, n + 1):

        customer = random.randint(1, 10000)

        product = random.randint(1, 500)

        quantity = random.randint(1, 5)

        discount = random.choice([0, 5, 10, 15, 20])

        price = products_df.loc[
            products_df.ProductID == product,
            "SellingPrice"
        ].values[0]

        cost = products_df.loc[
            products_df.ProductID == product,
            "CostPrice"
        ].values[0]

        sales_amount = round(price * quantity * (1 - discount / 100), 2)

        profit = round((price - cost) * quantity, 2)

        sales.append({

            "OrderID": order_id,

            "OrderDate": fake.date_between(
                start_date="-2y",
                end_date="today"
            ),

            "CustomerID": customer,

            "ProductID": product,

            "Quantity": quantity,

            "Discount": discount,

            "Sales": sales_amount,

            "Profit": profit

        })

    return pd.DataFrame(sales)

def generate_inventory(products_df):

    inventory = []

    warehouses = [

        "Delhi",

        "Mumbai",

        "Bengaluru",

        "Hyderabad"

    ]

    for inventory_id, product_id in enumerate(products_df.ProductID, start=1):

        inventory.append({

            "InventoryID": inventory_id,

            "ProductID": product_id,

            "Warehouse": random.choice(warehouses),

            "StockAvailable": random.randint(10, 500),

            "ReorderLevel": random.randint(20, 80),

            "LastRestocked": fake.date_between(
                start_date="-90d",
                end_date="today"
            ),

            "Supplier": fake.company()

        })

    return pd.DataFrame(inventory)

customers_df = generate_customers()
products_df = generate_products()
sales_df = generate_sales(products_df)
inventory_df = generate_inventory(products_df)

customers_df.to_csv("../data/customers.csv", index=False)
products_df.to_csv("../data/products.csv", index=False)
sales_df.to_csv("../data/sales.csv", index=False)
inventory_df.to_csv("../data/inventory.csv", index=False)

print("Dataset generated successfully!")