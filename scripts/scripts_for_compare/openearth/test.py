import shutil
import os
import os.path
import subprocess

# print(os.listdir())
script_path = 'script'

for f in os.listdir():
    if not os.path.isfile(f) and f != script_path:
        for script in os.listdir(script_path):
            shutil.copy(os.path.join(script_path,script), f)
# 
cwd = os.getcwd()
for f in os.listdir():
    if os.path.isfile(f) and f.endswith(".mlir"):
        os.chdir(cwd)
        f = f[:-5]
        if os.path.exists(f):
            print("exists")
            shutil.rmtree(f)
        os.mkdir(f)
        shutil.copy(f + ".mlir", f)
        for script in os.listdir(os.path.join(cwd, script_path)):
            shutil.copy(os.path.join(cwd, script_path,script), f)
        os.chdir(os.path.join(cwd,f))
        if "2d" in f:
            dimention = "2d"
        elif "3d" in f:
            dimention = "3d"
        if f == 'inline':
            cmd2 = ['python3', f'motivation{dimention}.py', '1', '10']
        else:
            cmd2 = ['python3', f'motivation{dimention}.py', '0', '10']
        subprocess.call(cmd2, cwd=os.path.join(cwd,f))
        print(f'finish case {f}')
        os.chdir(os.path.join(cwd))
        shutil.copy(os.path.join(f,"result.txt"), os.path.join(cwd, f"result_{f}.txt"))