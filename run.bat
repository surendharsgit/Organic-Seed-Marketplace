@echo off
REM Run the Organic Seed Marketplace app with all jars in lib on the classpath
SET SCRIPT_DIR=%~dp0
cd /d "%SCRIPT_DIR%"
if not exist lib (
  mkdir lib
  echo Created lib directory. Put mysql-connector-java-*.jar into lib\
)
java -cp "bin;lib/*" com.oseed.ui.LandingFrame
