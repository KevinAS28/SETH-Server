import re, os, traceback

"""src="{% static 'my_app/example.jpg' %}"""

with open("front0/dashboard.html", "r") as test:
    test = test.read()


# ex = "src=\"../assets/js/core/jquery.min.js\""

# to_replace = re.findall(r"src\=\".*assets/.*\"", test)
# for src in to_replace:
#     group = re.match(r"src\=\"(\.\.\/assets/)(.*)\"", src).groups()
#     res = "src=\"{% static 'assets/"+group[1]+"' %}\""
#     print(src)
#     print(src.replace(src, res))
#     print(src.replace("../", "static/"))
#     print("="*10)

#     break
# exit()

files = os.listdir("front0")
output = "front1"


for f in files:
    with open(os.path.join("front0", f), "r") as html0:
        with open(os.path.join("front1", f), "w+") as html1:
            the_html = "{% load static %}\n\n" + html0.read()

            to_replace = re.findall(r"\"\.\.\/assets/.*\"", the_html)
            for src in to_replace:
                try:
                    group = re.match(r"\"(\.\.\/assets/)(.*)\"", src).groups()
                    res = "\"{% static 'assets/"+group[1].split("?")[0]+"' %}\""
                    the_html = the_html.replace(src, src.replace("../", "static/"))
                except:
                    print(src)
                    traceback.print_exc()
                    exit()

            html1.write(the_html)
