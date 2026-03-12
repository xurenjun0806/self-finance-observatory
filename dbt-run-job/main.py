import logging
import os
import subprocess
import sys

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s %(levelname)s %(message)s",
)
logger = logging.getLogger(__name__)

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_DIR = os.path.join(BASE_DIR, "dbt_run")
PROFILES_DIR = os.path.join(BASE_DIR, "profiles")


def main():
    cmd = ["dbt", "run", "--project-dir", PROJECT_DIR, "--profiles-dir", PROFILES_DIR]
    logger.info("Running: %s", " ".join(cmd))

    result = subprocess.run(cmd)
    if result.returncode != 0:
        logger.error("dbt run failed (return code: %d)", result.returncode)
        sys.exit(result.returncode)

    logger.info("dbt run completed successfully")


if __name__ == "__main__":
    main()
