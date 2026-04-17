# Fixing "Communications link failure" and running the app

This guide walks through the common causes of the JDBC error shown in the app:

"Error: Failed to connect to database. Check db.properties and that MySQL is running. Communications link failure"

Follow these steps in order to diagnose and fix the problem, then run the application.

## 1) Quick checklist
- `lib/` contains a MySQL Connector/J jar (e.g. `mysql-connector-java-8.0.33.jar`).
- `db.properties` has correct `db.url`, `db.user`, `db.password`.
- MySQL server is running and listening on the host/port in `db.url`.
- The database `organic_seed_marketplace` exists (or run `schema.sql`).

## 2) Verify Connector JAR
From the project root run in PowerShell:

```powershell
cd 'C:\Users\HP\OneDrive\Documents\Organic Seed Marketplace'
Get-ChildItem .\lib -Force | Select-Object Name, Length
```

If you don't see a `mysql-connector-java-*.jar`, download it from MySQL or Maven Central and place it in `lib/`.

## 3) Verify `db.properties`
Open `db.properties` and confirm values. Example:

```
db.url=jdbc:mysql://localhost:3306/organic_seed_marketplace?useSSL=false&serverTimezone=UTC
db.user=root
db.password=your_password_here
```

- If MySQL is on another host, replace `localhost` with that host or IP.
- If MySQL uses a different port, update `:3306` accordingly.

## 4) Ensure MySQL server is running
Check service & port:

```powershell
# Check Windows service (common names)
Get-Service -Name 'MySQL*' -ErrorAction SilentlyContinue

# Check whether port 3306 is listening
netstat -ano | findstr :3306

# PowerShell port test (better):
Test-NetConnection -ComputerName localhost -Port 3306
```

- If the service is stopped, start it using Services.msc or:

```powershell
Start-Service -Name 'MySQL80'   # or the specific service name
```

## 5) Create the database and tables (if not already)
Run the provided schema file `schema.sql` (replace `root`/password):

```powershell
mysql -u root -p < "C:\Users\HP\OneDrive\Documents\Organic Seed Marketplace\schema.sql"
```

Or log into MySQL and run the file:

```sql
-- in mysql client
SOURCE C:/Users/HP/OneDrive/Documents/Organic Seed Marketplace/schema.sql;
```

## 6) Check user credentials and privileges
If you get authentication errors, create a user and grant privileges:

```sql
CREATE USER 'oseed'@'localhost' IDENTIFIED BY 'change_me';
GRANT ALL PRIVILEGES ON organic_seed_marketplace.* TO 'oseed'@'localhost';
FLUSH PRIVILEGES;
```

Update `db.properties` to use that user.

## 7) Test JDBC connectivity from the command line
Run the app from a terminal to capture exceptions (do not double-click, run in terminal):

```powershell
cd 'C:\Users\HP\OneDrive\Documents\Organic Seed Marketplace'
java -cp "bin;lib/*" com.oseed.ui.LandingFrame
```

Watch the terminal for full stack traces — they give exact reasons (authentication, socket timeout, refused connection).

## 8) Common error meanings & fixes
- "Communications link failure" — Java cannot reach MySQL host/port. Fix: start MySQL, correct host/port, check firewall.
- "Access denied for user" — credentials/privileges issue. Fix: create/grant user, check password.
- "Driver not found" — Connector JAR missing or not on classpath. Fix: put `mysql-connector-java-*.jar` into `lib/` and run `run.bat` or `java -cp "bin;lib/*" ...`

## 9) Firewall or networking
- If MySQL is on another machine, ensure port 3306 is reachable from this machine.
  Test from PowerShell:

```powershell
Test-NetConnection -ComputerName 192.168.1.50 -Port 3306
```

- If blocked, open firewall on the server machine or allow inbound on port 3306:

```powershell
New-NetFirewallRule -DisplayName 'MySQL In' -Direction Inbound -LocalPort 3306 -Protocol TCP -Action Allow
```

## 10) If GUI window is not visible / off-screen
- Run the app in a terminal so you see errors (see step 7).
- If `java.exe` exists in Task Manager but no window, try Alt+Tab or use Windows snap keys.

## 11) Re-run the app
Once the connector jar exists, `db.properties` is correct and MySQL is running, launch the app:

```powershell
cd 'C:\Users\HP\OneDrive\Documents\Organic Seed Marketplace'
.\run.ps1
# or
.\run.bat
```

Or run directly to see console output:

```powershell
java -cp "bin;lib/*" com.oseed.ui.LandingFrame
```

## 12) Quick troubleshooting flow (summary)
1. `Get-ChildItem .\lib` → ensure connector jar present.
2. `Get-Content .\db.properties` → confirm URL, user, password.
3. `Test-NetConnection -ComputerName localhost -Port 3306` → ensures MySQL reachable.
4. `mysql -u root -p < schema.sql` → create DB/tables.
5. Start the app from terminal and inspect the stack trace if errors remain.

## 13) Option: run without MySQL (fast local testing)
If you want to run the UI without installing MySQL, I can add an **H2 embedded fallback** and a toggle in `db.properties` (e.g. `db.driver=h2|mysql`). Tell me if you'd like that and I will implement it.

---
If you paste the outputs of these commands or a full stacktrace printed when you run the app from a terminal, I will diagnose the exact cause and provide the next fix.

Files referenced:
- `db.properties`
- `lib/` (put connector jar here)
- `schema.sql`
- `run.bat`, `run.ps1`
