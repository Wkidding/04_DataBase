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

测试框架在识别、加载用例的过程，称之为:用例发现
pytest的用例发现步骤:
1.遍历所有的目录，例外:venv，.开头的目录
2.打开python文件，test_开头或者_test结尾
3.遍历所有的Test开头类
4.收集所有的test_开头的函数或者方法
I
2.用例内容规则
pytest8.4增加了一个强制要求
pytest对用例的要求:
1.可调用的(函数、方法、类、对象)
2.名字test_开头
3.没有参数(参数有另外含义)

| **类型**  | **规则**                                                     |
| --------- | ------------------------------------------------------------ |
| 模块      | 模块名必须以test_开头，也就是：test_*.py或者_test结尾，也就是：*_test.py建议：test_+业务名称 |
| 类        | 测试类类名以Test开头说明：测试类中不能包含__init__构造方法，添加构造方法后就不是测试类了，里面的测试方法都识别不到 |
| 方法/函数 | 以test开头                                                   |
| 包        | 包名无特殊要求包必项要有__init__.py文件                      |

 

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

 

## 02: 用例查找规则

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