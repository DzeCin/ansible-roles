import ast
import sys

x = ast.literal_eval(sys.argv[1])
res = ''
for i in x:
    res += i + ','

print(res)