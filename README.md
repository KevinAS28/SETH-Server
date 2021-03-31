### Installation

1. Install the requirements
   ```sh
   python -m pip install -r requrements2.txt #requirements1.txt is result of pip freeze
   ```

2. (Optional) Add dummy data. Get your GCP API KEY (with MAPS API enabled) and copy that to a file "kevin_api_key", 
   ```sh
   python3 manage.py dummydata genA genC genB genPlace
   ```

3. Run the project 
   ```sh
   python3 manage.py runserver 0.0.0.0:8000
   ```