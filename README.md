# Organic Seed Marketplace

Java Swing desktop application connecting Customers with Farmers for organic seeds.

Setup:

1. Create the MySQL database and tables:

   - Edit `db.properties` and set `db.user` and `db.password`.
   - Run the SQL file `schema.sql` in your MySQL client to create the schema.

2. Add MySQL Connector/J to the classpath (mysql-connector-java).

3. Compile and run `com.oseed.ui.LandingFrame`.

Run the app (recommended):

- Windows (double-click): run `run.bat` in the project root.
- PowerShell: run `.
un.ps1` in the project root.

Both launchers include all jars under `lib/` on the classpath (`bin;lib/*`).

To download the MySQL Connector/J into `lib/`, run the PowerShell helper:

```powershell
.\scripts\download-connector.ps1 -version 8.0.33
```

Or manually place `mysql-connector-java-<version>.jar` into the `lib/` folder.

Demo data
---------

I added a demo dataset you can import to try the app quickly:

- `demo/demo_data.sql` — creates a demo DB user `oseed_demo` (password `demo123`), a demo customer and farmer, and sample seeds.
- `demo/import_demo.ps1` — imports `demo_data.sql` using your MySQL client (prompts for privileged user credentials).

To import demo data run in PowerShell from project root:

```powershell
cd 'C:\Users\HP\OneDrive\Documents\Organic Seed Marketplace'
.\demo\import_demo.ps1
```

Then update `db.properties` to use the demo app user if desired:

```
db.url=jdbc:mysql://localhost:3306/organic_seed_marketplace?useSSL=false&serverTimezone=UTC
db.user=oseed_demo
db.password=demo123
```

After that run the app with `run.bat`/`run.ps1` or `java -cp "bin;lib/*" com.oseed.ui.LandingFrame`.

Notes:
- Database properties are in `db.properties`.
- Passwords are stored as MD5 hashes by `PasswordUtil` (for demo). Replace with BCrypt in production.
