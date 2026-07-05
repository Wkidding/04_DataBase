## 01: pytest介绍及基本使用

官网：https://www.osgeo.cn/pytest/contents.html

pytest是python语言下的一种单元测试框架，与python自带的unittest单元测试框架类似，相比于unittest框架使用起来更简洁，效率更高。

（补充：java语言下的单元测试框架是junit和testng）

pytest可以结合requests实现接口测试，结合selenium/playwright、appium实现自动化功能测试。

 

### pytest特点

```py
具有unittest绝大部分功能，非常容易上手，入门简单，功能灵活，文档丰富，文档中有很多实例可以参考
具有强大灵活的fixture固件，支持简单的单元测试和复杂的功能测试；
支持参数化（parametrize）、数据驱动
执行测试过程中可以将某些测试跳过（skip），或者对某些预期失败的case标记成失败（xfail）
支持重复执行（rerun）失败的case
支持运行由nose ，unittest编写的测试case
支持执行部分用例（比如：根据标记，或者features、stories，后者一来allure-pytest插件）
具有很多第三方插件（顺序控制pytest-ordering、allure报告allure-pytest、多线程pytest-xdist、......），并且可以自定义开发插件
可生成html报告，也可以结合allure生成精美的测试报告10.方便的和持续集成工具jenkins集成
```

#### 和unittest区别

| **不同点** | **unittest**                                     | **pytest**                                                   |
| ---------- | ------------------------------------------------ | ------------------------------------------------------------ |
| 命名       | 测试方法以test开头                               | 模块名必须以test_开头，或者_test结尾类以Test开头方法/函数以test开头 |
| 框架结构   | 写case必须定义类，测试类要继承unitttest.TestCase | 不需要继承，可以是函数也可以是类中方法                       |
| 测试报告   | 使用HTMLTestRunner                               | 使用allure-pytest                                            |
| 数据驱动   | 参数化使用第三方ddt                              | 参数化使用自带的parametrize                                  |
| 断言       | 断言库丰富                                       | 采用python断言：使用assert关键字                             |
| 失败重试   | 不支持                                           | 支持                                                         |
| 固件       | -                                                | 灵活的fixture固件                                            |
| 扩展性     | -                                                | 快速自定义插件开发                                           |

#### pytest测试用例编写规则

测试框架在识别、加载用例的过程，称之为:**用例发现**
pytest的用例发现步骤:
	1.遍历所有的目录，例外: venv，.开头的目录
	2.打开**python文件**，test_开头 或  _test结尾
	3.遍历所有的Test开头**类**
	4.收集所有的 test_开头 的**函数或方法**

2.用例内容规则

pytest8.4增加了一个强制要求
pytest对用例的要求:
	1.可调用的(函数、方法、类、对象)
	2.名字test_开头
	3.没有参数(参数有另外含义)



| **类型**  | **规则**                                                     |
| --------- | ------------------------------------------------------------ |
| 模块      | 模块名必须以test_开头 或者  _test结尾：test_XXXXXX.py  或 XXXX_test.py |
| 类        | 测试类类名以Test开头：测试类中不能包含__init__构造方法，添加构造方法后就不是测试类了，里面的测试方法都识别不到 |
| 方法/函数 | test_开头：test_xxxxx                                        |
| 包        | 包名无特殊要求包必项要有__init__.py文件                      |
| 其他规则  | 1.执行时会遍历所有的目录，例外: venv，.开头的目录            |

 

### 安装pytest

前提：已经安装、配置python环境

参考：https://www.cnblogs.com/uncleyong/p/10778792.html

#### 通过命令安装

安装命令：pip install pytest

如果安装不了，请更换pip源，参考：https://www.cnblogs.com/uncleyong/p/17997261

如果已经安装，升级到最新版本：pip install -U pytest

#### 通过pycharm安装

pycharm中安装需要的包，在settings中，选择Python Interpreter，然后点击“+”

![img](images/1024732-20240112155831971-1882257017.png)

 

搜索要安装的包，右下角可以选择需要的版本，最后左下角安装即可

![img](images/1024732-20240217115345924-218080492.png)

 

#### 验证是否安装成功

pytest --version

![img](images/1024732-20240217114656803-1478004030.png)

 

#### pycharm默认测试执行器

settings中，进入Tools -> Python Intergrated Tools，Default test runner默认是自动发现的，可以直接选择pytest

![img](images/1024732-20240217120009826-2565956.png)

也可以settings中搜索pytest快速进入Python Intergrated Tools

![img](images/1024732-20240217120211346-494014536.png)

 总结

- 用pytest的解释器执行用例：1、命令行中直接执行pytest；2、pycharm中方法和类，直接点绿色执行按钮运行；模块和包，选中模块或者包，然后右键运行；或者非测试方法处点右键执行（因为pycharm已设置默认测试执行器是pytest）



- 用python的解释器执行用例：1、命令中执行python -m pytest调用pytest（jenkins持续集成可用到，可指定不同版本的python）；2、有main函数，命令中执行python xxx.py，调用py文件中main函数中的pytest.main()；说明：直接执行这个模块，被执行的模块是main（可print(__name__)查看结果），如果此模块被其它模块导入，这个模块就不是main了。

### pytest执行主要命令参数

| 参数           | 说明                                                         |
| -------------- | ------------------------------------------------------------ |
| --help         | 查看帮助，等同-h                                             |
| -q             | 简化控制台的输出，只输出执行结果，几条用例通过或不通过       |
| -v             | 详细输出，打印详细日志，可以看到用例执行的先后顺序、结果；如果不加-v，成功看到的是绿色.，失败看到的是红色F |
| -s             | 调试输出，就是输出print的内容，等价于pytest --capture=no，可以捕获print函数的输出一般和-v一起用，-vs |
| -k             | 测试方法名中包含指定关键字的测试用例，支持and、or、not比如：　　pytest -k test_2，或者pytest -k "test_2"　　pytest -k "test_2 or test_1"，这里要用双引号　　pytest -k "not test_1" |
| -m             | 通过标志表达式运行比如：pytest -m user，pytest -m "user"，将运行 @pytest.mark.user装饰器修饰的所有用例　　等价main中，pytest.main(["-m","user"])，一般加上-vs，pytest.main(["-vs","-m","user"]) |
| -n=2           | 多线程运行(依赖于插件)                                       |
| -x             | 用例一旦失败(fail/error)就立即停止测试（相当于冒烟测试，失败就停止，哪怕没执行完，也不用关心后面的执行结果），等价于pytest --exitfirst |
| --maxfail=n    | 在第n次失败后停止测试，也就是失败数达到num就停止             |
| --lf           | 重跑上次失败用例，等价于--last-failed；命令行参数使用缓存状态如果这些失败的都成功了，再次运行，会把所有成功的都运行，而不是没有失败的了就不运行了 |
| --collect-only | 收集测试用例(不执行)                                         |

#### 1、命令行参数

用于pytest运行时的参数，比如-k、-m等，有通用类、报告类、收集类、调试类、日志类等

==-h参数:pytest -h的结果分类：==

通用类

![img](images/1024732-20240219143955365-1071045535.png)

 

报告类

![img](images/1024732-20240219144005991-1726029832.png)

 

告警

![img](images/1024732-20240219144018462-1064386402.png)

 

收集

![img](images/1024732-20240219144027672-247358518.png)

 

调试

![img](images/1024732-20240219144040573-1464527854.png)

 

日志

![img](images/1024732-20240219144051027-224552130.png)

 

#### 2、元数据

![img](images/1024732-20240219144409001-966103844.png)



#### 3、配置参数：pytest.ini中配置的参数

![img](images/1024732-20240219144210527-2128416116.png)

 

4.环境变量

![img](images/1024732-20240219144156690-1532697727.png)

 

5.重跑失败

![img](images/1024732-20240219144348629-1881409574.png)

 

#### -s参数

示例：上面示例发现，如果用例执行成功，print内容没显示，可以加-s参数捕获print函数的输出

![img](images/1024732-20240217131021098-388683549.png)

 

## 02: 用例查找规则

### 规则

pytest命令方式运行时，用例查找规则如下：

| **命令**                                        | **说明**                        |
| ----------------------------------------------- | ------------------------------- |
| pytest（等价于：python -m pytest）              | 运行当前目录及子目录下所有用例  |
| pytest ./                                       | 运行当前目录及子目录下所有用例  |
| pytest case\sub_case\                           | 运行指定目录及子目录下所有用例  |
| pytest case\test_qzcsbj.py                      | 指定模块运行                    |
| pytest -k test_2                                | 按关键字（函数/方法名）匹配运行 |
| pytest case\test_qzcsbj.py::test_a              | 指定函数运行                    |
| pytest case\test_qzcsbj.py::TestQzcsbj1         | 指定类运行                      |
| pytest case\test_qzcsbj.py::TestQzcsbj1::test_c | 指定类方法运行                  |

### 执行演示

创建My_Pytest工程，添加测试Demo。以测试add函数为例子，创建测试用例

![image-20260705220155700](images/image-20260705220155700.png)

`test_00.py`

```python
import pytest

def inc (x):
    return x + 1

def test_a ( ):
    print("---test_a")
    assert inc(0) == 1


class TestDemo1:
    def test_b (self):
        print("---test_b")
        assert "D" in "Demo"

    def test_c (self):
        print("---test_c")
        assert "em" in "Demo"


class TestDemo2:
    def test_d (self):
        print("---test_d")
        assert "mo" in "Demo"


def add(a,b):
    return a + b

class TestAdd:
    def test_add_int(self):
        print("---test_add_int")
        res = add(1,3)
        assert res == 4

    def test_add_str(self):
        print("---test_add_str")
        res = add("aaa","bbb")
        assert res == "aaabbb"

    def test_add_list(self):
        print("---test_add_list")
        res = add([1],[2,3,4])
        assert res == [1,2,3,4]
```

`test_01.py`

```python
import pytest

def test_1():
    print("---test_1")
    assert 1 == 1
```

`test_02.py`

```python
import pytest

def test_2 ( ):
    print("---test_2")
    assert 1 == 1
```



测试结果：
![image-20260705220126576](images/image-20260705220126576.png)

## 03: pytest固件、及用例执行顺序





## 04: fixture简介及调用

## 05: fixture实现自定义前置、后置

## 06: fixture作用域(scope)详解

## 07: fixture跨模块共享conftest.py

## 08: fixture标志传参

## 09: fixture返回值实现参数化

## 10: fixture对用例重命名、给函数取别名

## 11: pytest的配置文件pytest.ini

## 12: mark标记测试用例

## 13: parametrize参数化

## 14: parametrize参数化数据来自yaml文件

## 15: parametrize参数化数据来自json文件

## 16: parametrize参数化数据来自excle文件

## 17: parametrize参数化数据来自csv文件

## 18: parametrize中indirect详解间接参数

## 19: parametrize中给用例取别名

## 20: 跳过用例 - skip、skipif

## 21: 标记为预期失败 - xfail]

## 22: 定义标记变量

## 23: pytest中配置过滤警告

## 24: pytest中异常处理

## 25: pytest断言

## 26: pytest中日志配置

## 27: pytest常用插件 - 失败重试pytest-rerunfailures

## 28: pytest常用插件 - 重复测试pytest-repeat

## 29: pytest常用插件 - 控制函数执行顺序pytest-ordering

## 30: pytest常用插件 - 随机执行pytest-random-order

## 31: pytest常用插件 - 并发执行pytest-xdist

## 32: pytest常用插件 - 依赖执行pytest-dependency

## 33: pytest常用插件 - 多重校验pytest-assume

## 34: pytest常用插件 - 测试报告pytest-html

## 35: pytest常用插件 - allure报告allure-pytest

## 36: pytest + allure最佳实践