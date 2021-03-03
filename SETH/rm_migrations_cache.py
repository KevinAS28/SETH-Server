import SETH.settings as settings
import os
import shutil

to_rm = ["__pycache__", "migrations"]
for app_name in settings.INSTALLED_APPS:
    app_dir = os.path.join(settings.BASE_DIR, app_name)
    if os.path.isdir(app_dir):
        print(f"{app_name}: ")
        for tr in to_rm:
            tr_path = os.path.join(app_dir, tr)
            if os.path.isdir(tr_path):
                print((" "*4)+tr_path)
                shutil.rmtree(tr_path)
