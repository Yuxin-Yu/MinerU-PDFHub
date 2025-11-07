================
CODE SNIPPETS
================
### Python setUp/tearDown Patching with unittest

Source: https://github.com/python/cpython/blob/main/Doc/library/unittest.mock-examples.rst

Demonstrates managing patches using setUp and tearDown methods in unittest.TestCase. Ensures patches are started in setUp and stopped in tearDown to manage mock objects effectively.

```python
class MyTest(unittest.TestCase):
    def setUp(self):
        self.patcher = patch('mymodule.foo')
        self.mock_foo = self.patcher.start()

    def test_foo(self):
        self.assertIs(mymodule.foo, self.mock_foo)

    def tearDown(self):
        self.patcher.stop()
```

--------------------------------

### Python unittest TestCase with setUp method

Source: https://github.com/python/cpython/blob/main/Doc/library/unittest.rst

An example demonstrating the use of the setUp method in unittest.TestCase. The setUp method is automatically called before each test method, allowing for common setup logic.

```python
import unittest

class WidgetTestCase(unittest.TestCase):
    def setUp(self):
        self.widget = Widget('The widget')

    def test_default_widget_size(self):
        self.assertEqual(self.widget.size(), (50,50),
```

--------------------------------

### Setup.py with Classifiers for Distutils

Source: https://github.com/python/cpython/blob/main/Doc/whatsnew/2.3.rst

An example setup.py file demonstrating how to add 'classifiers' to the Distutils `setup` function for package metadata. This example is designed for compatibility with older Distutils versions.

```python
from distutils import core
kw = {'name': "Quixote",
      'version': "0.5.1",
      'description': "A highly Pythonic Web application framework",
      # ...
      }

if (hasattr(core, 'setup_keywords') and
    'classifiers' in core.setup_keywords):
    kw['classifiers'] = \
        ['Topic :: Internet :: WWW/HTTP :: Dynamic Content',
         'Environment :: No Input/Output (Daemon)',
         'Intended Audience :: Developers'],

core.setup(**kw)
```

--------------------------------

### Managing multiple patches in setUp and tearDown

Source: https://github.com/python/cpython/blob/main/Doc/library/unittest.mock.rst

Provides an example of managing multiple patches within the setUp and tearDown methods of a unittest.TestCase. It shows starting multiple patches in setUp and stopping them in tearDown.

```python
>>> class MyTest(unittest.TestCase):
...     def setUp(self):
...         self.patcher1 = patch('package.module.Class1')
...         self.patcher2 = patch('package.module.Class2')
...         self.MockClass1 = self.patcher1.start()
...         self.MockClass2 = self.patcher2.start()
... 
...     def tearDown(self):
...         self.patcher1.stop()
...         self.patcher2.stop()
... 
...     def test_something(self):
...         assert package.module.Class1 is self.MockClass1
...         assert package.module.Class2 is self.MockClass2
... 
>>> MyTest('test_something').run()
```

--------------------------------

### Unattend.xml for Python Installation

Source: https://github.com/python/cpython/blob/main/Doc/using/windows.rst

An example unattend.xml file to configure Python installation options, mirroring the personal installation command. Values are provided as attributes and element text.

```xml
<Options>
        <Option Name="InstallAllUsers" Value="no" />
        <Option Name="Include_launcher" Value="0" />
        <Option Name="Include_test" Value="no" />
        <Option Name="SimpleInstall" Value="yes" />
        <Option Name="SimpleInstallDescription">Just for me, no test suite</Option>
    </Options>
```

--------------------------------

### Python Script Association Example

Source: https://github.com/python/cpython/blob/main/Doc/faq/windows.rst

Shows an example of how the Windows installer might associate the .py extension with the Python interpreter for script execution.

```doscon
D:\Program Files\Python\python.exe "%1" %*
```

--------------------------------

### Python Component Initialization Examples

Source: https://github.com/python/cpython/blob/main/Doc/howto/descriptor.rst

Demonstrates valid and invalid inputs for a hypothetical 'Component' class, highlighting validation rules for string casing, allowed values, numeric ranges, and type checking.

```python
>>> Component('Widget', 'metal', 5)      # Blocked: 'Widget' is not all uppercase
Traceback (most recent call last):
    ...
ValueError: Expected <method 'isupper' of 'str' objects> to be true for 'Widget'

>>> Component('WIDGET', 'metle', 5)      # Blocked: 'metle' is misspelled
Traceback (most recent call last):
    ...
ValueError: Expected 'metle' to be one of {'metal', 'plastic', 'wood'}

>>> Component('WIDGET', 'metal', -5)     # Blocked: -5 is negative
Traceback (most recent call last):
    ...
ValueError: Expected -5 to be at least 0

>>> Component('WIDGET', 'metal', 'V')    # Blocked: 'V' isn't a number
Traceback (most recent call last):
    ...
TypeError: Expected 'V' to be an int or float

>>> c = Component('WIDGET', 'metal', 5)  # Allowed:  The inputs are valid
```

--------------------------------

### Python: Mocking and Patching in Tests

Source: https://github.com/python/cpython/blob/main/Doc/library/unittest.mock-examples.rst

Demonstrates the use of patching to replace objects during testing and asserting their identity with the original objects. It includes setup for test cleanup.

```python
    patcher = patch(name)
    thing = patcher.start()
    self.addCleanup(patcher.stop)
    return thing

    def test_foo(self):
        mock_foo = self.create_patch('mymodule.Foo')
        mock_bar = self.create_patch('mymodule.Bar')
        mock_spam = self.create_patch('mymodule.Spam')

        assert mymodule.Foo is mock_foo
        assert mymodule.Bar is mock_bar
        assert mymodule.Spam is mock_spam

```

--------------------------------

### Python unittest addCleanup for Patching

Source: https://github.com/python/cpython/blob/main/Doc/library/unittest.mock-examples.rst

Illustrates using unittest.TestCase.addCleanup to simplify patch management. This ensures that patch.stop() is called even if exceptions occur during the test setup.

```python
class MyTest(unittest.TestCase):
    def setUp(self):
        patcher = patch('mymodule.foo')
        self.addCleanup(patcher.stop)
        self.mock_foo = patcher.start()

    def test_foo(self):
        self.assertIs(mymodule.foo, self.mock_foo)
```

--------------------------------

### Mocking Asynchronous Context Managers with `AsyncMock`

Source: https://github.com/python/cpython/blob/main/Doc/library/unittest.mock-examples.rst

Demonstrates mocking asynchronous context managers using `AsyncMock` or `MagicMock` by setting up `__aenter__` and `__aexit__`.

```python
>>> import asyncio
>>> from unittest.mock import MagicMock
>>> class AsyncContextManager:
...     async def __aenter__(self):
...         return self
...     async def __aexit__(self, exc_type, exc, tb):
...         pass
...
>>> mock_instance = MagicMock(AsyncContextManager())  # AsyncMock also works here
>>> async def main():
...     async with mock_instance as result:
...         pass
... 
>>> asyncio.run(main())
>>> mock_instance.__aenter__.assert_awaited_once()
>>> mock_instance.__aexit__.assert_awaited_once()
```

--------------------------------

### Build and Install Custom Python Module

Source: https://github.com/python/cpython/blob/main/Doc/extending/newtypes_tutorial.rst

Provides the necessary Python setup files (`pyproject.toml` and `setup.py`) and shell commands to build and install a custom Python module written in C. This process compiles the C code and makes the module available for import.

```python
from setuptools import Extension, setup
setup(ext_modules=[Extension("custom", ["custom.c"])] )
```

```shell
$ python -m pip install .
```

--------------------------------

### Basic Argparse Setup

Source: https://github.com/python/cpython/blob/main/Doc/howto/argparse.rst

Demonstrates the minimal setup for an ArgumentParser, which automatically provides a --help option and handles unrecognized arguments.

```python
import argparse
parser = argparse.ArgumentParser()
args = parser.parse_args()
```

--------------------------------

### Bootstrap Application for Python Installer UI

Source: https://github.com/python/cpython/blob/main/Tools/msi/README.txt

This describes the C++ bootstrap application responsible for controlling the Python installer's UI, interacting with WiX for installation logic, and handling UI definitions from Default.thm.

```cpp
Bootstrap Application
----------------------

The bootstrap application is a C++ application that controls the UI and
installation. While it does not directly compile into the main EXE of
the installer, it forms the main active component. Most of the
installation functionality is provided by WiX, and so the bootstrap
application is predominantly responsible for the code behind the UI that
is defined in the Default.thm file. The bootstrap application code is in
bundle/bootstrap and is built automatically when building the bundle.
```

--------------------------------

### Custom Mock Subclass Example

Source: https://github.com/python/cpython/blob/main/Doc/library/unittest.mock-examples.rst

Illustrates creating a subclass of `MagicMock` to customize child mock behavior, ensuring attributes of the subclass do not inherit the subclass type.

```python
>>> class Subclass(MagicMock):
...     def _get_child_mock(self, /, **kwargs):
...         return MagicMock(**kwargs)
...
>>> mymock = Subclass()
>>> mymock.foo
<MagicMock name='mock.foo' id='...'>
>>> assert isinstance(mymock, Subclass)
>>> assert not isinstance(mymock.foo, Subclass)
>>> assert not isinstance(mymock(), Subclass)
```

--------------------------------

### Shell: Output of Basic Logging Example

Source: https://github.com/python/cpython/blob/main/Doc/howto/logging.rst

Shows the expected console output when running the basic Python logging setup example. Each line includes timestamp, logger name, level, and message.

```shell
$ python simple_logging_module.py
2005-03-19 15:10:26,618 - simple_example - DEBUG - debug message
2005-03-19 15:10:26,620 - simple_example - INFO - info message
2005-03-19 15:10:26,695 - simple_example - WARNING - warn message
2005-03-19 15:10:26,697 - simple_example - ERROR - error message
2005-03-19 15:10:26,773 - simple_example - CRITICAL - critical message
```

--------------------------------

### Install Free-threaded Python Binaries

Source: https://github.com/python/cpython/blob/main/Doc/using/windows.rst

Demonstrates how to install experimental free-threaded Python builds using the 'py install' command with tags specifying the version and architecture.

```bash
$> py install 3.14t
$> py install 3.14t-arm64
$> py install 3.14t-32
```

--------------------------------

### setup.py for C extension modules

Source: https://github.com/python/cpython/blob/main/Doc/whatsnew/2.0.rst

An example setup.py script for distributing Python packages with C extension modules. It defines extension details like include directories, source files, and macros using the Extension class.

```python
from distutils.core import setup, Extension

expat_extension = Extension('xml.parsers.pyexpat',
     define_macros = [('XML_NS', None)],
     include_dirs = [ 'extensions/expat/xmltok',
                      'extensions/expat/xmlparse' ],
     sources = [ 'extensions/pyexpat.c',
                 'extensions/expat/xmltok/xmltok.c',
                 'extensions/expat/xmltok/xmlrole.c' ]
       )
setup(name = "PyXML", version = "0.5.4",
      ext_modules =[ expat_extension ] )
```

--------------------------------

### URL Opener Creation and Installation

Source: https://github.com/python/cpython/blob/main/Doc/howto/urllib2.rst

Demonstrates how to create and install a custom URL opener using OpenerDirector or build_opener, including adding custom handlers and overriding defaults.

```APIDOC
## URL Opener Creation and Installation

### Description
This section explains how to create and manage URL openers in Python's `urllib.request` module. You can build openers from scratch using `OpenerDirector` and adding handlers, or use the convenience function `build_opener`. It also covers installing an opener as the global default for `urlopen` calls.

### Creating an Opener

Instantiate an `OpenerDirector` and add handlers using `.add_handler(some_handler_instance)`.

Alternatively, use the convenience function `build_opener()`. `build_opener` adds default handlers but allows for easy addition or overriding of handlers.

### Installing an Opener

Use `install_opener()` to make an opener object the global default. Subsequent calls to `urlopen` will use the installed opener.

### Opener `open` Method

Opener objects have an `open` method that can be called directly to fetch URLs, eliminating the need for `install_opener` unless for convenience.
```

--------------------------------

### Distutils Setup with Package Metadata

Source: https://github.com/python/cpython/blob/main/Doc/whatsnew/2.5.rst

Demonstrates how to use the `setup` function from Distutils to define package metadata, including dependencies (`requires`, `obsoletes`) and download URL. This information is used for packaging and distribution.

```python
VERSION = '1.0'
setup(name='PyPackage',
      version=VERSION,
      requires=['numarray', 'zlib (>=1.1.4)'],
      obsoletes=['OldPackage']
      download_url=('http://www.example.com/pypackage/dist/pkg-%s.tar.gz'
                    % VERSION),
     )
```

--------------------------------

### PEP 397 Launcher Installation Path

Source: https://github.com/python/cpython/blob/main/Tools/msi/README.txt

Details the installation path for the PEP 397 launcher (py.exe or pyw.exe), which is used for managing multiple Python versions.

```text
.\py[w].exe         PEP 397 launcher
```

--------------------------------

### Grammar for Arithmetic Expressions (Python AST)

Source: https://github.com/python/cpython/blob/main/InternalDocs/parser.md

A grammar similar to the C-based AST example, but specifically targeting Python AST objects. It defines rules for 'start', 'expr_stmt', 'expr', 'term', 'factor', and 'atom' using Python's 'ast' module.

```python
start[ast.Module]: a=expr_stmt* ENDMARKER { ast.Module(body=a or []) }
expr_stmt: a=expr NEWLINE { ast.Expr(value=a, EXTRA) }

expr:
    | l=expr '+' r=term { ast.BinOp(left=l, op=ast.Add(), right=r, EXTRA) }
    | l=expr '-' r=term { ast.BinOp(left=l, op=ast.Sub(), right=r, EXTRA) }
    | term

term:
    | l=term '*' r=factor { ast.BinOp(left=l, op=ast.Mult(), right=r, EXTRA) }
    | l=term '/' r=factor { ast.BinOp(left=l, op=ast.Div(), right=r, EXTRA) }
    | factor

factor:
    | '(' e=expr ')' { e }
    | atom

atom:
    | NAME
    | NUMBER
```

--------------------------------

### Tracking All Calls with mock_calls

Source: https://github.com/python/cpython/blob/main/Doc/library/unittest.mock-examples.rst

Explains how to use the `mock_calls` attribute of a mock object to record all calls made to the mock and its children. This is useful for verifying complex interaction sequences.

```python
>>> mock = MagicMock()
>>> mock.method()
<MagicMock name='mock.method()' id='...'>
>>> mock.attribute.method(10, x=53)
<MagicMock name='mock.attribute.method()' id='...'>
>>> mock.mock_calls
[call.method(), call.attribute.method(10, x=53)]
```

--------------------------------

### Process start and termination example

Source: https://github.com/python/cpython/blob/main/Doc/library/multiprocessing.rst

Demonstrates creating, starting, and terminating a Process object using multiprocessing. The example shows how to check if a process is alive and retrieve its exit code after termination.

```python
>>> import multiprocessing, time, signal
>>> mp_context = multiprocessing.get_context('spawn')
>>> p = mp_context.Process(target=time.sleep, args=(1000,))
>>> print(p, p.is_alive())
<...Process ... initial> False
>>> p.start()
>>> print(p, p.is_alive())
<...Process ... started> True
>>> p.terminate()
>>> time.sleep(0.1)
>>> print(p, p.is_alive())
<...Process ... stopped exitcode=-SIGTERM> False
>>> p.exitcode == -signal.SIGTERM
True
```

--------------------------------

### Grammar for Arithmetic Expressions (C-based Python AST)

Source: https://github.com/python/cpython/blob/main/InternalDocs/parser.md

An example grammar for parsing arithmetic expressions, generating C-based Python AST nodes. It defines rules for 'start', 'expr_stmt', 'expr', 'term', 'factor', and 'atom'. 'EXTRA' is a macro for AST node metadata.

```c
start[mod_ty]: a=expr_stmt* ENDMARKER { _PyAST_Module(a, NULL, p->arena) }
expr_stmt[stmt_ty]: a=expr NEWLINE { _PyAST_Expr(a, EXTRA) }

expr[expr_ty]:
    | l=expr '+' r=term { _PyAST_BinOp(l, Add, r, EXTRA) }
    | l=expr '-' r=term { _PyAST_BinOp(l, Sub, r, EXTRA) }
    | term

term[expr_ty]:
    | l=term '*' r=factor { _PyAST_BinOp(l, Mult, r, EXTRA) }
    | l=term '/' r=factor { _PyAST_BinOp(l, Div, r, EXTRA) }
    | factor

factor[expr_ty]:
    | '(' e=expr ')' { e }
    | atom

atom[expr_ty]:
    | NAME
    | NUMBER
```

--------------------------------

### Starting and Serving Forever with Asyncio (Python)

Source: https://github.com/python/cpython/blob/main/Doc/library/asyncio-eventloop.rst

Shows how to start accepting connections indefinitely using the `serve_forever` coroutine. This method is part of the asyncio Server object and can be used after a server is created, especially if it was initially configured not to accept connections. The example also illustrates setting up a client connection handler.

```python
async def client_connected(reader, writer):
    # Communicate with the client with
    # reader/writer streams.  For example:
    await reader.readline()

async def main(host, port):
    srv = await asyncio.start_server(
        client_connected, host, port)
    await srv.serve_forever()

asyncio.run(main('127.0.0.1', 0))
```

--------------------------------

### Get Installation Paths

Source: https://github.com/python/cpython/blob/main/Doc/library/sysconfig.rst

Retrieve installation paths based on a specified scheme.

```APIDOC
## GET /sysconfig/install_paths/{scheme}

### Description
Retrieves the installation paths for a given scheme.

### Method
GET

### Endpoint
/sysconfig/install_paths/{scheme}

### Parameters
#### Path Parameters
- **scheme** (string) - The installation scheme identifier (e.g., 'posix_prefix', 'nt_user', 'venv').

### Request Example
```
GET /sysconfig/install_paths/posix_user
```

### Response
#### Success Response (200)
- **paths** (object) - A dictionary where keys are path identifiers (e.g., 'stdlib', 'platlib', 'scripts') and values are the corresponding installation directories.

#### Response Example
```json
{
  "paths": {
    "stdlib": "/home/user/.local/lib/python3.9",
    "platstdlib": "/home/user/.local/lib/python3.9",
    "platlib": "/home/user/.local/lib/python3.9/site-packages",
    "purelib": "/home/user/.local/lib/python3.9/site-packages",
    "include": "/home/user/.local/include/python3.9",
    "platinclude": "/home/user/.local/include/python3.9",
    "scripts": "/home/user/.local/bin",
    "data": "/home/user/.local/share/python3.9"
  }
}
```
```

--------------------------------

### WSGI Hello World Application Example

Source: https://github.com/python/cpython/blob/main/Doc/library/wsgiref.rst

Provides a basic 'Hello World' WSGI application example demonstrating the application object structure and the use of the start_response callable.

```APIDOC
## Hello World WSGI Application

### Description
This is a working 'Hello World' WSGI application, where the *start_response* callable should follow the .StartResponse protocol. Every WSGI application must have an application object - a callable object that accepts two arguments: an environ dictionary and a start_response callable.

### Method
Callable Function

### Endpoint
N/A

### Parameters
#### Path Parameters
N/A

#### Query Parameters
N/A

#### Request Body
N/A

### Request Example
```python
from wsgiref.simple_server import make_server

def hello_world_app(environ, start_response):
    status = "200 OK"  # HTTP Status
    # ... (rest of the application logic)
```

### Response
#### Success Response (200)
HTTP Response with status '200 OK'.

#### Response Example
N/A
```

--------------------------------

### Python Installer Build Script for Testing (Batch)

Source: https://github.com/python/cpython/blob/main/Tools/msi/README.txt

This batch script is used to build the Python installer for testing purposes. It allows specifying target architectures (x86, x64, ARM64) and options to include documentation or build side-by-side installers.

```batch
build.bat [-x86] [-x64] [-ARM64] [--doc] [--test-marker] [--pack]
```

--------------------------------

### Import and Initialize OptionParser

Source: https://github.com/python/cpython/blob/main/Doc/library/optparse.rst

Demonstrates the initial steps to use the optparse module by importing the OptionParser class and creating an instance.

```python
from optparse import OptionParser
...
parser = OptionParser()
```

--------------------------------

### Python: Creating an OptionParser instance

Source: https://github.com/python/cpython/blob/main/Doc/library/optparse.rst

Demonstrates the initialization of an OptionParser object with various optional keyword arguments such as usage, description, and version.

```Python
from optparse import OptionParser

parser = OptionParser(
    usage="usage: %prog [options] arg",
    version="%prog 1.0"
)
```

--------------------------------

### setup.py for Python packages with subpackages

Source: https://github.com/python/cpython/blob/main/Doc/whatsnew/2.0.rst

An example setup.py script for distributing Python packages that include subpackages. It specifies the package structure using the 'packages' argument.

```python
from distutils.core import setup

setup(name = "foo", version = "1.0",
      packages = ["package", "package.subpackage"])
```

--------------------------------

### Python unittest TestCase example

Source: https://github.com/python/cpython/blob/main/Doc/library/unittest.rst

An example of creating a test case by subclassing unittest.TestCase and implementing a test method. The test method name must start with 'test' to be recognized by the test runner.

```python
import unittest

class DefaultWidgetSizeTestCase(unittest.TestCase):
    def test_default_widget_size(self):
        widget = Widget('The widget')
        self.assertEqual(widget.size(), (50, 50))
```

--------------------------------

### Python Installation Directory Structure

Source: https://github.com/python/cpython/blob/main/Tools/msi/README.txt

Describes the typical files and folders found within a Python installation directory, including executables, DLLs, libraries, documentation, and scripts.

```text
.\python[w].exe The core executable files
.\python3x.dll  The core interpreter
.\python3.dll   The stable ABI reference
.\DLLs          Stdlib extensions (*.pyd) and dependencies
.\Doc           Documentation (*.html)
.\include       Development headers (*.h)
.\Lib           Standard library
.\Lib\test      Test suite
.\libs          Development libraries (*.lib)
.\Scripts       Launcher scripts (*.exe, *.py)
.\tcl           Tcl dependencies (*.dll, *.tcl and others)
.\Tools         Tool scripts (*.py)
```

--------------------------------

### Python range() Function Examples

Source: https://github.com/python/cpython/blob/main/Doc/tutorial/controlflow.rst

Demonstrates the Python built-in range() function for generating arithmetic progressions. Includes examples of default, custom start, and step values.

```python
>>> for i in range(5):
   ...     print(i)
   ...
   0
   1
   2
   3
   4
```

```python
>>> list(range(5, 10))
   [5, 6, 7, 8, 9]
```

```python
>>> list(range(0, 10, 3))
   [0, 3, 6, 9]
```

```python
>>> list(range(-10, -100, -30))
   [-10, -40, -70]
```

--------------------------------

### Get available pip version (Python API)

Source: https://github.com/python/cpython/blob/main/Doc/library/ensurepip.rst

The version() function returns a string specifying the available version of pip that will be installed when bootstrapping an environment.

```python
import ensurepip

print(ensurepip.version())
```

--------------------------------

### Build Installer Layouts with MSBuild

Source: https://github.com/python/cpython/blob/main/Tools/msi/README.txt

Commands to build different types of Python installer layouts using MSBuild. These commands target specific WiX project files to produce installers for testing or release.

```shell
msbuild bundle\snapshot.wixproj
msbuild bundle\releaseweb.wixproj
msbuild bundle\releaseweb.wixproj
msbuild bundle\full.wixproj
```

--------------------------------

### Command Line Interface

Source: https://github.com/python/cpython/blob/main/Doc/library/ensurepip.rst

Instructions on how to use the ensurepip module from the command line to install or upgrade pip.

```APIDOC
## Command Line Interface

### Description
Invoke ensurepip using the Python interpreter's `-m` switch to bootstrap the `pip` installer.

### Usage

**Basic Installation:**
```bash
python -m ensurepip
```
This installs `pip` if it's not already present. If `pip` is already installed, this command does nothing.

**Upgrade Existing pip:**
```bash
python -m ensurepip --upgrade
```
This ensures that the installed version of `pip` is at least as recent as the version bundled with `ensurepip`.

**Controlling Installation Location:**

*   `--root <dir>`: Installs `pip` relative to the specified directory instead of the default location (virtual environment or system site packages).
*   `--user`: Installs `pip` into the user site-packages directory. This option is not permitted within an active virtual environment.

**Controlling Script Installation:**

*   `--altinstall`: Prevents the installation of the `pipX` script (where X is the Python version). Only `pipX.Y` and potentially `pip` scripts are installed.
*   `--default-pip`: Installs the `pip` script in addition to the default `pipX` and `pipX.Y` scripts.

**Note:** Providing both `--altinstall` and `--default-pip` will result in an error.
```

--------------------------------

### Generating Python Package Sources with WiX

Source: https://github.com/python/cpython/blob/main/Tools/msi/README.txt

This snippet shows how WiX's InstallFiles element can be used in a .wixproj file to generate sources for packages, including the logic for cleaning __pycache__ directories.

```xml
<InstallFiles element in the .wixproj file to generate sources. See lib/lib.wixproj for an
example, and msi.targets and csv_to_wxs.py for the implementation. This
element is also responsible for generating the code for cleaning up and
removing __pycache__ folders in any directory containing .py files.
```

--------------------------------

### Update ./configure --help documentation

Source: https://github.com/python/cpython/blob/main/Misc/NEWS.d/3.9.0a3.rst

The documentation for './configure --help' has been updated to display default values for options, reference necessary documentation, and provide additional explanations. This improves the usability of the configure script.

```bash
# Execute the configure script with the --help option to see updated documentation:
./configure --help
```

--------------------------------

### Example Command-Line Parsing

Source: https://github.com/python/cpython/blob/main/Doc/library/optparse.rst

Illustrates a hypothetical command-line with options, option arguments, and positional arguments, explaining how they are identified.

```text
prog -v --report report.txt foo bar
```

--------------------------------

### Decimal Module Quick-Start Tutorial

Source: https://github.com/python/cpython/blob/main/Doc/library/decimal.rst

Demonstrates the basic usage of the decimal module, including importing, getting and setting the context, constructing Decimal instances, and handling special values.

```APIDOC
## Decimal Module Quick-Start Tutorial

### Description
This section provides a quick-start guide to using Python's `decimal` module for precise floating-point arithmetic. It covers importing the module, inspecting and modifying the current context (precision, rounding, traps), and constructing `Decimal` objects from various inputs.

### Method
N/A (Tutorial Overview)

### Endpoint
N/A (Module Usage)

### Parameters
N/A

### Request Example
```python
from decimal import *

# Get current context
print(getcontext())

# Set precision
getcontext().prec = 7

# Construct Decimal instances
print(Decimal(10))
print(Decimal('3.14'))
print(Decimal(3.14))
print(Decimal('NaN'))
print(Decimal('-Infinity'))
```

### Response
#### Success Response (N/A)
N/A

#### Response Example
```
Context(prec=28, rounding=ROUND_HALF_EVEN, Emin=-999999, Emax=999999, capitals=1, clamp=0, flags=[], traps=[Overflow, DivisionByZero, InvalidOperation])
Decimal('10')
Decimal('3.14')
Decimal('3.140000000000000124344978758017532527446746826171875')
Decimal('NaN')
Decimal('-Infinity')
```
```

--------------------------------

### IMAP4 Basic Usage Example (Python)

Source: https://github.com/python/cpython/blob/main/Doc/library/imaplib.rst

A minimal example illustrating how to connect to an IMAP server, open a mailbox, and retrieve all messages. This serves as a starting point for interacting with IMAP servers using Python.

```python
import getpass, imaplib

M = imaplib.IMAP4(host='example.org')
```

--------------------------------

### Mocking Class Instantiation with patch

Source: https://github.com/python/cpython/blob/main/Doc/library/unittest.mock-examples.rst

Demonstrates how to mock a class using unittest.mock.patch. When a class is patched, calls to instantiate it return a mock object whose return_value can be configured to simulate instance behavior.

```python
>>> def some_function():
...     instance = module.Foo()
...     return instance.method()
...
>>> with patch('module.Foo') as mock:
...     instance = mock.return_value
...     instance.method.return_value = 'the result'
...     result = some_function()
...     assert result == 'the result'
```

--------------------------------

### Python itertools.count() examples

Source: https://github.com/python/cpython/blob/main/Doc/howto/functional.rst

Generates an infinite stream of evenly spaced values. Accepts optional start and step arguments. Defaults to starting at 0 with a step of 1.

```python
import itertools

itertools.count()
# Output: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, ...
itertools.count(10)
# Output: 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, ...
itertools.count(10, 5)
# Output: 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, ...
```

--------------------------------

### mimetypes CLI: Get MIME type by URL

Source: https://github.com/python/cpython/blob/main/Doc/library/mimetypes.rst

Example of using the mimetypes command-line interface to get the MIME type of a URL.

```console
$ python -m mimetypes https://example.com/filename.txt
type: text/plain encoding: None
```

--------------------------------

### WiX Bundle Configuration and Package Groups

Source: https://github.com/python/cpython/blob/main/Tools/msi/README.txt

This section describes the structure of the WiX bundle, including the main EXE, package references, package groups, and payload groups used for embedding and downloading files. It also touches on install conditions for MSI and EXE packages.

```xml
Bundle
------

The bundle is compiled to the main EXE entry point that for most users
will represent the Python installer. It is built from Tools/msi/bundle
with packages references in Tools/msi/bundle/packagegroups.

Build logic for the bundle is in bundle.targets, but should be invoked
through one of the .wixproj files as described in Building the
Installer.

The UI is separated between Default.thm (UI layout), Default.wxl
(strings), bundle.wxs (properties) and the bootstrap application.
Bundle.wxs also contains the chain, which is the list of packages to
install and the order they should be installed in. These refer to named
package groups in bundle/packagegroups.

Each package group specifies one or more packages to install. Most
packages require two separate entries to support both per-user and
all-users installations. Because these reuse the same package, it does
not increase the overall size of the package.

Package groups refer to payload groups, which allow better control over
embedding and downloading files than the default settings. Whether files
are embedded and where they are downloaded from depends on settings
created by the project files.

Package references can include install conditions that determine when to
install the package. When a package is a dependency for others, the
condition should be crafted to ensure it is installed.

MSI packages are installed or uninstalled based on their current state
and the install condition. This makes them most suitable for features
that are clearly present or absent from the user's machine.

EXE packages are executed based on a customisable condition that can be
omitted. This makes them suitable for pre- or post-install tasks that
need to run regardless of whether features have been added or removed.
```

--------------------------------

### Get Python Distribution Package Version

Source: https://github.com/python/cpython/blob/main/Doc/library/importlib.metadata.rst

Retrieves the version of an installed Python distribution package. Raises PackageNotFoundError if the package is not installed. Returns the version as a string.

```python
from importlib.metadata import version

print(version('wheel'))
```

--------------------------------

### mimetypes CLI: Get MIME type by filename

Source: https://github.com/python/cpython/blob/main/Doc/library/mimetypes.rst

Example of using the mimetypes command-line interface to get the MIME type of a file.

```console
$ python -m mimetypes filename.png
type: image/png encoding: None
```

--------------------------------

### Get All Installation Paths for a Scheme

Source: https://github.com/python/cpython/blob/main/Doc/library/sysconfig.rst

Returns a dictionary containing all installation paths for a given scheme. If no scheme is specified, the default scheme is used. Paths can be expanded or not.

```python
import sysconfig

# Get all paths for the default scheme
all_paths = sysconfig.get_paths()
print(f"All default paths: {all_paths}")

# Get all paths for a specific scheme (e.g., 'nt') without expansion
nt_paths_no_expand = sysconfig.get_paths(scheme='nt', expand=False)
print(f"NT scheme paths (no expand): {nt_paths_no_expand}")
```

--------------------------------

### Optparse Usage Example (Shell)

Source: https://github.com/python/cpython/blob/main/Doc/library/optparse.rst

A sample shell session demonstrating the output of an optparse-configured script when the --version option is used.

```shell-session
$ /usr/bin/foo --version
foo 1.0
```

--------------------------------

### Registry Keys for Python Core Installation (64-bit, All Users)

Source: https://github.com/python/cpython/blob/main/Tools/msi/README.txt

Specifies the root registry key for 64-bit Python interpreters installed for all users.

```registry
HKEY_LOCAL_MACHINE\Software\Python\PythonCore\3.X
```

--------------------------------

### Setup Python Extension Modules

Source: https://github.com/python/cpython/blob/main/Doc/extending/newtypes_tutorial.rst

Configures the setup.py file to build and install Python extension modules. It uses setuptools.Extension to specify the module name and the corresponding C source file.

```python
from setuptools import Extension, setup
setup(
    ext_modules=[
        Extension("custom", ["custom.c"]),
        Extension("custom2", ["custom2.c"]),
    ]
)
```

--------------------------------

### Install CPython after building

Source: https://github.com/python/cpython/blob/main/Doc/using/configure.rst

The `make install` target first builds the `all` target (the complete Python project) and then proceeds to install the compiled Python binaries and associated files to the system.

```make
make install
```

--------------------------------

### cProfile.Profile.enable

Source: https://github.com/python/cpython/blob/main/Doc/library/profile.rst

Starts collecting profiling data.

```APIDOC
## cProfile.Profile.enable

### Description
Starts collecting profiling data.

### Method
Method

### Endpoint
N/A

### Parameters
#### Path Parameters
None

#### Query Parameters
None

#### Request Body
None

### Request Example
```python
import cProfile

pr = cProfile.Profile()
pr.enable()
# Code to profile goes here
```

### Response
#### Success Response (200)
Profiling collection is enabled.

#### Response Example
```
None
```
```

--------------------------------

### Saferepr Function Example

Source: https://github.com/python/cpython/blob/main/Doc/library/pprint.rst

Shows an example of using the saferepr function to get a string representation of an object, protected against recursion in common data structures.

```python
>>> import pprint
>>> stuff = ['spam', 'eggs', 'lumberjack', 'knights', 'ni']
>>> stuff.insert(0, stuff[:]) # Make it recursive
>>> pprint.saferepr(stuff)
"[<Recursion on list with id=...>, 'spam', 'eggs', 'lumberjack', 'knights', 'ni']"
```

--------------------------------

### Setting Return Values and Attributes on Mocks

Source: https://github.com/python/cpython/blob/main/Doc/library/unittest.mock-examples.rst

Explains how to set return values for mock objects and their methods directly or during initialization. It also shows how to assign attributes to mocks.

```python
>>> from unittest.mock import Mock
>>> mock = Mock()
>>> mock.return_value = 3
>>> mock()
3
```

```python
>>> mock = Mock()
>>> mock.method.return_value = 3
>>> mock.method()
3
```

```python
>>> mock = Mock(return_value=3)
>>> mock()
3
```

```python
>>> mock = Mock()
>>> mock.x = 3
>>> mock.x
3
```

--------------------------------

### Install Python Package

Source: https://github.com/python/cpython/blob/main/Doc/extending/newtypes_tutorial.rst

Command to install the Python package, typically used after modifying setup.py or extension modules. This command rebuilds and installs the package in the current environment.

```shell
python -m pip install .
```

--------------------------------

### Python SequenceMatcher Get Matching Blocks Example

Source: https://github.com/python/cpython/blob/main/Doc/library/difflib.rst

Demonstrates how to use `SequenceMatcher.get_matching_blocks()` to find non-overlapping matching subsequences between two strings. It initializes a `SequenceMatcher` object and then calls `get_matching_blocks()` to retrieve a list of `Match` objects, each representing a matching block by its start indices in `a` and `b` and its size. The last `Match` object in the list is a dummy with size 0, indicating the end of the sequences.

```python
s = SequenceMatcher(None, "abxcd", "abcd")
s.get_matching_blocks()
```

--------------------------------

### Create and Activate a Virtual Environment

Source: https://github.com/python/cpython/blob/main/Doc/using/windows.rst

Demonstrates the standard Python method for creating and activating a virtual environment. This is recommended for project isolation and dependency management.

```bash
python -m venv <env path>
```

```bash
<env>\Scripts\Activate
```

--------------------------------

### Start and Serve with BaseManager

Source: https://github.com/python/cpython/blob/main/Doc/library/multiprocessing.rst

This snippet demonstrates how to create a BaseManager, get its server object, and start serving requests indefinitely. It requires importing BaseManager from multiprocessing.managers.

```python
from multiprocessing.managers import BaseManager

manager = BaseManager(address=('', 50000), authkey=b'abc')
server = manager.get_server()
server.serve_forever()
```

--------------------------------

### Option Argument Syntax Examples

Source: https://github.com/python/cpython/blob/main/Doc/library/optparse.rst

Demonstrates various ways an option argument can follow its option on the command line. This includes arguments in separate or the same command-line tokens.

```text
-f foo
--file foo
```

```text
-ffoo
--file=foo
```

--------------------------------

### Create Doctest TestSuite from Files

Source: https://github.com/python/cpython/blob/main/Doc/library/doctest.rst

Describes the DocFileSuite function, which creates a unittest.TestSuite from doctests found in text files. It details parameters like package, module_relative, setUp, tearDown, globs, optionflags, parser, and encoding, explaining their roles in test execution and context setup.

```python
   calling module's directory is used as the base directory for module-relative
   filenames.  It is an error to specify *package* if *module_relative* is
   ``False``.

   Optional argument *setUp* specifies a set-up function for the test suite.
   This is called before running the tests in each file.  The *setUp* function
   will be passed a :class:`DocTest` object.  The *setUp* function can access the
   test globals as the :attr:`~DocTest.globs` attribute of the test passed.

   Optional argument *tearDown* specifies a tear-down function for the test
   suite.  This is called after running the tests in each file.  The *tearDown*
   function will be passed a :class:`DocTest` object.  The *tearDown* function can
   access the test globals as the :attr:`~DocTest.globs` attribute of the test
   passed.

   Optional argument *globs* is a dictionary containing the initial global
   variables for the tests.  A new copy of this dictionary is created for each
   test.  By default, *globs* is a new empty dictionary.

   Optional argument *optionflags* specifies the default doctest options for the
   tests, created by or-ing together individual option flags.  See section
   :ref:`doctest-options`. See function :func:`set_unittest_reportflags` below
   for a better way to set reporting options.

   Optional argument *parser* specifies a :class:`DocTestParser` (or subclass)
   that should be used to extract tests from the files.  It defaults to a normal
   parser (i.e., ``DocTestParser()``).

   Optional argument *encoding* specifies an encoding that should be used to
   convert the file to unicode.

   The global ``__file__`` is added to the globals provided to doctests loaded
   from a text file using :func:`DocFileSuite`.
```

--------------------------------

### Get Supported Start Methods (multiprocessing)

Source: https://github.com/python/cpython/blob/main/Doc/library/multiprocessing.rst

Returns a list of available process start methods ('fork', 'spawn', 'forkserver'), with the default method listed first. Not all methods are supported on every platform.

```python
from multiprocessing import get_all_start_methods

methods = get_all_start_methods()
print(f"Supported start methods: {methods}")
```

--------------------------------

### WSGI Hello World Application Example

Source: https://github.com/python/cpython/blob/main/Doc/library/wsgiref.rst

A basic WSGI application demonstrating the 'Hello World' response. It defines a callable that accepts environment and start_response arguments, sets the HTTP status, and returns a simple byte string. It also shows how to create a WSGI server using make_server.

```python
from wsgiref.simple_server import make_server

def hello_world_app(environ, start_response):
    status = "200 OK"  # HTTP Status

```

--------------------------------

### Minimal setup.py for Python-only packages

Source: https://github.com/python/cpython/blob/main/Doc/whatsnew/2.0.rst

A basic setup.py script for distributing Python packages containing only .py files. It uses distutils.core.setup to define package metadata and modules.

```python
from distutils.core import setup

setup(name = "foo", version = "1.0",
      py_modules = ["module1", "module2"])
```

--------------------------------

### mimetypes CLI: Get complex MIME type

Source: https://github.com/python/cpython/blob/main/Doc/library/mimetypes.rst

Example of using the mimetypes command-line interface to get the MIME type of a file with a complex extension like .tar.gz.

```console
$ python -m mimetypes filename.tar.gz
type: application/x-tar encoding: gzip
```

--------------------------------

### Tracking Call Order with Mock.mock_calls

Source: https://github.com/python/cpython/blob/main/Doc/library/unittest.mock-examples.rst

Explains how to use the `mock_calls` attribute of a parent mock to track the order of calls made to its child mocks. This is achieved by creating child mocks from the parent mock.

```python
>>> manager = Mock()
>>> mock_foo = manager.foo
>>> mock_bar = manager.bar

>>> mock_foo.something()
<Mock name='mock.foo.something()' id='...'>
>>> mock_bar.other.thing()
<Mock name='mock.bar.other.thing()' id='...'>

>>> manager.mock_calls
[call.foo.something(), call.bar.other.thing()]

>>> expected_calls = [call.foo.something(), call.bar.other.thing()]
>>> manager.mock_calls == expected_calls
True
```

--------------------------------

### Python Range Examples

Source: https://github.com/python/cpython/blob/main/Doc/library/stdtypes.rst

Demonstrates various ways to create and use Python's range() function to generate sequences of numbers. Includes examples with different start, stop, and step values, as well as edge cases.

```python
>>> list(range(10))
[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
>>> list(range(1, 11))
[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
>>> list(range(0, 30, 5))
[0, 5, 10, 15, 20, 25]
>>> list(range(0, 10, 3))
[0, 3, 6, 9]
>>> list(range(0, -10, -1))
[0, -1, -2, -3, -4, -5, -6, -7, -8, -9]
>>> list(range(0))
[]
>>> list(range(1, 0))
[]
```

--------------------------------

### Template for New Test File

Source: https://github.com/python/cpython/blob/main/Lib/idlelib/idle_test/README.txt

Example Python code structure for a new test file, including unittest setup and main execution block.

```python
if __name__ == "__main__":
    from unittest import main
    main('idlelib.idle_test.test_abc', verbosity=2, exit=False)
```

--------------------------------

### Worker Thread Example using queue.Queue

Source: https://github.com/python/cpython/blob/main/Doc/faq/library.rst

Demonstrates a basic multithreaded application where worker threads consume jobs from a queue. It shows how to create a queue, start multiple worker threads, put jobs into the queue, and how workers handle an empty queue. This example uses the `threading` and `queue` modules.

```python
import threading, queue, time

# The worker thread gets jobs off the queue.  When the queue is empty, it
# assumes there will be no more work and exits.
# (Realistically workers will run until terminated.)
def worker():
    print('Running worker')
    time.sleep(0.1)
    while True:
        try:
            arg = q.get(block=False)
        except queue.Empty:
            print('Worker', threading.current_thread(), end=' ')
            print('queue empty')
            break
        else:
            print('Worker', threading.current_thread(), end=' ')
            print('running with argument', arg)
            time.sleep(0.5)

# Create queue
q = queue.Queue()

# Start a pool of 5 workers
for i in range(5):
    t = threading.Thread(target=worker, name='worker %i' % (i+1))
    t.start()

# Begin adding work to the queue
for i in range(50):
    q.put(i)

# Give threads time to run
print('Main thread sleeping')
time.sleep(5)
```

--------------------------------

### install_opener - Install Global Opener

Source: https://github.com/python/cpython/blob/main/Doc/library/urllib.request.rst

Installs an OpenerDirector instance as the default global opener for urlopen.

```APIDOC
## POST install_opener

### Description
Installs an OpenerDirector instance as the global opener, which will be used by subsequent calls to urlopen.

### Method
POST

### Endpoint
/install_opener

### Parameters
#### Request Body
- **opener** (OpenerDirector) - Required - The OpenerDirector instance to install.

### Request Example
```json
{
  "opener": "<OpenerDirector instance>"
}
```

### Response
#### Success Response (200)
- **message** (string) - A success message indicating the opener was installed.

#### Response Example
```json
{
  "message": "Global opener installed successfully."
}
```

### Errors
- **TypeError**: If the provided opener is not an OpenerDirector instance.
```

--------------------------------

### Get Distribution Version

Source: https://github.com/python/cpython/blob/main/Doc/library/importlib.metadata.rst

Retrieves the installed version of a specified distribution package.

```APIDOC
## GET /dist/version

### Description
Returns the installed distribution package version for the named distribution package.

### Method
GET

### Endpoint
`/dist/version/{distribution_name}`

### Parameters
#### Path Parameters
- **distribution_name** (string) - Required - The name of the distribution package.

### Response
#### Success Response (200)
- **version** (string) - The version of the distribution package.

#### Response Example
```json
{
  "version": "0.32.3"
}
```

#### Error Response (404)
- **message** (string) - Indicates that the distribution package was not found.

#### Error Example
```json
{
  "message": "PackageNotFoundError: No package found with name 'nonexistent_package'"
}
```
```

--------------------------------

### mimetypes CLI: Get extension by MIME type

Source: https://github.com/python/cpython/blob/main/Doc/library/mimetypes.rst

Example of using the mimetypes command-line interface with the --extension option to get the file extension for a given MIME type.

```console
$ python -m mimetypes --extension text/javascript
.js
```

--------------------------------

### Python site module: .pth file configuration example

Source: https://github.com/python/cpython/blob/main/Doc/library/site.rst

Demonstrates how .pth files are used to add directories to sys.path and execute Python code during site initialization. Lines starting with '#' are comments, and lines starting with 'import' are executed. Non-existent paths are ignored.

```python
# foo package configuration

foo
bar
bletch
```

```python
# bar package configuration

bar
```

--------------------------------

### Python Installer Build Script for Official Release (Batch)

Source: https://github.com/python/cpython/blob/main/Tools/msi/README.txt

This batch script is used to build the Python installer for official releases. It requires specific environment variables to be set and supports options for target architectures, skipping documentation or Python rebuilds, specifying output directories, and code signing.

```batch
set PYTHON=<path to Python 3.10 or later>
set SPHINXBUILD=<path to sphinx-build.exe>
set PATH=<path to Git (git.exe)>;%PATH%

buildrelease.bat [-x86] [-x64] [-ARM64] [-D] [-B]
    [-o <output directory>] [-c <certificate name>]
```

--------------------------------

### Python HTTP GET using async/await

Source: https://github.com/python/cpython/blob/main/Doc/whatsnew/3.5.rst

An example of an asynchronous HTTP GET client implemented using Python's async/await syntax. It utilizes asyncio for network operations and asynchronous iteration over received data.

```python
import asyncio

async def http_get(domain):
    reader, writer = await asyncio.open_connection(domain, 80)

    writer.write(b'\r\n'.join([
        b'GET / HTTP/1.1',
        b'Host: %b' % domain.encode('latin-1'),
        b'Connection: close',
        b'', b''
    ]))

    async for line in reader:
        print('>>>', line)

    writer.close()

loop = asyncio.get_event_loop()
try:
    loop.run_until_complete(http_get('example.com'))
finally:
    loop.close()
```

--------------------------------

### Registry Keys for Python Core Installation (64-bit, Current User)

Source: https://github.com/python/cpython/blob/main/Tools/msi/README.txt

Specifies the root registry key for 64-bit Python interpreters installed for the current user.

```registry
HKEY_CURRENT_USER\Software\Python\PythonCore\3.X
```

--------------------------------

### Naming Mocks with MagicMock

Source: https://github.com/python/cpython/blob/main/Doc/library/unittest.mock-examples.rst

Shows how to assign a name to a MagicMock object. The name is included in the mock's representation and is propagated to its attributes and methods, aiding in debugging and test output.

```python
>>> mock = MagicMock(name='foo')
>>> mock
<MagicMock name='foo' id='...'>
>>> mock.method
<MagicMock name='foo.method' id='...'>
```

--------------------------------

### Install gettext for application-wide localization

Source: https://github.com/python/cpython/blob/main/Doc/library/gettext.rst

This demonstrates how to install the gettext translation function globally for an entire application. This allows all files within the application to use the '_' function for translations without explicit setup in each file.

```python
import gettext
gettext.install('myapplication')
```

--------------------------------

### Registry Keys for Python Core Installation (32-bit, All Users on 64-bit OS)

Source: https://github.com/python/cpython/blob/main/Tools/msi/README.txt

Specifies the root registry key for 32-bit Python interpreters installed for all users on a 64-bit operating system.

```registry
HKEY_LOCAL_MACHINE\Software\Wow6432Node\Python\PythonCore\3.X-32
```

--------------------------------

### Get Default Installation Scheme

Source: https://github.com/python/cpython/blob/main/Doc/library/sysconfig.rst

Returns the default installation scheme name for the current platform. This function's name and behavior have evolved across Python versions.

```python
import sysconfig

default_scheme = sysconfig.get_default_scheme()
print(f"Default scheme: {default_scheme}")
```

--------------------------------

### HTTPConnection.request() Example

Source: https://github.com/python/cpython/blob/main/Doc/library/http.client.rst

Demonstrates how to perform a GET request to a specified host and path, including setting the Host header.

```APIDOC
## GET https://docs.python.org/3/

### Description
Performs a GET request to the specified host and path.

### Method
GET

### Endpoint
/3/

### Parameters
#### Path Parameters
- **host** (string) - Required - The hostname to connect to.

#### Query Parameters
None

#### Request Body
None

### Request Example
```python
import http.client

host = "docs.python.org"
conn = http.client.HTTPSConnection(host)
conn.request("GET", "/3/", headers={"Host": host})
response = conn.getresponse()
print(response.status, response.reason)
```

### Response
#### Success Response (200)
- **status** (integer) - The HTTP status code.
- **reason** (string) - The HTTP reason phrase.

#### Response Example
```
200 OK
```
```

--------------------------------

### Get Specific Installation Path

Source: https://github.com/python/cpython/blob/main/Doc/library/sysconfig.rst

Retrieves a specific installation path by its name, optionally using a specified scheme, variables, and expansion settings. Raises KeyError if the name is not found.

```python
import sysconfig

# Get the 'stdlib' path using the default scheme
stdlib_path = sysconfig.get_path('stdlib')
print(f"Standard library path: {stdlib_path}")

# Get the 'scripts' path without expanding variables
scripts_path_no_expand = sysconfig.get_path('scripts', expand=False)
print(f"Scripts path (no expand): {scripts_path_no_expand}")
```

--------------------------------

### Get Current Start Method (multiprocessing)

Source: https://github.com/python/cpython/blob/main/Doc/library/multiprocessing.rst

Returns the name of the start method currently in use for spawning processes. If the global start method hasn't been set and allow_none is False, it defaults to the system's default and returns its name. Returns None if not set and allow_none is True.

```python
from multiprocessing import get_start_method

# Get start method, setting default if not already set
method = get_start_method()
print(f"Current start method: {method}")

# Get start method, returning None if not set
method_allow_none = get_start_method(allow_none=True)
print(f"Current start method (allow_none=True): {method_allow_none}")
```

--------------------------------

### Optparse: Basic command-line option parsing

Source: https://github.com/python/cpython/blob/main/Doc/library/optparse.rst

Demonstrates basic command-line option parsing using the optparse library. It sets up an OptionParser, adds options for output and verbosity, and parses arguments.

```python
import optparse

if __name__ == '__main__':
    parser = optparse.OptionParser()
    parser.add_option('-o', '--output')
    parser.add_option('-v', dest='verbose', action='store_true')
    opts, args = parser.parse_args()
    process(args, output=opts.output, verbose=opts.verbose)
```

--------------------------------

### Python: Basic TestCase with setUp and tearDown

Source: https://github.com/python/cpython/blob/main/Doc/library/unittest.rst

Demonstrates a basic unittest.TestCase subclass with setUp and tearDown methods for managing test fixtures. The setUp method initializes a widget, and tearDown disposes of it, ensuring a clean environment for each test.

```python
import unittest

class WidgetTestCase(unittest.TestCase):
    def setUp(self):
        self.widget = Widget('The widget')

    def tearDown(self):
        self.widget.dispose()

    def test_default_widget_size(self):
        self.assertEqual(self.widget.size(), (100, 150),
                         'incorrect default size')

    def test_widget_resize(self):
        self.widget.resize(100,150)
        self.assertEqual(self.widget.size(), (100,150),
                         'wrong size after resize')
```

--------------------------------

### Python: Enhance setup.py upload message

Source: https://github.com/python/cpython/blob/main/Misc/NEWS.d/3.6.5rc1.rst

Rewrites the confusing message from setup.py upload to be more helpful. The message now clarifies that files must be created and uploaded in a single command.

```python
Rewrite confusing message from setup.py upload from "No dist file created in
earlier command" to the more helpful "Must create and upload files in one
command".
```

--------------------------------

### Python POP3 Example: Fetch and Print Messages

Source: https://github.com/python/cpython/blob/main/Doc/library/poplib.rst

A minimal example demonstrating how to connect to a POP3 server, authenticate, retrieve all messages, and print their content.

```python
import getpass, poplib

M = poplib.POP3('localhost')
M.user(getpass.getuser())
M.pass_(getpass.getpass())
numMessages = len(M.list()[1])
for i in range(numMessages):
    for j in M.retr(i+1)[1]:
        print(j)
```

--------------------------------

### Upload Python Installer with uploadrelease.bat

Source: https://github.com/python/cpython/blob/main/Tools/msi/README.txt

Script to upload the Python installer to a specified host. It requires PuTTY utilities (plink.exe, pscp.exe) and optionally GPG for signing. Options include dry-run and disabling GPG.

```shell
uploadrelease.bat --host <host> --user <username> [--dry-run] [--no-gpg]
```

--------------------------------

### Registry Keys for Python Core Installation (32-bit, Current User)

Source: https://github.com/python/cpython/blob/main/Tools/msi/README.txt

Specifies the root registry key for 32-bit Python interpreters installed for the current user.

```registry
HKEY_CURRENT_USER\Software\Python\PythonCore\3.X-32
```

--------------------------------

### Get Preferred Installation Scheme

Source: https://github.com/python/cpython/blob/main/Doc/library/sysconfig.rst

Returns a preferred installation scheme name based on a given key ('prefix', 'home', or 'user'). The returned scheme can be used with other sysconfig functions.

```python
import sysconfig

preferred_scheme = sysconfig.get_preferred_scheme('prefix')
print(f"Preferred scheme for 'prefix': {preferred_scheme}")
```

--------------------------------

### Initialize OptionParser for command-line arguments

Source: https://github.com/python/cpython/blob/main/Doc/whatsnew/2.3.rst

Demonstrates the basic setup for command-line argument parsing using the optparse module. It shows how to create an OptionParser instance and add options like '--input'. This is a foundational step for building command-line tools that accept user-defined arguments.

```python
import sys
from optparse import OptionParser

op = OptionParser()
op.add_option('-i', '--input',

```

--------------------------------

### Server Methods for asyncio (Python)

Source: https://github.com/python/cpython/blob/main/Misc/NEWS.d/3.7.0b1.rst

Introduced Server.start_serving(), Server.serve_forever(), and Server.is_serving() methods. Additionally, added the 'start_serving' keyword parameter to loop.create_server() and loop.create_unix_server().

```python
import asyncio

async def handle_echo(reader, writer):
    data = await reader.read(100)
    message = data.decode()
    addr = writer.get_extra_info('peername')
    print(f"Received {message!r} from {addr!r}")

    print(f"Send: {message!r}")
    writer.write(data)
    await writer.drain()

    print("Close the connection")
    writer.close()
    await writer.wait_closed()

async def main():
    loop = asyncio.get_running_loop()
    
    # Using the new start_serving parameter
    server = await loop.create_server(
        handle_echo, '127.0.0.1', 8888, start_serving=True)

    addr = server.sockets[0].getsockname()
    print(f'Serving on {addr}')

    # Example of using server.serve_forever() if start_serving was False
    # await server.serve_forever()
    
    # Example of checking if serving
    print(f'Is serving: {server.is_serving()}')

    # Keep the server running for a bit
    await asyncio.sleep(10)
    server.close()
    await server.wait_closed()

# asyncio.run(main())
# Note: To run this, you would need a client to connect to the server.
```

--------------------------------

### Python SequenceMatcher Get Opcodes Example

Source: https://github.com/python/cpython/blob/main/Doc/library/difflib.rst

Illustrates the usage of `SequenceMatcher.get_opcodes()` to generate a list of operations required to transform sequence `a` into sequence `b`. The example initializes a `SequenceMatcher` with two strings and then iterates through the opcodes, printing each operation (delete, equal, replace, insert) along with the affected slices from both sequences.

```python
a = "qabxcd"
b = "abycdf"
s = SequenceMatcher(None, a, b)
for tag, i1, i2, j1, j2 in s.get_opcodes():
    print('{:7}   a[{}:{}] --> b[{}:{}] {!r:>8} --> {!r}'.format(
        tag, i1, i2, j1, j2, a[i1:i2], b[j1:j2]))
```

--------------------------------

### Get Multiprocessing Context for 'spawn' Method

Source: https://github.com/python/cpython/blob/main/Doc/library/multiprocessing.rst

Shows how to obtain a multiprocessing context for the 'spawn' start method using `get_context` and create processes and Queues from this context, allowing multiple start methods in one program.

```python
import multiprocessing as mp

def foo(q):
    q.put('hello')

if __name__ == '__main__':
    ctx = mp.get_context('spawn')
    q = ctx.Queue()
    p = ctx.Process(target=foo, args=(q,))
    p.start()
    print(q.get())
    p.join()
```

--------------------------------

### Python HTML Parser Example

Source: https://github.com/python/cpython/blob/main/Doc/library/html.parser.rst

This example demonstrates how to use the HTMLParser class from the html.parser module to parse HTML content. It defines a custom parser that prints encountered start tags, end tags, and data.

```python
from html.parser import HTMLParser

class MyHTMLParser(HTMLParser):
    def handle_starttag(self, tag, attrs):
        print("Encountered a start tag:", tag)

    def handle_endtag(self, tag):
        print("Encountered an end tag :", tag)

    def handle_data(self, data):
        print("Encountered some data  :", data)

parser = MyHTMLParser()
parser.feed('<html><head><title>Test</title></head>'
            '<body><h1>Parse me!</h1></body></html>')
```

--------------------------------

### Configuring Chained Calls with Mocks

Source: https://github.com/python/cpython/blob/main/Doc/library/unittest.mock-examples.rst

Demonstrates how to configure mocks for chained method calls, such as mocking `mock.connection.cursor().execute()`. It uses `call.list()` to create assertions for chained calls.

```python
>>> from unittest.mock import Mock, call
>>> mock = Mock()
>>> cursor = mock.connection.cursor.return_value
>>> cursor.execute.return_value = ['foo']
>>> mock.connection.cursor().execute("SELECT 1")
['foo']
>>> expected = call.connection.cursor().execute("SELECT 1").call_list()
>>> mock.mock_calls
[call.connection.cursor(), call.connection.cursor().execute('SELECT 1')]
>>> mock.mock_calls == expected
True
```

--------------------------------

### Python: Example usage of _callmethod

Source: https://github.com/python/cpython/blob/main/Doc/library/multiprocessing.rst

Provides doctest examples for the _callmethod, illustrating its use for common list operations like getting the length and slicing. It also shows how IndexError is handled.

```python
>>> l = manager.list(range(10))
>>> l._callmethod('__len__')
10
>>> l._callmethod('__getitem__', (slice(2, 7),)) # equivalent to l[2:7]
[2, 3, 4, 5, 6]
>>> l._callmethod('__getitem__', (20,))          # equivalent to l[20]
Traceback (most recent call last):
... 
IndexError: list index out of range
```

--------------------------------

### Registry Keys for Python Core Installation (32-bit, All Users on 32-bit OS)

Source: https://github.com/python/cpython/blob/main/Tools/msi/README.txt

Specifies the root registry key for 32-bit Python interpreters installed for all users on a 32-bit operating system.

```registry
HKEY_LOCAL_MACHINE\Software\Python\PythonCore\3.X-32
```

--------------------------------

### Shell Commands Example

Source: https://github.com/python/cpython/blob/main/Doc/howto/argparse.rst

Illustrates basic shell commands like 'ls' with different options to demonstrate concepts like default behavior, positional arguments, and optional arguments.

```shell-session
$ ls
cpython  devguide  prog.py  pypy  rm-unused-function.patch
$ ls pypy
ctypes_configure  demo  dotviewer  include  lib_pypy  lib-python ...
$ ls -l
total 20
drwxr-xr-x 19 wena wena 4096 Feb 18 18:51 cpython
drwxr-xr-x  4 wena wena 4096 Feb  8 12:04 devguide
-rwxr-xr-x  1 wena wena  535 Feb 19 00:05 prog.py
drwxr-xr-x 14 wena wena 4096 Feb  7 00:59 pypy
-rw-r--r--  1 wena wena  741 Feb 18 01:01 rm-unused-function.patch
$ ls --help
Usage: ls [OPTION]... [FILE]...
List information about the FILEs (the current directory by default).
Sort entries alphabetically if none of -cftuvSUX nor --sort is specified.
...
```

--------------------------------

### Python Docstring Conventions and Example

Source: https://github.com/python/cpython/blob/main/Doc/tutorial/controlflow.rst

Illustrates the standard conventions for Python docstrings, including a summary line and multi-line content, with an example of how to access and print a docstring.

```python
>>> def my_function():
...     """Do nothing, but document it.
...
...     No, really, it doesn't do anything.
...     """
...     pass
...
>>> print(my_function.__doc__)
Do nothing, but document it.

    No, really, it doesn't do anything.
```

--------------------------------

### Python: Basic optparse script example

Source: https://github.com/python/cpython/blob/main/Doc/library/optparse.rst

A typical script structure using the optparse module to define usage, add options, parse arguments, and handle them. It demonstrates setting up a parser for file input and verbose/quiet flags.

```Python
from optparse import OptionParser
...
def main():
    usage = "usage: %prog [options] arg"
    parser = OptionParser(usage)
    parser.add_option("-f", "--file", dest="filename",
                      help="read data from FILENAME")
    parser.add_option("-v", "--verbose",
                      action="store_true", dest="verbose")
    parser.add_option("-q", "--quiet",
                      action="store_false", dest="verbose")
    ...
    (options, args) = parser.parse_args()
    if len(args) != 1:
        parser.error("incorrect number of arguments")
    if options.verbose:
        print("reading %s..." % options.filename)
    ...

if __name__ == "__main__":
    main()
```

--------------------------------

### Getting Base Prefix (Python)

Source: https://github.com/python/cpython/blob/main/Doc/library/sys.rst

Retrieves the base prefix of the Python installation using `sys.base_prefix`. This attribute remains constant and points to the base Python installation, unlike `sys.prefix` which changes within virtual environments.

```Python
import sys

base_prefix = sys.base_prefix
print(f"Base prefix: {base_prefix}")
```

--------------------------------

### Patching a Method on an Object with MagicMock

Source: https://github.com/python/cpython/blob/main/Doc/library/unittest.mock-examples.rst

Demonstrates how to replace a method on an existing object with a MagicMock to verify it's called with the correct arguments. The MagicMock object records calls and allows assertions on them.

```python
>>> real = SomeClass()
>>> real.method = MagicMock(name='method')
>>> real.method(3, 4, 5, key='value')
<MagicMock name='method()' id='...'>
```

--------------------------------

### BaseHandler.setup_environ()

Source: https://github.com/python/cpython/blob/main/Doc/library/wsgiref.rst

Sets up a fully populated WSGI environment using various methods and attributes.

```APIDOC
## BaseHandler.setup_environ()

### Description
Set the :attr:`environ` attribute to a fully populated WSGI environment.

### Method
Any

### Endpoint
N/A

### Parameters

### Request Example
```json
{
  "message": "No specific request example available for this method."
}
```

### Response
#### Success Response (200)
- **None**: This method modifies the internal state and does not return a value directly.

#### Response Example
```json
{
  "message": "Internal state modified."
}
```
```

--------------------------------

### Getting Base Execution Prefix (Python)

Source: https://github.com/python/cpython/blob/main/Doc/library/sys.rst

Retrieves the base execution prefix of the Python installation using `sys.base_exec_prefix`. This differs from `sys.exec_prefix` when running in virtual environments, as `base_exec_prefix` always points to the base Python installation.

```Python
import sys

base_prefix = sys.base_exec_prefix
print(f"Base execution prefix: {base_prefix}")
```

--------------------------------

### Mocking Package Imports with patch.dict

Source: https://github.com/python/cpython/blob/main/Doc/library/unittest.mock-examples.rst

Illustrates how to mock entire packages and their submodules using `patch.dict` by providing a dictionary of module names to mock objects in `sys.modules`. This facilitates testing interactions with complex package structures.

```python
>>> mock = Mock()
>>> modules = {'package': mock, 'package.module': mock.module}
>>> with patch.dict('sys.modules', modules):
...    from package.module import fooble
...    fooble()
... 
<Mock name='mock.module.fooble()' id='...'>
>>> mock.module.fooble.assert_called_once_with()
```

--------------------------------

### Setting Environment Variables for Release Build (Batch)

Source: https://github.com/python/cpython/blob/main/Tools/msi/README.txt

This code snippet demonstrates how to set the necessary environment variables before running the `buildrelease.bat` script for an official Python installer release. It includes paths to a Python executable, the Sphinx build tool, and Git.

```batch
set PYTHON=<path to Python 3.10 or later>
set SPHINXBUILD=<path to sphinx-build.exe>
set PATH=<path to Git (git.exe)>;%PATH%
```

--------------------------------

### Create ArgumentParser Instance

Source: https://github.com/python/cpython/blob/main/Doc/library/argparse.rst

Demonstrates how to create an instance of the ArgumentParser class with various configurations for program name, description, and epilog text.

```python
parser = argparse.ArgumentParser(
                    prog='ProgramName',
                    description='What the program does',
                    epilog='Text at the bottom of help')
```

--------------------------------

### Mocking Asynchronous Iterators with `AsyncMock`

Source: https://github.com/python/cpython/blob/main/Doc/library/unittest.mock-examples.rst

Illustrates how to mock asynchronous iterators using `AsyncMock` or `MagicMock` by configuring the `return_value` of the `__aiter__` attribute.

```python
>>> import asyncio
>>> from unittest.mock import MagicMock
>>> mock = MagicMock()  # AsyncMock also works here
>>> mock.__aiter__.return_value = [1, 2, 3]
>>> async def main():
...     return [i async for i in mock]
... 
>>> asyncio.run(main())
[1, 2, 3]
```

--------------------------------

### QueueListener Example with logging

Source: https://github.com/python/cpython/blob/main/Doc/howto/logging-cookbook.rst

Demonstrates setting up a QueueListener to handle log records from a QueueHandler. It includes configuring handlers, formatters, starting the listener, and logging a message. The output shows the originating thread name.

```python
que = queue.Queue(-1)  # no limit on size
queue_handler = QueueHandler(que)
handler = logging.StreamHandler()
listener = QueueListener(que, handler)
root = logging.getLogger()
root.addHandler(queue_handler)
formatter = logging.Formatter('%(threadName)s: %(message)s')
handler.setFormatter(formatter)
listener.start()
root.warning('Look out!')
listener.stop()
```

--------------------------------

### Running Unittest from Command Line

Source: https://github.com/python/cpython/blob/main/Doc/library/unittest.rst

Demonstrates how to execute tests using the unittest module from the command line. It shows examples of specifying test modules, classes, and methods, as well as using file paths.

```shell
python -m unittest test_module1 test_module2
python -m unittest test_module.TestClass
python -m unittest test_module.TestClass.test_method
python -m unittest tests/test_something.py
python -m unittest -v test_module
python -m unittest
python -m unittest -h
```

--------------------------------

### Get Date and Time Information in Python

Source: https://github.com/python/cpython/blob/main/Doc/library/datetime.rst

Provides examples of retrieving current date and time information using datetime methods. It covers getting the current local time, current UTC time, and converting timestamps.

```python
>>> import time
>>> from datetime import date
>>> today = date.today()
>>> today
datetime.date(2007, 12, 5)
>>> today == date.fromtimestamp(time.time())
True
>>> my_birthday = date(today.year, 6, 24)
>>> if my_birthday < today:
...     my_birthday = my_birthday.replace(year=today.year + 1)
...
>>> my_birthday
datetime.date(2008, 6, 24)
>>> time_to_birthday = abs(my_birthday - today)
>>> time_to_birthday.days
202
```

```python
>>> from datetime import datetime
>>> datetime.today()
# Example output: datetime.datetime(2023, 10, 27, 10, 30, 0, 123456)
>>> datetime.now()
# Example output: datetime.datetime(2023, 10, 27, 10, 30, 0, 123456)
>>> datetime.utcnow()
# Example output: datetime.datetime(2023, 10, 27, 15, 30, 0, 123456)
```

--------------------------------

### Install Python using py launcher

Source: https://github.com/python/cpython/blob/main/Doc/using/windows.rst

Installs a Python runtime, potentially a prerelease version, using the py launcher. This command is typically used after uninstalling a prerelease runtime.

```bash
py install
```

--------------------------------

### Raising Exceptions with Mock `side_effect`

Source: https://github.com/python/cpython/blob/main/Doc/library/unittest.mock-examples.rst

Shows how to use the `side_effect` attribute of a Mock object to raise a specified exception when the mock is called.

```python
>>> from unittest.mock import Mock
>>> mock = Mock(side_effect=Exception('Boom!'))
>>> mock()
Traceback (most recent call last):
  ...
Exception: Boom!
```

--------------------------------

### Asserting Mock Call Order and Arguments with call

Source: https://github.com/python/cpython/blob/main/Doc/library/unittest.mock-examples.rst

Demonstrates how to use the `call` object to create expected call lists for asserting the order and arguments of mock method calls. It highlights limitations when tracking nested calls with important parameters.

```python
>>> from unittest.mock import Mock, call
>>> mock = Mock()
>>> mock.method(10, x=53)
<Mock name='mock.method()' id='...'/>
>>> mock.mock_calls
[call.method(10, x=53)]
>>> expected = [call.method(10, x=53)]
>>> mock.mock_calls == expected
True
```

```python
>>> mock = Mock()
>>> m = mock.factory(important=True)
>>> m.deliver()
<Mock name='mock.factory().deliver()' id='...'/>
>>> mock.mock_calls[-1] == call.factory(important=False).deliver()
True
```

--------------------------------

### Python: Populating parser with Option instances

Source: https://github.com/python/cpython/blob/main/Doc/library/optparse.rst

Shows how to create a list of Option instances using make_option and then pass this list to the OptionParser constructor to populate the parser with predefined options.

```Python
from optparse import OptionParser, make_option

option_list = [
    make_option("-f", "--filename",
                action="store", type="string", dest="filename"),
    make_option("-q", "--quiet",
                action="store_false", dest="verbose"),
    ]
parser = OptionParser(option_list=option_list)
```

--------------------------------

### Python Package Directory Structure Example

Source: https://github.com/python/cpython/blob/main/Doc/tutorial/modules.rst

Illustrates a typical hierarchical filesystem layout for a Python package named 'sound', including subpackages for file formats, effects, and filters. Each subpackage contains an __init__.py file.

```text
sound/                          Top-level package
        __init__.py               Initialize the sound package
        formats/                  Subpackage for file format conversions
                 __init__.py
                 wavread.py
                 wavwrite.py
                 aiffread.py
                 aiffwrite.py
                 auread.py
                 auwrite.py
                 ...
         effects/                  Subpackage for sound effects
                 __init__.py
                 echo.py
                 surround.py
                 reverse.py
                 ...
         filters/                  Subpackage for filters
                 __init__.py
                 equalizer.py
                 vocoder.py
                 karaoke.py
                 ...
```

--------------------------------

### Get Window Starting Coordinates

Source: https://github.com/python/cpython/blob/main/Doc/library/curses.rst

The getbegyx() method returns a tuple containing the (y, x) coordinates of the upper-left corner of the window.

```python
window.getbegyx()
```

--------------------------------

### Example: Get Password with Echo Off

Source: https://github.com/python/cpython/blob/main/Doc/library/termios.rst

Demonstrates how to prompt for a password with echoing disabled using termios.

```APIDOC
## Example: Get Password with Echo Off

### Description
This example shows how to securely prompt for a password by disabling terminal echo using `termios`.
It saves the original terminal settings and restores them afterwards.

### Code

```python
import termios, sys

def getpass(prompt="Password: "):
    fd = sys.stdin.fileno()
    old = termios.tcgetattr(fd)
    new = termios.tcgetattr(fd)
    new[3] = new[3] & ~termios.ECHO  # Disable ECHO flag in lflags
    try:
        termios.tcsetattr(fd, termios.TCSADRAIN, new)
        passwd = input(prompt)
    finally:
        # Restore original terminal settings
        termios.tcsetattr(fd, termios.TCSADRAIN, old)
    return passwd

# Example usage:
# password = getpass()
# print(f"Entered password: {password}")
```

### Method
`getpass()` function utilizing `termios` module.

### Parameters
- `prompt` (str): The message to display to the user.

### Request Example
(This is a Python function, not a direct API request)

### Response Example
(Returns the entered password as a string)

```

--------------------------------

### Python str.format(): Dictionary Unpacking

Source: https://github.com/python/cpython/blob/main/Doc/tutorial/inputoutput.rst

Shows how to unpack a dictionary as keyword arguments using the `**` notation with str.format(). This simplifies formatting when all values needed are in a dictionary.

```python
>>> table = {'Sjoerd': 4127, 'Jack': 4098, 'Dcab': 8637678}
>>> print('Jack: {Jack:d}; Sjoerd: {Sjoerd:d}; Dcab: {Dcab:d}'.format(**table))
Jack: 4098; Sjoerd: 4127; Dcab: 8637678
```

--------------------------------

### Python Method Binding Example

Source: https://github.com/python/cpython/blob/main/Doc/howto/descriptor.rst

Demonstrates the practical application of the function descriptor's `__get__` method. It shows how an instance attribute lookup results in a bound method, making `self` available within the method call.

```python
class D:
    def f(self):
         return self

class D2:
    pass

d = D()
d2 = D2()
d2.f = d.f.__get__(d2, D2)
d2.f() is d
```

--------------------------------

### Python Mock Assertions: assert_called_once_with

Source: https://github.com/python/cpython/blob/main/Doc/library/unittest.mock-examples.rst

Shows how to use mock.assert_called_once_with to verify that a mock was called exactly once with specific arguments. It also checks the call count.

```python
mock = Mock()
mock.foo_bar.return_value = None
mock.foo_bar('baz', spam='eggs')
mock.foo_bar.assert_called_once_with('baz', spam='eggs')
mock.foo_bar()
# The following line would raise an AssertionError:
# mock.foo_bar.assert_called_once_with('baz', spam='eggs')
```

--------------------------------

### Registry Keys for Python Launcher (All Users, 64-bit OS)

Source: https://github.com/python/cpython/blob/main/Tools/msi/README.txt

Specifies the root registry key for the Python launcher (py.exe) when installed for all users on a 64-bit operating system.

```registry
HKEY_LOCAL_MACHINE\Software\Wow6432Node\Python\Launcher
```

--------------------------------

### XML Example with Namespaces

Source: https://github.com/python/cpython/blob/main/Doc/library/xml.etree.elementtree.rst

An example XML structure demonstrating the use of both prefixed namespaces and a default namespace. This serves as input for parsing examples.

```xml
<?xml version="1.0"?>
<actors xmlns:fictional="http://characters.example.com"
        xmlns="http://people.example.com">
    <actor>
        <name>John Cleese</name>
        <fictional:character>Lancelot</fictional:character>
        <fictional:character>Archie Leach</fictional:character>
    </actor>
    <actor>
        <name>Eric Idle</name>
        <fictional:character>Sir Robin</fictional:character>
        <fictional:character>Gunther</fictional:character>
        <fictional:character>Commander Clement</fictional:character>
    </actor>
</actors>
```

--------------------------------

### Launching IDLE from Command Line

Source: https://github.com/python/cpython/blob/main/Lib/idlelib/News3.txt

This snippet shows the command to launch IDLE as a module from the Python interpreter. It's a standard way to start IDLE without needing to navigate to its installation directory.

```bash
python -m idlelib
```

--------------------------------

### Get Main Thread (Python)

Source: https://github.com/python/cpython/blob/main/Doc/library/threading.rst

Returns the main Thread object, which is typically the thread from which the Python interpreter was initially started.

```python
import threading

main_thread = threading.main_thread()
print(f"Main thread: {main_thread.name}")
```

--------------------------------

### Python Logging Example with multiprocessing

Source: https://github.com/python/cpython/blob/main/Doc/library/multiprocessing.rst

Demonstrates how to set up and use logging within the multiprocessing module. It shows how to get a logger, set its level, and illustrates the output format which includes the log level and process name. It also includes example output from Manager creation and shutdown.

```python
>>> import multiprocessing, logging
>>> logger = multiprocessing.log_to_stderr()
>>> logger.setLevel(logging.INFO)
>>> logger.warning('doomed')
[WARNING/MainProcess] doomed
>>> m = multiprocessing.Manager()
[INFO/SyncManager-...] child process calling self.run()
[INFO/SyncManager-...] created temp directory /.../pymp-...
[INFO/SyncManager-...] manager serving at '/.../listener-...'
>>> del m
[INFO/MainProcess] sending shutdown message to manager
[INFO/SyncManager-...] manager exiting with exitcode 0
```

--------------------------------

### Build Python Docs with Make (Unix)

Source: https://github.com/python/cpython/blob/main/Doc/README.rst

Commands to create a virtual environment and build HTML documentation for Python using the 'make' utility on Unix-like systems. Requires Sphinx and other tools installed via PyPI.

```shell
make venv
make html
```

--------------------------------

### Start an HTTP server and open a web browser

Source: https://github.com/python/cpython/blob/main/Doc/library/pydoc.rst

This command starts an HTTP server and automatically opens a web browser to the module index page. This provides a convenient way to start exploring the documentation. It requires the 'python' interpreter and the '-m pydoc -b' flag.

```bash
python -m pydoc -b
```

--------------------------------

### Invoking the Python Interpreter

Source: https://github.com/python/cpython/blob/main/Doc/tutorial/interpreter.rst

Demonstrates commands to start the Python interpreter from the command line on different operating systems.

```text
python3.15
```

--------------------------------

### Tokenization Output Example

Source: https://github.com/python/cpython/blob/main/Doc/library/tokenize.rst

Demonstrates the output of tokenizing a Python script (`hello.py`) using the `tokenize` module from the command line. Shows line/column coordinates, token names, and values.

```shell-session
$ python -m tokenize hello.py
0,0-0,0:            ENCODING       'utf-8'
1,0-1,3:            NAME           'def'
1,4-1,13:           NAME           'say_hello'
1,13-1,14:          OP             '('
1,14-1,15:          OP             ')'
1,15-1,16:          OP             ':'
1,16-1,17:          NEWLINE        '\n'
2,0-2,4:            INDENT         '    '
2,4-2,9:            NAME           'print'
2,9-2,10:           OP             '('
2,10-2,25:          STRING         '"Hello, World!"'
2,25-2,26:          OP             ')'
2,26-2,27:          NEWLINE        '\n'
3,0-3,1:            NL             '\n'
4,0-4,0:            DEDENT         ''
4,0-4,9:            NAME           'say_hello'
4,9-4,10:           OP             '('

```

--------------------------------

### Configure Python for Framework Installation (Bash)

Source: https://github.com/python/cpython/blob/main/Mac/README.rst

Enables framework-based installation of Python on macOS. This is typically the first step in building a framework Python, followed by 'make' and 'make install'. It specifies the installation directory for the framework.

```bash
configure --enable-framework
```

--------------------------------

### Start an HTTP server for documentation

Source: https://github.com/python/cpython/blob/main/Doc/library/pydoc.rst

This command starts an HTTP server on the specified port (e.g., 1234) to serve documentation. You can access the documentation through a web browser at http://localhost:1234/. Specifying port 0 selects an arbitrary unused port. It requires the 'python' interpreter and the '-m pydoc -p' flags.

```bash
python -m pydoc -p 1234
```

--------------------------------

### optparse Generated Help Message Example

Source: https://github.com/python/cpython/blob/main/Doc/library/optparse.rst

Shows the typical output generated by optparse when a user requests help (e.g., using -h or --help). This includes the usage string and a formatted list of available options.

```text
Usage: <yourscript> [options]

Options:
  -h, --help            show this help message and exit
  -f FILE, --file=FILE  write report to FILE
  -q, --quiet           don't print status messages to stdout
```

--------------------------------

### Python: Alternative Mocking for Dictionary Behavior

Source: https://github.com/python/cpython/blob/main/Doc/library/unittest.mock-examples.rst

Presents alternative ways to mock dictionary-like objects. One method uses a basic Mock with explicitly defined magic methods, while another uses MagicMock with a spec.

```python
mock = Mock()
mock.__getitem__ = Mock(side_effect=getitem)
mock.__setitem__ = Mock(side_effect=setitem)

# or

mock = MagicMock(spec_set=dict)
mock.__getitem__.side_effect = getitem
mock.__setitem__.side_effect = setitem

```

--------------------------------

### Install Alternative Python Versions

Source: https://github.com/python/cpython/blob/main/README.rst

Install alternative Python versions using 'make altinstall'. This method ensures that version-specific files (including executables) are created, allowing multiple versions to coexist without overwriting.

```makefile
make altinstall
```

--------------------------------

### Create Offline Python Installer Layout

Source: https://github.com/python/cpython/blob/main/Doc/using/windows.rst

Command to download all necessary Python installation files to create a complete offline installer layout. The optional target directory specifies where to save the files.

```bash
python-3.9.0.exe /layout [optional target directory]
```

--------------------------------

### Python/C API Introduction

Source: https://github.com/python/cpython/blob/main/Doc/c-api/intro.rst

Overview of the Python/C API, its use cases for extension modules and embedding Python, and general guidance.

```APIDOC
## Introduction to the Python/C API

### Description
The Python/C API allows C and C++ programmers to interact with the Python interpreter. It is primarily used for writing extension modules to extend Python's functionality and for embedding Python within larger applications.

### Key Concepts
- **Extension Modules**: C modules that extend the Python interpreter's capabilities.
- **Embedding Python**: Using Python as a component within a larger application.
- **Compatibility**: The C API is compatible with C11 and C++11 standards.
- **Coding Standards**: Adherence to PEP 7 is required for C code intended for CPython.

### Related Topics
- Include Files: `Python.h` is the primary header for the API.
- Useful Macros: Various macros simplify C API usage.
```

--------------------------------

### Python Argparse Subparser Setup and Usage

Source: https://github.com/python/cpython/blob/main/Doc/library/argparse.rst

This snippet demonstrates the basic setup of subparsers in Python's argparse module. It includes creating a main parser, adding subparsers for different commands ('a' and 'b'), defining arguments for each subparser, and parsing command-line arguments.

```python
import argparse

# create the top-level parser
parser = argparse.ArgumentParser(prog='PROG')
parser.add_argument('--foo', action='store_true', help='foo help')
subparsers = parser.add_subparsers(help='subcommand help')

# create the parser for the "a" command
parser_a = subparsers.add_parser('a', help='a help')
parser_a.add_argument('bar', type=int, help='bar help')

# create the parser for the "b" command
parser_b = subparsers.add_parser('b', help='b help')
parser_b.add_argument('--baz', choices=('X', 'Y', 'Z'), help='baz help')

# parse some argument lists
# print(parser.parse_args(['a', '12']))
# print(parser.parse_args(['--foo', 'b', '--baz', 'Z']))
```

--------------------------------

### Asserting a Single Call with MagicMock

Source: https://github.com/python/cpython/blob/main/Doc/library/unittest.mock-examples.rst

Shows how to test if a method on an object was called exactly once with specific arguments. This is done by replacing the method with a MagicMock and using assert_called_once_with.

```python
>>> class ProductionClass:
...     def method(self):
...         self.something(1, 2, 3)
...     def something(self, a, b, c):
...         pass
...
>>> real = ProductionClass()
>>> real.something = MagicMock()
>>> real.method()
>>> real.something.assert_called_once_with(1, 2, 3)
```

--------------------------------

### Python: Get the main thread object

Source: https://github.com/python/cpython/blob/main/Doc/whatsnew/3.4.rst

Introduces threading.main_thread() to retrieve the main thread object, typically the one from which the Python interpreter was started.

```python
import threading
main_thread = threading.main_thread()
print(f"Main thread: {main_thread.name}")
```

--------------------------------

### Get Multiprocessing Context

Source: https://github.com/python/cpython/blob/main/Doc/library/multiprocessing.rst

Illustrates obtaining a multiprocessing context object to manage processes with specific start methods.

```APIDOC
## POST /get_context

### Description
Obtains a context object which provides an API similar to the multiprocessing module, allowing the use of multiple start methods within the same program.

### Method
POST

### Endpoint
/

### Parameters
#### Query Parameters
- **method** (string) - Required - The desired start method ('spawn', 'fork', 'forkserver').

### Request Example
```python
import multiprocessing as mp

def foo(q):
    q.put('hello')

if __name__ == '__main__':
    ctx = mp.get_context('spawn')
    q = ctx.Queue()
    p = ctx.Process(target=foo, args=(q,))
    p.start()
    print(q.get())
    p.join()
```

### Response
#### Success Response (200)
Returns a context object that can be used to create Queues, Processes, etc.

#### Response Example
```json
{
  "context_type": "spawn"
}
```
```

--------------------------------

### Python Dictionary Creation Examples

Source: https://github.com/python/cpython/blob/main/Doc/library/stdtypes.rst

Demonstrates multiple ways to create dictionaries in Python, including using keyword arguments, literal syntax, zip, and existing dictionaries.

```python
a = dict(one=1, two=2, three=3)
b = {'one': 1, 'two': 2, 'three': 3}
c = dict(zip(['one', 'two', 'three'], [1, 2, 3]))
d = dict([('two', 2), ('one', 1), ('three', 3)])
e = dict({'three': 3, 'one': 1, 'two': 2})
f = dict({'one': 1, 'three': 3}, two=2)
a == b == c == d == e == f
```

--------------------------------

### Create Mock from Existing Object Specification (Python)

Source: https://github.com/python/cpython/blob/main/Doc/library/unittest.mock-examples.rst

Demonstrates creating a Mock object with a specification from an existing class or function. This ensures that only existing attributes and methods can be accessed, raising an AttributeError otherwise. It also enables smarter call matching.

```python
from unittest.mock import Mock

# Assume SomeClass is defined elsewhere
class SomeClass:
    def class_method(self):
        pass

# Create a mock with a specification
mock = Mock(spec=SomeClass)

# Accessing an existing method works
mock.class_method()

# Accessing a non-existent method raises AttributeError
try:
    mock.old_method()
except AttributeError as e:
    print(e)

# Example with a function specification
def f(a, b, c):
    pass

func_mock = Mock(spec=f)
func_mock(1, 2, 3)
func_mock.assert_called_with(a=1, b=2, c=3)
```

--------------------------------

### Get Supported Scheme Names

Source: https://github.com/python/cpython/blob/main/Doc/library/sysconfig.rst

Retrieves a tuple of all supported installation scheme names within the sysconfig module.

```python
import sysconfig

schemes = sysconfig.get_scheme_names()
print(schemes)
```

--------------------------------

### Build Python on Unix-like Systems

Source: https://github.com/python/cpython/blob/main/README.rst

Standard commands to configure, build, test, and install Python from source on Unix, Linux, BSD, macOS, and Cygwin. Installs Python as 'python3'. Supports various configure options for customization.

```shell
./configure
make
make test
sudo make install
```

--------------------------------

### Python Mock Call History: call_args_list

Source: https://github.com/python/cpython/blob/main/Doc/library/unittest.mock-examples.rst

Explains how to inspect the history of all calls made to a mock object using mock.call_args_list. This attribute contains a list of all arguments the mock was called with.

```python
mock = Mock(return_value=None)
mock(1, 2, 3)
mock(4, 5, 6)
mock()
# mock.call_args_list will be [call(1, 2, 3), call(4, 5, 6), call()]
expected = [call(1, 2, 3), call(4, 5, 6), call()]
assert mock.call_args_list == expected
```

--------------------------------

### Registry Keys for Python Launcher (All Users, 32-bit OS)

Source: https://github.com/python/cpython/blob/main/Tools/msi/README.txt

Specifies the root registry key for the Python launcher (py.exe) when installed for all users on a 32-bit operating system.

```registry
HKEY_LOCAL_MACHINE\Software\Python\Launcher
```

--------------------------------

### Get distribution metadata by name in Python

Source: https://github.com/python/cpython/blob/main/Doc/library/importlib.metadata.rst

Retrieves the metadata for a specified installed distribution package. It returns a PackageMetadata object containing package details.

```python
from importlib.metadata import metadata

wheel_metadata = metadata('wheel')
```

--------------------------------

### Include Files and Definitions

Source: https://github.com/python/cpython/blob/main/Doc/c-api/intro.rst

Details on the necessary include files and preprocessor definitions for using the Python/C API.

```APIDOC
## Include Files for Python/C API

### Description
To utilize the Python/C API, you must include the `Python.h` header file. It's crucial to define `PY_SSIZE_T_CLEAN` before including `Python.h` and to include `Python.h` before any standard C headers.

### Include Statement
```c
#define PY_SSIZE_T_CLEAN
#include <Python.h>
```

### Header Inclusion Order
- **Mandatory**: Include `Python.h` *before* any standard C headers.
- **Recommended**: Define `PY_SSIZE_T_CLEAN` before including `Python.h`.

### Naming Conventions
- **User Visible Names**: Prefixed with `Py` or `_Py`.
- **Internal Names**: Prefixed with `_Py` (should not be used by extension writers).
- **Structure Members**: No reserved prefix.
- **User Code**: Should not define names starting with `Py` or `_Py` to avoid conflicts.

### Header File Locations
- **Unix**: `{prefix}/include/pythonversion/` and `{exec_prefix}/include/pythonversion/`
- **Windows**: `{prefix}/include/`

### C++ Usage
- The API is C-based, but headers declare entry points as `extern "C"`, making it usable directly from C++ without special handling.
```

--------------------------------

### Python str.format(): Aligned Columns Example

Source: https://github.com/python/cpython/blob/main/Doc/tutorial/inputoutput.rst

Provides a practical example of using str.format() to create neatly aligned columns of integers, their squares, and cubes. It uses positional arguments and field width specifiers.

```python
>>> for x in range(1, 11):
...     print('{0:2d} {1:3d} {2:4d}'.format(x, x*x, x*x*x))
... 
  1   1    1
  2   4    8
  3   9   27
  4  16   64
  5  25  125
  6  36  216
  7  49  343
  8  64  512
  9  81  729
 10 100 1000
```

--------------------------------

### Interactive Python Mode Examples

Source: https://github.com/python/cpython/blob/main/Doc/faq/windows.rst

Illustrates basic commands and their output within the Python interactive interpreter, showcasing simple operations like printing and string manipulation.

```pycon
>>> print("Hello")
Hello
```

```pycon
>>> "Hello" * 3
'HelloHelloHello'
```

--------------------------------

### Python: Creating and Running a Test Suite

Source: https://github.com/python/cpython/blob/main/Doc/library/unittest.rst

Shows how to manually create a unittest.TestSuite and add individual test cases to it. It then demonstrates running the suite using TextTestRunner.

```python
import unittest

def suite():
    suite = unittest.TestSuite()
    suite.addTest(WidgetTestCase('test_default_widget_size'))
    suite.addTest(WidgetTestCase('test_widget_resize'))
    return suite

if __name__ == '__main__':
    runner = unittest.TextTestRunner()
    runner.run(suite())
```

--------------------------------

### Define and Parse Command-Line Options with optparse

Source: https://github.com/python/cpython/blob/main/Doc/library/optparse.rst

Demonstrates how to create an OptionParser, add options with help messages and actions, and parse command-line arguments. It shows how to access parsed options and handles the "--help" flag.

```python
from optparse import OptionParser
...
parser = OptionParser()
parser.add_option("-f", "--file", dest="filename",
                  help="write report to FILE", metavar="FILE")
parser.add_option("-q", "--quiet",
                  action="store_false", dest="verbose", default=True,
                  help="don't print status messages to stdout")

(options, args) = parser.parse_args()
```

--------------------------------

### Mocking Method Calls on an Object with Mock

Source: https://github.com/python/cpython/blob/main/Doc/library/unittest.mock-examples.rst

Illustrates how to pass a Mock object into a function or method and then assert that a specific method on the mock was called. Accessing a method on a Mock object automatically creates it.

```python
>>> class ProductionClass:
...     def closer(self, something):
...         something.close()
...
>>> real = ProductionClass()
>>> mock = Mock()
>>> real.closer(mock)
>>> mock.close.assert_called_with()
```

--------------------------------

### Python itertools.islice() examples

Source: https://github.com/python/cpython/blob/main/Doc/howto/functional.rst

Returns a slice of an iterator, similar to list slicing but without support for negative indices. Can specify start, stop, and step parameters.

```python
import itertools

itertools.islice(range(10), 8)
# Output: 0, 1, 2, 3, 4, 5, 6, 7
itertools.islice(range(10), 2, 8)
# Output: 2, 3, 4, 5, 6, 7
itertools.islice(range(10), 2, 8, 2)
# Output: 2, 4, 6
```

--------------------------------

### Python Mock Assertions: assert_called_with

Source: https://github.com/python/cpython/blob/main/Doc/library/unittest.mock-examples.rst

Demonstrates using mock.assert_called_with to verify the arguments of the most recent call to a mock object. This is useful for checking function call parameters.

```python
mock = Mock()
mock.foo_bar.return_value = None
mock.foo_bar('baz', spam='eggs')
mock.foo_bar.assert_called_with('baz', spam='eggs')
```

--------------------------------

### Python: Mocking Dictionary Access with MagicMock

Source: https://github.com/python/cpython/blob/main/Doc/library/unittest.mock-examples.rst

Shows how to use MagicMock to mimic dictionary behavior, using side_effect to delegate item access and modification to a real dictionary. This allows for inspection of dictionary operations.

```python
my_dict = {'a': 1, 'b': 2, 'c': 3}
def getitem(name):
     return my_dict[name]

def setitem(name, val):
    my_dict[name] = val

mock = MagicMock()
mock.__getitem__.side_effect = getitem
mock.__setitem__.side_effect = setitem

# Example usage:
# mock['a']
# mock['b'] = 'fish'

# Assertions:
# mock.__getitem__.call_args_list
# mock.__setitem__.call_args_list
# my_dict

```

--------------------------------

### Python File I/O Example

Source: https://github.com/python/cpython/blob/main/Doc/library/io.rst

Illustrates basic file operations, including getting file contents and closing the file object. Shows handling of memory buffers.

```python
# Retrieve file contents -- this will be
# 'First line.\nSecond line.\n'
contents = output.getvalue()

# Close object and discard memory buffer --
# .getvalue() will now raise an exception.
output.close()
```

--------------------------------

### Python Build and Install Sequence (Bash)

Source: https://github.com/python/cpython/blob/main/Mac/README.rst

The standard sequence for building and installing a framework Python on macOS. It involves configuring the build, compiling the source code, and then installing the built components.

```bash
make install
```

--------------------------------

### Setup.py detects system libffi with multiarch wrapper

Source: https://github.com/python/cpython/blob/main/Misc/NEWS.d/3.7.0a1.rst

This update modifies the `setup.py` script to correctly detect the system's `libffi` library, including its multiarch wrapper. This is crucial for building Python extensions that depend on `libffi`, ensuring they link against the appropriate system library.

```python
import distutils.sysconfig
import os

lib_dirs = distutils.sysconfig.get_config_vars('llibdirs')
include_dirs = distutils.sysconfig.get_config_vars('incdir')

# Logic to find libffi and its multiarch wrapper
```

--------------------------------

### Window Setup

Source: https://github.com/python/cpython/blob/main/Doc/library/turtle.rst

Configure the size and position of the main turtle graphics window.

```APIDOC
## POST /setup

### Description
Set the size and position of the main turtle graphics window. Default values can be configured via a ``turtle.cfg`` file.

### Method
POST

### Endpoint
/setup

### Parameters
#### Request Body
- **width** (integer | float) - Optional - The width of the window. If an integer, it's in pixels. If a float, it's a fraction of the screen width. Defaults to 50% of screen width.
- **height** (integer | float) - Optional - The height of the window. If an integer, it's in pixels. If a float, it's a fraction of the screen height. Defaults to 75% of screen height.
- **startx** (integer | None) - Optional - The starting horizontal position. Positive values are from the left edge, negative values from the right edge, and ``None`` centers the window horizontally. Defaults to centering.
- **starty** (integer | None) - Optional - The starting vertical position. Positive values are from the top edge, negative values from the bottom edge, and ``None`` centers the window vertically. Defaults to centering.

### Request Example
```json
{
  "width": 800,
  "height": 600,
  "startx": 100,
  "starty": 50
}
```
```json
{
  "width": 0.75,
  "height": 0.5,
  "startx": null,
  "starty": null
}
```

### Response
#### Success Response (200)
- **message** (string) - Confirmation that the window setup is complete.

#### Response Example
```json
{
  "message": "Window setup complete."
}
```
```

--------------------------------

### Python str.endswith() Example

Source: https://github.com/python/cpython/blob/main/Doc/library/stdtypes.rst

Checks if a string ends with a specified suffix, which can also be a tuple of suffixes. Optional start and end indices can define the slice to check.

```python
>>> 'Python'.endswith('on')
True
>>> 'a tuple of suffixes'.endswith(('at', 'in'))
False
>>> 'a tuple of suffixes'.endswith(('at', 'es'))
True
>>> 'Python is amazing'.endswith('is', 0, 9)
True
```

--------------------------------

### Personal Python Installation Command

Source: https://github.com/python/cpython/blob/main/Doc/using/windows.rst

Provides a command for a user-specific Python installation, disabling the launcher and test suite, and enabling a simplified UI with a custom description. This command is suitable for users without a system-wide installation.

```bash
python-3.9.0.exe InstallAllUsers=0 Include_launcher=0 Include_test=0
    SimpleInstall=1 SimpleInstallDescription="Just for me, no test suite."
```

--------------------------------

### Coroutine Execution with coroutine.send()

Source: https://github.com/python/cpython/blob/main/Doc/howto/a-conceptual-overview-of-asyncio.rst

Illustrates the low-level mechanism of coroutine control transfer using the `send()` method. This example shows how to manually start and resume a coroutine, passing values into it and receiving return values or intermediate results.

```python
class Rock:
    def __await__(self):
        value_sent_in = yield 7
        print(f"Rock.__await__ resuming with value: {value_sent_in}.")
        return value_sent_in

async def main():
    print("Beginning coroutine main().")
    rock = Rock()
    print("Awaiting rock...")
    value_from_rock = await rock
    print(f"Coroutine received value: {value_from_rock} from rock.")
    return 23

coroutine = main()
intermediate_result = coroutine.send(None) # Start the coroutine
print(f"Coroutine paused and returned intermediate value: {intermediate_result}.")

print(f"Resuming coroutine and sending in value: 42.")
try:
    coroutine.send(42) # Resume the coroutine with a value
except StopIteration as e:
    returned_value = e.value
print(f"Coroutine main() finished and provided value: {returned_value}.")
```

--------------------------------

### Python: Get Argparse Module File Path

Source: https://github.com/python/cpython/blob/main/Doc/howto/argparse.rst

A simple Python script to locate the installed argparse module file on the system. This is useful for specifying paths in localization tools.

```python
import argparse
print(argparse.__file__)
```

--------------------------------

### Heap Operations with heapq in Python

Source: https://github.com/python/cpython/blob/main/Doc/tutorial/stdlib2.rst

Shows how to use the `heapq` module for heap queue algorithm implementations based on Python lists. This example demonstrates heapifying a list, pushing a new element, and popping the smallest elements.

```python
>>> from heapq import heapify, heappop, heappush
>>> data = [1, 3, 5, 7, 9, 2, 4, 6, 8, 0]
>>> heapify(data)                      # rearrange the list into heap order
>>> heappush(data, -5)                 # add a new entry
>>> [heappop(data) for i in range(3)]  # fetch the three smallest entries
[-5, 0, 1]
```

--------------------------------

### PropertyMock for Descriptors

Source: https://github.com/python/cpython/blob/main/Doc/library/unittest.mock.rst

Shows how to use PropertyMock as a mock for Python properties or other descriptors. It includes examples of setting return values and asserting calls made during property gets and sets.

```python
>>> class Foo:
...     @property
...     def foo(self):
...         return 'something'
...     @foo.setter
...     def foo(self, value): 
...         pass
... 
>>> with patch('__main__.Foo.foo', new_callable=PropertyMock) as mock_foo:
...     mock_foo.return_value = 'mockity-mock'
...     this_foo = Foo()
...     print(this_foo.foo)
...     this_foo.foo = 6
... 
mockity-mock
>>> mock_foo.mock_calls
[call(), call(6)]
```

```python
>>> m = MagicMock()
>>> p = PropertyMock(return_value=3)
>>> type(m).foo = p
>>> m.foo
3
>>> p.assert_called_once_with()
```

```python
>>> m = MagicMock()
>>> no_attribute = PropertyMock(side_effect=AttributeError)
>>> type(m).my_property = no_attribute
>>> m.my_property
<MagicMock name='mock.my_property' id='140165240345424'>
```

--------------------------------

### Shell Session Example for Short Options - Shell Session

Source: https://github.com/python/cpython/blob/main/Doc/howto/argparse.rst

This example demonstrates the output of the Python script when using the short option '-v' and when requesting help. It shows how the command-line execution reflects the defined arguments and their help messages.

```shell-session
$ python prog.py -v
verbosity turned on
$ python prog.py --help
usage: prog.py [-h] [-v]

options:
  -h, --help     show this help message and exit
  -v, --verbose  increase output verbosity
```

--------------------------------

### Python ORM Example: Song Model

Source: https://github.com/python/cpython/blob/main/Doc/howto/descriptor.rst

Defines a `Song` model class, similar to the `Movie` model, using the `Field` descriptor to map 'artist', 'year', and 'genre' attributes to columns in a 'Music' database table.

```python
class Song:
    table = 'Music'
    key = 'title'
    artist = Field()
    year = Field()
    genre = Field()

    def __init__(self, key):
        self.key = key
```

--------------------------------

### Get original standard output

Source: https://github.com/python/cpython/blob/main/Doc/library/test.rst

Retrieves the original standard output stream that was recorded at the start of the regrtest execution. Returns sys.stdout if it was not explicitly set.

```python
get_original_stdout()
```

--------------------------------

### mimetypes CLI: Handle unknown MIME type

Source: https://github.com/python/cpython/blob/main/Doc/library/mimetypes.rst

Example of the mimetypes command-line interface handling an unknown MIME type when trying to get an extension.

```console
$ python -m mimetypes --extension text/xul
error: unknown type text/xul
```

--------------------------------

### Get Source Lines

Source: https://github.com/python/cpython/blob/main/Doc/library/inspect.rst

Retrieves the source code lines and starting line number for an object. Raises OSError if source cannot be retrieved, and TypeError for built-in objects.

```APIDOC
## GET /object/source/lines

### Description
Retrieves the source code lines and the starting line number for an object.

### Method
GET

### Endpoint
/object/source/lines

### Parameters
#### Query Parameters
- **object** (object) - Required - The object to inspect (module, class, method, function, etc.).

### Response
#### Success Response (200)
- **source_lines** (list of strings) - A list of source code lines.
- **first_line_number** (integer) - The line number where the first line of code was found.

#### Response Example
```json
{
  "source_lines": [
    "def my_function():",
    "    pass"
  ],
  "first_line_number": 10
}
```
```

--------------------------------

### Python @staticmethod Example

Source: https://github.com/python/cpython/blob/main/Doc/howto/descriptor.rst

Demonstrates the basic usage of the @staticmethod decorator in Python. Static methods do not receive an implicit first argument (like self or cls) and can be called on the class or an instance.

```python
class E:
    @staticmethod
    def f(x):
        return x * 10
```

--------------------------------

### Python ORM Example: Movie Model

Source: https://github.com/python/cpython/blob/main/Doc/howto/descriptor.rst

Defines a `Movie` model class that uses the `Field` descriptor to map attributes like 'director' and 'year' to columns in a 'Movies' database table.

```python
class Movie:
    table = 'Movies'                    # Table name
    key = 'title'                       # Primary key
    director = Field()
    year = Field()

    def __init__(self, key):
        self.key = key
```

--------------------------------

### Registry Keys for Python Launcher (Current User)

Source: https://github.com/python/cpython/blob/main/Tools/msi/README.txt

Specifies the root registry key for the Python launcher (py.exe) when installed for the current user.

```registry
HKEY_CURRENT_USER\Software\Python\Launcher
```

--------------------------------

### Install Specific or Minimum Module Version

Source: https://github.com/python/cpython/blob/main/Doc/installing/index.rst

Installs a specific version or a minimum version of a module. For versions specified with comparators like '>', '<', enclose the package name and version in double quotes to prevent shell interpretation.

```bash
python -m pip install SomePackage==1.0.4    # specific version
```

```bash
python -m pip install "SomePackage>=1.0.4"  # minimum version
```

--------------------------------

### Setup WSGI Environment - Python

Source: https://github.com/python/cpython/blob/main/Doc/library/wsgiref.rst

The setup_environ method populates the WSGI environment dictionary, utilizing various attributes and methods for a complete request context.

```python
BaseHandler.setup_environ()
```

--------------------------------

### XML-RPC Client Example with xmlrpclib

Source: https://github.com/python/cpython/blob/main/Doc/whatsnew/2.2.rst

Demonstrates how to use the 'xmlrpclib' module to interact with an XML-RPC server. The example retrieves a list of RSS channels and then fetches recent headlines for a specific channel, showcasing remote procedure calls over HTTP.

```python
import xmlrpclib
s = xmlrpclib.Server(
      'http://www.oreillynet.com/meerkat/xml-rpc/server.php')
channels = s.meerkat.getChannels()
# channels is a list of dictionaries, like this:
# [{'id': 4, 'title': 'Freshmeat Daily News'}
#  {'id': 190, 'title': '32Bits Online'},
#  {'id': 4549, 'title': '3DGamers'}, ... ]

# Get the items for one channel
items = s.meerkat.getItems( {'channel': 4} )

# 'items' is another list of dictionaries, like this:
# [{'link': 'http://freshmeat.net/releases/52719/',
#   'description': 'A utility which converts HTML to XSL FO.',
#   'title': 'html2fo 0.3 (Default)'}, ... ]
```

--------------------------------

### Python Install Manager Configuration Options

Source: https://github.com/python/cpython/blob/main/Doc/using/windows.rst

Defines standard configuration keys, their corresponding environment variables, and descriptions for managing Python installations. These settings control default versions, platform preferences, log locations, automatic installs, and more.

```json
{
  "default_tag": "PYTHON_MANAGER_DEFAULT",
  "default_platform": "PYTHON_MANAGER_DEFAULT_PLATFORM",
  "logs_dir": "PYTHON_MANAGER_LOGS",
  "automatic_install": "PYTHON_MANAGER_AUTOMATIC_INSTALL",
  "include_unmanaged": "PYTHON_MANAGER_INCLUDE_UNMANAGED",
  "shebang_can_run_anything": "PYTHON_MANAGER_SHEBANG_CAN_RUN_ANYTHING",
  "log_level": ["PYMANAGER_VERBOSE", "PYMANAGER_DEBUG"],
  "confirm": "PYTHON_MANAGER_CONFIRM",
  "install.source": "PYTHON_MANAGER_SOURCE_URL",
  "list.format": "PYTHON_MANAGER_LIST_FORMAT"
}
```

--------------------------------

### Python Property Descriptor Implementation

Source: https://github.com/python/cpython/blob/main/Doc/howto/descriptor.rst

A pure Python implementation of the descriptor protocol, mimicking the functionality of the built-in `property` class. This includes methods for getting, setting, deleting attributes, and chaining descriptors.

```python
class Property:
    """Emulate PyProperty_Type() in Objects/descrobject.c"""

    def __init__(self, fget=None, fset=None, fdel=None, doc=None):
        self.fget = fget
        self.fset = fset
        self.fdel = fdel
        if doc is None and fget is not None:
            doc = fget.__doc__
        self.__doc__ = doc

    def __set_name__(self, owner, name):
        self.__name__ = name

    def __get__(self, obj, objtype=None):
        if obj is None:
            return self
        if self.fget is None:
            raise AttributeError
        return self.fget(obj)

    def __set__(self, obj, value):
        if self.fset is None:
            raise AttributeError
        self.fset(obj, value)

    def __delete__(self, obj):
        if self.fdel is None:
            raise AttributeError
        self.fdel(obj)

    def getter(self, fget):
        return type(self)(fget, self.fset, self.fdel, self.__doc__)

    def setter(self, fset):
        return type(self)(self.fget, fset, self.fdel, self.__doc__)

    def deleter(self, fdel):
        return type(self)(self.fget, self.fset, fdel, self.__doc__)
```

--------------------------------

### optparse 'store' Action Example

Source: https://github.com/python/cpython/blob/main/Doc/library/optparse.rst

Demonstrates the 'store' action in optparse, which stores an argument's value to a destination attribute. It shows how to specify argument types, number of arguments (nargs), and destination names. The example also illustrates how optparse handles multiple arguments and default types.

```python
parser.add_option("-f")
parser.add_option("-p", type="float", nargs=3, dest="point")

# Example command line parsing:
# -f foo.txt -p 1 -3.5 4 -fbar.txt

# Resulting options object:
# options.f = "foo.txt"
# options.point = (1.0, -3.5, 4.0)
# options.f = "bar.txt"
```

--------------------------------

### Handling Hidden Left Recursion

Source: https://github.com/python/cpython/blob/main/InternalDocs/parser.md

Shows an example of 'hidden' left recursion, where the recursive call is not immediately apparent in the rule definition, and how CPython handles it.

```PEG
rule: 'optional'? rule '@' some_other_rule
```

--------------------------------

### Automating Profile Guided Optimization (PGO)

Source: https://github.com/python/cpython/blob/main/PCbuild/readme.txt

Explains how to use the `build.bat` script to automate the Profile Guided Optimization (PGO) process. This includes creating PGI files, running the test suite with a PGI-enabled Python, and generating optimized binaries.

```shell
build.bat --pgo
build.bat --pgo --pgo-job <job>
```

--------------------------------

### str.format() Method Formatting Example

Source: https://github.com/python/cpython/blob/main/Doc/tutorial/inputoutput.rst

Illustrates the use of the str.format() method for more controlled output formatting. It shows how to format numbers with padding, alignment, and percentage notation. This method is available in earlier Python versions as well.

```python
>>> yes_votes = 42_572_654
>>> total_votes = 85_705_149
>>> percentage = yes_votes / total_votes
>>> '{:-9} YES votes  {:2.2%}'.format(yes_votes, percentage)
' 42572654 YES votes  49.67%'
```

--------------------------------

### Python @classmethod Example

Source: https://github.com/python/cpython/blob/main/Doc/howto/descriptor.rst

Illustrates the use of the @classmethod decorator. Class methods receive the class itself (conventionally named 'cls') as the first argument, allowing them to operate on the class rather than an instance.

```python
class F:
    @classmethod
    def f(cls, x):
        return cls.__name__, x
```

--------------------------------

### Custom Argument Matching with Mock in Python

Source: https://github.com/python/cpython/blob/main/Doc/library/unittest.mock-examples.rst

Illustrates how to create custom matchers for complex argument assertions when default object identity comparison is insufficient. This involves defining comparison logic and a matcher object.

```python
>>> class Foo:
...     def __init__(self, a, b):
...         self.a, self.b = a, b
...
>>> mock = Mock(return_value=None)
>>> mock(Foo(1, 2))
>>> mock.assert_called_with(Foo(1, 2))
Traceback (most recent call last):
    ...
AssertionError: expected call not found.
Expected: mock(<__main__.Foo object at 0x...>)
Actual: mock(<__main__.Foo object at 0x...>)

>>> def compare(self, other):
...     if not type(self) == type(other):
...         return False
...     if self.a != other.a:
...         return False
...     if self.b != other.b:
...         return False
...     return True
...
>>> class Matcher:
...     def __init__(self, compare, some_obj):
...         self.compare = compare
...         self.some_obj = some_obj
...     def __eq__(self, other):
...         return self.compare(self.some_obj, other)
...
>>> match_foo = Matcher(compare, Foo(1, 2))
>>> mock.assert_called_with(match_foo)

>>> match_wrong = Matcher(compare, Foo(3, 4))
>>> mock.assert_called_with(match_wrong)
Traceback (most recent call last):
    ...
AssertionError: Expected: ((<Matcher object at 0x...>,), {})
Called with: ((<Foo object at 0x...>,), {})
```

--------------------------------

### Get Generator State with inspect.getgeneratorstate

Source: https://github.com/python/cpython/blob/main/Doc/whatsnew/3.2.rst

Shows how to use inspect.getgeneratorstate to determine the current state of a generator-iterator. It illustrates the states 'GEN_CREATED', 'GEN_SUSPENDED', and 'GEN_CLOSED' through a simple generator example.

```python
from inspect import getgeneratorstate

def gen():
    yield 'demo'

g = gen()
print(getgeneratorstate(g))
next(g)
print(getgeneratorstate(g))
next(g, None)
print(getgeneratorstate(g))
```

--------------------------------

### Deterministic Profiler Command Line Interface

Source: https://github.com/python/cpython/blob/main/Doc/library/profile.rst

Explains how to invoke the `cProfile` module as a script to profile other scripts, including options for output files, sorting, and profiling modules.

```APIDOC
## Deterministic Profiler Command Line Interface (cProfile)

### Description
Allows invoking the `cProfile` module as a script to profile other scripts. Supports specifying output files, sorting criteria, and profiling modules.

### Method
N/A (Command-line execution)

### Endpoint
N/A

### Parameters
#### Path Parameters
N/A

#### Query Parameters
N/A

#### Request Body
N/A

### Command Example
```bash
python -m cProfile [-o output_file] [-s sort_order] (-m module | myscript.py)
```

### Options
- **-o <output_file>** - Writes the profile results to a file instead of to stdout.
- **-s <sort_order>** - Specifies one of the `pstats.Stats.sort_stats` sort values to sort the output by. This only applies when `-o <output_file>` is not supplied.
- **-m <module>** - Specifies that a module is being profiled instead of a script. (Added in Python 3.7 for `cProfile`, 3.8 for `profile`)
```

--------------------------------

### Using `side_effect` with Iterables and Functions

Source: https://github.com/python/cpython/blob/main/Doc/library/unittest.mock-examples.rst

Explains how `side_effect` can be used with iterables to return different values on successive calls, or with functions to dynamically determine return values based on arguments.

```python
>>> from unittest.mock import MagicMock
>>> mock = MagicMock(side_effect=[4, 5, 6])
>>> mock()
4
>>> mock()
5
>>> mock()
6
```

```python
>>> from unittest.mock import MagicMock
>>> vals = {(1, 2): 1, (2, 3): 2}
>>> def side_effect(*args):
...     return vals[args]
...
>>> mock = MagicMock(side_effect=side_effect)
>>> mock(1, 2)
1
>>> mock(2, 3)
2
```

--------------------------------

### IDLE Command Line Options Explained

Source: https://github.com/python/cpython/blob/main/Lib/idlelib/help.html

Provides a breakdown of individual command-line arguments for IDLE, explaining their functionality.

```shell
-c command  run command in the shell window
-d          enable debugger and open shell window
-e          open editor window
-h          print help message with legal combinations and exit
-i          open shell window
-r file     run file in shell window
-s          run $IDLESTARTUP or $PYTHONSTARTUP first, in shell window
-t title    set title of shell window
-           run stdin in shell (- must be last option before args)
```

--------------------------------

### Cmd.preloop() Method

Source: https://github.com/python/cpython/blob/main/Doc/library/cmd.rst

This method is called once when the `cmdloop` method is initiated. It serves as an entry point for setup tasks before the command loop begins. Subclasses can override it for initialization.

```python
def preloop(self):
    """Hook method executed once when :meth:`cmdloop` is called. This method is a stub in :class:`Cmd`; it exists to be overridden by subclasses."""
    pass
```

--------------------------------

### Argparse Help Message Example

Source: https://github.com/python/cpython/blob/main/Doc/howto/argparse.rst

An example of the help message generated by an argparse script. It displays usage information, positional arguments, and options, demonstrating the default output structure.

```shell
$ python prog.py --help
usage: prog.py [-h] [-v | -q] x y

calculate X to the power of Y

positional arguments:
  x         the base
  y         the exponent

options:
  -h, --help  show this help message and exit
  -v, --verbose
  -q, --quiet
```

--------------------------------

### Get resource usage for current process (Python)

Source: https://github.com/python/cpython/blob/main/Doc/library/resource.rst

Retrieves resource consumption information for the calling process. This example demonstrates fetching usage after a sleep and after a CPU-bound task.

```python
from resource import *
import time

# a non CPU-bound task
time.sleep(3)
print(getrusage(RUSAGE_SELF))

# a CPU-bound task
for i in range(10 ** 8):
   _ = 1 + 1
print(getrusage(RUSAGE_SELF))
```

--------------------------------

### Python Mocking Unbound Methods with autospec

Source: https://github.com/python/cpython/blob/main/Doc/library/unittest.mock-examples.rst

Shows how to patch unbound methods using patch.object with autospec=True. This ensures the mock has the same signature as the original method and correctly handles 'self' when called on an instance.

```python
class Foo:
  def foo(self):
    pass

with patch.object(Foo, 'foo', autospec=True) as mock_foo:
  mock_foo.return_value = 'foo'
  foo = Foo()
  foo.foo()
mock_foo.assert_called_once_with(foo)
```

--------------------------------

### Example HTML Parser Application

Source: https://github.com/python/cpython/blob/main/Doc/library/html.parser.rst

A practical example demonstrating how to create a custom HTML parser.

```APIDOC
## Example HTML Parser Application

### Description
This example shows a basic implementation of `HTMLParser` to print encountered start tags, end tags, and data.

### Code
```python
from html.parser import HTMLParser

class MyHTMLParser(HTMLParser):
    def handle_starttag(self, tag, attrs):
        print("Encountered a start tag:", tag)

    def handle_endtag(self, tag):
        print("Encountered an end tag :", tag)

    def handle_data(self, data):
        print("Encountered some data  :", data)

parser = MyHTMLParser()
parser.feed('<html><head><title>Test</title></head>'
            '<body><h1>Parse me!</h1></body></html>')
```

### Output
```
Encountered a start tag: html
Encountered a start tag: head
Encountered a start tag: title
Encountered some data  : Test
Encountered an end tag : title
Encountered an end tag : head
Encountered a start tag: body
Encountered a start tag: h1
Encountered some data  : Parse me!
Encountered an end tag : h1
Encountered an end tag : body
Encountered an end tag : html
```
```

--------------------------------

### Set and Get First Weekday

Source: https://github.com/python/cpython/blob/main/Doc/library/calendar.rst

Shows how to set the starting day of the week for calendar generation and how to retrieve the current setting. Monday is represented by 0 and Sunday by 6.

```python
import calendar
calendar.setfirstweekday(calendar.SUNDAY)
```

```python
current_first_weekday = calendar.firstweekday()
```

--------------------------------

### Run ensurepip from command line (Python)

Source: https://github.com/python/cpython/blob/main/Doc/library/ensurepip.rst

This command invokes the ensurepip module using Python's -m switch to bootstrap the pip installer. It can optionally upgrade an existing pip installation.

```python
python -m ensurepip
python -m ensurepip --upgrade
```

--------------------------------

### Third-Party Tools for Extension Development

Source: https://github.com/python/cpython/blob/main/Doc/c-api/intro.rst

Highlights recommended third-party tools for creating Python extensions.

```APIDOC
## Recommended Third-Party Tools

### Description
This section lists external tools that facilitate the creation of C, C++, and Rust extensions for Python.

### Tools

- **Cython**: Provides a means to write C extensions in a Python-like syntax. Visit `https://cython.org/` for more information.
```

--------------------------------

### Python Grammar Action Example

Source: https://github.com/python/cpython/blob/main/InternalDocs/parser.md

This code demonstrates a basic structure for a Python grammar action within a PEG parser. It shows how a parsed rule `a` can be directly returned as the result of the rule `rule_name`.

```PEG Grammar
rule_name[return_type]: '(' a=some_other_rule ')' { a }
```

--------------------------------

### Shell commands for argparse help and execution

Source: https://github.com/python/cpython/blob/main/Doc/whatsnew/3.2.rst

This snippet provides examples of shell commands to interact with an argparse-defined script. It shows how to get top-level help, help for specific subparsers, and how to execute commands with arguments.

```shell-session
$ ./helm.py --help                         # top level help (launch and move)
$ ./helm.py launch --help                  # help for launch options
$ ./helm.py launch --missiles              # set missiles=True and torpedos=False
$ ./helm.py steer --course 180 --speed 5   # set movement parameters
```

--------------------------------

### Converting doctest examples to a Python script (output)

Source: https://github.com/python/cpython/blob/main/Doc/library/doctest.rst

This shows the output of the `doctest.script_from_examples` function when applied to the provided input. It demonstrates how the doctest examples are transformed into code and the descriptive text into comments.

```python
# Set x and y to 1 and 2.
x, y = 1, 2
#
# Print their sum:
print(x+y)
# Expected:
## 3
```

--------------------------------

### YAML Logging Configuration Example

Source: https://github.com/python/cpython/blob/main/Doc/library/logging.config.rst

This example demonstrates how to define logging configurations using YAML, specifying formatters, handlers, and their connections to loggers. It shows how to link handlers to specific formatters and assign multiple handlers to a logger.

```yaml
formatters:
  brief:
    # configuration for formatter with id 'brief' goes here
  precise:
    # configuration for formatter with id 'precise' goes here
handlers:
  h1: #This is an id
   # configuration of handler with id 'h1' goes here
   formatter: brief
  h2: #This is another id
   # configuration of handler with id 'h2' goes here
   formatter: precise
loggers:
  foo.bar.baz:
    # other configuration for logger 'foo.bar.baz'
    handlers: [h1, h2]
```

--------------------------------

### Custom Framework Installation Path (Bash)

Source: https://github.com/python/cpython/blob/main/Mac/README.rst

Allows specifying a custom directory for framework installation on macOS, useful when admin privileges are limited. The 'configure' command with '--enable-framework=<path>' sets the installation location for the framework, applications, and Unix tools.

```bash
configure --enable-framework=$HOME/Library/Frameworks
```

--------------------------------

### Control pip script installation (Python)

Source: https://github.com/python/cpython/blob/main/Doc/library/ensurepip.rst

These options control which scripts are installed by ensurepip. --altinstall prevents the installation of the pipX script, and --default-pip installs the pip script in addition to the regular ones.

```python
python -m ensurepip --altinstall
python -m ensurepip --default-pip
```

--------------------------------

### Using the Asyncio REPL

Source: https://github.com/python/cpython/blob/main/Doc/whatsnew/3.8.rst

Demonstrates how to launch the natively async REPL by running 'python -m asyncio'. This allows direct use of 'await' for rapid experimentation without needing to call asyncio.run() explicitly.

```shell
$ python -m asyncio
asyncio REPL 3.8.0
Use "await" directly instead of "asyncio.run()".
Type "help", "copyright", "credits" or "license" for more information.
>>> import asyncio
>>> await asyncio.sleep(10, result='hello')
hello
```

--------------------------------

### Install Script from URL in Python

Source: https://github.com/python/cpython/blob/main/Doc/library/venv.rst

Downloads a script from a given URL and installs it into a specified directory. It handles script execution, progress reporting, and cleanup of downloaded files. Dependencies include 'os', 'sys', 'urllib.request.urlretrieve', 'urllib.parse.urlparse', and 'subprocess.Popen'.

```python
import os
import sys
from urllib.request import urlretrieve
from urllib.parse import urlparse
from subprocess import Popen, PIPE
from threading import Thread

class VenvBuilder:
    def __init__(self, verbose=False, progress=None):
        self.verbose = verbose
        self.progress = progress

    def reader(self, stream, name):
        """Read stream and print to stderr or call progress."""
        progress = self.progress
        while True:
            s = stream.readline()
            if not s:
                break
            if progress is not None:
                progress(s, context)
            else:
                if not self.verbose:
                    sys.stderr.write('.')
                else:
                    sys.stderr.write(s.decode('utf-8'))
                sys.stderr.flush()
        stream.close()

    def install_script(self, context, name, url):
        _, _, path, _, _, _ = urlparse(url)
        fn = os.path.split(path)[-1]
        binpath = context.bin_path
        distpath = os.path.join(binpath, fn)
        # Download script into the virtual environment's binaries folder
        urlretrieve(url, distpath)
        progress = self.progress
        if self.verbose:
            term = '\n'
        else:
            term = ''
        if progress is not None:
            progress('Installing %s ...%s' % (name, term), 'main')
        else:
            sys.stderr.write('Installing %s ...%s' % (name, term))
            sys.stderr.flush()
        # Install in the virtual environment
        args = [context.env_exe, fn]
        p = Popen(args, stdout=PIPE, stderr=PIPE, cwd=binpath)
        t1 = Thread(target=self.reader, args=(p.stdout, 'stdout'))
        t1.start()
        t2 = Thread(target=self.reader, args=(p.stderr, 'stderr'))
        t2.start()
        p.wait()
        t1.join()
        t2.join()
        if progress is not None:
            progress('done.', 'main')
        else:
            sys.stderr.write('done.\n')
        # Clean up - no longer needed
        os.unlink(distpath)

    def install_setuptools(self, context):
        """
        Install setuptools in the virtual environment.

        :param context: The information for the virtual environment
                        creation request being processed.
        """
        url = "https://bootstrap.pypa.io/ez_setup.py"
        self.install_script(context, 'setuptools', url)
        # clear up the setuptools archive which gets downloaded
        pred = lambda o: o.startswith('setuptools-') and o.endswith('.tar.gz')
        files = filter(pred, os.listdir(context.bin_path))
        for f in files:
            f = os.path.join(context.bin_path, f)
            os.unlink(f)

    def install_pip(self, context):
        """
        Install pip in the virtual environment.

        :param context: The information for the virtual environment
                        creation request being processed.
        """
        url = 'https://bootstrap.pypa.io/get-pip.py'
        self.install_script(context, 'pip', url)

```

--------------------------------

### Use side_effect for Per-File Content Mocking (Python)

Source: https://github.com/python/cpython/blob/main/Doc/library/unittest.mock-examples.rst

Illustrates using the `side_effect` attribute of a Mock object to provide different return values for each call, specifically for mocking the `open` function to return different file contents.

```python
from unittest.mock import mock_open, patch

DEFAULT = "default"
data_dict = {"file1": "data1",
             "file2": "data2"}

def open_side_effect(name):
    return mock_open(read_data=data_dict.get(name, DEFAULT))()

with patch("builtins.open", side_effect=open_side_effect):
    with open("file1") as file1:
        assert file1.read() == "data1"

    with open("file2") as file2:
        assert file2.read() == "data2"

    with open("file3") as file3:
        assert file3.read() == "default"
```

--------------------------------

### Example Configure Warning Message

Source: https://github.com/python/cpython/blob/main/Mac/README.rst

Demonstrates a common warning message from the configure script, typically indicating issues with compiling libraries for universal binaries on macOS. It suggests checking for missing prerequisite headers and provides a link for reporting bugs.

```text
configure: WARNING: libintl.h: present but cannot be compiled
configure: WARNING: libintl.h:     check for missing prerequisite headers?
configure: WARNING: libintl.h: see the Autoconf documentation
configure: WARNING: libintl.h:     section "Present But Cannot Be Compiled"
configure: WARNING: libintl.h: proceeding with the preprocessor's result
configure: WARNING: libintl.h: in the future, the compiler will take precedence
configure: WARNING:     ## -------------------------------------------------------- ##
configure: WARNING:     ## Report this to https://github.com/python/cpython/issues/ ##
configure: WARNING:     ## -------------------------------------------------------- ##
```

--------------------------------

### Get a slice of a tuple (C API)

Source: https://github.com/python/cpython/blob/main/Doc/c-api/tuple.rst

Extracts a sub-sequence (slice) from a tuple based on start and end indices. Returns NULL and sets an exception on failure. Negative indexing is not supported.

```c
PyObject* PyTuple_GetSlice(PyObject *p, Py_ssize_t low, Py_ssize_t high);
```

--------------------------------

### Logging Output Example

Source: https://github.com/python/cpython/blob/main/Doc/library/logging.rst

Illustrates the expected output format in a log file when using the provided Python logging examples. This shows the level, module, and message for each logged event.

```none
INFO:__main__:Started
INFO:mylib:Doing something
INFO:__main__:Finished
```

--------------------------------

### Mocking 'from module import name' with patch.dict

Source: https://github.com/python/cpython/blob/main/Doc/library/unittest.mock-examples.rst

Demonstrates mocking specific names imported from a module using `patch.dict` on `sys.modules`. This allows testing code that relies on specific imported attributes or functions.

```python
>>> mock = Mock()
>>> with patch.dict('sys.modules', {'fooble': mock}):
...    from fooble import blob
...    blob.blip()
... 
<Mock name='mock.blob.blip()' id='...'>
>>> mock.blob.blip.assert_called_once_with()
```

--------------------------------

### Mocking Module Imports with patch.dict

Source: https://github.com/python/cpython/blob/main/Doc/library/unittest.mock-examples.rst

Shows how to use `patch.dict` to temporarily inject a mock object into `sys.modules`, allowing imports within a specific context to resolve to the mock. This is useful for isolating code during testing.

```python
>>> import sys
>>> mock = Mock()
>>> with patch.dict('sys.modules', {'fooble': mock}):
...    import fooble
...    fooble.blob()
... 
<Mock name='mock.blob()' id='...'>
>>> assert 'fooble' not in sys.modules
>>> mock.blob.assert_called_once_with()
```

--------------------------------

### Virtual Environments using venv module and pyvenv script (Python)

Source: https://github.com/python/cpython/blob/main/Doc/whatsnew/3.3.rst

Introduces the 'venv' module for programmatic access and the 'pyvenv' script for command-line administration of Python virtual environments. These environments help create separate Python setups while sharing a system-wide base install.

```python
import venv

# Create a virtual environment
venv.create('myenv', symlinks=True, with_pip=True)

# Activate the virtual environment (example for bash/zsh)
# source myenv/bin/activate

# Run a command within the virtual environment
# python -m venv --help

```

--------------------------------

### CPython Build System: Modules/Setup Handling

Source: https://github.com/python/cpython/blob/main/Doc/whatsnew/3.8.rst

CPython's build system now directly reads from 'Modules/Setup' in the source tree, removing the need to manually copy 'Modules/Setup.dist'. This simplifies the process for developers and packagers.

```text
The duality of "Modules/Setup.dist" and "Modules/Setup" has been removed. Previously, when updating the CPython source tree, one had to manually copy "Modules/Setup.dist" (inside the source tree) to "Modules/Setup" (inside the build tree) in order to reflect any changes upstream. This was of a small benefit to packagers at the expense of a frequent annoyance to developers following CPython development, as forgetting to copy the file could produce build failures.

Now the build system always reads from "Modules/Setup" inside the source tree. People who want to customize that file are encouraged to maintain their changes in a git fork of CPython or as patch files, as they would do for any other change to the source tree.
```

--------------------------------

### Custom Attribute Get Handler: getattr Example (C)

Source: https://github.com/python/cpython/blob/main/Doc/extending/newtypes.rst

An example C function demonstrating a custom getattr handler. This function is called when an attribute lookup occurs on an object and handles specific attribute names like 'data', returning the corresponding C value as a Python object. It raises an AttributeError for unknown attributes.

```c
static PyObject *
newdatatype_getattr(PyObject *op, char *name)
{
    newdatatypeobject *self = (newdatatypeobject *) op;
    if (strcmp(name, "data") == 0) {
        return PyLong_FromLong(self->data);
    }

    PyErr_Format(PyExc_AttributeError,
                 "'%.100s' object has no attribute '%.400s'",
                 Py_TYPE(self)->tp_name, name);
    return NULL;
}
```

--------------------------------

### Install IDLE on SUSE/OpenSUSE

Source: https://github.com/python/cpython/blob/main/Doc/using/unix.rst

Installs the IDLE integrated development environment on SUSE and OpenSUSE systems using the zypper package manager. Requires sudo privileges.

```shell
sudo zypper install python3-idle
```

--------------------------------

### Python str.format(): Keyword Arguments

Source: https://github.com/python/cpython/blob/main/Doc/tutorial/inputoutput.rst

Shows how to use keyword arguments with str.format() by referencing the argument names within the format string. This improves readability and maintainability.

```python
>>> print('This {food} is {adjective}.'.format(
...       food='spam', adjective='absolutely horrible'))
This spam is absolutely horrible.
```

--------------------------------

### cProfile.runctx

Source: https://github.com/python/cpython/blob/main/Doc/library/profile.rst

Similar to run, but allows supplying globals and locals mappings for the command string.

```APIDOC
## cProfile.runctx

### Description
Similar to run, but allows supplying globals and locals mappings for the command string.

### Method
Function

### Endpoint
N/A

### Parameters
#### Path Parameters
None

#### Query Parameters
None

#### Request Body
None

### Request Example
```python
import cProfile

my_globals = {'x': 1}
my_locals = {'y': 2}
cProfile.runctx('x + y', my_globals, my_locals)
```

### Response
#### Success Response (200)
Profiling statistics are printed to standard output or returned based on filename specification.

#### Response Example
```
         2 function calls in 0.000 seconds

   Ordered by: standard name

   ncalls  tottime  percall  cumtime  percall filename:lineno(function)
        1    0.000    0.000    0.000    0.000 <string>:1(x + y)
        1    0.000    0.000    0.000    0.000 {built-in method builtins.exec}
```
```

--------------------------------

### Switching languages dynamically with gettext

Source: https://github.com/python/cpython/blob/main/Doc/library/gettext.rst

This example illustrates how to manage multiple language translations within an application. It involves creating separate translation instances for different languages and switching between them using the install() method.

```python
import gettext

lang1 = gettext.translation('myapplication', languages=['en'])
lang2 = gettext.translation('myapplication', languages=['fr'])
lang3 = gettext.translation('myapplication', languages=['de'])

# start by using language1
lang1.install()

# ... time goes by, user selects language 2
lang2.install()

# ... more time goes by, user selects language 3
lang3.install()
```

--------------------------------

### Get Python Distribution Package Requirements

Source: https://github.com/python/cpython/blob/main/Doc/library/importlib.metadata.rst

Retrieves the declared dependency specifiers for a given distribution package. Raises PackageNotFoundError if the package is not installed. The output is a list of strings, each representing a dependency.

```python
from importlib.metadata import requires

print(requires('wheel'))
```

--------------------------------

### Manual patch lifecycle management with start() and stop()

Source: https://github.com/python/cpython/blob/main/Doc/library/unittest.mock.rst

Explains how to use the start() and stop() methods of patcher objects for manual control over patching. It demonstrates starting a patch, asserting the mock, and stopping the patch to restore the original.

```python
>>> patcher = patch('package.module.ClassName')
>>> from package import module
>>> original = module.ClassName
>>> new_mock = patcher.start()
>>> assert module.ClassName is not original
>>> assert module.ClassName is new_mock
>>> patcher.stop()
>>> assert module.ClassName is original
>>> assert module.ClassName is not new_mock
```

--------------------------------

### Installing Python Manager with WinGet

Source: https://github.com/python/cpython/blob/main/Doc/using/windows.rst

Provides a PowerShell command to programmatically install the Python install manager using WinGet, a package manager included with Windows.

```powershell
winget install Python.Python.3.11
```

--------------------------------

### Python: Example of an Asynchronous Context Manager Class

Source: https://github.com/python/cpython/blob/main/Doc/reference/datamodel.rst

This Python class, `AsyncContextManager`, illustrates how to create an asynchronous context manager. It implements `__aenter__` to perform setup asynchronously (e.g., logging) and `__aexit__` to perform asynchronous cleanup or error handling upon exiting the context.

```python
    class AsyncContextManager:
        async def __aenter__(self):
            await log('entering context')

        async def __aexit__(self, exc_type, exc, tb):
            await log('exiting context')
```

--------------------------------

### Attaching Mocks for Call Tracking with Mock.attach_mock

Source: https://github.com/python/cpython/blob/main/Doc/library/unittest.mock-examples.rst

Demonstrates using `attach_mock` to associate patched mocks with a parent `MagicMock`. This allows the parent mock to track calls made to the attached mocks through its `mock_calls` attribute, useful for verifying interactions within patched contexts.

```python
>>> manager = MagicMock()
>>> with patch('mymodule.Class1') as MockClass1:
...     with patch('mymodule.Class2') as MockClass2:
...         manager.attach_mock(MockClass1, 'MockClass1')
...         manager.attach_mock(MockClass2, 'MockClass2')
...         MockClass1().foo()
...         MockClass2().bar()
... 
<MagicMock name='mock.MockClass1().foo()' id='...'>
```

--------------------------------

### Asyncio Hello World Example

Source: https://github.com/python/cpython/blob/main/Doc/library/asyncio.rst

A simple asynchronous 'Hello World' program demonstrating the basic structure of an asyncio application. It prints messages with a delay between them using `asyncio.sleep`.

```python
import asyncio

async def main():
    print('Hello ...')
    await asyncio.sleep(1)
    print('... World!')

asyncio.run(main())
```

--------------------------------

### Python ORM Example: Field Descriptor

Source: https://github.com/python/cpython/blob/main/Doc/howto/descriptor.rst

Defines a `Field` descriptor class for an ORM. It utilizes `__set_name__`, `__get__`, and `__set__` to interact with a database, fetching and storing data based on table schema and primary keys.

```python
class Field:

    def __set_name__(self, owner, name):
        self.fetch = f'SELECT {name} FROM {owner.table} WHERE {owner.key}=?';
        self.store = f'UPDATE {owner.table} SET {name}=? WHERE {owner.key}=?';

    def __get__(self, obj, objtype=None):
        return conn.execute(self.fetch, [obj.key]).fetchone()[0]

    def __set__(self, obj, value):
        conn.execute(self.store, [value, obj.key])
        conn.commit()
```

--------------------------------

### Patch Module Attribute with Decorator (Python)

Source: https://github.com/python/cpython/blob/main/Doc/library/unittest.mock-examples.rst

Demonstrates using the `@patch` decorator to replace an attribute within a module or built-in namespace. This is useful for mocking functions or classes that are imported or globally accessed.

```python
from unittest.mock import patch, sentinel

# Assume package.module.attribute exists

@patch('package.module.attribute', sentinel.patched_attribute)
def test_module_attribute_patch():
    from package.module import attribute
    assert attribute is sentinel.patched_attribute

test_module_attribute_patch()

# Example patching builtins.open
@patch('builtins.open', return_value=sentinel.file_handle)
def test_builtin_patch():
    handle = open('filename', 'r')
    open.assert_called_with('filename', 'r')
    assert handle == sentinel.file_handle

test_builtin_patch()

# Example patching a class attribute in a module
@patch('package.module.ClassName.attribute', sentinel.new_class_attribute)
def test_class_attribute_patch():
    from package.module import ClassName
    assert ClassName.attribute == sentinel.new_class_attribute

test_class_attribute_patch()
```

--------------------------------

### Module Search Path Initialization (Conceptual)

Source: https://github.com/python/cpython/blob/main/Doc/tutorial/modules.rst

Describes the initialization process for Python's module search path, which determines where the interpreter looks for modules. It includes the script's directory, PYTHONPATH, and default installation locations.

```plaintext
# The directory containing the input script (or the current directory when no file is specified).
# PYTHONPATH (a list of directory names, with the same syntax as the shell variable PATH).
# The installation-dependent default (by convention including a "site-packages" directory, handled by the site module).
```

--------------------------------

### Install a custom opener with urllib.request.install_opener

Source: https://github.com/python/cpython/blob/main/Doc/library/urllib.request.rst

Installs a custom OpenerDirector instance as the default global opener. This allows urlopen to use the custom opener for subsequent requests. It requires an OpenerDirector instance as input.

```python
import urllib.request

# Assume 'my_opener' is a properly configured OpenerDirector instance
# urllib.request.install_opener(my_opener)

# Now urlopen will use 'my_opener' by default
# response = urllib.request.urlopen('some_url')
```

--------------------------------

### Python Testing Frameworks - Python

Source: https://github.com/python/cpython/blob/main/Doc/faq/library.rst

Introduces Python's built-in testing frameworks, doctest and unittest. Doctest runs examples from docstrings, while unittest provides a more comprehensive framework for writing and running tests.

```python
import doctest
# Run doctest examples

```

```python
import unittest
# Use the unittest framework

```

--------------------------------

### Build Python with Clang/LLVM (Windows)

Source: https://github.com/python/cpython/blob/main/PCbuild/readme.txt

Builds Python using Clang/LLVM on Windows by leveraging the build.bat script with specific parameters. This allows for using clang-cl, including options for Profile Guided Optimization (PGO) and specifying Clang installation directories.

```batch
build.bat "/p:PlatformToolset=ClangCL"
```

```batch
build.bat --pgo "/p:PlatformToolset=ClangCL" "/p:LLVMInstallDir=<my-clang-dir>" "/p:LLVMToolsVersion=18"
```

```batch
"/p:CLANG_PROFILE_PATH=instrumented"
```

--------------------------------

### Custom Completion Setup in Python

Source: https://github.com/python/cpython/blob/main/Doc/library/readline.rst

Facilitates the implementation of custom word completion functionality, typically triggered by the Tab key. It allows setting and retrieving completer functions and getting information about the completion attempt.

```python
set_completer([function])
get_completer()
get_completion_type()
get_begidx()
get_endidx()
```

--------------------------------

### Automated macOS Python Installer

Source: https://github.com/python/cpython/blob/main/Doc/using/mac.rst

Demonstrates how to automate the installation of a Python macOS package (.pkg) using the command-line `installer` utility. It includes downloading the package, creating a custom choice changes property list to select specific features (like the free-threaded interpreter), and applying these changes during installation.

```shell
RELEASE="python-3.x.0b2-macos11.pkg"

# download installer pkg
curl -O https://www.python.org/ftp/python/3.x.0/${RELEASE}

# create installer choicechanges to customize the install:
#    enable the PythonTFramework-3.x package
#    while accepting the other defaults (install all other packages)
cat > ./choicechanges.plist <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<array>
        <dict>
                <key>attributeSetting</key>
                <integer>1</integer>
                <key>choiceAttribute</key>
                <string>selected</string>
                <key>choiceIdentifier</key>
                <string>org.python.Python.PythonTFramework-3.x</string>
        </dict>
</array>
</plist>
EOF

sudo installer -pkg ./${RELEASE} -applyChoiceChangesXML ./choicechanges.plist -target /

```

--------------------------------

### Executing a Startup File in a Python Script

Source: https://github.com/python/cpython/blob/main/Doc/tutorial/appendix.rst

Shows how to explicitly load and execute a Python startup file within a script by checking for the PYTHONSTARTUP environment variable and executing its content.

```python
import os
filename = os.environ.get('PYTHONSTARTUP')
if filename and os.path.isfile(filename):
    with open(filename) as fobj:
        startup_file = fobj.read()
    exec(startup_file)
```

--------------------------------

### PEG Grammar with Python Actions

Source: https://github.com/python/cpython/blob/main/InternalDocs/parser.md

Illustrates how to define grammar rules with Python actions to generate AST nodes. This example shows alternatives within a rule, each with a specific Python expression to determine the returned AST node.

```PEG Grammar
rule_name[return_type]:
   | first_alt1 first_alt2 { first_alt1 }
   | second_alt1 second_alt2 { second_alt1 }
```

--------------------------------

### Install Module and Dependencies

Source: https://github.com/python/cpython/blob/main/Doc/installing/index.rst

Installs the latest version of a specified module and its dependencies from the Python Package Index. Assumes a virtual environment for POSIX users and PATH adjustment for Windows users.

```bash
python -m pip install SomePackage
```

--------------------------------

### Custom Action Example

Source: https://github.com/python/cpython/blob/main/Doc/library/argparse.rst

Example of creating and using a custom action by extending argparse.Action.

```APIDOC
## POST /api/custom_action

### Description
Demonstrates the usage of a custom action 'FooAction'.

### Method
POST

### Endpoint
/api/custom_action

### Parameters
#### Query Parameters
- **action** (string) - Required - Specifies the custom action, e.g., 'FooAction'.
- **dest** (string) - Required - The name of the attribute to be created in the namespace.
- **value** (string) - Required - The value to be processed by the custom action.

### Request Example
{
  "example": "action=FooAction&dest=foo&value=2"
}

### Response
#### Success Response (200)
- **Namespace** (object) - An object containing the parsed arguments, with the custom action applied.

#### Response Example
{
  "example": "Namespace(bar=None, foo='2')"
}
```

--------------------------------

### Control pip installation location (Python)

Source: https://github.com/python/cpython/blob/main/Doc/library/ensurepip.rst

These options control where pip is installed. --root specifies an alternative root directory, and --user installs into the user site packages directory.

```python
python -m ensurepip --root <dir>
python -m ensurepip --user
```

--------------------------------

### Python: Subclassing MagicMock for Custom Methods

Source: https://github.com/python/cpython/blob/main/Doc/library/unittest.mock-examples.rst

Demonstrates creating a custom mock class by subclassing MagicMock to add new methods, such as checking if the mock has been called. Attributes and return values of these custom mocks also inherit the subclass type.

```python
class MyMock(MagicMock):
    def has_been_called(self):
        return self.called

mymock = MyMock(return_value=None)
# mymock.has_been_called()
# mymock()
# mymock.has_been_called()

# mymock.foo
# mymock.foo.has_been_called()

```

--------------------------------

### ARM64 Installer for Windows (Windows)

Source: https://github.com/python/cpython/blob/main/Misc/NEWS.d/3.11.0a5.rst

The traditional EXE/MSI installer for Windows is now available for the ARM64 architecture. This provides a native installation experience for Windows on ARM devices.

```Windows
The traditional EXE/MSI based installer for Windows is now available for
ARM64
```

--------------------------------

### Start an HTTP server with a specific hostname

Source: https://github.com/python/cpython/blob/main/Doc/library/pydoc.rst

This command starts an HTTP server listening on a specified hostname (e.g., '0.0.0.0') to serve documentation. This is useful for accessing the server from other machines or within containers. It requires the 'python' interpreter and the '-m pydoc -n' flags.

```bash
python -m pydoc -n 0.0.0.0
```

--------------------------------

### Create Text Stream using open()

Source: https://github.com/python/cpython/blob/main/Doc/library/io.rst

Demonstrates how to create a text stream by opening a file with a specified encoding. This is the recommended way to handle text files to ensure consistent behavior across different platforms.

```python
f = open("myfile.txt", "r", encoding="utf-8")
```

--------------------------------

### PYTHONTRACEMALLOC Usage

Source: https://github.com/python/cpython/blob/main/Doc/using/cmdline.rst

Starts tracing Python memory allocations using the tracemalloc module. The value specifies the maximum number of frames stored in a traceback. For example, PYTHONTRACEMALLOC=1 stores only the most recent frame.

```shell
PYTHONTRACEMALLOC=1
```

--------------------------------

### Asserting Call Sequences with assert_has_calls in Python

Source: https://github.com/python/cpython/blob/main/Doc/library/unittest.mock-examples.rst

Demonstrates how to use assert_has_calls to verify if a specific sequence of calls exists within the mock's call history. It shows how to construct call objects and pass them to the assertion method.

```python
>>> manager.mock_calls
[call.MockClass1(),
 call.MockClass1().foo(),
 call.MockClass2(),
 call.MockClass2().bar()]

>>> m = MagicMock()
>>> m().foo().bar().baz()
<MagicMock name='mock().foo().bar().baz()' id='...'>
>>> m.one().two().three()
<MagicMock name='mock.one().two().three()' id='...'>
>>> calls = call.one().two().three().call_list()
>>> m.assert_has_calls(calls)

>>> m = MagicMock()
>>> m(1), m.two(2, 3), m.seven(7), m.fifty('50')
(...)
>>> calls = [call.fifty('50'), call(1), call.seven(7)]
>>> m.assert_has_calls(calls, any_order=True)
```

--------------------------------

### Printing with Formatting in Python

Source: https://github.com/python/cpython/blob/main/Doc/tutorial/introduction.rst

Demonstrates using the print() function with string formatting and the 'end' keyword argument to control output.

```python
i = 256*256
print('The value of i is', i)

a, b = 0, 1
while a < 1000:
    print(a, end=',')
    a, b = b, a+b
```

--------------------------------

### Python CLI Command: Start Service (start.py)

Source: https://github.com/python/cpython/blob/main/Doc/howto/logging-cookbook.rst

Implements the 'start' command for the CLI application. It defines a 'command' function that accepts parsed options, logs debug information about the service to be started, and then logs an informational message upon successful start.

```python
# start.py
import logging

logger = logging.getLogger(__name__)

def command(options):
    logger.debug('About to start %s', options.name)
    # actually do the command processing here ...
    logger.info('Started the '%s' service.', options.name)
```

--------------------------------

### Demonstrate Logging Context Manager Usage

Source: https://github.com/python/cpython/blob/main/Doc/howto/logging-cookbook.rst

Illustrates the practical application of the `LoggingContext` class. It shows how to change logging levels and add/remove handlers within `with` blocks, verifying the expected log output based on the active configuration.

```python
import logging
import sys

# Assume LoggingContext class is defined as above

if __name__ == '__main__':
    logger = logging.getLogger('foo')
    logger.addHandler(logging.StreamHandler())
    logger.setLevel(logging.INFO)
    logger.info('1. This should appear just once on stderr.')
    logger.debug('2. This should not appear.')
    with LoggingContext(logger, level=logging.DEBUG):
        logger.debug('3. This should appear once on stderr.')
    logger.debug('4. This should not appear.')
    h = logging.StreamHandler(sys.stdout)
    with LoggingContext(logger, level=logging.DEBUG, handler=h, close=True):
        logger.debug('5. This should appear twice - once on stderr and once on stdout.')
    logger.info('6. This should appear just once on stderr.')
    logger.debug('7. This should not appear.')
```

--------------------------------

### Parse Command-Line Arguments

Source: https://github.com/python/cpython/blob/main/Doc/library/optparse.rst

Provides an example of how to parse command-line arguments using the parse_args() method, returning parsed options and remaining arguments.

```python
(options, args) = parser.parse_args()
```

--------------------------------

### Running doctest examples from the command line

Source: https://github.com/python/cpython/blob/main/Doc/library/doctest.rst

Demonstrates how to run a Python script containing doctests from the command line. Shows the output when tests pass (no output) and when the verbose flag (-v) is used to see detailed test results.

```shell
$ python example.py
```

```shell
$ python example.py -v
```

--------------------------------

### Running Python Code with cProfile

Source: https://github.com/python/cpython/blob/main/Doc/library/profile.rst

This Python function demonstrates the basic usage of the cProfile module to run a command and optionally save the profiling results to a file, sorted by a specified order. Requires the cProfile module.

```python
import cProfile

cProfile.run('my_function()', 'output.prof')
```

--------------------------------

### Python: Preventing Subclassing for Mock Attributes

Source: https://github.com/python/cpython/blob/main/Doc/library/unittest.mock-examples.rst

Explains how to override the `_get_child_mock` method in a Mock subclass to prevent the subclass from being used for attributes or return values, thus controlling the type of child mocks created.

```python
class MyMock(MagicMock):
    def _get_child_mock(self, **kwargs):
        # Prevent MyMock from being used for attributes
        return super()._get_child_mock(**kwargs)

```

--------------------------------

### Turtle Configuration File Example (INI)

Source: https://github.com/python/cpython/blob/main/Doc/library/turtle.rst

Provides an example of a `turtle.cfg` file, which is used to configure the appearance and behavior of the turtle graphics module. It lists various settings like screen dimensions, colors, and language.

```ini
width = 0.5
height = 0.75
leftright = None
topbottom = None
canvwidth = 400
canvheight = 300
mode = standard
colormode = 1.0
delay = 10
undobuffersize = 1000
shape = classic
pencolor = black
fillcolor = black
resizemode = noresize
visible = True
language = english
exampleturtle = turtle
examplescreen = screen
title = Python Turtle Graphics
using_IDLE = False
```

--------------------------------

### multiprocessing.Process Usage Example

Source: https://github.com/python/cpython/blob/main/Doc/library/multiprocessing.rst

Demonstrates how to create a Process object with a target function and arguments, start it, and observe its execution and potential errors like AttributeError. This is useful for understanding process creation and basic execution flow.

```python
import multiprocessing as mp

def knigit():
    print("Ni!")

process = mp.Process(target=knigit)
process.start()
# Example of an AttributeError during spawn
# Traceback (most recent call last):
#   File ".../multiprocessing/spawn.py", line ..., in spawn_main
#     File ".../multiprocessing/spawn.py", line ..., in _main
# AttributeError: module '__main__' has no attribute 'knigit'

process
```

--------------------------------

### Timeit command-line interface usage

Source: https://github.com/python/cpython/blob/main/Doc/library/timeit.rst

Example of using the timeit module from the command line to time a statement. Options allow specifying the number of loops, repetitions, setup statements, and timer type (wallclock vs. process time).

```bash
python -m timeit -n 10000 -s "import math" "math.sqrt(256)"
```

--------------------------------

### Custom Database Importer with Metadata

Source: https://github.com/python/cpython/blob/main/Doc/library/importlib.metadata.rst

Example of a custom Python importer that loads modules from a database and provides distribution metadata and entry points.

```python
import importlib.abc
from importlib.metadata import DistributionFinder, Distribution
import sys

class DatabaseImporter(importlib.abc.MetaPathFinder):
    def __init__(self, db):
        self.db = db

    def find_spec(self, fullname, target=None):
        return self.db.spec_from_name(fullname)

sys.meta_path.append(DatabaseImporter(connect_db(...)))

class DatabaseImporter(DistributionFinder):
    ...

    def find_distributions(self, context=DistributionFinder.Context()):
        query = dict(name=context.name) if context.name else {}
        for dist_record in self.db.query_distributions(query):
            yield DatabaseDistribution(dist_record)

class DatabaseDistribution(Distribution):
    def __init__(self, record):
        self.record = record

    def read_text(self, filename):
        if filename == "METADATA":
            return f"""Name: {self.record.name}
Version: {self.record.version}
"""
        if filename == "entry_points.txt":
            return "\n".join(
              f"[{ep.group}]\n{ep.name}={ep.value}"
              for ep in self.record.entry_points)

    def locate_file(self, path):
        raise RuntimeError("This distribution has no file system")

```

--------------------------------

### Python Installer Command-Line Options

Source: https://github.com/python/cpython/blob/main/Doc/using/windows.rst

These are common command-line options for the Python installer, enabling silent or passive installations, uninstallation, and layout creation. These options allow for automated deployments without user interaction.

```bash
python-installer.exe /passive
python-installer.exe /quiet
python-installer.exe /simple
python-installer.exe /uninstall
python-installer.exe /layout C:\Python
python-installer.exe /log installer.log
```

--------------------------------

### Install IDLE on Alpine Linux

Source: https://github.com/python/cpython/blob/main/Doc/using/unix.rst

Installs the IDLE integrated development environment on Alpine Linux systems using the apk package manager. Requires sudo privileges.

```shell
sudo apk add python3-idle
```

--------------------------------

### cProfile.Profile.run

Source: https://github.com/python/cpython/blob/main/Doc/library/profile.rst

Profiles a command string using exec.

```APIDOC
## cProfile.Profile.run

### Description
Profiles a command string using exec.

### Method
Method

### Endpoint
N/A

### Parameters
#### Path Parameters
None

#### Query Parameters
None

#### Request Body
None

### Request Example
```python
import cProfile

pr = cProfile.Profile()
pr.run('my_function()')
```

### Response
#### Success Response (200)
Profiling data for the command is collected.

#### Response Example
```
None
```
```

--------------------------------

### Patch Object Attribute with Decorator (Python)

Source: https://github.com/python/cpython/blob/main/Doc/library/unittest.mock-examples.rst

Shows how to use the `@patch.object` decorator to temporarily replace an attribute of a specific object during a test. The original attribute value is restored after the decorated function or method finishes.

```python
from unittest.mock import patch, sentinel

class SomeClass:
    attribute = "original_value"

# Store the original attribute value
original = SomeClass.attribute

@patch.object(SomeClass, 'attribute', sentinel.new_attribute)
def test_attribute_patch():
    assert SomeClass.attribute == sentinel.new_attribute

test_attribute_patch()

# Verify the attribute is restored
assert SomeClass.attribute == original
```

--------------------------------

### Send Data to CGI Script via STDIN

Source: https://github.com/python/cpython/blob/main/Doc/library/urllib.request.rst

Demonstrates sending data to a CGI script's standard input and reading the response. This example requires SSL support in the Python installation.

```python
import urllib.request
req = urllib.request.Request(url='https://localhost/cgi-bin/test.cgi',
                      data=b'This data is passed to stdin of the CGI')
with urllib.request.urlopen(req) as f:
    print(f.read().decode('utf-8'))
```

--------------------------------

### cProfile.Profile.runctx

Source: https://github.com/python/cpython/blob/main/Doc/library/profile.rst

Profiles a command string with specified global and local environments using exec.

```APIDOC
## cProfile.Profile.runctx

### Description
Profiles a command string with specified global and local environments using exec.

### Method
Method

### Endpoint
N/A

### Parameters
#### Path Parameters
None

#### Query Parameters
None

#### Request Body
None

### Request Example
```python
import cProfile

my_globals = {'x': 1}
my_locals = {'y': 2}
pr = cProfile.Profile()
pr.runctx('x + y', my_globals, my_locals)
```

### Response
#### Success Response (200)
Profiling data with custom environments is collected.

#### Response Example
```
None
```
```

--------------------------------

### PEG Meta-Grammar: Start Rule

Source: https://github.com/python/cpython/blob/main/InternalDocs/parser.md

Defines the top-level structure of a PEG grammar, specifying how the parsing process begins and ends. It includes a rule for the overall grammar structure and the end marker.

```PEG Grammar
start[Grammar]: grammar ENDMARKER { grammar }
```

--------------------------------

### Iterate through gdbm keys

Source: https://github.com/python/cpython/blob/main/Doc/library/dbm.rst

This example demonstrates how to iterate through all keys in a GDBM database without loading them all into memory at once. It uses `firstkey()` to get the initial key and `nextkey()` to retrieve subsequent keys.

```python
k = db.firstkey()
while k is not None:
    print(k)
    k = db.nextkey(k)
```

--------------------------------

### Python BytesIO getbuffer() Example

Source: https://github.com/python/cpython/blob/main/Doc/library/io.rst

Demonstrates how to get a mutable view of the BytesIO buffer, allowing in-place modifications. Note that the BytesIO object cannot be resized or closed while the view exists.

```python
import io

b = io.BytesIO(b"abcdef")
view = b.getbuffer()
view[2:4] = b"56"
print(b.getvalue())
```

--------------------------------

### Cmd Example: Building a Turtle Shell

Source: https://github.com/python/cpython/blob/main/Doc/library/cmd.rst

This example demonstrates how to use the Cmd module to create an interactive shell for controlling the turtle graphics module. Custom commands like 'forward' are implemented as `do_forward` methods.

```python
import cmd
import turtle

class TurtleShell(cmd.Cmd):
    intro = 'Welcome to the turtle shell.   Type help or ? to list commands.\n'
    prompt = '(turtle) '

    def do_forward(self, arg):
        'Move the turtle forward. Usage: forward <distance>'
        try:
            distance = int(arg)
            turtle.forward(distance)
        except ValueError:
            print('Invalid distance. Please provide an integer.')

    def do_turn(self, arg):
        'Turn the turtle left or right. Usage: turn <direction> <degrees>'
        try:
            direction, degrees_str = arg.split()
            degrees = int(degrees_str)
            if direction.lower() == 'left':
                turtle.left(degrees)
            elif direction.lower() == 'right':
                turtle.right(degrees)
            else:
                print('Invalid direction. Use left or right.')
        except ValueError:
            print('Invalid arguments. Usage: turn <left|right> <degrees>')

    def do_quit(self, arg):
        'Exit the turtle shell.'
        print('Goodbye!')
        return True

if __name__ == '__main__':
    turtle.Screen()
    TurtleShell().cmdloop()
```

--------------------------------

### Server-side SSL Context Creation and Socket Binding (Python)

Source: https://github.com/python/cpython/blob/main/Doc/library/ssl.rst

This code sets up a server-side SSL context for client authentication. It loads a certificate and private key, binds a socket to a specific address and port, and starts listening for incoming connections. This is the initial setup for a secure server.

```python
import socket
import ssl

context = ssl.create_default_context(ssl.Purpose.CLIENT_AUTH)
context.load_cert_chain(certfile="mycertfile", keyfile="mykeyfile")

bindsocket = socket.socket()
bindsocket.bind(('myaddr.example.com', 10023))
bindsocket.listen(5)
```

--------------------------------

### Run HTTP Server from Command Line

Source: https://github.com/python/cpython/blob/main/Doc/library/http.server.rst

This demonstrates how to run a simple HTTP server from the command line using Python's http.server module. It shows examples of specifying the port, binding address, and directory to serve.

```bash
python -m http.server [OPTIONS] [port]
```

```bash
python -m http.server 9000
```

```bash
python -m http.server --bind 127.0.0.1
```

```bash
python -m http.server --directory /tmp/
```

--------------------------------

### pynng Sender Setup and Logging (Python)

Source: https://github.com/python/cpython/blob/main/Doc/howto/logging-cookbook.rst

Defines a custom logging handler `NNGSocketHandler` that extends `logging.handlers.QueueHandler`. This handler sends log records as JSON-encoded strings over a pynng publisher socket. The example configures basic logging and then continuously sends random log messages.

```python
# sender.py
import json
import logging
import logging.handlers
import time
import random

import pynng

DEFAULT_ADDR = "tcp://localhost:13232"

class NNGSocketHandler(logging.handlers.QueueHandler):

    def __init__(self, uri):
        socket = pynng.Pub0(dial=uri, send_timeout=500)
        super().__init__(socket)

    def enqueue(self, record):
        d = dict(record.__dict__)
        data = json.dumps(d)
        self.queue.send(data.encode('utf-8'))

    def close(self):
        self.queue.close()

logging.getLogger('pynng').propagate = False
handler = NNGSocketHandler(DEFAULT_ADDR)
logging.basicConfig(level=logging.DEBUG,
                    handlers=[logging.StreamHandler(), handler],
                    format='%(levelname)-8s %(name)10s %(process)6s %(message)s')
levels = (logging.DEBUG, logging.INFO, logging.WARNING, logging.ERROR,
          logging.CRITICAL)
logger_names = ('myapp', 'myapp.lib1', 'myapp.lib2')
msgno = 1
while True:
    level = random.choice(levels)
    logger = logging.getLogger(random.choice(logger_names))
    logger.log(level, 'Message no. %5d' % msgno)
    msgno += 1
    delay = random.random() * 2 + 0.5
    time.sleep(delay)
```

--------------------------------

### Windows Command Prompt Example

Source: https://github.com/python/cpython/blob/main/Doc/faq/windows.rst

Demonstrates the typical appearance of a Windows command prompt, indicating the current directory.

```doscon
C:\>
```

```doscon
D:\YourName\Projects\Python>
```

--------------------------------

### Create and manage asyncio Tasks with create_task() and current_task()

Source: https://github.com/python/cpython/blob/main/Doc/library/asyncio-api-index.rst

Use `create_task()` to start a coroutine running concurrently in the event loop and get a Task object. `current_task()` returns the currently running Task.

```python
import asyncio

async def my_coro():
    print('Coroutine running')

task = asyncio.create_task(my_coro())
current = asyncio.current_task()
print(f'Current task: {current.get_name()}')
await task
```

--------------------------------

### Bootstrap pip using module API (Python)

Source: https://github.com/python/cpython/blob/main/Doc/library/ensurepip.rst

The bootstrap() function bootstraps pip into the current or designated environment. It accepts parameters to control installation location, upgrades, user installation, script installation, and verbosity.

```python
import ensurepip

ensurepip.bootstrap(root=None, upgrade=False, user=False, altinstall=False, default_pip=False, verbosity=0)
```

--------------------------------

### Enable Framework Installation Directory for iOS Builds

Source: https://github.com/python/cpython/blob/main/Apple/iOS/README.md

This configure argument specifies the installation directory for the Python.framework on iOS. It is mandatory for iOS builds as they exclusively support framework installations.

```bash
--enable-framework[=DIR]
```

--------------------------------

### Warn about invalid types in setup() fields

Source: https://github.com/python/cpython/blob/main/Misc/NEWS.d/3.7.0a3.rst

The `distutils.dist.Distribution` class now issues warnings if the `classifiers`, `keywords`, or `platforms` fields are not specified as a list or a string during the `setup()` call. This helps catch potential configuration errors early.

```python
# Example of a potential warning (not executable code):
# setup(
#     name='my_package',
#     version='0.1',
#     classifiers=123 # This would trigger a warning
# )
```

--------------------------------

### Configure Python for Framework Build on macOS

Source: https://github.com/python/cpython/blob/main/Mac/README.rst

Enables the creation of a Python.framework instead of a traditional Unix install. Optionally specifies an installation directory for the framework, applications, and command-line tools.

```bash
#!/bin/sh
./configure --enable-framework=/Users/ronald/Library/Frameworks
make && make install
```

--------------------------------

### Python XML-RPC Client Example

Source: https://github.com/python/cpython/blob/main/Doc/library/xmlrpc.server.rst

This Python code shows how to connect to an XML-RPC server and call the registered methods. It demonstrates calling the 'pow', 'add', and 'mul' methods, as well as listing available methods using 'system.listMethods'.

```python
import xmlrpc.client

s = xmlrpc.client.ServerProxy('http://localhost:8000')
print(s.pow(2,3))  # Returns 2**3 = 8
print(s.add(2,3))  # Returns 5
print(s.mul(5,2))  # Returns 5*2 = 10

# Print list of available methods
print(s.system.listMethods())
```

--------------------------------

### Using Simulated Slots in a Class Definition

Source: https://github.com/python/cpython/blob/main/Doc/howto/descriptor.rst

This example demonstrates how to use the simulated `Object` class and `Type` metaclass to create a class (`H`) that utilizes `__slots__`. It defines `slot_names` and initializes the slots in the `__init__` method, showing how attributes are stored and accessed via the underlying `_slotvalues` list.

```python
class H(Object, metaclass=Type):
    'Instance variables stored in slots'

    slot_names = ['x', 'y']

    def __init__(self, x, y):
        self.x = x
        self.y = y
```

--------------------------------

### Basic `sched` Usage Example

Source: https://github.com/python/cpython/blob/main/Doc/library/sched.rst

Demonstrates the fundamental usage of the `sched` module to schedule and run events. It shows how to create a scheduler instance, define functions to be executed, and schedule them with different delays, priorities, and arguments (both positional and keyword). The example also illustrates the use of `enterabs` for scheduling at specific times and the behavior of the `run` method.

```python
import sched, time
s = sched.scheduler(time.time, time.sleep)
def print_time(a='default'):
    print("From print_time", time.time(), a)
def print_some_times():
    print(time.time())
    s.enter(10, 1, print_time)
    s.enter(5, 2, print_time, argument=('positional',))
    # despite having higher priority, 'keyword' runs after 'positional' as enter() is relative
    s.enter(5, 1, print_time, kwargs={'a': 'keyword'})
    s.enterabs(1_650_000_000, 10, print_time, argument=("first enterabs",))
    s.enterabs(1_650_000_000, 5, print_time, argument=("second enterabs",))
    s.run()
    print(time.time())

print_some_times()
```

--------------------------------

### Python: Set up Basic Authentication Handler

Source: https://github.com/python/cpython/blob/main/Doc/howto/urllib2.rst

Configures a password manager and an HTTPBasicAuthHandler for basic authentication. It adds a username and password to the manager for a specific URL or a default realm. This handler is then used to build a custom opener.

```python
import urllib.request

# create a password manager
password_mgr = urllib.request.HTTPPasswordMgrWithDefaultRealm()

# Add the username and password. 
# If we knew the realm, we could use it instead of None.
top_level_url = "http://example.com/foo/"
username = "user"
password = "pass"
password_mgr.add_password(None, top_level_url, username, password)

handler = urllib.request.HTTPBasicAuthHandler(password_mgr)

# create "opener" (OpenerDirector instance)
opener = urllib.request.build_opener(handler)

# use the opener to fetch a URL
a_url = "http://example.com/foo/"
# opener.open(a_url)

# Install the opener. 
# Now all calls to urllib.request.urlopen use our opener.
urllib.request.install_opener(opener)
```

--------------------------------

### Operating System Interface using os module

Source: https://github.com/python/cpython/blob/main/Doc/tutorial/stdlib.rst

Demonstrates basic operating system interactions like getting the current working directory, changing directories, and executing system commands using the 'os' module. It advises against using 'from os import *' to avoid naming conflicts.

```python
import os
os.getcwd()      # Return the current working directory
os.chdir('/server/accesslogs')   # Change current working directory
os.system('mkdir today')   # Run the command mkdir in the system shell
```

```python
import os
dir(os)
help(os)
```

--------------------------------

### Start Method Configuration

Source: https://github.com/python/cpython/blob/main/Doc/library/multiprocessing.rst

Functions for configuring how child processes are started, including inheriting import states and setting the start method.

```APIDOC
## Start Method Configuration

### Description
This section covers functions related to configuring the process start method, ensuring proper inheritance of imported modules and setting the desired start strategy (`fork`, `spawn`, `forkserver`).

### Functions

#### `set_forkserver_preload(preload)`

##### Description
Specifies a list of modules to import in the forkserver process. This allows imported modules to be inherited by forked processes, acting as a performance enhancement. Any `ImportError` during this process is ignored silently. This must be called before launching the forkserver process (e.g., before creating a `Pool` or `Process`). It is only meaningful with the `'forkserver'` start method.

##### Parameters
- **preload** (list of str) - A list of module names to preload.

#### `set_start_method(method, force=False)`

##### Description
Sets the method used to start child processes. The `method` can be `'fork'`, `'spawn'`, or `'forkserver'`. Raises `RuntimeError` if the start method is already set and `force` is `False`. If `method` is `None` and `force` is `True`, the start method is unset. If `method` is `None` and `force` is `False`, the default context is used. This function should be called at most once and protected within an `if __name__ == '__main__'` block.

##### Parameters
- **method** (str or None) - The desired start method ('fork', 'spawn', 'forkserver').
- **force** (bool, optional) - If `True`, allows resetting the start method.

##### Raises
- `RuntimeError` - If the start method is already set and `force` is `False`.
```

--------------------------------

### Python Logging - Formatter Initialization

Source: https://github.com/python/cpython/blob/main/Doc/howto/logging.rst

Shows how to instantiate a Formatter object with optional message format, date format, and style indicator arguments.

```python
formatter = logging.Formatter(fmt='%(asctime)s - %(levelname)s - %(message)s', datefmt='%Y-%m-%d %H:%M:%S', style='%')
```

--------------------------------

### Starting the Python Interpreter

Source: https://github.com/python/cpython/blob/main/Doc/faq/windows.rst

Shows the command to initiate the Python interpreter from the Windows command prompt and the expected output when it successfully starts in interactive mode.

```doscon
C:\Users\YourName> py
```

```pycon
Python 3.6.4 (v3.6.4:d48eceb, Dec 19 2017, 06:04:45) [MSC v.1900 32 bit (Intel)] on win32
Type "help", "copyright", "credits" or "license" for more information.
>>>
```

--------------------------------

### Option Actions

Source: https://github.com/python/cpython/blob/main/Doc/library/optparse.rst

Lists and explains the standard actions available for command-line options.

```APIDOC
## Option Actions

### Description
Explains the different actions that can be assigned to an option, defining how its value is processed and stored.

### Actions
- **"store"**: Stores the option's argument. This is the default action.
- **"store_const"**: Stores a constant value specified by the `const` attribute.
- **"store_true"**: Stores the boolean value `True`.
- **"store_false"**: Stores the boolean value `False`.
- **"append"**: Appends the option's argument to a list.
- **"append_const"**: Appends a constant value (specified by `const`) to a list.
- **"count"**: Increments a counter by one each time the option is seen.
- **"callback"**: Calls a specified function with arguments derived from the option. Requires `callback`, `callback_args`, and `callback_kwargs` attributes.
- **"help"**: Displays a usage message including all options and their descriptions.
```

--------------------------------

### Timeit command-line interface with multiple setup statements

Source: https://github.com/python/cpython/blob/main/Doc/library/timeit.rst

Illustrates providing multiple setup statements by using multiple '-s' options. Each setup statement is executed once before the timing.

```bash
python -m timeit -s "import sys" -s "x=1" "sys.stdout.write(str(x))"
```

--------------------------------

### Python Class Definition for MRO Example

Source: https://github.com/python/cpython/blob/main/Doc/howto/mro.rst

Defines a set of classes (A, B, C, D, E, F, O) to demonstrate Method Resolution Order (MRO) calculations. This setup is used to illustrate the C3 linearization algorithm.

```python
>>> O = object
>>> class F(O): pass
>>> class E(O): pass
>>> class D(O): pass
>>> class C(D,F): pass
>>> class B(E,D): pass
>>> class A(B,C): pass
```

--------------------------------

### Populating a List with PyList_SetItem

Source: https://github.com/python/cpython/blob/main/Doc/c-api/intro.rst

Shows an equivalent way to populate a list using PyList_New and PyList_SetItem, similar to the tuple example. PyList_SetItem also steals references to the items being added.

```c
PyObject *list;

list = PyList_New(3);
PyList_SetItem(list, 0, PyLong_FromLong(1L));
PyList_SetItem(list, 1, PyLong_FromLong(2L));
PyList_SetItem(list, 2, PyUnicode_FromString("three"));
```

--------------------------------

### Python unittest discover command with options

Source: https://github.com/python/cpython/blob/main/Doc/library/unittest.rst

Shows how to use the 'discover' subcommand with specific options for verbosity, start directory, and pattern matching. These options allow for fine-grained control over the test discovery process.

```python
python -m unittest discover -s project_directory -p "*_test.py"
```

--------------------------------

### PEG Grammar Rule Example

Source: https://github.com/python/cpython/blob/main/InternalDocs/parser.md

Illustrates a basic rule in a PEG grammar showing ordered alternatives. The parser tries 'A' first, then 'B', then 'C'. If 'A' succeeds, 'B' and 'C' are not attempted, even if parsing fails later.

```peg
rule: A | B | C
```

--------------------------------

### HTMLParser Example: Basic Tag and Data Handling - Python

Source: https://github.com/python/cpython/blob/main/Doc/library/html.parser.rst

Demonstrates a custom HTMLParser subclass that prints start tags, attributes, end tags, and data. It also shows handling for entity and character references, comments, and declarations.

```python
from html.parser import HTMLParser
from html.entities import name2codepoint

class MyHTMLParser(HTMLParser):
    def handle_starttag(self, tag, attrs):
        print("Start tag:", tag)
        for attr in attrs:
            print("     attr:", attr)

    def handle_endtag(self, tag):
        print("End tag  :", tag)

    def handle_data(self, data):
        print("Data     :", data)

    def handle_comment(self, data):
        print("Comment  :", data)

    def handle_entityref(self, name):
        c = chr(name2codepoint[name])
        print("Named ent:", c)

    def handle_charref(self, name):
        if name.startswith('x'):
            c = chr(int(name[1:], 16))
        else:
            c = chr(int(name))
        print("Num ent  :", c)

    def handle_decl(self, data):
        print("Decl     :", data)

parser = MyHTMLParser()
```

--------------------------------

### WSGI Demo Application

Source: https://github.com/python/cpython/blob/main/Doc/library/wsgiref.rst

A simple WSGI application that displays 'Hello world!' and the request environment details. Useful for verifying WSGI server functionality.

```python
def demo_app(environ, start_response):
    """This function is a small but complete WSGI application that returns a text page containing the message 'Hello world!' and a list of the key/value pairs provided in the *environ* parameter."""
    
    # The *start_response* callable should follow the :class:`.StartResponse` protocol.
```

--------------------------------

### Python Installer Named Arguments

Source: https://github.com/python/cpython/blob/main/Doc/using/windows.rst

These are additional named arguments that can be passed to the Python installer for customization. They control aspects like all-users installation, target directory, and default target directories.

```bash
python-installer.exe InstallAllUsers=1 TargetDir="C:\Python310"
python-installer.exe DefaultAllUsersTargetDir="%ProgramFiles%\Python310"
```

--------------------------------

### cProfile/profile Module Functions

Source: https://github.com/python/cpython/blob/main/Doc/library/profile.rst

Lists the functions provided by the `cProfile` and `profile` modules, including the `run` function for executing and profiling Python code.

```APIDOC
## cProfile/profile Module Functions

### Description
Both the `profile` and `cProfile` modules provide the following functions for profiling Python code.

### Method
`run(command, filename=None, sort=-1)`

### Endpoint
N/A (Module function)

### Parameters
#### Path Parameters
N/A

#### Query Parameters
N/A

#### Request Body
N/A

### Function Description
- **run(command, filename=None, sort=-1)**: Executes the given `command` (a string or code object) and optionally saves the profiling results to `filename`. The `sort` parameter specifies the sorting order for the output. If `filename` is None, results are printed to stdout.

### Example Usage
```python
import cProfile

# Profile a script and save results to a file, sorted by cumulative time
cProfile.run('my_script.py', 'profile_results.prof', sort='cumulative')

# Profile a piece of code and print results to stdout, sorted by time
cProfile.run('x = 1 + 1', filename=None, sort='time')
```
```

--------------------------------

### ThreadingMock wait_until_called method

Source: https://github.com/python/cpython/blob/main/Doc/library/unittest.mock.rst

Illustrates the usage of ThreadingMock's wait_until_called method to pause execution until the mock object is invoked. It includes an example of starting a thread that calls the mock and then waiting for that call with a timeout.

```python
>>> mock = ThreadingMock()
>>> thread = threading.Thread(target=mock)
>>> thread.start()
>>> mock.wait_until_called(timeout=1)
>>> thread.join()
```

--------------------------------

### Using Select for Socket I/O in C

Source: https://github.com/python/cpython/blob/main/Doc/howto/sockets.rst

This code provides a C-language structure for using the `select()` system call to monitor socket readiness. It includes setting up file descriptor sets (`fd_set`) for reading, writing, and exceptions, and then calling `select()` with a timeout. The returned file descriptor sets indicate which sockets are ready.

```c
#include <sys/select.h>
#include <sys/time.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/socket.h>

int sock_fd;
fd_set readfds, writefds, exceptfds;
struct timeval tv;

// ... socket creation and setup code ...

// Clear and populate the file descriptor sets
FD_ZERO(&readfds);
FD_SET(sock_fd, &readfds);
FD_ZERO(&writefds);
FD_SET(sock_fd, &writefds);
FD_ZERO(&exceptfds);
FD_SET(sock_fd, &exceptfds);

// Set timeout (e.g., 1 minute)
tv.tv_sec = 60;
tv.tv_usec = 0;

// Call select
int retval = select(sock_fd + 1, &readfds, &writefds, &exceptfds, &tv);

if (retval == -1) {
    perror("select");
} else if (retval) {
    // Check which sets have activity
    if (FD_ISSET(sock_fd, &readfds)) {
        // Socket is ready for reading
    }
    if (FD_ISSET(sock_fd, &writefds)) {
        // Socket is ready for writing
    }
    if (FD_ISSET(sock_fd, &exceptfds)) {
        // An error occurred or an exception condition
    }
} else {
    // Timeout occurred
}

```

--------------------------------

### Install Python via PowerShell

Source: https://github.com/python/cpython/blob/main/Doc/using/windows.rst

This command installs Python from a downloaded MSIX file using Windows PowerShell. It's an alternative to installing from the Microsoft Store or double-clicking the file.

```powershell
Add-AppxPackage <path to MSIX>
```

--------------------------------

### Getting Available TLS Signature Algorithms

Source: https://github.com/python/cpython/blob/main/Doc/library/ssl.rst

Provides an example of how to retrieve a list of available TLS signature algorithm names using `ssl.get_sigalgs()`. These algorithms are used during the TLS handshake for server authentication or client certificate authentication.

```python
>>> ssl.get_sigalgs()  # doctest: +SKIP
['ecdsa_secp256r1_sha256', 'ecdsa_secp384r1_sha384', ...]
```

--------------------------------

### Python Private Name Mangling Example

Source: https://github.com/python/cpython/blob/main/Doc/faq/programming.rst

Illustrates Python's private name mangling for attributes starting with double underscores (`__`). It shows how `__one` within class `A` is mangled to `_A__one` and how it can be accessed from a subclass or externally.

```python
class A:
    def __one(self):
        return 1
    def two(self):
        return 2 * self.__one()

class B(A):
    def three(self):
        return 3 * self._A__one()

four = 4 * A()._A__one()
```

--------------------------------

### Setting Items in a Mutable Sequence with PyObject_SetItem

Source: https://github.com/python/cpython/blob/main/Doc/c-api/intro.rst

Provides an example of a function that sets all items of a mutable sequence (like a list) to a given item. It uses PyObject_Length to get the sequence size and PyObject_SetItem to set each element, handling reference counts carefully.

```c
int
set_all(PyObject *target, PyObject *item)
{
    Py_ssize_t i, n;

    n = PyObject_Length(target);
    if (n < 0)
        return -1;
    for (i = 0; i < n; i++) {
        PyObject *index = PyLong_FromSsize_t(i);
        if (!index)
            return -1;
        if (PyObject_SetItem(target, index, item) < 0) {
            Py_DECREF(index);
            return -1;
        }
        Py_DECREF(index);
    }
    return 0;
}
```

--------------------------------

### Install Python Packages from Requirements File

Source: https://github.com/python/cpython/blob/main/Doc/tutorial/venv.rst

Installs all packages listed in a requirements.txt file, ensuring that the project environment is recreated accurately. This is crucial for collaboration and deployment.

```console
(tutorial-env) $ python -m pip install -r requirements.txt
Collecting novas==3.1.1.3 (from -r requirements.txt (line 1))
  ...
Collecting numpy==1.9.2 (from -r requirements.txt (line 2))
  ...
Collecting requests==2.7.0 (from -r requirements.txt (line 3))
  ...
Installing collected packages: novas, numpy, requests
    Running setup.py install for novas
Successfully installed novas-3.1.1.3 numpy-1.9.2 requests-2.7.0
```

--------------------------------

### Install LLVM 19 on Ubuntu/Debian

Source: https://github.com/python/cpython/blob/main/Tools/jit/README.md

Installs LLVM version 19 on Ubuntu or Debian-based systems using a provided script.

```shell
wget https://apt.llvm.org/llvm.sh
chmod +x llvm.sh
sudo ./llvm.sh 19
```

--------------------------------

### Python Iterator Example: List Iteration

Source: https://github.com/python/cpython/blob/main/Doc/whatsnew/2.2.rst

Demonstrates how to use the iter() function to get an iterator for a list and then repeatedly call the next() method to retrieve elements. It also shows how StopIteration is raised when the iterator is exhausted.

```python
>>> L = [1,2,3]
>>> i = iter(L)
>>> print i
<iterator object at 0x8116870>
>>> i.next()
1
>>> i.next()
2
>>> i.next()
3
>>> i.next()
Traceback (most recent call last):
  File "<stdin>", line 1, in ?
StopIteration
>>>
```

--------------------------------

### MSbuild Project Properties for Python Installers

Source: https://github.com/python/cpython/blob/main/Tools/msi/README.txt

Defines properties that can be passed to MSBuild projects for customizing the Python installer build. These properties control release builds, URIs for unique IDs, download sources, and signing certificates.

```shell
/p:BuildForRelease=(true|false)
/p:ReleaseUri=(any URI)
/p:DownloadUrlBase=(any URI)
/p:DownloadUrl=(any URI)
/p:SigningCertificate=(certificate name)
/p:RebuildAll=(true|false)
```

--------------------------------

### Installing SystemTap Development Tools

Source: https://github.com/python/cpython/blob/main/Doc/howto/instrumentation.rst

Installs the necessary development tools for SystemTap on Linux systems, allowing CPython to be built with embedded markers for SystemTap instrumentation.

```shell
$ yum install systemtap-sdt-devel
```

```shell
$ sudo apt-get install systemtap-sdt-dev
```

--------------------------------

### Python: setUpClass and tearDownClass Example

Source: https://github.com/python/cpython/blob/main/Doc/library/unittest.rst

Shows the implementation of class methods `setUpClass` and `tearDownClass` for setting up and tearing down resources at the class level in Python's unittest. These methods are called once per test class. You must explicitly call base class methods if you want them executed.

```python
import unittest

class Test(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls._connection = createExpensiveConnectionObject()

    @classmethod
    def tearDownClass(cls):
        cls._connection.destroy()
```

--------------------------------

### Open URL in Browser using Python's webbrowser module

Source: https://github.com/python/cpython/blob/main/Doc/library/webbrowser.rst

Demonstrates how to use the `webbrowser` module in Python to open a given URL. It shows examples for opening the URL in a new tab and a new window. Requires the `webbrowser` module to be installed.

```python
import webbrowser

url = 'https://docs.python.org/'

# Open URL in a new tab, if a browser window is already open.
webbrowser.open_new_tab(url)

# Open URL in new window, raising the window if possible.
webbrowser.open_new(url)
```

--------------------------------

### Creating and Populating a Tuple with PyTuple_SetItem

Source: https://github.com/python/cpython/blob/main/Doc/c-api/intro.rst

Demonstrates how to create a new tuple and populate its elements using PyTuple_New and PyTuple_SetItem. This involves creating new references for each element, which are then stolen by PyTuple_SetItem.

```c
PyObject *t;

t = PyTuple_New(3);
PyTuple_SetItem(t, 0, PyLong_FromLong(1L));
PyTuple_SetItem(t, 1, PyLong_FromLong(2L));
PyTuple_SetItem(t, 2, PyUnicode_FromString("three"));
```

--------------------------------

### os.startfile

Source: https://github.com/python/cpython/blob/main/Doc/library/os.rst

Function to start a file with its associated application on Windows.

```APIDOC
## os.startfile(path, [operation], [arguments], [cwd], [show_cmd])

### Description
Starts a file with its associated application. This is equivalent to double-clicking a file in Windows Explorer or using the `start` command.

### Method
`os.startfile`

### Endpoint
N/A (Internal module function)

### Parameters
#### Path Parameters
None

#### Query Parameters
None

#### Request Body
None

### Request Example
```python
# Example on Windows
os.startfile('mydocument.txt')
os.startfile('myimage.jpg', operation='print')
os.startfile('report.pdf', arguments='-p', cwd='C:\Reports')
```

### Response
#### Success Response (200)
Returns as soon as the associated application is launched. No exit status is available.

#### Response Example
```json
{
  "status": "launched"
}
```

### Notes
- This function is only available on Windows.
- `operation` specifies an action like 'open', 'print', or 'edit'.
- `arguments` are passed to the application.
- `cwd` sets the current working directory for the launched application.
- `show_cmd` overrides the default window style (e.g., minimized, maximized).
```

--------------------------------

### Logging to a File Example

Source: https://github.com/python/cpython/blob/main/Doc/howto/logging.rst

Python code snippet that configures logging to write messages to a file named 'example.log' with UTF-8 encoding and DEBUG level. It logs messages at different severity levels.

```python
import logging
logger = logging.getLogger(__name__)
logging.basicConfig(filename='example.log', encoding='utf-8', level=logging.DEBUG)
logger.debug('This message should go to the log file')
logger.info('So should this')
logger.warning('And this, too')
logger.error('And non-ASCII stuff, too, like Øresund and Malmö')
```

--------------------------------

### Add initializer argument to ThreadPoolExecutor (Python)

Source: https://github.com/python/cpython/blob/main/Misc/NEWS.d/3.7.0a3.rst

Provides the ability to add an initializer argument to the ThreadPoolExecutor and ProcessPoolExecutor. This allows for setup code to be run when each worker thread or process is started, improving initialization consistency.

```python
from concurrent.futures import ThreadPoolExecutor

def worker_init(arg):
    print(f"Worker initialized with: {arg}")

# Create executor with an initializer function and its argument
with ThreadPoolExecutor(max_workers=4, initializer=worker_init, initargs=('setup_data',)) as executor:
    # Submit tasks
    pass
```

--------------------------------

### Get Stack Trace (Python)

Source: https://github.com/python/cpython/blob/main/Doc/library/inspect.rst

Returns a list of FrameInfo objects for the caller's stack, starting with the caller and ending with the outermost call. In Python 3.11, `FrameInfo` objects are returned; prior to that, named tuples were used.

```python
import traceback

stack_frames = traceback.stack()
for frame_info in stack_frames:
    print(f"File: {frame_info.filename}, Line: {frame_info.lineno}, Function: {frame_info.function}")
```

--------------------------------

### Installation Path Functions

Source: https://github.com/python/cpython/blob/main/Doc/library/sysconfig.rst

Functions for retrieving installation scheme names, default schemes, preferred schemes, path names, and specific installation paths.

```APIDOC
## GET /sysconfig/scheme_names

### Description
Retrieves a tuple containing all currently supported installation scheme names.

### Method
GET

### Endpoint
/sysconfig/scheme_names

## GET /sysconfig/default_scheme

### Description
Returns the default scheme name for the current platform. This function was renamed in Python 3.10 and its behavior changed in 3.11 for virtual environments.

### Method
GET

### Endpoint
/sysconfig/default_scheme

## GET /sysconfig/preferred_scheme

### Description
Returns a preferred scheme name for a given installation layout key ('prefix', 'home', or 'user'). The returned scheme can be used with other sysconfig functions like get_paths. Behavior is adjusted for virtual environments in Python 3.11.

### Parameters
#### Query Parameters
- **key** (string) - Required - The key specifying the installation layout ('prefix', 'home', or 'user').

### Method
GET

### Endpoint
/sysconfig/preferred_scheme

## GET /sysconfig/path_names

### Description
Returns a tuple containing all path names currently supported by sysconfig.

### Method
GET

### Endpoint
/sysconfig/path_names

## GET /sysconfig/path

### Description
Retrieves a specific installation path based on its name and an optional scheme, variables, and expansion setting. If the name is not found, a KeyError is raised.

### Parameters
#### Query Parameters
- **name** (string) - Required - The name of the path to retrieve (e.g., 'stdlib', 'scripts').
- **scheme** (string) - Optional - The name of the installation scheme to use. Defaults to the platform's default scheme.
- **vars** (dict) - Optional - A dictionary of variables to update the configuration variables.
- **expand** (boolean) - Optional - If True, the path will be expanded using variables. Defaults to True.

### Method
GET

### Endpoint
/sysconfig/path

## GET /sysconfig/paths

### Description
Returns a dictionary containing all installation paths for a given installation scheme. It uses the default scheme if none is provided. Paths can be expanded based on provided variables or a flag.

### Parameters
#### Query Parameters
- **scheme** (string) - Optional - The name of the installation scheme. Defaults to the platform's default scheme.
- **vars** (dict) - Optional - A dictionary of variables to update the configuration variables used for path expansion.
- **expand** (boolean) - Optional - If True, the paths will be expanded. Defaults to True.

### Method
GET

### Endpoint
/sysconfig/paths
```

--------------------------------

### Get Garbage Collection Statistics in Python

Source: https://github.com/python/cpython/blob/main/Doc/library/gc.rst

This function returns a list of dictionaries containing collection statistics for each generation since the interpreter started. It includes counts of collections, collected objects, and uncollectable objects.

```python
import gc
stats = gc.get_stats()

for i, gen_stats in enumerate(stats):
    print(f"Generation {i}:")
    print(f"  Collections: {gen_stats['collections']}")
    print(f"  Collected: {gen_stats['collected']}")
    print(f"  Uncollectable: {gen_stats['uncollectable']}")
```

--------------------------------

### Basic cProfile Usage

Source: https://github.com/python/cpython/blob/main/Doc/library/profile.rst

Demonstrates the basic usage of the cProfile module to profile a block of code, enabling and disabling profiling, and printing the statistics to a string buffer.

```python
import cProfile, pstats, io
from pstats import SortKey
pr = cProfile.Profile()
pr.enable()
# ... do something ...
pr.disable()
s = io.StringIO()
sortby = SortKey.CUMULATIVE
ps = pstats.Stats(pr, stream=s).sort_stats(sortby)
ps.print_stats()
print(s.getvalue())
```

--------------------------------

### Get Key Agreement Groups for TLS in Python

Source: https://github.com/python/cpython/blob/main/Doc/library/ssl.rst

Retrieves a list of key agreement groups supported by the SSLContext, considering the minimum and maximum TLS versions. The example shows how to set TLS versions and then fetch the available groups, optionally including aliases.

```python
>>> ctx = ssl.create_default_context()
>>> ctx.minimum_version = ssl.TLSVersion.TLSv1_3
>>> ctx.maximum_version = ssl.TLSVersion.TLSv1_3
>>> ctx.get_groups()  # doctest: +SKIP
['secp256r1', 'secp384r1', 'secp521r1', 'x25519', 'x448', ...]
```

--------------------------------

### Finding All Matches with re.findall (Python)

Source: https://github.com/python/cpython/blob/main/Doc/howto/regex.rst

Demonstrates the use of re.findall to get a list of all non-overlapping matches of a pattern in a string. The example uses a raw string literal for the pattern to avoid issues with backslashes.

```python
>>> p = re.compile(r'\d+')
>>> p.findall('12 drummers drumming, 11 pipers piping, 10 lords a-leaping')
['12', '11', '10']
```

--------------------------------

### Basic Authentication Handler

Source: https://github.com/python/cpython/blob/main/Doc/howto/urllib2.rst

Details on implementing Basic Authentication using `HTTPBasicAuthHandler` and `HTTPPasswordMgrWithDefaultRealm` for handling username and password mapping.

```APIDOC
## Basic Authentication Handler

### Description
This section covers setting up Basic Authentication for URL requests. It explains how servers signal authentication requirements and how to use `HTTPBasicAuthHandler` with a password manager to provide credentials.

### Setting up Basic Authentication

When authentication is required, the server sends a `WWW-Authenticate` header (e.g., `WWW-Authenticate: Basic realm="cPanel Users"`). The client must then resend the request with the appropriate credentials in a header.

### Using `HTTPBasicAuthHandler` and Password Managers

- Create a password manager: `password_mgr = urllib.request.HTTPPasswordMgrWithDefaultRealm()`.
- Add credentials: `password_mgr.add_password(None, top_level_url, username, password)`. The `None` argument for the realm indicates a default for the URL.
- Create the handler: `handler = urllib.request.HTTPBasicAuthHandler(password_mgr)`.
- Build an opener with the handler: `opener = urllib.request.build_opener(handler)`.
- Use the opener: `opener.open(a_url)`.
- Optionally install the opener: `urllib.request.install_opener(opener)`.

### `top_level_url` Format

`top_level_url` can be a full URL (e.g., `"http://example.com/"`) or an authority (e.g., `"example.com"` or `"example.com:8080"`). The authority must not include userinfo (e.g., `"joe:password@example.com"` is invalid).
```

--------------------------------

### Python Dictionary Representation of Formatter Configurations

Source: https://github.com/python/cpython/blob/main/Doc/library/logging.config.rst

Shows the Python dictionary equivalents for the 'brief' and 'default' formatters defined in the YAML example, illustrating how standard logging.Formatter instances are configured.

```python
{
  'format' : '%(message)s'
}
```

```python
{
  'format' : '%(asctime)s %(levelname)-8s %(name)-15s %(message)s',
  'datefmt' : '%Y-%m-%d %H:%M:%S'
}
```

--------------------------------

### Get source code location from byte offset

Source: https://github.com/python/cpython/blob/main/Doc/c-api/code.rst

Retrieves the start and end line and column numbers for an instruction at a given `byte_offset` within a `PyCodeObject`. Returns 1 on success, 0 otherwise. Information may not always be available.

```c
int PyCode_Addr2Location(PyObject *co, int byte_offset, int *start_line, int *start_column, int *end_line, int *end_column)
```

--------------------------------

### Update py.exe launcher installs on Windows (Windows)

Source: https://github.com/python/cpython/blob/main/Misc/NEWS.d/3.12.0a6.rst

Ensures that the Windows installer correctly upgrades existing installations of the `py.exe` launcher. This maintains a smooth upgrade path for users who rely on the Python launcher.

```installer
.. 

.. date: 2023-02-13-16:32:50
.. gh-issue: 101849
.. nonce: 7lm_53
.. section: Windows

Ensures installer will correctly upgrade existing ``py.exe`` launcher
installs.

..
```

--------------------------------

### Shell Session: optparse Argument Parsing Examples

Source: https://github.com/python/cpython/blob/main/Doc/whatsnew/2.3.rst

Illustrates the output of a Python script using optparse when invoked with different command-line arguments, showcasing successful parsing and argument conversion.

```shell-session
$ ./python opt.py -i data arg1
<Values at 0x400cad4c: {'input': 'data', 'length': None}>
['arg1']
$ ./python opt.py --input=data --length=4
<Values at 0x400cad2c: {'input': 'data', 'length': 4}>
[]
$
```

--------------------------------

### Python Launcher for Windows Usage

Source: https://github.com/python/cpython/blob/main/PC/launcher-usage.txt

Demonstrates the command-line usage of the Python Launcher for Windows. It shows how to invoke the launcher with arguments to select specific Python versions or execute scripts.

```bash
usage:
%s [launcher-args] [python-args] [script [script-args]]

Launcher arguments:
-2     : Launch the latest Python 2.x version
-3     : Launch the latest Python 3.x version
-X.Y   : Launch the specified Python version

The above default to an architecture native runtime, but will select any
available. Add a "-32" to the argument to only launch 32-bit runtimes,
or add "-64" to omit 32-bit runtimes (this latter option is deprecated).

To select a specific runtime, use the -V: options.

-V:TAG         : Launch a Python runtime with the specified tag
-V:COMPANY/TAG : Launch a Python runtime from the specified company and
                 with the specified tag

-0  --list       : List the available pythons
-0p --list-paths : List with paths

If no options are given but a script is specified, the script is checked for a
shebang line. Otherwise, an active virtual environment or global default will
be selected.
```

--------------------------------

### Install Python Certificates on macOS

Source: https://github.com/python/cpython/blob/main/Doc/using/mac.rst

This command installs SSL root certificates for Python on macOS using the 'Install Certificates.command' script. It requires administrator privileges and is part of the Python installation process.

```shell
Install Certificates.command
```

--------------------------------

### Timeit command-line interface with custom setup

Source: https://github.com/python/cpython/blob/main/Doc/library/timeit.rst

Shows how to provide a custom setup statement using the '-s' or '--setup' option when running timeit from the command line. This statement is executed once before the timing begins.

```bash
python -m timeit -s "x = range(1000)" "for i in x: i**2"
```

--------------------------------

### Use sysconfig as a script (Shell)

Source: https://github.com/python/cpython/blob/main/Doc/library/sysconfig.rst

Demonstrates how to run the sysconfig module as a script using Python's -m option. This command prints installation information such as platform, Python version, installation scheme, paths, and configuration variables.

```shell
$ python -m sysconfig
Platform: "macosx-10.4-i386"
Python version: "3.2"
Current installation scheme: "posix_prefix"

Paths:
        data = "/usr/local"
        include = "/Users/tarek/Dev/svn.python.org/py3k/Include"
        platinclude = "."
        platlib = "/usr/local/lib/python3.2/site-packages"
        platstdlib = "/usr/local/lib/python3.2"
        purelib = "/usr/local/lib/python3.2/site-packages"
        scripts = "/usr/local/bin"
        stdlib = "/usr/local/lib/python3.2"

Variables:
        AC_APPLE_UNIVERSAL_BUILD = "0"
        AIX_GENUINE_CPLUSPLUS = "0"
        AR = "ar"
        ARFLAGS = "rc"
        ...

```

--------------------------------

### Verifying Python Installation on macOS

Source: https://github.com/python/cpython/blob/main/Doc/using/mac.rst

Commands to verify that different Python installations (e.g., traditional vs. free-threaded) are correctly installed and accessible. It checks both prefixed paths and assumes `/usr/local/bin` is in the system's PATH.

```shell
# test that the free-threaded interpreter was installed if the Unix Command Tools package was enabled
/usr/local/bin/python3.x t -VV
#    and the traditional interpreter
/usr/local/bin/python3.x -VV
# test that they are also available without the prefix if /usr/local/bin is on $PATH
python3.x t -VV
python3.x -VV
```

--------------------------------

### Python: setUpModule and tearDownModule Example

Source: https://github.com/python/cpython/blob/main/Doc/library/unittest.rst

Illustrates the implementation of module-level functions `setUpModule` and `tearDownModule` for setting up and cleaning up resources for an entire module in Python's unittest. These functions are called once per module. Exceptions raised here will prevent tests in the module from running.

```python
def setUpModule():
    createConnection()

def tearDownModule():
    closeConnection()
```

--------------------------------

### Converting doctest examples to a Python script

Source: https://github.com/python/cpython/blob/main/Doc/library/doctest.rst

The `doctest.script_from_examples` function converts a string containing doctest examples into a Python script. Doctest examples are turned into executable code, and other text is converted into comments. This is useful for generating runnable scripts from interactive session examples.

```python
import doctest
print(doctest.script_from_examples(r"""
    Set x and y to 1 and 2.
    >>> x, y = 1, 2

    Print their sum:
    >>> print(x+y)
    3
"""))
```

--------------------------------

### setupterm

Source: https://github.com/python/cpython/blob/main/Doc/library/curses.rst

Initializes the terminal, optionally using a specified terminal name and file descriptor.

```APIDOC
## POST /curses/setupterm

### Description
Initialize the terminal. *term* is a string giving the terminal name, or ``None``; if omitted or ``None``, the value of the :envvar:`TERM` environment variable will be used. *fd* is the file descriptor to which any initialization sequences will be sent; if not supplied or ``-1``, the file descriptor for ``sys.stdout`` will be used.

### Method
POST

### Endpoint
/curses/setupterm

### Parameters
#### Request Body
- **term** (string) - Optional - The terminal name. Defaults to the TERM environment variable.
- **fd** (int) - Optional - The file descriptor for initialization sequences. Defaults to sys.stdout.

### Request Example
{
  "term": "xterm-256color",
  "fd": 1
}

### Response
#### Success Response (200)
- **message** (string) - A success message indicating the terminal has been initialized.

#### Response Example
{
  "message": "Terminal initialized successfully."
}
```

--------------------------------

### Example Objects

Source: https://github.com/python/cpython/blob/main/Doc/library/doctest.rst

Describes the Example class, which holds a single Python statement and its expected output.

```APIDOC
## Example Object

### Description
An `Example` object encapsulates a single Python statement or interactive example and its corresponding expected output. It is a fundamental component used by `DocTest` objects.

*(Note: Specific attributes for Example class were not detailed in the provided text, but it conceptually pairs a statement with its output.)*
```

--------------------------------

### Module API

Source: https://github.com/python/cpython/blob/main/Doc/library/ensurepip.rst

Details on the functions available in the ensurepip module for programmatic use.

```APIDOC
## Module API

### Description
The `ensurepip` module provides two functions for bootstrapping `pip` programmatically.

### Functions

#### `ensurepip.version()`

*   **Description**: Returns a string specifying the version of `pip` that will be installed when bootstrapping.
*   **Returns**: (string) The available pip version.

#### `ensurepip.bootstrap(root=None, upgrade=False, user=False, altinstall=False, default_pip=False, verbosity=0)`

*   **Description**: Bootstraps `pip` into the current or a designated Python environment.
*   **Parameters**:
    *   `root` (string, optional): An alternative root directory for installation. If `None`, uses the default location.
    *   `upgrade` (boolean, optional): If `True`, upgrades an existing `pip` installation to the bundled version. Defaults to `False`.
    *   `user` (boolean, optional): If `True`, installs into the user site-packages directory. Not permitted in virtual environments. Defaults to `False`.
    *   `altinstall` (boolean, optional): If `True`, omits the `pipX` script installation. Defaults to `False`.
    *   `default_pip` (boolean, optional): If `True`, installs the `pip` script in addition to `pipX` and `pipX.Y`. Defaults to `False`.
    *   `verbosity` (integer, optional): Controls the level of output to `sys.stdout` during bootstrapping. Defaults to `0`.
*   **Raises**:
    *   `ValueError`: If both `altinstall` and `default_pip` are set to `True`.
*   **Side Effects**:
    *   Modifies `sys.path` and `os.environ`.
*   **Audit Events**:
    *   `ensurepip.bootstrap`: Logs the `root` parameter.
```

--------------------------------

### Running a Python Script from Command Line

Source: https://github.com/python/cpython/blob/main/Doc/faq/windows.rst

Demonstrates how to execute a Python script named 'hello.py' located in the 'Desktop' directory from the Windows command prompt.

```doscon
C:\Users\YourName> py Desktop\hello.py
```

```doscon
hello
```

--------------------------------

### SocketHandler Configuration

Source: https://github.com/python/cpython/blob/main/Doc/library/logging.config.rst

Example configuration for a SocketHandler, detailing its class, logging level, formatter, and constructor arguments (host and port).

```ini
[handler_hand03]
class=handlers.SocketHandler
level=INFO
formatter=form03
args=('localhost', handlers.DEFAULT_TCP_LOGGING_PORT)
```

--------------------------------

### Parallel compilation with 'make install'

Source: https://github.com/python/cpython/blob/main/Misc/NEWS.d/3.8.0b1.rst

The `make install` command now utilizes parallel execution for the `compileall` step. This change aims to speed up the installation process by compiling modules concurrently.

```makefile
install:
	$(MAKE) pythonlibs
	$(MAKE) Lib/ensurepip
	$(MAKE) Modules/Setup.local
	$(MAKE) all
	$(MAKE) install-exec
	$(MAKE) install-data
	$(MAKE) compileall # Now runs compileall in parallel
	$(MAKE) install-scripts
	$(MAKE) install-headers
```

--------------------------------

### Argparse: Basic command-line option parsing

Source: https://github.com/python/cpython/blob/main/Doc/library/optparse.rst

Demonstrates basic command-line option parsing using the argparse library. It sets up an ArgumentParser, adds arguments for output, verbosity, and positional arguments, and parses them.

```python
import argparse

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('-o', '--output')
    parser.add_argument('-v', dest='verbose', action='store_true')
    parser.add_argument('rest', nargs='*')
    args = parser.parse_args()
    process(args.rest, output=args.output, verbose=args.verbose)
```

--------------------------------

### Enum Functional API Parameters

Source: https://github.com/python/cpython/blob/main/Doc/howto/enum.rst

Details the complete signature and parameters for the `Enum` functional API: `value` (enum name), `names` (members), `module`, `qualname`, `type` (mixin class), and `start` (initial value). It shows examples of different formats for the `names` parameter.

```python
Enum(
    value='NewEnumName',
    names='RED GREEN BLUE' | 'RED,GREEN,BLUE' | 'RED, GREEN, BLUE' | ['RED', 'GREEN', 'BLUE'] | [('CYAN', 4), ('MAGENTA', 5), ('YELLOW', 6)] | {'CHARTREUSE': 7, 'SEA_GREEN': 11, 'ROSEMARY': 42},
    *, 
    module='...', 
    qualname='...', 
    type=<mixed-in class>,
    start=1,
    )
```

--------------------------------

### Get Outer Frames (Python)

Source: https://github.com/python/cpython/blob/main/Doc/library/inspect.rst

Returns a list of FrameInfo objects for a given frame and all its outer frames. The list starts with the provided frame and ends with the outermost call. In Python 3.11, it returns `FrameInfo` objects, previously named tuples.

```python
import traceback

def outer_func():
    inner_func()

def inner_func():
    frame = traceback.currentframe()
    outer_frames = traceback.getouterframes(frame)
    for frame_info in outer_frames:
        print(f"File: {frame_info.filename}, Line: {frame_info.lineno}, Function: {frame_info.function}")

outer_func()
```

--------------------------------

### Example: ZeroCopyByteArray

Source: https://github.com/python/cpython/blob/main/Doc/library/pickle.rst

An example demonstrating a bytearray subclass that supports out-of-band buffer pickling.

```APIDOC
## Example: ZeroCopyByteArray

This example shows a `bytearray` subclass implementing out-of-band buffer pickling:

```python
class ZeroCopyByteArray(bytearray):

    def __reduce_ex__(self, protocol):
        if protocol >= 5:
            return type(self)._reconstruct, (PickleBuffer(self),), None
        else:
            # PickleBuffer is forbidden with pickle protocols <= 4.
            return type(self)._reconstruct, (bytearray(self),)

    @classmethod
    def _reconstruct(cls, obj):
        with memoryview(obj) as m:
            # Get a handle over the original buffer object
            obj = m.obj
            if type(obj) is cls:
                # Original buffer object is a ZeroCopyByteArray, return it
                # as-is.
                return obj
            else:
                return cls(obj)
```

**Consumer-side usage:**

*   **Normal unserialization (with copy):**
    ```python
    b = ZeroCopyByteArray(b"abc")
    data = pickle.dumps(b, protocol=5)
    new_b = pickle.loads(data)
    print(b == new_b)  # True
    print(b is new_b)  # False: a copy was made
    ```

*   **Out-of-band unserialization (zero-copy):**
    ```python
    b = ZeroCopyByteArray(b"abc")
    buffers = []
    data = pickle.dumps(b, protocol=5, buffer_callback=buffers.append)
    new_b = pickle.loads(data, buffers=buffers)
    print(b == new_b)  # True
    print(b is new_b)  # True: no copy was made
    ```

**Note:** This example is limited as `bytearray` allocates its own memory. Third-party datatypes like NumPy arrays can better leverage zero-copy pickling.
```

--------------------------------

### List Installed Python Versions

Source: https://github.com/python/cpython/blob/main/Doc/using/windows.rst

This command lists all installed Python versions and indicates which one is currently set as the default.

```bash
py --list
```

--------------------------------

### Install IDLE on Debian/Ubuntu

Source: https://github.com/python/cpython/blob/main/Doc/using/unix.rst

Installs the IDLE integrated development environment on Debian and Ubuntu-based systems using the apt package manager. Requires sudo privileges.

```shell
sudo apt update
sudo apt install idle
```

--------------------------------

### Improve turtledemo usability (Python)

Source: https://github.com/python/cpython/blob/main/Misc/NEWS.d/3.5.0a1.rst

The turtledemo has received several usability enhancements: examples are no longer reloaded on each run, GUI setup is consolidated in main(), code font size is adjustable, the text/canvas separator is draggable, and the code text pane is resizable. Buttons also remain visible when the window is shrunk.

```python
# turtledemo updates:
# - Initialization in main() for better structure.
# - Adjustable font size via menu or controls.
# - Draggable separator between text and canvas.
# - Resizable panes for code visibility and small screens.
# - Improved button visibility on window resize.
```

--------------------------------

### Start TCP servers with asyncio.start_server()

Source: https://github.com/python/cpython/blob/main/Doc/library/asyncio-api-index.rst

The `start_server()` function starts a TCP server on a given host and port, accepting incoming connections. It takes a callback function that will be executed for each new client connection.

```python
import asyncio

async def handle_client(reader, writer):
    addr = writer.get_extra_info('peername')
    print(f'Connection from {addr}')
    data = await reader.read(100)
    message = data.decode()
    print(f'Received {message!r} from {addr}')
    writer.write(f'Echo: {message}'.encode())
    await writer.drain()
    writer.close()
    await writer.wait_closed()

async def main():
    server = await asyncio.start_server(
        handle_client, '127.0.0.1', 8888)
    addrs = ', '.join(str(sock.getsockname()) for sock in server.sockets)
    print(f'Serving on {addrs}')
    async with server:
        await server.serve_forever()

asyncio.run(main())
```

--------------------------------

### Document asyncio.open_connection and start_server (Python)

Source: https://github.com/python/cpython/blob/main/Misc/NEWS.d/3.8.0a1.rst

This update improves the documentation for asyncio functions related to network connections, specifically 'asyncio.open_connection' and 'asyncio.start_server', including their UNIX socket counterparts. It provides clearer explanations and usage examples.

```python
import asyncio

async def manage_connection():
    # Documentation improvements for:
    # asyncio.open_connection(host, port, ...)
    # asyncio.start_server(client_connected_cb, host, port, ...)
    # asyncio.open_unix_connection(path, ...)
    # asyncio.start_unix_server(client_connected_cb, path, ...)

    # Example usage context:
    # server = await asyncio.start_server(handle_client, '127.0.0.1', 8888)
    # client_reader, client_writer = await asyncio.open_connection('127.0.0.1', 8888)
    pass
```

--------------------------------

### Create and Fill a Pad

Source: https://github.com/python/cpython/blob/main/Doc/howto/curses.rst

Illustrates the creation of a pad, which is a window that can be larger than the screen. This example shows how to create a pad and fill it with data using `addch`.

```python
pad = curses.newpad(100, 100)
# These loops fill the pad with letters; addch() is
# explained in the next section
for y in range(0, 99):
    for x in range(0, 99):
        pad.addch(y,x, ord('a') + (x*x+y*y) % 26)

# Displays a section of the pad in the middle of the screen.
# (0,0) : coordinate of upper-left corner of pad area to display.
```

--------------------------------

### Making a GET Request with urllib

Source: https://github.com/python/cpython/blob/main/Doc/howto/urllib2.rst

Illustrates how to construct a URL with encoded query parameters for a GET request using urllib.parse.urlencode and urllib.request.urlopen.

```APIDOC
## GET /example.cgi

### Description
Retrieves data from a specified URL using the HTTP GET method. Data is appended to the URL as query parameters.

### Method
GET

### Endpoint
/example.cgi

### Parameters
#### Query Parameters
- **name** (string) - The name parameter for the query.
- **location** (string) - The location parameter for the query.
- **language** (string) - The language parameter for the query.

#### Request Body
None

### Request Example
```python
import urllib.request
import urllib.parse

data = {}
data['name'] = 'Somebody Here'
data['location'] = 'Northampton'
data['language'] = 'Python'
url_values = urllib.parse.urlencode(data)
full_url = 'http://www.example.com/example.cgi' + '?' + url_values
response = urllib.request.urlopen(full_url)
```

### Response
#### Success Response (200)
- **response_body** (bytes) - The content of the response from the server.

#### Response Example
```python
# Example response content would be here
```
```

--------------------------------

### Python SQLite Database Creation and Data Insertion

Source: https://github.com/python/cpython/blob/main/Doc/howto/descriptor.rst

This snippet demonstrates how to create an in-memory SQLite database, define tables with indexes, and insert data using `executemany`. It shows table creation for 'Music' and 'Movies' and includes index creation.

```python
import sqlite3

conn = sqlite3.connect(':memory:')
conn.execute('CREATE TABLE Music (title text, artist text, year integer);')
conn.execute('CREATE INDEX MusicNdx ON Music (title);')
conn.executemany('INSERT INTO Music VALUES (?, ?, ?);', song_data)
conn.execute('CREATE TABLE Movies (title text, director text, year integer);')
conn.execute('CREATE INDEX MovieNdx ON Music (title);')
conn.executemany('INSERT INTO Movies VALUES (?, ?, ?);', movie_data)
conn.commit()
```

--------------------------------

### Python 3.9 Unparenthesized Generator Expression Syntax Error

Source: https://github.com/python/cpython/blob/main/Doc/whatsnew/3.10.rst

This example shows the `SyntaxError` raised in Python versions before 3.10 when a generator expression is used without parentheses within a function call. The error highlights only the starting point of the problematic expression.

```python
>>> foo(x, z for z in range(10), t, w)
  File "<stdin>", line 1
    foo(x, z for z in range(10), t, w)
               ^
SyntaxError: Generator expression must be parenthesized
```

--------------------------------

### logging.basicConfig Configuration Example (Python)

Source: https://github.com/python/cpython/blob/main/Doc/whatsnew/2.4.rst

Demonstrates how to configure basic logging in Python using logging.basicConfig. It shows setting the filename, logging level, and format for log messages.

```python
import logging
logging.basicConfig(filename='/var/log/application.log',
    level=0,  # Log all messages
    format='%(levelname):%(process):%(thread):%(message)')

```

--------------------------------

### Python Doctest Example Usage

Source: https://github.com/python/cpython/blob/main/Doc/library/doctest.rst

Demonstrates how doctest examples are structured within a Python docstring, including function calls and list comprehensions with expected outputs.

```python
__test__ = {
    'numbers': """
>>> factorial(6)
720

>>> [factorial(n) for n in range(6)]
[1, 1, 2, 6, 24, 120]
""
}
```

--------------------------------

### Configure Doctest Options and Reporting

Source: https://github.com/python/cpython/blob/main/Doc/library/doctest.rst

Explains how to set default doctest options using bitwise OR of individual flags and mentions a function for setting unittest reporting options. It details the purpose and usage of 'optionflags' and 'setUp'/'tearDown' arguments for test suite configuration.

```python
Optional argument *optionflags* specifies the default doctest options for the
   tests, created by or-ing together individual option flags.  See section
   :ref:`doctest-options`. See function :func:`set_unittest_reportflags` below
   for a better way to set reporting options.

   Optional argument *setUp* specifies a set-up function for the test suite.
   This is called before running the tests in each file.  The *setUp* function
   will be passed a :class:`DocTest` object.  The *setUp* function can access the
   test globals as the :attr:`~DocTest.globs` attribute of the test passed.

   Optional argument *tearDown* specifies a tear-down function for the test
   suite.  This is called after running the tests in each file.  The *tearDown*
   function will be passed a :class:`DocTest` object.  The *tearDown* function can
   access the test globals as the :attr:`~DocTest.globs` attribute of the test
   passed.
```

--------------------------------

### Approximate Internal Logic for Py_Main Function (C)

Source: https://github.com/python/cpython/blob/main/Doc/c-api/init.rst

This C code snippet illustrates the approximate internal steps `Py_Main` takes to initialize the Python interpreter, handle command-line arguments, and execute the main program. It uses the `PyConfig` API for configuration, sets command-line arguments, initializes the runtime, and then calls `Py_RunMain`.

```c
PyConfig config;
PyConfig_InitPythonConfig(&config);
PyConfig_SetArgv(&config, argc, argv);
Py_InitializeFromConfig(&config);
PyConfig_Clear(&config);

Py_RunMain();
```

--------------------------------

### Create and Bind a Server Socket (Python)

Source: https://github.com/python/cpython/blob/main/Doc/howto/sockets.rst

This snippet shows how to create an INET, STREAMing socket, bind it to a specific host and port, and then listen for incoming connections. This is the fundamental setup for a server application.

```python
# create an INET, STREAMing socket
serversocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
# bind the socket to a public host, and a well-known port
serversocket.bind((socket.gethostname(), 80))
# become a server socket
serversocket.listen(5)
```

--------------------------------

### Get slice indices (C, deprecated)

Source: https://github.com/python/cpython/blob/main/Doc/c-api/slice.rst

Retrieves start, stop, and step indices from a slice object for a sequence of a given length. Treats indices exceeding the length as errors. Returns 0 on success, -1 on error. This function is not recommended for use.

```c
int PySlice_GetIndices(PyObject *slice, Py_ssize_t length, Py_ssize_t *start, Py_ssize_t *stop, Py_ssize_t *step)
```

--------------------------------

### Create asyncio Server with List of Hosts

Source: https://github.com/python/cpython/blob/main/Doc/whatsnew/3.5.rst

Shows that the loop.create_server method can now accept a list of host addresses, allowing a server to listen on multiple network interfaces simultaneously.

```python
loop.create_server(handler, ['host1', 'host2'], port)
```

--------------------------------

### Sample Turtle Shell Session Output

Source: https://github.com/python/cpython/blob/main/Doc/library/cmd.rst

This section provides a sample interactive session with the Python turtle shell. It demonstrates the help functionality, basic turtle commands, and the record and playback feature, showing the output of commands and the state of the turtle.

```none
Welcome to the turtle shell.   Type help or ? to list commands.

(turtle) ?

Documented commands (type help <topic>):
========================================
bye     color    goto     home  playback  record  right
circle  forward  heading  left  position  reset   undo

(turtle) help forward
Move the turtle forward by the specified distance:  FORWARD 10
(turtle) record spiral.cmd
(turtle) position
Current position is 0 0

(turtle) heading
Current heading is 0

(turtle) reset
(turtle) circle 20
(turtle) right 30
(turtle) circle 40
(turtle) right 30
(turtle) circle 60
(turtle) right 30
(turtle) circle 80
(turtle) right 30
(turtle) circle 100
(turtle) right 30
(turtle) circle 120
(turtle) right 30
(turtle) circle 120
(turtle) heading
Current heading is 180

(turtle) forward 100
(turtle)
(turtle) right 90
(turtle) forward 100
(turtle)
(turtle) right 90
(turtle) forward 400
(turtle) right 90
(turtle) forward 500
(turtle) right 90
(turtle) forward 400
(turtle) right 90
(turtle) forward 300
(turtle) playback spiral.cmd
Current position is 0 0

Current heading is 0

Current heading is 180

(turtle) bye
Thank you for using Turtle

```

--------------------------------

### pathlib.Path.write_text() Example

Source: https://github.com/python/cpython/blob/main/Doc/whatsnew/3.5.rst

Illustrates the use of pathlib.Path.write_text() to create or overwrite a file with specified content. The example creates a file named '~/spam42' and writes 'ham' into it.

```python
>>> import pathlib
>>> p = pathlib.Path('~/spam42')
>>> p.expanduser().write_text('ham')
3
```

--------------------------------

### Asyncio Barrier wait example

Source: https://github.com/python/cpython/blob/main/Doc/library/asyncio-sync.rst

Provides an example of using an asyncio.Barrier with a specified number of parties, demonstrating how tasks can synchronize.

```python
async def example_barrier():
   # barrier with 3 parties
   b = asyncio.Barrier(3)
   
```

--------------------------------

### demo_app

Source: https://github.com/python/cpython/blob/main/Doc/library/wsgiref.rst

A simple WSGI application that returns a text page with 'Hello world!' and lists the environment variables.

```APIDOC
## demo_app

### Description
This function is a small but complete WSGI application that returns a text page containing the message "Hello world!" and a list of the key/value pairs provided in the *environ* parameter.

### Method
function

### Endpoint
N/A

### Parameters
#### Path Parameters
None

#### Query Parameters
None

#### Request Body
None

### Request Example
```python
def demo_app(environ, start_response):
    pass
```

### Response
#### Success Response (200)
N/A

#### Response Example
N/A
```

--------------------------------

### Get slice indices with length (C)

Source: https://github.com/python/cpython/blob/main/Doc/c-api/slice.rst

A replacement for PySlice_GetIndices, this function retrieves start, stop, and step indices, and also calculates the slice length. Out-of-bounds indices are clipped consistently with normal slices. Returns 0 on success, -1 on error with an exception set.

```c
int PySlice_GetIndicesEx(PyObject *slice, Py_ssize_t length, Py_ssize_t *start, Py_ssize_t *stop, Py_ssize_t *step, Py_ssize_t *slicelength)
```

--------------------------------

### Verbose output of failing doctest examples

Source: https://github.com/python/cpython/blob/main/Doc/library/doctest.rst

Illustrates the detailed output produced by doctest when the '-v' flag is used, showing which examples are being tried, what is expected, and the result (e.g., 'ok' or failure details).

```shell
$ python example.py -v
Trying:
    factorial(5)
Expecting:
    120
ok
Trying:
    [factorial(n) for n in range(6)]
Expecting:
    [1, 1, 2, 6, 24, 120]
ok

And so on, eventually ending with:

Trying:
    factorial(1e100)
Expecting:
    Traceback (most recent call last):
        ...
    OverflowError: n too large
ok
2 items passed all tests:
   1 test in __main__
   6 tests in __main__.factorial
7 tests in 2 items.
7 passed.
Test passed.
$
```

--------------------------------

### Update Windows installer to SQLite 3.40.1 (Windows)

Source: https://github.com/python/cpython/blob/main/Misc/NEWS.d/3.12.0a6.rst

Updates the SQLite library used by the Windows installer to version 3.40.1. This ensures that the installer benefits from the latest features and bug fixes in SQLite.

```installer
.. 

.. date: 2023-02-09-22:09:27
.. gh-issue: 101759
.. nonce: zFlqSH
.. section: Windows

Update Windows installer to SQLite 3.40.1.

..
```

--------------------------------

### Run turtledemo from command-line

Source: https://github.com/python/cpython/blob/main/Doc/whatsnew/3.2.rst

Demonstrates how to run the turtle module's demonstration scripts directly from the command line. This requires the demo code to be accessible via sys.path.

```shell
$ python -m turtledemo
```

--------------------------------

### Subparsers Example

Source: https://github.com/python/cpython/blob/main/Doc/library/argparse.rst

Demonstrates how to use subparsers to handle different command-line actions, including setting default functions and handling deprecated commands.

```APIDOC
## POST /api/users

### Description
This endpoint allows for the creation of new user resources.

### Method
POST

### Endpoint
/api/users

### Parameters
#### Request Body
- **username** (string) - Required - The desired username for the new user.
- **email** (string) - Required - The email address of the new user.
- **password** (string) - Required - The password for the new user.

### Request Example
```json
{
  "username": "johndoe",
  "email": "john.doe@example.com",
  "password": "securepassword123"
}
```

### Response
#### Success Response (201)
- **id** (integer) - The unique identifier for the newly created user.
- **username** (string) - The username of the created user.
- **email** (string) - The email address of the created user.

#### Response Example
```json
{
  "id": 1,
  "username": "johndoe",
  "email": "john.doe@example.com"
}
```
```

--------------------------------

### Python 'match' Statement Example

Source: https://github.com/python/cpython/blob/main/Doc/reference/compound_stmts.rst

Provides a practical example of the 'match' statement, showing how it matches against different patterns and handles guards.

```python
>>> flag = False
>>> match (100, 200):
...    case (100, 300):  # Mismatch: 200 != 300
...        print('Case 1')
...    case (100, 200) if flag:  # Successful match, but guard fails
...        print('Case 2')
...    case (100, y):  # Matches and binds y to 200
...        print(f'Case 3, y: {y}')
```

--------------------------------

### Create GitHub Actions workflow for pip/setuptools verification

Source: https://github.com/python/cpython/blob/main/Misc/NEWS.d/3.12.0a1.rst

Introduces a GitHub Actions workflow to verify bundled pip and setuptools in CPython releases.

```yaml
name: Verify Bundled Pip and Setuptools

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    - name: Set up Python
      uses: actions/setup-python@v3
      with:
        python-version: '3.10'
    - name: Install dependencies
      run: |
        python -m pip install --upgrade pip
        pip install build
    - name: Build python package
      run: python -m build --sdist --wheel --outdir dist/
    - name: Verify pip and setuptools
      run: |
        python -m pip show pip
        python -m pip show setuptools
```

--------------------------------

### Python install() function for installing translations

Source: https://github.com/python/cpython/blob/main/Doc/library/gettext.rst

Installs the '_' function into Python's builtins namespace. It uses the domain and localedir to find translations via the translation() function. The names parameter is used for the translation object's install method.

```python
def install(domain, localedir=None, *, names=None):
    """
    This installs the function :func:`!_` in Python's builtins namespace, based on
    *domain* and *localedir* which are passed to the function :func:`translation`.

    For the *names* parameter, please see the description of the translation
    object's :meth:`~NullTranslations.install` method.

    As seen below, you usually mark the strings in your application that are
    candidates for translation, by wrapping them in a call to the :func:`!_`
    function, like this::

       print(_('This string will be translated.'))

    For convenience, you want the :func:`!_` function to be installed in Python's
    builtins namespace, so it is easily accessible in all modules of your
    application.
    """
    pass
```

--------------------------------

### UUID Generation Examples

Source: https://github.com/python/cpython/blob/main/Doc/library/uuid.rst

Examples demonstrating how to use the `uuid` module functions for different UUID generation methods.

```APIDOC
## UUID Generation Examples

### Description
Illustrates various ways to generate UUIDs using the `uuid` module functions.

### Examples

```python
import uuid

# Generate a UUID based on host ID and current time (UUIDv1)
# uuid.uuid1() # doctest: +SKIP

# Generate a UUID using MD5 hash of a namespace and name (UUIDv3)
# uuid.uuid3(uuid.NAMESPACE_DNS, 'python.org')

# Generate a random UUID (UUIDv4)
# uuid.uuid4()

# Generate a UUID using SHA-1 hash of a namespace and name (UUIDv5)
# uuid.uuid5(uuid.NAMESPACE_DNS, 'python.org')

# Create a UUID from a hex string
# x = uuid.UUID('{00010203-0405-0607-0809-0a0b0c0d0e0f}')

# Convert UUID to string
# str(x)

# Get raw bytes of a UUID
# x.bytes

# Create a UUID from bytes
# uuid.UUID(bytes=x.bytes)

# Get the Nil UUID
# uuid.NIL

# Get the Max UUID
# uuid.MAX

# Generate a UUIDv6 (reordered fields for DB locality)
# uuid.uuid6() # doctest: +SKIP

# Get UUIDv7 creation time (milliseconds)
# u = uuid.uuid7()
# u.time # doctest: +SKIP

# Make a UUID with custom blocks (UUIDv8)
# uuid.uuid8(0x12345678, 0x9abcdef0, 0x11223344)
```
```

--------------------------------

### Nested Groups and Accessing Subgroup Information in Python Regex

Source: https://github.com/python/cpython/blob/main/Doc/howto/regex.rst

Demonstrates how regular expressions can contain nested groups. The numbering of groups starts from 1 and is determined by counting the opening parentheses from left to right. This example shows accessing nested group values.

```python
>>> p = re.compile('(a(b)c)d')
>>> m = p.match('abcd')
>>> m.group(0)
'abcd'
>>> m.group(1)
'abc'
>>> m.group(2)
'b'
```

--------------------------------

### Python Installation Directories

Source: https://github.com/python/cpython/blob/main/Doc/using/windows.rst

Specifies the default installation directories for Python. 'DefaultJustForMeTargetDir' is used for user-specific installations, pointing to common locations within the user's AppData. 'DefaultCustomTargetDir' is the default shown in the UI but is empty in this configuration.

```text
DefaultJustForMeTargetDir: %LocalAppData%\Programs\Python\PythonXY` or %LocalAppData%\Programs\Python\PythonXY-32` or %LocalAppData%\Programs\Python\PythonXY-64`
DefaultCustomTargetDir: (empty)
```

--------------------------------

### Useful Macros in Python/C API

Source: https://github.com/python/cpython/blob/main/Doc/c-api/intro.rst

Highlights of commonly used macros provided by the Python/C API header files.

```APIDOC
## Useful Macros in Python/C API

### Description
The Python header files define several macros to aid in C API usage. Some are defined near their context, while others are of general utility.

### Example Macro: `Py_ABS(x)`

#### Description
Returns the absolute value of `x`.

#### Version Added
3.3

#### Usage
```c
PyObject* abs_value(PyObject* self, PyObject* args) {
    long val;
    if (!PyArg_ParseTuple(args, "l", &val)) {
        return NULL;
    }
    return PyLong_FromLong(Py_ABS(val));
}
```
```

--------------------------------

### Python Dictionary and Set Literal Examples

Source: https://github.com/python/cpython/blob/main/Lib/test/test_ast/data/ast_repr.txt

Shows AST nodes for dictionary and set literals, including those with starred elements.

```python
Module(body=[Expr(value=Dict(keys=[None, Constant(...)], values=[Dict(...), Constant(...)]))], type_ignores=[])
```

```python
Module(body=[Expr(value=Set(elts=[Starred(...), Constant(...)]))], type_ignores=[])
```

--------------------------------

### Use threading_setup and threading_cleanup in test_thread

Source: https://github.com/python/cpython/blob/main/Misc/NEWS.d/3.7.0a1.rst

Updates `test_thread`'s `setUp()` method to use `support.threading_setup()` and `support.threading_cleanup()`. This ensures that threads complete before subsequent tests, preventing random side effects.

```python
test_thread: setUp() now uses support.threading_setup() and
support.threading_cleanup() to wait until threads complete to avoid random
side effects on following tests.
```

--------------------------------

### DocTest Object Definition

Source: https://github.com/python/cpython/blob/main/Doc/library/doctest.rst

Represents a collection of doctest examples to be run in a single namespace. It holds examples, the global namespace, name, filename, line number, and the original docstring.

```python
class DocTest:
    """A collection of doctest examples that should be run in a single namespace."""
    def __init__(self, examples, globs, name, filename, lineno, docstring):
        self.examples = examples
        self.globs = globs
        self.name = name
        self.filename = filename
        self.lineno = lineno
        self.docstring = docstring
```

--------------------------------

### Python: Assert Not Starts With

Source: https://github.com/python/cpython/blob/main/Doc/library/unittest.rst

Asserts that a string does NOT start with a specified prefix. Checks for the absence of a starting substring.

```python
self.assertNotStartsWith(a, b)
```

--------------------------------

### Iterating over usable hosts in an IPv4 network

Source: https://github.com/python/cpython/blob/main/Doc/library/ipaddress.rst

Demonstrates how to use the hosts() method to get an iterator of usable IP addresses within a given IPv4 network. It shows examples for different prefix lengths, including /29, /31, and /32.

```python
>>> list(ip_network('192.0.2.0/29').hosts())  #doctest: +NORMALIZE_WHITESPACE
         [IPv4Address('192.0.2.1'), IPv4Address('192.0.2.2'),
          IPv4Address('192.0.2.3'), IPv4Address('192.0.2.4'),
          IPv4Address('192.0.2.5'), IPv4Address('192.0.2.6')]
         >>> list(ip_network('192.0.2.0/31').hosts())
         [IPv4Address('192.0.2.0'), IPv4Address('192.0.2.1')]
         >>> list(ip_network('192.0.2.1/32').hosts())
         [IPv4Address('192.0.2.1')]
```

--------------------------------

### Get Object Source Lines (Python)

Source: https://github.com/python/cpython/blob/main/Doc/library/inspect.rst

Returns a list of source code lines and the starting line number for a given object. Supports modules, classes, methods, functions, tracebacks, frames, or code objects. Raises OSError if source code cannot be retrieved and TypeError for built-in objects.

```python
import inspect

def another_function(x, y):
    # This is a comment
    result = x + y
    return result

lines, start_line = inspect.getsourcelines(another_function)
print(f"Source lines starting at line {start_line}:")
for line in lines:
    print(line.rstrip())

```

--------------------------------

### Python: Custom LogRecord Factory Example

Source: https://github.com/python/cpython/blob/main/Doc/library/logging.rst

Demonstrates how to create a custom factory to modify LogRecord instances during creation. This allows for injecting custom attributes like a unique identifier or other metadata into every log record. It shows the pattern of getting the old factory, defining a new one, and setting it.

```python
import logging

# Get the existing LogRecord factory
old_factory = logging.getLogRecordFactory()

# Define a new factory function
def record_factory(*args, **kwargs):
    record = old_factory(*args, **kwargs)
    # Add a custom attribute to the LogRecord
    record.custom_attribute = 0xdecafbad
    return record

# Set the new factory
logging.setLogRecordFactory(record_factory)

# Example usage (assuming a logger is configured)
# logger = logging.getLogger(__name__)
# logger.info('This is a test message.')

# To revert to the default factory:
# logging.setLogRecordFactory(logging.LogRecord)
```

--------------------------------

### Installer PATH Option (Windows)

Source: https://github.com/python/cpython/blob/main/Misc/NEWS.d/3.11.0a5.rst

The Windows installer now includes a command-line option to add the installation directory to the end of the PATH environment variable, rather than the default behavior of adding it to the beginning.

```Windows
The installer now offers a command-line only option to add the installation
directory to the end of :envvar:`PATH` instead of at the start.
```

--------------------------------

### Change Display Attributes with chgat in Python curses module

Source: https://github.com/python/cpython/blob/main/Doc/whatsnew/2.6.rst

Shows how to use the `chgat` method within the `curses` module to modify the display attributes of characters on a specific line of the terminal. This example applies boldface formatting to text starting at a given coordinate and extending to the end of the line.

```python
# Boldface text starting at y=0,x=21
# and affecting the rest of the line.
stdscr.chgat(0, 21, curses.A_BOLD)
```

--------------------------------

### Capturing Groups and Accessing Match Information in Python Regex

Source: https://github.com/python/cpython/blob/main/Doc/howto/regex.rst

Explains how groups marked by '(' and ')' capture substrings and store their start and end indices. This example shows accessing the entire match (group 0) and specific captured groups using match object methods.

```python
>>> p = re.compile('(a)b')
>>> m = p.match('ab')
>>> m.group()
'ab'
>>> m.group(0)
'ab'
```

--------------------------------

### Get Inner Frames (Python)

Source: https://github.com/python/cpython/blob/main/Doc/library/inspect.rst

Retrieves a list of FrameInfo objects for a traceback's frame and all inner frames, representing calls made as a consequence of the frame. The list starts with the traceback's frame and ends where the exception was raised. Previously returned named tuples, now returns `FrameInfo` objects.

```python
import traceback

try:
    1/0
except ZeroDivisionError:
    exc_type, exc_value, tb = sys.exc_info()
    inner_frames = traceback.getinnerframes(tb)
    for frame_info in inner_frames:
        print(f"File: {frame_info.filename}, Line: {frame_info.lineno}, Function: {frame_info.function}")
```

--------------------------------

### Upgrade Existing Module

Source: https://github.com/python/cpython/blob/main/Doc/installing/index.rst

Explicitly requests an upgrade for an already installed module to the latest available version. If a suitable module is already installed, a regular install command will have no effect.

```bash
python -m pip install --upgrade SomePackage
```

--------------------------------

### Install Packages for Current User with Pip

Source: https://github.com/python/cpython/blob/main/Doc/installing/index.rst

Installs a Python package specifically for the current user, rather than system-wide. This is useful for avoiding permission issues or when you don't have administrative privileges.

```python
python -m pip install --user SomePackage
```

--------------------------------

### Install Coverage Package

Source: https://github.com/python/cpython/blob/main/Lib/idlelib/idle_test/README.txt

Install the 'coverage' package using pip for test coverage analysis. The command may vary slightly depending on the Python installation and operating system.

```bash
python3 -m pip install coverage
```

--------------------------------

### Full Python Logging Example

Source: https://github.com/python/cpython/blob/main/Doc/howto/logging-cookbook.rst

This comprehensive Python script combines the JSON configuration for logging with a custom filter factory function. It demonstrates how to load the configuration and set up logging handlers for different output streams based on severity.

```python
import json
import logging
import logging.config

CONFIG = '''
{
    "version": 1,
    "disable_existing_loggers": false,
    "formatters": {
        "simple": {
            "format": "% (levelname) -8s - % (message)s"
        }
    },
    "filters": {
        "warnings_and_below": {
            "()" : "__main__.filter_maker",
            "level": "WARNING"
        }
    },
    "handlers": {
        "stdout": {
            "class": "logging.StreamHandler",
            "level": "INFO",

```

--------------------------------

### Get Python Configuration Variables

Source: https://github.com/python/cpython/blob/main/Doc/library/sysconfig.rst

Retrieves configuration variables relevant to the current platform. It can return all variables as a dictionary or specific values based on provided arguments. If a requested variable is not found, it returns None. This function is essential for understanding the build and installation environment of Python.

```python
import sysconfig

# Get all configuration variables
all_vars = sysconfig.get_config_vars()
print(all_vars)

# Get a single configuration variable
libdir = sysconfig.get_config_var('LIBDIR')
print(f"LIBDIR: {libdir}")

# Get multiple configuration variables
build_vars = sysconfig.get_config_vars('AR', 'CXX')
print(f"Build variables: {build_vars}")

# Example of a non-existent variable
non_existent = sysconfig.get_config_var('NON_EXISTENT_VAR')
print(f"Non-existent variable: {non_existent}")
```

--------------------------------

### Ensure Pip is Installed and Up-to-Date

Source: https://github.com/python/cpython/blob/main/Doc/installing/index.rst

Ensures that pip is installed and up-to-date for the current Python environment. This command is a common fix if pip is missing or not functioning correctly.

```python
python -m ensurepip --default-pip
```

--------------------------------

### Emulating C Structure Members with Python Descriptors

Source: https://github.com/python/cpython/blob/main/Doc/howto/descriptor.rst

This code defines a `Member` class that acts as a descriptor to emulate the behavior of C structure members (`PyMemberDef`) used with Python's `__slots__`. It handles attribute getting, setting, deletion, and representation, managing values stored in a private list mimicking C memory.

```python
null = object()

class Member:

    def __init__(self, name, clsname, offset):
        'Emulate PyMemberDef in Include/structmember.h'
        # Also see descr_new() in Objects/descrobject.c
        self.name = name
        self.clsname = clsname
        self.offset = offset

    def __get__(self, obj, objtype=None):
        'Emulate member_get() in Objects/descrobject.c'
        # Also see PyMember_GetOne() in Python/structmember.c
        if obj is None:
            return self
        value = obj._slotvalues[self.offset]
        if value is null:
            raise AttributeError(self.name)
        return value

    def __set__(self, obj, value):
        'Emulate member_set() in Objects/descrobject.c'
        obj._slotvalues[self.offset] = value

    def __delete__(self, obj):
        'Emulate member_delete() in Objects/descrobject.c'
        value = obj._slotvalues[self.offset]
        if value is null:
            raise AttributeError(self.name)
        obj._slotvalues[self.offset] = null

    def __repr__(self):
        'Emulate member_repr() in Objects/descrobject.c'
        return f'<Member {self.name!r} of {self.clsname!r}>'
```

--------------------------------

### Start Network Listener for Logging Configurations

Source: https://github.com/python/cpython/blob/main/Doc/library/logging.config.rst

Starts a socket server to listen for logging configurations. Configurations are sent as files for dictConfig or fileConfig. Accepts an optional 'verify' callable for security validation. Returns a threading.Thread instance.

```python
logging.config.listen(port=DEFAULT_LOGGING_CONFIG_PORT, verify=None)
```

--------------------------------

### Update macOS installer to SQLite 3.40.1 (macOS)

Source: https://github.com/python/cpython/blob/main/Misc/NEWS.d/3.12.0a6.rst

Updates the SQLite library used by the macOS installer to version 3.40.1. This ensures that the installer benefits from the latest features and bug fixes in SQLite.

```installer
.. 

.. date: 2023-02-09-22:07:17
.. gh-issue: 101759
.. nonce: B0JP2H
.. section: macOS

Update macOS installer to SQLite 3.40.1.

..
```

--------------------------------

### Installation Path Prefix (sys.prefix)

Source: https://github.com/python/cpython/blob/main/Doc/library/sys.rst

Indicates the installation directory prefix for platform-independent Python files.

```APIDOC
## sys.prefix

### Description
Directory prefix where platform-independent Python files are installed.

### Method
N/A (Attribute)

### Endpoint
N/A (Internal Module Attribute)

### Parameters
None

### Request Example
None

### Response
#### Success Response (N/A)
- **sys.prefix** (str) - The path to the installation prefix.

#### Response Example
```
'/usr/local'
```

### Notes
- On Unix systems, the default is often ``/usr/local``.
- When a virtual environment is active, this points to the virtual environment's prefix.
- The `exec_prefix` attribute provides the path for platform-dependent files.
```

--------------------------------

### ZoneInfo Initialization Example

Source: https://github.com/python/cpython/blob/main/Doc/library/zoneinfo.rst

Demonstrates that ZoneInfo objects created with the same key are identical, provided the cache is not invalidated. This highlights the caching mechanism.

```python
a = ZoneInfo(key)
        b = ZoneInfo(key)
        assert a is b
```

--------------------------------

### ThreadPoolExecutor: Load URLs Example

Source: https://github.com/python/cpython/blob/main/Doc/library/concurrent.futures.rst

An example of using ThreadPoolExecutor to concurrently download web pages from a list of URLs. It shows how to submit tasks, associate futures with data, and handle exceptions.

```python
import concurrent.futures
import urllib.request

URLS = ['http://www.foxnews.com/',
        'http://www.cnn.com/',
        'http://europe.wsj.com/',
        'http://www.bbc.co.uk/',
        'http://nonexistent-subdomain.python.org/']

# Retrieve a single page and report the URL and contents
def load_url(url, timeout):
    with urllib.request.urlopen(url, timeout=timeout) as conn:
        return conn.read()

# We can use a with statement to ensure threads are cleaned up promptly
with concurrent.futures.ThreadPoolExecutor(max_workers=5) as executor:
    # Start the load operations and mark each future with its URL
    future_to_url = {executor.submit(load_url, url, 60): url for url in URLS}
    for future in concurrent.futures.as_completed(future_to_url):
        url = future_to_url[future]
        try:
            data = future.result()
        except Exception as exc:
            print('%r generated an exception: %s' % (url, exc))
        else:
            print('%r page is %d bytes' % (url, len(data)))
```

--------------------------------

### Python unittest basic example

Source: https://github.com/python/cpython/blob/main/Doc/library/unittest.rst

A basic example demonstrating how to create and run tests using Python's unittest module. It includes tests for string methods like upper(), isupper(), and split(), along with assertions for expected results and exceptions.

```python
import unittest

class TestStringMethods(unittest.TestCase):

    def test_upper(self):
        self.assertEqual('foo'.upper(), 'FOO')

    def test_isupper(self):
        self.assertTrue('FOO'.isupper())
        self.assertFalse('Foo'.isupper())

    def test_split(self):
        s = 'hello world'
        self.assertEqual(s.split(), ['hello', 'world'])
        # check that s.split fails when the separator is not a string
        with self.assertRaises(TypeError):
            s.split(2)

if __name__ == '__main__':
    unittest.main()
```

--------------------------------

### Command Line Installation Option for Free-threaded Binaries

Source: https://github.com/python/cpython/blob/main/Doc/using/windows.rst

This command-line argument is used to include free-threaded binaries during Python installation. It is part of the customization options for advanced users.

```bash
Include_freethreaded=1
```

--------------------------------

### Shutil copytree Example

Source: https://github.com/python/cpython/blob/main/Doc/library/shutil.rst

Provides examples of using shutil.copytree with ignore_patterns and a custom ignore callback.

```APIDOC
## Shutil copytree Example

### Description
Illustrates how to use the `shutil.copytree` function with the `ignore` argument. Examples include using `ignore_patterns` to exclude specific file types or prefixes, and providing a custom logging callback function.

### Method
N/A (Example usage of a function)

### Endpoint
N/A (Example usage of a function)

### Parameters
N/A

### Request Example
```python
from shutil import copytree, ignore_patterns

copytree(source, destination, ignore=ignore_patterns('*.pyc', 'tmp*'))

import logging

def _logpath(path, names):
    logging.info('Working in %s', path)
    return []   # nothing will be ignored

copytree(source, destination, ignore=_logpath)
```

### Response
N/A

#### Response Example
N/A
```

--------------------------------

### Start Method Configuration

Source: https://github.com/python/cpython/blob/main/Doc/library/multiprocessing.rst

Functions for retrieving and setting the multiprocessing start method.

```APIDOC
## get_all_start_methods()

### Description
Returns a list of the supported start methods, the first of which is the default. The possible start methods are ``'fork'``, ``'spawn'`` and ``'forkserver'``. Not all platforms support all methods.

### Method
GET

### Endpoint
/start_method/all

### Response
#### Success Response (200)
- **methods** (array) - A list of supported start method names.

#### Response Example
{
  "methods": ["spawn", "fork", "forkserver"]
}

## get_context(method=None)

### Description
Return a context object which has the same attributes as the :mod:`multiprocessing` module. If *method* is ``None`` then the default context is returned. Otherwise *method* should be ``'fork'``, ``'spawn'``, ``'forkserver'``. :exc:`ValueError` is raised if the specified start method is not available.

### Method
GET

### Endpoint
/start_method/context

### Parameters
#### Query Parameters
- **method** (string) - Optional - The desired start method ('fork', 'spawn', 'forkserver').

### Response
#### Success Response (200)
- **context** (object) - A context object with multiprocessing attributes.

#### Response Example
{
  "context": {"method": "spawn"}
}

## get_start_method(allow_none=False)

### Description
Return the name of start method used for starting processes. If the global start method has not been set and *allow_none* is ``False``, then the start method is set to the default and the name is returned. If the start method has not been set and *allow_none* is ``True`` then ``None`` is returned. The return value can be ``'fork'``, ``'spawn'``, ``'forkserver'`` or ``None``.

### Method
GET

### Endpoint
/start_method/current

### Parameters
#### Query Parameters
- **allow_none** (boolean) - Optional - Whether to return None if the start method is not set.

### Response
#### Success Response (200)
- **method** (string or null) - The name of the current start method.

#### Response Example
{
  "method": "spawn"
}

## set_executable(executable)

### Description
Set the path of the Python interpreter to use when starting a child process. (By default :data:`sys.executable` is used). Embedders will probably need to do some thing like ``set_executable(os.path.join(sys.exec_prefix, 'pythonw.exe'))`` before they can create child processes.

### Method
PUT

### Endpoint
/start_method/executable

### Parameters
#### Request Body
- **executable** (string) - Required - The path to the Python interpreter executable.

### Request Example
{
  "executable": "/usr/bin/python3"
}

### Response
#### Success Response (200)
- **message** (string) - Indicates the executable path has been set.

#### Response Example
{
  "message": "Executable path set successfully"
}

## set_forkserver_preload(module_names)

### Description
Set a list of module names for the forkserver main process to attempt to preload.

### Method
PUT

### Endpoint
/start_method/forkserver_preload

### Parameters
#### Request Body
- **module_names** (array of strings) - Required - A list of module names to preload.

### Request Example
{
  "module_names": ["os", "sys"]
}

### Response
#### Success Response (200)
- **message** (string) - Indicates preload modules have been set.

#### Response Example
{
  "message": "Preload modules set for forkserver"
}
```

--------------------------------

### Python Initialization and Finalization

Source: https://github.com/python/cpython/blob/main/Doc/c-api/intro.rst

Details on initializing and finalizing the Python interpreter using C API functions.

```APIDOC
## Initialization and Finalization

### Description
This section describes the core functions for managing the Python interpreter's lifecycle within an embedding application, including initialization and finalization.

### Functions

- **Py_Initialize**: Initializes the Python interpreter, including the module table, fundamental modules (builtins, __main__, sys), and the module search path.
- **Py_InitializeFromConfig**: Initializes the Python interpreter using a configuration structure. Allows setting program name to influence module search.
- **Py_IsInitialized**: Returns true if the Python interpreter is currently initialized.
- **Py_FinalizeEx**: Uninitializes the Python interpreter, freeing allocated memory. Note that memory allocated by extension modules may not be released.

### Configuration for Initialization

- **PyConfig.argv**: Argument list for the Python interpreter. Must be set if `sys.argv` is needed.
- **PyConfig.parse_argv**: Flag to indicate if `sys.argv` should be parsed.
- **PyConfig.program_name**: Name of the program, used to determine the module search path.
```

--------------------------------

### Timing custom function using setup (Python)

Source: https://github.com/python/cpython/blob/main/Doc/library/timeit.rst

Demonstrates how to time a custom function defined in the main script by importing it into the timeit environment using the setup parameter.

```python
def test():
    """Stupid test function"""
    L = [i for i in range(100)]

if __name__ == '__main__':
    import timeit
    print(timeit.timeit("test()", setup="from __main__ import test"))
```

--------------------------------

### Install a Package using pip

Source: https://github.com/python/cpython/blob/main/Doc/tutorial/venv.rst

Installs the latest version of a specified package from the Python Package Index (PyPI) into the active virtual environment.

```console
(tutorial-env) $ python -m pip install novas
```

--------------------------------

### Start Debugger Trace

Source: https://github.com/python/cpython/blob/main/Doc/library/bdb.rst

Initiate a debugging session using a Bdb instance starting from the caller's frame.

```python
set_trace()
    Start debugging with a :class:`Bdb` instance from caller's frame.
```

--------------------------------

### Add --with-wheel-pkg-dir option to configure script

Source: https://github.com/python/cpython/blob/main/Misc/NEWS.d/3.10.0a5.rst

Introduces the `--with-wheel-pkg-dir=PATH` option to the `./configure` script. This allows `ensurepip` to locate `setuptools` and `pip` wheel packages from a specified directory, supporting packaging policies that avoid bundling dependencies.

```Shell
# Example of using the new option:
# ./configure --with-wheel-pkg-dir=/usr/share/python-wheels/

# This affects how ensurepip finds wheels, potentially skipping bundled ones.
```

--------------------------------

### Python Comments

Source: https://github.com/python/cpython/blob/main/Doc/tutorial/introduction.rst

Demonstrates how to write comments in Python, which start with '#' and extend to the end of the line. Comments are ignored by the interpreter.

```Python
# this is the first comment
spam = 1  # and this is the second comment
          # ... and now a third!
text = "# This is not a comment because it's inside quotes."
```

--------------------------------

### Main Application Setup for Contextual Logging (Python)

Source: https://github.com/python/cpython/blob/main/Doc/howto/logging-cookbook.rst

This Python code sets up a multi-threaded application simulation. It defines a Request class, sample requests, context variables for request details and app name, a custom logging formatter, and an InjectingFilter to add context to log records.

```python
# main.py
import argparse
from contextvars import ContextVar
import logging
import os
from random import choice
import threading
import webapplib

logger = logging.getLogger(__name__)
root = logging.getLogger()
root.setLevel(logging.DEBUG)

class Request:
    """
    A simple dummy request class which just holds dummy HTTP request method,
    client IP address and client username
    """
    def __init__(self, method, ip, user):
        self.method = method
        self.ip = ip
        self.user = user

# Note that the format string includes references to request context information
# such as HTTP method, client IP and username

formatter = logging.Formatter('%(threadName)-11s %(appName)s %(name)-9s %(user)-6s %(ip)s %(method)-4s %(message)s')

# Create our context variables. These will be filled at the start of request
# processing, and used in the logging that happens during that processing

ctx_request = ContextVar('request')
ctx_appname = ContextVar('appname')

class InjectingFilter(logging.Filter):
    """
    A filter which injects context-specific information into logs and ensures
    that only information for a specific webapp is included in its log
    """
    def __init__(self, app):
        self.app = app

    def filter(self, record):
        request = ctx_request.get()
        record.method = request.method
        record.ip = request.ip
        record.user = request.user
        return True
```

--------------------------------

### Python Lambda Function Example

Source: https://github.com/python/cpython/blob/main/Doc/tutorial/controlflow.rst

Demonstrates creating and using lambda functions for simple operations and as arguments to other functions like sort.

```python
>>> def make_incrementor(n):
...     return lambda x: x + n
...
>>> f = make_incrementor(42)
>>> f(0)
42
>>> f(1)
43
```

```python
>>> pairs = [(1, 'one'), (2, 'two'), (3, 'three'), (4, 'four')]
>>> pairs.sort(key=lambda pair: pair[1])
>>> pairs
[(4, 'four'), (1, 'one'), (3, 'three'), (2, 'two')]
```

--------------------------------

### Create and Run a WSGI Server using make_server

Source: https://github.com/python/cpython/blob/main/Doc/library/wsgiref.rst

Creates a WSGI server instance that listens on a specified host and port, serving a given WSGI application. It supports running the server indefinitely or handling a single request.

```python
from wsgiref.simple_server import make_server, demo_app

with make_server('', 8000, demo_app) as httpd:
    print("Serving HTTP on port 8000...")

    # Respond to requests until process is killed
    httpd.serve_forever()

    # Alternative: serve one request, then exit
    # httpd.handle_request()
```

--------------------------------

### Python Calltip Example

Source: https://github.com/python/cpython/blob/main/Doc/library/idle.rst

Illustrates how calltips are displayed for Python functions, showing the function signature and docstring. It uses `itertools.count` as an example of a function that triggers a calltip.

```python
import itertools

# When typing 'itertools.count(', a calltip should appear.
itertools.count(
```

--------------------------------

### Python str.format(): Combined Arguments

Source: https://github.com/python/cpython/blob/main/Doc/tutorial/inputoutput.rst

Demonstrates the ability to arbitrarily combine positional and keyword arguments within the str.format() method, offering flexibility in how data is inserted into strings.

```python
>>> print('The story of {0}, {1}, and {other}.'.format('Bill', 'Manfred',
...                                                    other='Georg'))
The story of Bill, Manfred, and Georg.
```

--------------------------------

### Iterate Over Python sqlite3 Cursor for SELECT Results

Source: https://github.com/python/cpython/blob/main/Doc/library/sqlite3.rst

This example demonstrates how `Cursor` objects in Python's `sqlite3` module can be directly iterated over to fetch rows from a `SELECT` query. The setup code initializes an in-memory SQLite database and inserts a sample row, which is then retrieved and printed by the iteration.

```python
import sqlite3
con = sqlite3.connect(":memory:", isolation_level=None)
cur = con.execute("CREATE TABLE data(t)")
cur.execute("INSERT INTO data VALUES(1)")
for row in cur.execute("SELECT t FROM data"):
    print(row)
```

--------------------------------

### Install Package with Free-threaded Python

Source: https://github.com/python/cpython/blob/main/Doc/using/mac.rst

Command to install a Python package using the free-threaded interpreter without a virtual environment. This ensures the package is installed specifically for the free-threaded build.

```python
python |version| t -m pip install <package_name>
```

--------------------------------

### Seeking and reading in binary files in Python

Source: https://github.com/python/cpython/blob/main/Doc/tutorial/inputoutput.rst

Demonstrates changing the file position using `seek()` with different `whence` values (0, 1, 2) and reading data. Primarily for binary files.

```python
>>> f = open('workfile', 'rb+')
>>> f.write(b'0123456789abcdef')
16
>>> f.seek(5)      # Go to the 6th byte in the file
5
>>> f.read(1)
b'5'
>>> f.seek(-3, 2)  # Go to the 3rd byte before the end
13
>>> f.read(1)
b'd'
```

--------------------------------

### Update macOS Installer to SQLite 3.41.2

Source: https://github.com/python/cpython/blob/main/Misc/NEWS.d/3.12.0b1.rst

Updates the macOS installer to utilize SQLite version 3.41.2. This is a maintenance update for the installer.

```Unknown
.. date: 2023-03-24-11-20-47
.. gh-issue: 102997
.. nonce: ZgQkbq
.. section: macOS

Update macOS installer to SQLite 3.41.2.

..
```

--------------------------------

### Option Actions and Implementation

Source: https://github.com/python/cpython/blob/main/Doc/library/optparse.rst

Details on how to categorize and implement new actions for the Option class.

```APIDOC
## Option Actions and Implementation

### Description
This section describes how to extend the `Option` class by defining new actions and overriding the `take_action` method. It also explains the roles of `ACTIONS`, `STORE_ACTIONS`, `TYPED_ACTIONS`, and `ALWAYS_TYPED_ACTIONS` attributes.

### Custom Action Example: "extend"

```python
class MyOption(Option):

    ACTIONS = Option.ACTIONS + ("extend",)
    STORE_ACTIONS = Option.STORE_ACTIONS + ("extend",)
    TYPED_ACTIONS = Option.TYPED_ACTIONS + ("extend",)
    ALWAYS_TYPED_ACTIONS = Option.ALWAYS_TYPED_ACTIONS + ("extend",)

    def take_action(self, action, dest, opt, value, values, parser):
        if action == "extend":
            lvalue = value.split(",")
            values.ensure_value(dest, []).extend(lvalue)
        else:
            Option.take_action(
                self, action, dest, opt, value, values, parser)
```

### Key Concepts

*   **`Option.ACTIONS`**: All actions must be listed here.
*   **`Option.STORE_ACTIONS`**: Actions that store values.
*   **`Option.TYPED_ACTIONS`**: Actions that expect a type.
*   **`Option.ALWAYS_TYPED_ACTIONS`**: Actions that always take a type; `optparse` assigns the default type `"string"` to options with no explicit type listed here.
*   **`Option.take_action(self, action, dest, opt, value, values, parser)`**: Method to be overridden for implementing custom actions.
*   **`values.ensure_value(attr, value)`**: A method on the `optparse.Values` class that ensures an attribute exists and is initialized with a default value, useful for accumulating actions like "append" or "extend".
```

--------------------------------

### Time 'char in text' vs 'text.find(char)' with setup (Python)

Source: https://github.com/python/cpython/blob/main/Doc/library/timeit.rst

Demonstrates timing Python expressions using the timeit.timeit() function with a setup parameter to pre-configure variables.

```python
import timeit
timeit.timeit('char in text', setup='text = "sample string"; char = "g"')
0.41440500499993504
timeit.timeit('text.find(char)', setup='text = "sample string"; char = "g"')
1.7246671520006203
```

--------------------------------

### Doctest example with object address and SKIP directive

Source: https://github.com/python/cpython/blob/main/Doc/library/doctest.rst

Provides an example of a doctest that might fail due to outputting object addresses, using the '+SKIP' directive to prevent it from running.

```python
>>> id(1.0)  # certain to fail some of the time  # doctest: +SKIP
7948648
```

```python
>>> class C: pass
>>> C()  # the default repr() for instances embeds an address   # doctest: +SKIP
<C object at 0x00AC18F0>
```

--------------------------------

### Site Module Command Line Usage (Shell)

Source: https://github.com/python/cpython/blob/main/Doc/library/site.rst

Demonstrates how to use the 'site' module from the command line to display user-specific directory paths. The --user-site option prints the user site-packages directory.

```shell
python -m site --user-site
```

--------------------------------

### Python `bin()` Function Examples

Source: https://github.com/python/cpython/blob/main/Doc/library/functions.rst

Demonstrates the conversion of integers to their binary string representation, prefixed with '0b'. Includes examples using the built-in `bin()` and the `format()` function for custom formatting.

```python
print(bin(3))
print(bin(-10))
```

```python
print(format(14, '#b'), format(14, 'b'))
print(f'{14:#b}', f'{14:b}')
```

--------------------------------

### Windows Installer Updates

Source: https://github.com/python/cpython/blob/main/Misc/NEWS.d/3.13.0b1.rst

Details on updates to the Windows installer, including dependency management and versioning.

```APIDOC
## Windows Installer Updates

### Description
Updates related to the Windows installer, including changes to bundled libraries and fixes for installation issues.

### Method
N/A (Informational)

### Endpoint
N/A

### Parameters
N/A

### Request Example
N/A

### Response
N/A
```

--------------------------------

### Update Windows Installer to SQLite 3.38.1

Source: https://github.com/python/cpython/blob/main/Misc/NEWS.d/3.11.0a7.rst

Updates the Windows installer to use SQLite version 3.38.1. This ensures the installer benefits from the latest features and bug fixes in SQLite.

```text
Update Windows installer to use SQLite 3.38.1.
```

--------------------------------

### Python: re.subn example

Source: https://github.com/python/cpython/blob/main/Doc/library/re.rst

Provides an example of using `re.subn`, which performs the same substitution as `re.sub` but also returns the number of substitutions made.

```python
# Example usage for subn would typically involve calling it and inspecting the tuple return value.
# For instance: new_string, num_subs = re.subn(pattern, repl, string)
# Since no direct code example is provided in the text for subn's output, a placeholder comment is used.
```

--------------------------------

### Trace Memory Usage in Python

Source: https://github.com/python/cpython/blob/main/Doc/library/tracemalloc.rst

This code snippet demonstrates how to use the tracemalloc module to trace memory usage during Python computations. It shows how to start tracing, record memory usage before and after operations, and print the results. The example highlights the use of get_traced_memory() to retrieve current and peak memory usage.

```python
import tracemalloc

tracemalloc.start()

# Example code: compute a sum with a large temporary list
large_sum = sum(list(range(100000)))

first_size, first_peak = tracemalloc.get_traced_memory()

tracemalloc.reset_peak()

# Example code: compute a sum with a small temporary list
small_sum = sum(list(range(1000)))

second_size, second_peak = tracemalloc.get_traced_memory()

print(f"{first_size=}, {first_peak=}")
print(f"{second_size=}, {second_peak=}")
```

--------------------------------

### Bootstrap pip with ensurepip Module (Python)

Source: https://github.com/python/cpython/blob/main/Doc/whatsnew/3.4.rst

The 'ensurepip' module provides a cross-platform mechanism to bootstrap the pip installer into Python installations and virtual environments. It installs 'pip', 'pipX', and 'pipX.Y' commands. Usage can be controlled via configure and Makefile options for source builds, and it's enabled by default in installers for Windows and macOS.

```python
import ensurepip

# Bootstrap pip in the current environment
ensurepip.bootstrap()

# Bootstrap pip with a specific version (if available)
# ensurepip.bootstrap(version='20.0.2')

# To install pip into a virtual environment, typically done implicitly by venv
# or explicitly by calling ensurepip.bootstrap() within that environment.
```

--------------------------------

### Fix unittest.IsolatedAsyncioTestCase event loop setup

Source: https://github.com/python/cpython/blob/main/Misc/NEWS.d/3.12.0a1.rst

Ensures that 'unittest.IsolatedAsyncioTestCase' correctly sets the event loop before executing setup functions. This guarantees that asynchronous setup methods have a properly configured event loop available.

```python
import unittest
import asyncio

# Example of an async test case:
# class MyAsyncTests(unittest.IsolatedAsyncioTestCase):
#     async def asyncSetUp(self):
#         await super().asyncSetUp()
#         # Test setup logic here
#
#     async def test_something(self):
#         await self.asyncSetUp()
#         # Test execution

# The fix ensures asyncSetUp and other async methods work correctly.
```

--------------------------------

### Install IDLE on Fedora/RHEL/CentOS

Source: https://github.com/python/cpython/blob/main/Doc/using/unix.rst

Installs the IDLE integrated development environment on Fedora, RHEL, and CentOS systems using the dnf package manager. Requires sudo privileges.

```shell
sudo dnf install python3-idle
```

--------------------------------

### Basic Configuration API

Source: https://github.com/python/cpython/blob/main/Doc/howto/logging.rst

API for basic logging configuration, including setting up default handlers and formatters.

```APIDOC
## basicConfig() Function

### Description
Provides a simple way to configure the root logger, setting up a default handler and formatter if none are already configured.

### Method
`logging.basicConfig(*, level=None, filename=None, filemode='a', ..., format=None, datefmt=None, style='%', validate=True, defaults=None)`

### Endpoint
N/A (This is a module-level function in the Python logging library)

### Parameters
#### level
- **level** (int) - Optional - Specifies the root logger's severity level.

#### filename
- **filename** (str) - Optional - If provided, messages will be written to this file.

#### filemode
- **filemode** (str) - Optional - Defaults to 'a' (append). Specifies the file mode if `filename` is used.

#### format
- **format** (str) - Optional - Specifies the format for the log messages. Default format is 'severity:logger name:message'.

#### datefmt
- **datefmt** (str) - Optional - Specifies the format for the date and time in the log messages.

### Request Example
```python
import logging

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

logging.info('This message will be logged with the specified format.')
```

### Response
#### Success Response (200)
This function configures the logging system and does not return a value.

#### Response Example
N/A
```

--------------------------------

### Update macOS Installer to SQLite 3.42.0

Source: https://github.com/python/cpython/blob/main/Misc/NEWS.d/3.12.0b1.rst

Updates the macOS installer to utilize SQLite version 3.42.0. This is a routine maintenance update for the installer.

```Unknown
.. date: 2023-05-18-22-31-49
.. gh-issue: 104623
.. nonce: 6h7Xfx
.. section: macOS

Update macOS installer to SQLite 3.42.0.

..
```

--------------------------------

### Python Comprehension Examples

Source: https://github.com/python/cpython/blob/main/Lib/test/test_ast/data/ast_repr.txt

Shows AST nodes for generator expressions, dictionary comprehensions, and set comprehensions with single or multiple generators.

```python
Module(body=[Expr(value=GeneratorExp(elt=Tuple(...), generators=[comprehension(...)]))], type_ignores=[])
```

```python
Module(body=[Expr(value=DictComp(key=Name(...), value=Name(...), generators=[comprehension(...), comprehension(...)]))], type_ignores=[])
```

```python
Module(body=[Expr(value=DictComp(key=Name(...), value=Name(...), generators=[comprehension(...)]))], type_ignores=[])
```

```python
Module(body=[Expr(value=SetComp(elt=Name(...), generators=[comprehension(...)]))], type_ignores=[])
```

--------------------------------

### Update Python Installer to SQLite 3.41.2 on Windows

Source: https://github.com/python/cpython/blob/main/Misc/NEWS.d/3.12.0b1.rst

Updates the Windows installer to utilize SQLite version 3.41.2. This is a maintenance update for the installer.

```Unknown
.. date: 2023-03-24-11-25-28
.. gh-issue: 102997
.. nonce: dredy2
.. section: Windows

Update Windows installer to use SQLite 3.41.2.

..
```

--------------------------------

### venv Command Line Options

Source: https://github.com/python/cpython/blob/main/Doc/library/venv.rst

Displays the help message for the venv command, outlining all available options for creating and configuring virtual environments. This includes options for system site packages, symlinks vs. copies, clearing existing environments, upgrading, and managing pip.

```text
usage: venv [-h] [--system-site-packages] [--symlinks | --copies] [--clear]
            [--upgrade] [--without-pip] [--prompt PROMPT] [--upgrade-deps]
            [--without-scm-ignore-files]
            ENV_DIR [ENV_DIR ...]

Creates virtual Python environments in one or more target directories.

Once an environment has been created, you may wish to activate it, e.g. by
sourcing an activate script in its bin directory.
```

--------------------------------

### CPython Legacy Single-Phase Module Initialization (Python Example)

Source: https://github.com/python/cpython/blob/main/Doc/c-api/extension-modules.rst

Demonstrates the behavior of legacy single-phase initialization in CPython using a Python example. It shows how module objects and their dictionaries are handled across different imports, highlighting differences from multi-phase initialization.

```python
>>> import sys
>>> import _testsinglephase as one
>>> del sys.modules['_testsinglephase']
>>> import _testsinglephase as two
>>> one is two
False
>>> one.__dict__ is two.__dict__
False
>>> one.sum is two.sum
True
>>> one.error is two.error
True
```

--------------------------------

### Fix timeit with string statement and non-string setup

Source: https://github.com/python/cpython/blob/main/Misc/NEWS.d/3.5.0b2.rst

Resolves an issue in the `timeit` module where it failed when the `stmt` argument was a string but the `setup` argument was not. This ensures `timeit` works correctly with mixed types for statement and setup.

```python
import timeit

# setup_code = compile("x = 1", '<string>', 'exec')
# timeit.timeit(stmt='x+1', setup=setup_code)
# This usage should now be supported.
```

--------------------------------

### Update Python Installer to SQLite 3.42.0 on Windows

Source: https://github.com/python/cpython/blob/main/Misc/NEWS.d/3.12.0b1.rst

Updates the Windows installer to utilize SQLite version 3.42.0. This is a routine maintenance update for the installer.

```Unknown
.. date: 2023-05-18-22-46-03
.. gh-issue: 104623
.. nonce: HJZhm1
.. section: Windows

Update Windows installer to use SQLite 3.42.0.

..
```

--------------------------------

### Send Entire Directory Contents as Email

Source: https://github.com/python/cpython/blob/main/Doc/library/email.examples.rst

Provides an example of how to package and send the entire contents of a specified directory as an email message. This often involves creating a MIME archive or similar structure.

```python
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.base import MIMEBase
from email import encoders
import os

def send_directory_email(directory_path, sender, recipient):
    msg = MIMEMultipart()
    msg['Subject'] = f'Contents of {os.path.basename(directory_path)}'
    msg['From'] = sender
    msg['To'] = recipient

    msg.attach(MIMEText(f'Attached is the content of the directory: {directory_path}'))

    for filename in os.listdir(directory_path):
        filepath = os.path.join(directory_path, filename)
        if os.path.isfile(filepath):
            with open(filepath, 'rb') as attachment_file:
                payload = MIMEBase('application', 'octet-stream')
                payload.set_payload(attachment_file.read())
                encoders.encode_base64(payload)
                payload.add_header('Content-Disposition', f'attachment; filename="{filename}"')
                msg.attach(payload)

    # Send the message (implementation omitted for brevity)
    # with SMTP('localhost') as s:
    #     s.send_message(msg)

# Example usage:
# send_directory_email('/path/to/your/directory', 'sender@example.com', 'recipient@example.com')

```

--------------------------------

### Using pydoc to display module documentation (Python)

Source: https://github.com/python/cpython/blob/main/Doc/whatsnew/2.1.rst

Demonstrates how to use the 'pydoc' command-line tool to display documentation for a Python package. It shows the expected output format, including module name, file path, and description.

```shell
pydoc xml.dom
```

```text
Python Library Documentation: package xml.dom in xml

NAME
    xml.dom - W3C Document Object Model implementation for Python.

FILE
    /usr/local/lib/python2.1/xml/dom/__init__.pyc

DESCRIPTION
    The Python mapping of the Document Object Model is documented in the
    Python Library Reference in the section on the xml.dom package.

    This package contains the following modules:
      ...
```

--------------------------------

### Simulate Nested Contexts with Python ChainMap

Source: https://github.com/python/cpython/blob/main/Doc/library/collections.rst

This Python example illustrates how to use `collections.ChainMap` to simulate nested contexts, similar to local and global scopes in programming languages. It demonstrates creating child contexts using `new_child()`, accessing specific mappings within the chain, and performing common dictionary operations like setting, getting, deleting, listing keys, and checking membership.

```python
c = ChainMap()        # Create root context
d = c.new_child()     # Create nested child context
e = c.new_child()     # Child of c, independent from d
e.maps[0]             # Current context dictionary -- like Python's locals()
e.maps[-1]            # Root context -- like Python's globals()
e.parents             # Enclosing context chain -- like Python's nonlocals

d['x'] = 1            # Set value in current context
d['x']                # Get first key in the chain of contexts
del d['x']            # Delete from current context
list(d)               # All nested values
k in d                # Check all nested values
len(d)                # Number of nested values
d.items()             # All nested items
dict(d)               # Flatten into a regular dictionary
```

--------------------------------

### Parse XML with custom Expat event handlers in Python

Source: https://github.com/python/cpython/blob/main/Doc/library/pyexpat.rst

This Python example illustrates how to parse an XML string using `xml.parsers.expat`. It defines custom handler functions for start elements, end elements, and character data, assigning them to the parser's respective attributes. The parser then processes a multi-line XML string, triggering these handlers to print information about the parsed elements and data.

```python
import xml.parsers.expat

# 3 handler functions
def start_element(name, attrs):
    print('Start element:', name, attrs)
def end_element(name):
    print('End element:', name)
def char_data(data):
    print('Character data:', repr(data))

p = xml.parsers.expat.ParserCreate()

p.StartElementHandler = start_element
p.EndElementHandler = end_element
p.CharacterDataHandler = char_data

p.Parse("""<?xml version="1.0"?>
<parent id="top"><child1 name="paul">Text goes here</child1>
<child2 name="fred">More text</child2>
</parent>""", 1)
```

--------------------------------

### Support *disabled* marker in Setup files

Source: https://github.com/python/cpython/blob/main/Misc/NEWS.d/3.7.0a1.rst

Introduces support for a `*disabled*` marker in `Setup` files. Extension modules listed after this marker will not be built by either the Makefile or `setup.py`.

```bash
Support the *disabled* marker in Setup files. Extension modules listed after
this marker are not built at all, neither by the Makefile nor by setup.py.
```

--------------------------------

### Instantiate cProfile.Profile with Custom Integer Timer and Calibration

Source: https://github.com/python/cpython/blob/main/Doc/library/profile.rst

Initializes a cProfile.Profile object with a custom timer function that returns integer values. A second argument is provided to specify the real duration of one unit of time for calibration purposes.

```python
pr = cProfile.Profile(your_integer_time_func, 0.001)
```

--------------------------------

### Compile Python Files Using compileall

Source: https://github.com/python/cpython/blob/main/Doc/faq/programming.rst

This command-line example demonstrates how to use the `compileall` module to compile all Python files in the current directory and its subdirectories. It's a convenient way to pre-compile Python modules.

```bash
python -m compileall .
```

--------------------------------

### MagicMock Context Manager Example

Source: https://github.com/python/cpython/blob/main/Doc/library/unittest.mock.rst

Demonstrates how to use MagicMock as a context manager within a 'with' statement, including setting up __enter__ and __exit__ methods.

```APIDOC
## MagicMock Context Manager Example

### Description
This example shows how to use `MagicMock` as a context manager. It configures the `__enter__` and `__exit__` methods to simulate the behavior of a context manager in a `with` statement.

### Method
N/A (Illustrative Example)

### Endpoint
N/A (Illustrative Example)

### Request Example
```python
from unittest.mock import Mock

mock = Mock()
mock.__enter__ = Mock(return_value='foo')
mock.__exit__ = Mock(return_value=False)

with mock as m:
    assert m == 'foo'

mock.__enter__.assert_called_with()
mock.__exit__.assert_called_with(None, None, None)
```

### Response
N/A (Illustrative Example)
```

--------------------------------

### Example Python module with doctests

Source: https://github.com/python/cpython/blob/main/Doc/library/doctest.rst

A sample Python module demonstrating the factorial function. It includes multiple doctest examples within the function's docstring to test various scenarios, including valid inputs, error conditions, and edge cases.

```python
"""
This is the "example" module.

The example module supplies one function, factorial().  For example,

>>> factorial(5)
120
"""

def factorial(n):
    """Return the factorial of n, an exact integer >= 0.

    >>> [factorial(n) for n in range(6)]
    [1, 1, 2, 6, 24, 120]
    >>> factorial(30)
    265252859812191058636308480000000
    >>> factorial(-1)
    Traceback (most recent call last):
        ...
    ValueError: n must be >= 0

    Factorials of floats are OK, but the float must be an exact integer:
    >>> factorial(30.1)
    Traceback (most recent call last):
        ...
    ValueError: n must be exact integer
    >>> factorial(30.0)
    265252859812191058636308480000000

    It must also not be ridiculously large:
    >>> factorial(1e100)
    Traceback (most recent call last):
        ...
    OverflowError: n too large
    """

    import math
    if not n >= 0:
        raise ValueError("n must be >= 0")
    if math.floor(n) != n:
        raise ValueError("n must be exact integer")
    if n+1 == n:  # catch a value like 1e300
        raise OverflowError("n too large")
    result = 1
    factor = 2
    while factor <= n:
        result *= factor
        factor += 1
    return result


if __name__ == "__main__":
    import doctest
    doctest.testmod()

```

--------------------------------

### Install Embeddable Python Package

Source: https://github.com/python/cpython/blob/main/Doc/using/windows.rst

Installs an embeddable Python distribution to a specified target directory. This is useful for integrating Python into other applications.

```bash
$> py install 3.14-embed --target=runtime
```

--------------------------------

### Python Spacing Example

Source: https://github.com/python/cpython/blob/main/Doc/tutorial/controlflow.rst

Demonstrates correct spacing around operators and commas, and within bracketing constructs in Python.

```python
a = f(1, 2) + g(3, 4)
```

--------------------------------

### Python Multiprocessing Logging Example

Source: https://github.com/python/cpython/blob/main/Doc/howto/logging-cookbook.rst

This example demonstrates logging within a Python multiprocessing application. It sets up logging using `dictConfig`, creates worker processes that log messages, and a listener process. It shows how to manage process lifecycles and propagate log messages across processes.

```python
import logging
import logging.config
from multiprocessing import Process, Event, Queue

# Assume worker_process, listener_process, config_worker, config_listener are defined elsewhere
# For example:
def worker_process(config):
    logger = logging.getLogger('worker')
    logger.info('Worker started')

def listener_process(queue, stop_event, config):
    # Listener implementation
    pass

def main():
    # ... logging configuration setup (as shown in previous snippet) ...
    logging.config.dictConfig(config_initial)
    logger = logging.getLogger('setup')
    logger.info('About to create workers ...')
    workers = []
    for i in range(5):
        wp = Process(target=worker_process, name='worker %d' % (i + 1),
                     args=(config_worker,)) # Assuming config_worker is defined
        workers.append(wp)
        wp.start()
        logger.info('Started worker: %s', wp.name)
    logger.info('About to create listener ...')
    stop_event = Event()
    q = Queue() # Assuming Queue is needed for listener
    lp = Process(target=listener_process, name='listener',
                 args=(q, stop_event, config_listener)) # Assuming config_listener is defined
    lp.start()
    logger.info('Started listener')
    # We now hang around for the workers to finish their work.
    for wp in workers:
        wp.join()
    # Workers all done, listening can now stop.
    # Logging in the parent still works normally.
    logger.info('Telling listener to stop ...')
    stop_event.set()
    lp.join()
    logger.info('All done.')

if __name__ == '__main__':
    main()

```

--------------------------------

### Python File I/O Modes and Text/Binary Handling

Source: https://github.com/python/cpython/blob/main/Doc/tutorial/inputoutput.rst

Explains the different modes for opening files ('r', 'w', 'a', 'r+') and the distinction between text mode (default, handles string encoding and line ending conversion) and binary mode (handles bytes, no encoding or line ending conversion).

```python
# Opening a file for writing with UTF-8 encoding
f = open('workfile', 'w', encoding="utf-8")

# Opening a file for reading
f = open('workfile', 'r')

# Opening a file in binary mode for reading
f = open('workfile', 'rb')

# Opening a file for appending
f = open('workfile', 'a')

# Opening a file for both reading and writing
f = open('workfile', 'r+')

```

--------------------------------

### Install Python on OpenBSD

Source: https://github.com/python/cpython/blob/main/Doc/using/unix.rst

Installs a specific version of Python on OpenBSD systems using the pkg_add command. The URL needs to be adjusted for the specific architecture and version. Requires sudo privileges.

```shell
pkg_add -r python

pkg_add ftp://ftp.openbsd.org/pub/OpenBSD/4.2/packages/<insert your architecture here>/python-<version>.tgz
```

--------------------------------

### Install LLVM 19 via Chocolatey on Windows

Source: https://github.com/python/cpython/blob/main/Tools/jit/README.md

Installs LLVM version 19 on Windows using the Chocolatey package manager. It's recommended to select the option to add LLVM to the system PATH during installation.

```powershell
choco install llvm --version=19.1.0
```

--------------------------------

### Python `init` Method Example

Source: https://github.com/python/cpython/blob/main/Doc/library/email.headerregistry.rst

Demonstrates an example `init` method for a specialized class that handles keyword arguments before passing them to the superclass constructor. It specifically shows how to pop a custom attribute and pass the remaining arguments.

```python
def init(self, /, *args, **kw):
    self._myattr = kw.pop('myattr')
    super().init(*args, **kw)
```

--------------------------------

### os.walk and os.fwalk

Source: https://github.com/python/cpython/blob/main/Doc/library/os.rst

Details on traversing directory trees using os.walk and os.fwalk, including examples for file size calculation and directory deletion.

```APIDOC
## os.walk

### Description
Provides a way to walk a directory tree, yielding tuples of (dirpath, dirnames, filenames) for each directory visited.

### Method
GET (implicitly, as it's a generator function)

### Endpoint
N/A (function within a module)

### Parameters
#### Path Parameters
- **top** (str) - The starting directory for the traversal.
- **topdown** (bool) - If True, walk the tree top-down. If False, walk the tree bottom-up.
- **onerror** (callable, optional) - A function to call for errors.
- **follow_symlinks** (bool) - If True, follow symbolic links.

### Request Example
```python
import os
for root, dirs, files in os.walk('my_directory'):
    print(f'Directory: {root}')
    print(f'  Subdirectories: {dirs}')
    print(f'  Files: {files}')
```

### Response
#### Success Response (yields tuples)
- **dirpath** (str) - The path to the current directory.
- **dirnames** (list) - A list of subdirectory names in the current directory.
- **filenames** (list) - A list of file names in the current directory.

#### Response Example
```json
{
  "dirpath": "/path/to/directory",
  "dirnames": ["subdir1", "subdir2"],
  "filenames": ["file1.txt", "file2.py"]
}
```

## os.fwalk

### Description
Similar to `os.walk`, but yields a 4-tuple `(dirpath, dirnames, filenames, dirfd)` and supports `dir_fd` for more efficient operations with file descriptors.

### Method
GET (implicitly, as it's a generator function)

### Endpoint
N/A (function within a module)

### Parameters
#### Path Parameters
- **top** (str) - The starting directory for the traversal.
- **topdown** (bool) - If True, walk the tree top-down. If False, walk the tree bottom-up.
- **onerror** (callable, optional) - A function to call for errors.
- **follow_symlinks** (bool, optional) - If True, follow symbolic links. Defaults to False.
- **dir_fd** (int, optional) - A file descriptor referring to the directory `top`.

### Request Example
```python
import os
for root, dirs, files, rootfd in os.fwalk('my_directory'):
    print(f'Directory: {root}, File Descriptor: {rootfd}')
    # Process files using rootfd for efficiency
```

### Response
#### Success Response (yields tuples)
- **dirpath** (str) - The path to the current directory.
- **dirnames** (list) - A list of subdirectory names in the current directory.
- **filenames** (list) - A list of file names in the current directory.
- **dirfd** (int) - A file descriptor referring to the directory `dirpath`.

#### Response Example
```json
{
  "dirpath": "/path/to/directory",
  "dirnames": ["subdir1"],
  "filenames": ["config.ini"],
  "dirfd": 3
}
```
```

--------------------------------

### Shell Session: Argparse Verbosity Examples

Source: https://github.com/python/cpython/blob/main/Doc/howto/argparse.rst

Demonstrates various command-line executions of a Python script using argparse, showing different verbosity levels and argument combinations.

```shell-session
$ python prog.py 4
16
$ python prog.py 4 -v
4^2 == 16
$ python prog.py 4 -vv
the square of 4 equals 16
$ python prog.py 4 --verbosity --verbosity
the square of 4 equals 16
$ python prog.py 4 -v 1
usage: prog.py [-h] [-v] square
prog.py: error: unrecognized arguments: 1
$ python prog.py 4 -h
usage: prog.py [-h] [-v] square

positional arguments:
  square           display a square of a given number

options:
  -h, --help       show this help message and exit
  -v, --verbosity  increase output verbosity
$ python prog.py 4 -vvv
16
```

```shell-session
$ python prog.py 4 -vvv
the square of 4 equals 16
$ python prog.py 4 -vvvv
the square of 4 equals 16
$ python prog.py 4
Traceback (most recent call last):
  File "prog.py", line 11, in <module>
    if args.verbosity >= 2:
TypeError: '>=' not supported between instances of 'NoneType' and 'int'
```

```shell-session
$ python prog.py 4
16
```

```shell-session
$ python prog.py
usage: prog.py [-h] [-v] x y
prog.py: error: the following arguments are required: x, y
$ python prog.py -h
usage: prog.py [-h] [-v] x y

positional arguments:
  x                the base
  y                the exponent

options:
  -h, --help       show this help message and exit
  -v, --verbosity
$ python prog.py 4 2 -v
```

--------------------------------

### Define User Base Directory (PYTHONUSERBASE)

Source: https://github.com/python/cpython/blob/main/Doc/using/cmdline.rst

Sets the user base directory, which influences the location of user-specific site-packages and installation paths for packages installed with 'pip install --user'.

```bash
export PYTHONUSERBASE=/home/user/.local
```

--------------------------------

### Update macOS Installer to Tcl/Tk 8.6.13

Source: https://github.com/python/cpython/blob/main/Misc/NEWS.d/3.12.0b1.rst

Updates the macOS installer to use Tcl/Tk version 8.6.13. This is a standard update for the installer's core components.

```Unknown
.. date: 2023-05-21-23-54-52
.. gh-issue: 99834
.. nonce: 6ANPts
.. section: macOS

Update macOS installer to Tcl/Tk 8.6.13.

..
```

--------------------------------

### Doctest example using ELLIPSIS for object addresses

Source: https://github.com/python/cpython/blob/main/Doc/library/doctest.rst

Demonstrates using the '+ELLIPSIS' directive to handle unpredictable parts of output, such as memory addresses, in doctest examples.

```python
>>> C()  # doctest: +ELLIPSIS
<C object at 0x...>
```

--------------------------------

### Shebang Line Examples for Cross-Platform Compatibility

Source: https://github.com/python/cpython/blob/main/Doc/using/windows.rst

Provides examples of shebang lines for Python scripts intended for cross-platform use. These lines specify the interpreter to be used, aiming for compatibility between Unix-like systems and Windows.

```sh
#! /usr/bin/python
```

```sh
#! /usr/bin/env python
```

```sh
#! /usr/bin/python3.7-32
```

```sh
#! /usr/bin/python3-64
```

--------------------------------

### Set Multiprocessing Start Method to 'spawn'

Source: https://github.com/python/cpython/blob/main/Doc/library/multiprocessing.rst

Demonstrates how to set the multiprocessing start method to 'spawn' using `set_start_method` and illustrates basic process creation and inter-process communication using a Queue.

```python
import multiprocessing as mp

def foo(q):
    q.put('hello')

if __name__ == '__main__':
    mp.set_start_method('spawn')
    q = mp.Queue()
    p = mp.Process(target=foo, args=(q,))
    p.start()
    print(q.get())
    p.join()
```

--------------------------------

### Python For Loop Examples

Source: https://github.com/python/cpython/blob/main/Lib/test/test_ast/data/ast_repr.txt

Demonstrates AST representations for for loops, including iterating over sequences, using break/continue, and unpacking targets.

```python
Module(body=[For(target=Name(id='v', ctx=Store(...)), iter=Name(id='v', ctx=Load(...)), body=[Break()], orelse=[], type_comment=None)], type_ignores=[])
```

```python
Module(body=[For(target=Name(id='v', ctx=Store(...)), iter=Name(id='v', ctx=Load(...)), body=[Continue()], orelse=[], type_comment=None)], type_ignores=[])
```

```python
Module(body=[For(target=Tuple(elts=[Name(...), Name(...)], ctx=Store(...)), iter=Name(id='c', ctx=Load(...)), body=[Pass()], orelse=[], type_comment=None)], type_ignores=[])
```

```python
Module(body=[For(target=List(elts=[Name(...), Name(...)], ctx=Store(...)), iter=Name(id='c', ctx=Load(...)), body=[Pass()], orelse=[], type_comment=None)], type_ignores=[])
```

--------------------------------

### Placeholder for Post-Setup Actions

Source: https://github.com/python/cpython/blob/main/Doc/library/venv.rst

A placeholder method that can be overridden in custom implementations. It allows for pre-installing packages or performing other custom actions after the virtual environment has been created.

```python
class EnvBuilder:
    # ... (other methods)

    def post_setup(self, context):
        """
        A placeholder method which can be overridden in third party
        implementations to pre-install packages in the virtual environment or
        perform other post-creation steps.
        """
        # Default implementation does nothing
        pass
```

--------------------------------

### Install Custom Scripts into Virtual Environment

Source: https://github.com/python/cpython/blob/main/Doc/library/venv.rst

A utility method that can be called from 'setup_scripts' or 'post_setup' in subclasses to help install custom scripts. It copies scripts from specified directories ('common', 'posix', 'nt') into the environment's 'bin' directory after performing text replacements.

```python
class EnvBuilder:
    # ... (other methods)

    def install_scripts(self, context, path):
        """
        This method can be called from :meth:`setup_scripts` or :meth:`post_setup` in subclasses to
        assist in installing custom scripts into the virtual environment.

        *path* is the path to a directory that should contain subdirectories
        ``common``, ``posix``, ``nt``; each containing scripts destined for the
        ``bin`` directory in the environment.  The contents of ``common`` and the
        directory corresponding to :data:`os.name` are copied after some text
        replacement of placeholders:

        * ``__VENV_DIR__`` is replaced with the absolute path of the environment
          directory.
        """
        # Implementation details for installing custom scripts
        pass
```

--------------------------------

### Demonstrate Python list methods (append, sort, pop, index, count, reverse)

Source: https://github.com/python/cpython/blob/main/Doc/tutorial/datastructures.rst

This example showcases a variety of list methods including `count()` for element frequency, `index()` for finding an element's position (with an optional start index), `reverse()` for in-place reversal, `append()` for adding elements to the end, `sort()` for in-place sorting, and `pop()` for removing and returning the last item. It illustrates the practical application and effects of these common list operations.

```python
fruits = ['orange', 'apple', 'pear', 'banana', 'kiwi', 'apple', 'banana']
fruits.count('apple')
fruits.count('tangerine')
fruits.index('banana')
fruits.index('banana', 4)  # Find next banana starting at position 4
fruits.reverse()
fruits
fruits.append('grape')
fruits
fruits.sort()
fruits
fruits.pop()
'pear'
```

--------------------------------

### Silent Python Installation Command

Source: https://github.com/python/cpython/blob/main/Doc/using/windows.rst

Demonstrates a silent, system-wide Python installation with path prepended and test suite excluded. This command is executed from an elevated command prompt.

```bash
python-3.9.0.exe /quiet InstallAllUsers=1 PrependPath=1 Include_test=0
```

--------------------------------

### Shell Commands for Running and Inspecting Log Files

Source: https://github.com/python/cpython/blob/main/Doc/howto/logging-cookbook.rst

Demonstrates how to run the Python simulation script and then inspect the generated log files using shell commands like `wc` and `head`.

```shell
python main.py
wc -l *.log
head -3 app1.log
head -3 app2.log
head app.log
```

--------------------------------

### Python Raise Statement Examples

Source: https://github.com/python/cpython/blob/main/Lib/test/test_ast/data/ast_repr.txt

Demonstrates how to represent 'raise' statements in Python AST. This includes raising specific exceptions with arguments and without.

```python
Module(body=[Raise(exc=Call(func=Name(...), args=[Constant(...)], keywords=[]), cause=None)], type_ignores=[])
```

```python
Module(body=[Raise(exc=Name(id='Exception', ctx=Load(...)), cause=None)], type_ignores=[])
```

```python
Module(body=[Raise(exc=Call(func=Name(...), args=[Constant(...)], keywords=[]), cause=Constant(value=None, kind=None))], type_ignores=[])
```

--------------------------------

### DocTestRunner

Source: https://github.com/python/cpython/blob/main/Doc/library/doctest.rst

Describes the DocTestRunner class, which executes doctest examples.

```APIDOC
## DocTestRunner

### Description
The `DocTestRunner` class executes the examples contained within a `DocTest` object. It utilizes an `OutputChecker` to verify that the actual output matches the expected output.

*(Note: Specific methods or constructor arguments for DocTestRunner were not detailed in the provided text.)*
```

--------------------------------

### Python optparse: Grouping Options

Source: https://github.com/python/cpython/blob/main/Doc/library/optparse.rst

Demonstrates how to group related command-line options using OptionGroup for better organization and help output. Includes adding options to groups and adding groups to the parser.

```python
from optparse import OptionParser, OptionGroup

parser = OptionParser()

group = OptionGroup(parser, "Dangerous Options", "Caution: use these options at your own risk. It is believed that some of them bite.")
group.add_option("-g", action="store_true", help="Group option.")
parser.add_option_group(group)

group2 = OptionGroup(parser, "Debug Options")
# Add options to group2 here if needed
parser.add_option_group(group2)
```

--------------------------------

### Initialize LZMACompressor with custom settings

Source: https://github.com/python/cpython/blob/main/Doc/library/lzma.rst

Initializes an LZMACompressor with specific format, check, and preset. For example, using raw format, no check, and an extreme preset.

```python
from lzma import LZMACompressor, FORMAT_RAW, CHECK_NONE, PRESET_EXTREME

compressor = LZMACompressor(format=FORMAT_RAW, check=CHECK_NONE, preset=PRESET_EXTREME | 9)
```

--------------------------------

### Python f-string: Column Alignment

Source: https://github.com/python/cpython/blob/main/Doc/tutorial/inputoutput.rst

Demonstrates aligning columns using f-strings with specified minimum field widths for strings and integers. This is useful for creating neatly formatted output.

```python
>>> table = {'Sjoerd': 4127, 'Jack': 4098, 'Dcab': 7678}
>>> for name, phone in table.items():
...     print(f'{name:10} ==> {phone:10d}')
... 
Sjoerd     ==>       4127
Jack       ==>       4098
Dcab       ==>       7678
```

--------------------------------

### Python 2 to Python 3 Code Migration Examples

Source: https://github.com/python/cpython/blob/main/Doc/whatsnew/3.0.rst

Illustrates how to adapt common Python 2 constructs to their Python 3 equivalents, focusing on removed functions and alternative methods.

```python
In Python 3, `apply(f, args)` is replaced with `f(*args)`.
Instead of `callable(f)`, use `isinstance(f, collections.Callable)`.
`execfile(fn)` is replaced by `exec(open(fn).read())`.
`reduce(func, iterable)` is replaced by `functools.reduce(func, iterable)`.
`reload(module)` is replaced by `imp.reload(module)`.
`dict.has_key(key)` is replaced by the `in` operator: `key in dict`.
```

--------------------------------

### Port _blake2 to multi-phase initialization API (PEP 489)

Source: https://github.com/python/cpython/blob/main/Misc/NEWS.d/3.10.0a1.rst

This change focuses on porting the _blake2 extension module to the multi-phase initialization API, following the guidelines of PEP 489. This ensures consistent initialization practices across extension modules.

```python
.. bpo: 1635741
.. date: 2020-08-13-07-18-05
.. nonce: FC13e7
.. section: Core and Builtins

Port the :mod:`!_blake2` extension module to the multi-phase initialization
API (:pep:`489`).
```

--------------------------------

### Basic Interpolation Example

Source: https://github.com/python/cpython/blob/main/Doc/library/configparser.rst

Illustrates basic value interpolation in configuration files where values can reference other values within the same section or a special default section. It shows how to define and use format strings for dynamic value resolution.

```ini
[Paths]
home_dir: /Users
my_dir: %(home_dir)s/lumberjack
my_pictures: %(my_dir)s/Pictures

[Escape]
# use a %% to escape the % sign (% is the only character that needs to be escaped):
gain: 80%%
```

--------------------------------

### Python code to load and apply dictionary logging configuration

Source: https://github.com/python/cpython/blob/main/Doc/whatsnew/3.2.rst

This snippet shows how to load a logging configuration from a JSON file and apply it using `logging.config.dictConfig`. It includes example logging calls to demonstrate the configured output.

```python
import json, logging.config
with open('conf.json') as f:
    conf = json.load(f)

logging.config.dictConfig(conf)
logging.info("Transaction completed normally")
logging.critical("Abnormal termination")
```

--------------------------------

### Python: Assert Starts With

Source: https://github.com/python/cpython/blob/main/Doc/library/unittest.rst

Asserts that a string starts with a specified prefix. Leverages the built-in `startswith` method.

```python
self.assertStartsWith(a, b)
```

--------------------------------

### Python: Test Examples in a Text File with doctest

Source: https://github.com/python/cpython/blob/main/Doc/library/doctest.rst

Demonstrates how to use the `testfile` function from the `doctest` module to verify interactive Python examples embedded within a text file. The file content is treated as a single docstring. Failures are reported to stdout.

```python
import doctest
doctest.testfile("example.txt")
```

--------------------------------

### macOS Installer Updates

Source: https://github.com/python/cpython/blob/main/Misc/NEWS.d/3.13.0b1.rst

Details on updates to the macOS installer, including dependency versioning.

```APIDOC
## macOS Installer Updates

### Description
Updates related to the macOS installer, including dependency versioning for libraries like libmpdecimal and SQLite.

### Method
N/A (Informational)

### Endpoint
N/A

### Parameters
N/A

### Request Example
N/A

### Response
N/A
```

--------------------------------

### DocTestRunner.run

Source: https://github.com/python/cpython/blob/main/Doc/library/doctest.rst

Executes doctest examples within a given DocTest object and manages the execution environment.

```APIDOC
## DocTestRunner.run

### Description
Run the examples in *test* (a :class:`DocTest` object), and display the results using the writer function *out*. Return a :class:`TestResults` instance.

### Method
`run(test, compileflags=None, out=None, clear_globs=True)`

### Endpoint
N/A (Method within a class)

### Parameters
#### Arguments
- **test** (DocTest) - The doctest object containing examples to run.
- **compileflags** (object, optional) - Flags for the Python compiler.
- **out** (callable, optional) - The output function to display results.
- **clear_globs** (bool, optional) - Whether to clear the global namespace after execution (default: True).

### Request Example
```python
# Example usage (conceptual)
# runner.run(my_doctest_object)
```

### Response
#### Success Response (200)
- **TestResults** (object) - An instance of TestResults summarizing the test outcomes.
```

--------------------------------

### Run Python Platform Module from Command Line

Source: https://github.com/python/cpython/blob/main/Doc/library/platform.rst

Demonstrates how to invoke the 'platform' module directly from the command line using the '-m' switch. It shows the usage of '--terse' and '--nonaliased' options for controlling output format, and explains that these options correspond to function arguments in the module.

```bash
python -m platform [--terse] [--nonaliased] [{nonaliased,terse} ...]
```

--------------------------------

### Python String Quoting and Escaping

Source: https://github.com/python/cpython/blob/main/Doc/tutorial/introduction.rst

Demonstrates how to define strings using single and double quotes, and how to escape special characters like single quotes within strings. It also shows how to use print() for formatted output.

```python
>>> "Paris rabbit got your back :)! Yay!"  # double quotes
'Paris rabbit got your back :)! Yay!'
>>> '1975'  # digits and numerals enclosed in quotes are also strings
'1975'

To quote a quote, we need to "escape" it, by preceding it with `\`. 
Alternatively, we can use the other type of quotation marks::

>>> 'doesn\'t'  # use \' to escape the single quote...
"doesn't"
>>> "doesn't"  # ...or use double quotes instead
"doesn't"
>>> '"Yes," they said.'
'"Yes," they said.'
>>> "\"Yes,\" they said."
'"Yes," they said.'
>>> '"Isn\'t," they said.'
'"Isn\'t," they said.'

In the Python shell, the string definition and output string can look
different.  The :func:`print` function produces a more readable output, by
omitting the enclosing quotes and by printing escaped and special characters::

>>> s = 'First line.\nSecond line.'  # \n means newline
>>> s  # without print(), special characters are included in the string
'First line.\nSecond line.'
>>> print(s)  # with print(), special characters are interpreted, so \n produces new line
First line.
Second line.
```

--------------------------------

### Python Function Annotations Example

Source: https://github.com/python/cpython/blob/main/Doc/tutorial/controlflow.rst

Shows how to add type hints to function arguments and return values using Python's annotation syntax and accessing them via the __annotations__ attribute.

```python
>>> def f(ham: str, eggs: str = 'eggs') -> str:
...     print("Annotations:", f.__annotations__)
...     print("Arguments:", ham, eggs)
...     return ham + ' and ' + eggs
...
>>> f('spam')
Annotations: {'ham': <class 'str'>, 'return': <class 'str'>, 'eggs': <class 'str'>}
Arguments: spam eggs
'spam and eggs'
```

--------------------------------

### Python Pass Statement Example

Source: https://github.com/python/cpython/blob/main/Lib/test/test_ast/data/ast_repr.txt

Illustrates the AST node for the 'pass' statement, which does nothing.

```python
Module(body=[Pass()], type_ignores=[])
```

--------------------------------

### Executing Unit Tests with unittest.main()

Source: https://github.com/python/cpython/blob/main/Doc/library/unittest.rst

Demonstrates how to make test modules executable using unittest.main(). It shows basic usage and how to increase verbosity for more detailed output.

```python
import unittest

if __name__ == '__main__':
    unittest.main()
```

```python
import unittest

if __name__ == '__main__':
    unittest.main(verbosity=2)
```

--------------------------------

### Initialize Curses and Run Application

Source: https://github.com/python/cpython/blob/main/Doc/library/curses.rst

Initializes the curses environment, sets up cbreak mode, disables echo, enables the keypad, and initializes colors. It then calls a provided function with the main window and arguments, restoring the terminal state upon completion or exception.

```python
curses.wrapper(func, *args, **kwargs)
```

--------------------------------

### Move threading.local documentation and examples

Source: https://github.com/python/cpython/blob/main/Misc/NEWS.d/3.14.0b1.rst

Relocates the documentation and example code for threading.local from its docstring to the official Python documentation. This improves the accessibility and organization of information for this class.

```python
# This is a documentation change, not a code functionality change.
# The examples previously in the docstring are now in the official docs.
```

--------------------------------

### Implementing `__enter__` Method for Python Context Manager

Source: https://github.com/python/cpython/blob/main/Doc/whatsnew/2.6.rst

This code shows the implementation of the `__enter__` method for the `DatabaseConnection` class. This method is responsible for setting up the context, such as starting a new database transaction, and returning the resource (in this case, a database cursor) that will be bound to the `as` variable in a `with` statement.

```python
class DatabaseConnection:
    ...
    def __enter__(self):
        # Code to start a new transaction
        cursor = self.cursor()
        return cursor
```

--------------------------------

### Get Item from Queue Immediately (Python)

Source: https://github.com/python/cpython/blob/main/Doc/library/queue.rst

Equivalent to get(False). Provided for compatibility with Queue.get_nowait.

```python
SimpleQueue.get_nowait()
```

--------------------------------

### Create Doctest TestSuite from a Module

Source: https://github.com/python/cpython/blob/main/Doc/library/doctest.rst

Demonstrates how to convert doctest tests within a Python module into a unittest.TestSuite. It details the arguments for DocTestSuite, including module specification, global variables, test finder, setup/teardown functions, and option flags. It also explains how doctests are run as subtests and how failures are reported.

```python
.. function:: DocTestSuite(module=None, globs=None, extraglobs=None, test_finder=None, setUp=None, tearDown=None, optionflags=0, checker=None)

   Convert doctest tests for a module to a :class:`unittest.TestSuite`.

   The returned :class:`unittest.TestSuite` is to be run by the unittest
   framework and runs each doctest in the module.  Each docstring is run as a
   separate unit test, and each example in a docstring is run as a
   :ref:`subtest <subtests>`.
   If any of the doctests fail, then the synthesized unit test fails.  The
   traceback for failure or error contains the name of the file containing
   the test and a (sometimes approximate) line number.  If all the examples in
   a docstring are skipped, then the synthesized unit test is also marked as
   skipped.

   Optional argument *module* provides the module to be tested.  It can be a module
   object or a (possibly dotted) module name.  If not specified, the module calling
   this function is used.

   Optional argument *globs* is a dictionary containing the initial global
   variables for the tests.  A new copy of this dictionary is created for each
   test.  By default, *globs* is the module's :attr:`~module.__dict__`.

   Optional argument *extraglobs* specifies an extra set of global variables, which
   is merged into *globs*.  By default, no extra globals are used.

   Optional argument *test_finder* is the :class:`DocTestFinder` object (or a
   drop-in replacement) that is used to extract doctests from the module.

   Optional arguments *setUp*, *tearDown*, and *optionflags* are the same as for
   function :func:`DocFileSuite` above, but they are called for each docstring.

   This function uses the same search technique as :func:`testmod`.
```

--------------------------------

### Python Try-Except-Finally and Try-ExceptStar Examples

Source: https://github.com/python/cpython/blob/main/Lib/test/test_ast/data/ast_repr.txt

Illustrates the AST representation of try-except blocks, including handlers, optional else and finally clauses, and the try-except-star syntax.

```python
Module(body=[Try(body=[Pass()], handlers=[ExceptHandler(type=Name(...), name=None, body=[Pass(...)])], orelse=[], finalbody=[])], type_ignores=[])
```

```python
Module(body=[Try(body=[Pass()], handlers=[ExceptHandler(type=Name(...), name='exc', body=[Pass(...)])], orelse=[], finalbody=[])], type_ignores=[])
```

```python
Module(body=[Try(body=[Pass()], handlers=[], orelse=[], finalbody=[Pass()])], type_ignores=[])
```

```python
Module(body=[TryStar(body=[Pass()], handlers=[ExceptHandler(type=Name(...), name=None, body=[Pass(...)])], orelse=[], finalbody=[])], type_ignores=[])
```

```python
Module(body=[TryStar(body=[Pass()], handlers=[ExceptHandler(type=Name(...), name='exc', body=[Pass(...)])], orelse=[], finalbody=[])], type_ignores=[])
```

```python
Module(body=[Try(body=[Pass()], handlers=[ExceptHandler(type=Name(...), name=None, body=[Pass(...)])], orelse=[Pass()], finalbody=[Pass()])], type_ignores=[])
```

```python
Module(body=[Try(body=[Pass()], handlers=[ExceptHandler(type=Name(...), name='exc', body=[Pass(...)])], orelse=[Pass()], finalbody=[Pass()])], type_ignores=[])
```

```python
Module(body=[TryStar(body=[Pass()], handlers=[ExceptHandler(type=Name(...), name='exc', body=[Pass(...)])], orelse=[Pass()], finalbody=[Pass()])], type_ignores=[])
```

--------------------------------

### Python: Install _ function with gettext

Source: https://github.com/python/cpython/blob/main/Doc/library/gettext.rst

Installs the gettext function into the built-in namespace, binding it to the underscore symbol '_'. Optionally installs other gettext functions like 'ngettext', 'pgettext', and 'npgettext' if provided in the names parameter.

```python
import gettext
t = gettext.translation('mymodule', ...)
_ = t.gettext
```

--------------------------------

### Virtual Environment Launch Fix

Source: https://github.com/python/cpython/blob/main/Misc/NEWS.d/3.13.0b1.rst

Fixes for virtual environments not launching correctly when created from a Store installation.

```APIDOC
## Virtual Environment Launch Fix

### Description
Resolves an issue where virtual environments created from a Microsoft Store installation would not launch correctly.

### Method
N/A (Informational)

### Endpoint
N/A

### Parameters
N/A

### Request Example
N/A

### Response
N/A
```

--------------------------------

### Build and Upload Python Package

Source: https://github.com/python/cpython/blob/main/Doc/whatsnew/2.5.rst

Commands for building a package distribution using Distutils and uploading it to PyPI. Supports GPG signing with identity.

```bash
python setup.py sdist
python setup.py upload
python setup.py upload --sign --identity="Your GPG Key ID"
```

--------------------------------

### GET /window/getparyx

Source: https://github.com/python/cpython/blob/main/Doc/library/curses.rst

Gets the parent coordinates of the window.

```APIDOC
## GET /window/getparyx

### Description
Return the beginning coordinates of this window relative to its parent window as a tuple `(y, x)`. Return `(-1, -1)` if this window has no parent.

### Method
GET

### Endpoint
/window/getparyx

### Response
#### Success Response (200)
- **y** (int) - The y-coordinate relative to the parent.
- **x** (int) - The x-coordinate relative to the parent.

#### Response Example
```json
{
  "y": 10,
  "x": 20
}
```
```

--------------------------------

### Example Output of Rotating Log Files

Source: https://github.com/python/cpython/blob/main/Doc/howto/logging-cookbook.rst

This output shows the filenames generated by the `RotatingFileHandler` example. It lists the main log file and its backup files, indicating that the log rotation mechanism has successfully created multiple files with sequential numbering.

```none
logging_rotatingfile_example.out
logging_rotatingfile_example.out.1
logging_rotatingfile_example.out.2
logging_rotatingfile_example.out.3
logging_rotatingfile_example.out.4
logging_rotatingfile_example.out.5
```

--------------------------------

### Site Module Command Line - User Base (Shell)

Source: https://github.com/python/cpython/blob/main/Doc/library/site.rst

Demonstrates how to use the 'site' module from the command line to display the user base directory path using the --user-base option.

```shell
python -m site --user-base
```

--------------------------------

### Create and Execute Code in a Python Interpreter

Source: https://github.com/python/cpython/blob/main/Doc/library/concurrent.interpreters.rst

Demonstrates how to create a new Python interpreter instance and execute simple Python code strings within it. Includes examples of executing single and multi-line strings, and using `textwrap.dedent` for cleaner multi-line code execution.

```python
from concurrent import interpreters

interp = interpreters.create()

# Run in the current OS thread.

interp.exec('print("spam!")')

interp.exec("""if True:
    print('spam!')
    """)

from textwrap import dedent
interp.exec(dedent("""
    print('spam!')
    """
))

```

--------------------------------

### Enabling Python perf support via -X option

Source: https://github.com/python/cpython/blob/main/Doc/howto/perf_profiling.rst

This example illustrates enabling Python's 'perf' profiling support directly via the command-line '-X perf' option. This method provides an alternative to using environment variables for activating profiling.

```shell
python -X perf my_script.py
```

--------------------------------

### Client Socket Example (Default Context)

Source: https://github.com/python/cpython/blob/main/Doc/library/ssl.rst

Demonstrates how to create a client socket connection with default SSL context and IPv4/IPv6 dual stack support.

```APIDOC
## GET /client/connection/default

### Description
Establishes a secure client socket connection using the default SSL context.

### Method
GET

### Endpoint
/client/connection/default

### Parameters
#### Query Parameters
- **hostname** (string) - Required - The hostname to connect to.

### Request Example
```http
GET /client/connection/default?hostname=www.python.org
```

### Response
#### Success Response (200)
- **protocol_version** (string) - The TLS/SSL protocol version used for the connection.

#### Response Example
```json
{
  "protocol_version": "TLSv1.3"
}
```
```

--------------------------------

### Match-Case with Class Pattern Matching

Source: https://github.com/python/cpython/blob/main/Doc/tutorial/controlflow.rst

Shows how to match instances of custom classes using attribute-based patterns. It demonstrates matching specific attributes and general instances.

```python
class Point:
    def __init__(self, x, y):
        self.x = x
        self.y = y

def where_is(point):
    match point:
        case Point(x=0, y=0):
            print("Origin")
        case Point(x=0, y=y):
            print(f"Y={y}")
        case Point(x=x, y=0):
            print(f"X={x}")
        case Point():
            print("Somewhere else")
        case _:
            print("Not a point")
```

--------------------------------

### Python Constant Expression Example

Source: https://github.com/python/cpython/blob/main/Lib/test/test_ast/data/ast_repr.txt

Shows the AST representation of a simple constant value as an expression.

```python
Module(body=[Expr(value=Constant(value=1, kind=None))], type_ignores=[])
```

--------------------------------

### Tkinter Application Startup in IDLE vs. Standard Python

Source: https://github.com/python/cpython/blob/main/Lib/idlelib/help.html

Illustrates the difference in initiating a Tkinter application between IDLE and standard Python. IDLE automatically displays the Tk window and updates it, whereas standard Python requires an explicit `root.update()` call to render changes.

```python
import tkinter as tk
root = tk.Tk()
b = tk.Button(root, text='button')
b.pack()
```

--------------------------------

### Update macOS installer to use SQLite 3.45.3

Source: https://github.com/python/cpython/blob/main/Misc/NEWS.d/3.13.0b1.rst

The macOS installer has been updated to use SQLite version 3.45.3. This brings the latest SQLite features and fixes to macOS Python installations.

```text
.. date: 2024-04-15-21-19-39
.. gh-issue: 115009
.. nonce: IdxH9N
.. section: macOS

Update macOS installer to use SQLite 3.45.3.
```

--------------------------------

### Stricter installer rules for Python launcher on Windows

Source: https://github.com/python/cpython/blob/main/Misc/NEWS.d/3.13.0a5.rst

The Python installer on Windows now enforces stricter rules for updating the launcher. It disables the launcher installation option if multiple launchers exist and prevents downgrades, improving consistency for users.

```windows
The installer now has more strict rules about updating the :ref:`launcher`.
In general, most users only have a single launcher installed and will see no
difference. When multiple launchers have been installed, the option to
install the launcher is disabled until all but one have been removed.
Downgrading the launcher (which was never allowed) is now more obviously
blocked.
```

--------------------------------

### Python String Prefixes Example

Source: https://github.com/python/cpython/blob/main/Doc/reference/lexical_analysis.rst

Demonstrates the usage of various string literal prefixes in Python, such as bytes, formatted, and raw strings.

```python
b"data"
f'{result=}'
```

--------------------------------

### Python Async Function Definition Examples

Source: https://github.com/python/cpython/blob/main/Lib/test/test_ast/data/ast_repr.txt

Illustrates AST representations for async function definitions, including basic structure, async for loops, and async with statements.

```python
Module(body=[AsyncFunctionDef(name='f', args=arguments(posonlyargs=[], args=[], vararg=None, kwonlyargs=[], kw_defaults=[], kwarg=None, defaults=[]), body=[Expr(value=Constant(...)), Expr(value=Await(...))], decorator_list=[], returns=None, type_comment=None, type_params=[])], type_ignores=[])
```

```python
Module(body=[AsyncFunctionDef(name='f', args=arguments(posonlyargs=[], args=[], vararg=None, kwonlyargs=[], kw_defaults=[], kwarg=None, defaults=[]), body=[AsyncFor(target=Name(...), iter=Name(...), body=[Expr(...)], orelse=[Expr(...)], type_comment=None)], decorator_list=[], returns=None, type_comment=None, type_params=[])], type_ignores=[])
```

```python
Module(body=[AsyncFunctionDef(name='f', args=arguments(posonlyargs=[], args=[], vararg=None, kwonlyargs=[], kw_defaults=[], kwarg=None, defaults=[]), body=[AsyncWith(items=[withitem(...)], body=[Expr(...)], type_comment=None)], decorator_list=[], returns=None, type_comment=None, type_params=[])], type_ignores=[])
```

--------------------------------

### Setting a breakpoint in a doctest example

Source: https://github.com/python/cpython/blob/main/Doc/library/doctest.rst

This snippet demonstrates how to insert `pdb.set_trace()` within a doctest example to enable interactive debugging. When the doctest runs, execution will pause at this line, allowing inspection of variables and stepping through the code.

```python
"""
>>> def f(x):
...     g(x*2)
>>> def g(x):
...     print(x+3)
...     import pdb; pdb.set_trace()
>>> f(3)
9
"""
```

--------------------------------

### Python: Configure STARTUPINFO for Subprocess Creation

Source: https://github.com/python/cpython/blob/main/Doc/library/subprocess.rst

Demonstrates how to set STARTUPINFO flags to use standard handles and control window visibility for a new process. Requires the subprocess module.

```python
import subprocess

si = subprocess.STARTUPINFO()
si.dwFlags = subprocess.STARTF_USESTDHANDLES | subprocess.STARTF_USESHOWWINDOW
```

--------------------------------

### Update Windows Installer SQLite Version (Windows)

Source: https://github.com/python/cpython/blob/main/Misc/NEWS.d/3.11.0a5.rst

The Windows installer has been updated to use SQLite version 3.37.2. This ensures the installer utilizes the latest stable version of the SQLite library.

```Windows
Update Windows installer to use SQLite 3.37.2.
```

--------------------------------

### IDLE Command-Line Options Overview

Source: https://github.com/python/cpython/blob/main/Doc/library/idle.rst

This section lists and explains the command-line options for starting IDLE. These options control the initial state and behavior of the IDLE environment, such as opening specific windows or running scripts.

```shell
python -m idlelib
```

```shell
IDLE --debugger --shell
```

```shell
IDLE --editor
```

```shell
IDLE --help
```

```shell
IDLE --run <file>
```

```shell
IDLE --startup-file <file>
```

```shell
IDLE --title <title>
```

```shell
IDLE -
```

--------------------------------

### Quiet Offline Python Installer Layout

Source: https://github.com/python/cpython/blob/main/Doc/using/windows.rst

Command to create an offline Python installer layout without displaying the progress. This is useful for scripting or unattended operations.

```bash
python-3.9.0.exe /layout [optional target directory] /quiet
```

--------------------------------

### Conditional Distutils Setup for New Keywords

Source: https://github.com/python/cpython/blob/main/Doc/whatsnew/2.3.rst

This Python code snippet demonstrates how to conditionally use new keyword arguments in distutils.setup based on the distutils version.

```python
from distutils import core
from distutils.extension import Extension

kw = {'sources': 'foo.c'}

# Check if the distutils version supports get_distutil_options
if hasattr(core, 'get_distutil_options'):
    kw['depends'] = ['foo.h']

ext = Extension(**kw)

# You would typically pass 'ext' to core.setup()
# core.setup(ext_modules=[ext])

```

--------------------------------

### optparse 'store_const' Action Example

Source: https://github.com/python/cpython/blob/main/Doc/library/optparse.rst

Illustrates the 'store_const' action, which stores a predefined constant value to a destination. This is useful for setting flags or different states based on option presence. The example shows how to use 'const' and 'dest' attributes.

```python
parser.add_option("-q", "--quiet",
                  action="store_const", const=0, dest="verbose")
parser.add_option("-v", "--verbose",
                  action="store_const", const=1, dest="verbose")
parser.add_option("--noisy",
                  action="store_const", const=2, dest="verbose")

# If "--noisy" is seen, options.verbose will be set to 2.
```

--------------------------------

### Python Inspect Module Setup

Source: https://github.com/python/cpython/blob/main/Doc/library/inspect.rst

Imports the inspect module and all its functions for use in tests. This is a common setup for testing functionalities within the inspect module.

```python
import inspect
from inspect import *
```

--------------------------------

### Fetch URL with Request Object

Source: https://github.com/python/cpython/blob/main/Doc/howto/urllib2.rst

Demonstrates fetching a URL by creating a urllib.request.Request object first. This approach is more flexible and allows for additional customization like setting headers or sending data.

```python
import urllib.request

req = urllib.request.Request('http://python.org/')
with urllib.request.urlopen(req) as response:
   the_page = response.read()
```

--------------------------------

### Create Server SSL Socket Listening on IPv4

Source: https://github.com/python/cpython/blob/main/Doc/library/ssl.rst

This example demonstrates setting up an SSL server socket. It creates an SSL context for the server, loads a certificate chain and private key, binds to a local address and port, and listens for incoming connections. It then wraps the listening socket for secure communication.

```python
context = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
context.load_cert_chain('/path/to/certchain.pem', '/path/to/private.key')

with socket.socket(socket.AF_INET, socket.SOCK_STREAM, 0) as sock:
    sock.bind(('127.0.0.1', 8443))
    sock.listen(5)
    with context.wrap_socket(sock, server_side=True) as ssock:
        conn, addr = ssock.accept()
        ...
```

--------------------------------

### Install LLVM 19 on Fedora Linux

Source: https://github.com/python/cpython/blob/main/Tools/jit/README.md

Installs LLVM version 19 on Fedora Linux 40 or newer using the DNF package manager.

```shell
sudo dnf install 'clang(major) = 19' 'llvm(major) = 19'
```

--------------------------------

### Thread Start Method

Source: https://github.com/python/cpython/blob/main/Doc/library/threading.rst

Details the `start` method, which begins the thread's activity by invoking the `run` method in a new thread of control.

```APIDOC
## Thread Start Method

### Description
This method starts the thread's activity. It must be called only once per thread object and arranges for the `run` method to be executed in a separate thread.

### Method
`start()`

### Endpoint
N/A (This is a method call on a Thread object)

### Parameters
None

### Request Example
```python
thread.start()
```

### Response
#### Success Response (200)
N/A (This is a method call)

#### Response Example
N/A

### Error Handling
- **RuntimeError**: Raised if `start()` is called more than once on the same thread object.

.. note::
   If supported, the operating system thread name is set to `threading.Thread.name`. This name may be truncated based on OS limits.
```

--------------------------------

### ArgumentParser Initialization Options

Source: https://github.com/python/cpython/blob/main/Doc/library/argparse.rst

Demonstrates how to initialize ArgumentParser with various configuration options like add_help, prefix_chars, exit_on_error, suggest_on_error, and color.

```APIDOC
## ArgumentParser Initialization Configuration

### Description
This section details the various keyword arguments that can be passed during the initialization of an `ArgumentParser` object to customize its behavior.

### Key Initialization Arguments:

*   **add_help** (bool): If `False`, the default help option (-h/--help) is not added.
*   **prefix_chars** (str): Characters used to prefix option strings. If it does not include '-', the help option prefix changes.
*   **exit_on_error** (bool): If `False`, `ArgumentParser` will raise an `ArgumentError` instead of exiting on invalid arguments. (Added in Python 3.9)
*   **suggest_on_error** (bool): If `True`, `ArgumentParser` will suggest valid choices for mistyped arguments. (Added in Python 3.14)
*   **color** (bool): If `False`, help messages will be printed in plain text without ANSI escape sequences. (Added in Python 3.14)

### Examples:

```python
import argparse

# Disable default help option
parser_no_help = argparse.ArgumentParser(prog='PROG', add_help=False)

# Customize help option prefix
parser_custom_prefix = argparse.ArgumentParser(prog='PROG', prefix_chars='+/')

# Disable exit on error
parser_no_exit = argparse.ArgumentParser(exit_on_error=False)
try:
    parser_no_exit.parse_args(['--invalid_arg'])
except argparse.ArgumentError:
    print('Caught ArgumentError')

# Enable suggestions on error
parser_suggestions = argparse.ArgumentParser(suggest_on_error=True)
parser_suggestions.add_argument('--choice', choices=['a', 'b'])
# Example usage: parser_suggestions.parse_args(['--choice', 'c'])

# Disable color output
parser_no_color = argparse.ArgumentParser(color=False)
```
```

--------------------------------

### Python List Comprehension Example

Source: https://github.com/python/cpython/blob/main/Doc/howto/functional.rst

Provides a concrete example of a Python list comprehension iterating over two sequences (`seq1` and `seq2`) to create a list of tuples. It highlights the output format.

```python
seq1 = 'abc'
seq2 = (1, 2, 3)
[(x, y) for x in seq1 for y in seq2]  #doctest: +NORMALIZE_WHITESPACE
```

--------------------------------

### Set Multiprocessing Start Method

Source: https://github.com/python/cpython/blob/main/Doc/library/multiprocessing.rst

Demonstrates how to set the multiprocessing start method for a program.

```APIDOC
## POST /set_start_method

### Description
Sets the start method for creating new processes. This should only be called once in the main module.

### Method
POST

### Endpoint
/

### Parameters
#### Query Parameters
- **method** (string) - Required - The desired start method ('spawn', 'fork', 'forkserver').

### Request Example
```python
import multiprocessing as mp

def foo(q):
    q.put('hello')

if __name__ == '__main__':
    mp.set_start_method('spawn')
    q = mp.Queue()
    p = mp.Process(target=foo, args=(q,))
    p.start()
    print(q.get())
    p.join()
```

### Response
#### Success Response (200)
This operation typically modifies internal state and does not return a specific response body.

#### Response Example
```json
{}
```
```

--------------------------------

### Python Factory Call Example

Source: https://github.com/python/cpython/blob/main/Doc/library/logging.config.rst

Illustrates the expected call to the user-defined factory function 'my.package.customFormatterFactory' with keyword arguments derived from the configuration dictionary.

```python
my.package.customFormatterFactory(bar='baz', spam=99.9, answer=42)
```

--------------------------------

### Python List Indexing and Slicing

Source: https://github.com/python/cpython/blob/main/Doc/tutorial/introduction.rst

Demonstrates accessing elements in a Python list using positive and negative indices, and slicing to create new lists. It highlights that slicing returns a new list.

```python
>>> squares = [1, 4, 9, 16, 25]
>>> squares[0]
1
>>> squares[-3:]
[9, 16, 25]
```

--------------------------------

### ThreadPoolExecutor Usage Example

Source: https://github.com/python/cpython/blob/main/Doc/library/concurrent.futures.rst

Demonstrates how to use ThreadPoolExecutor to fetch multiple URLs concurrently and handle results or exceptions.

```APIDOC
## ThreadPoolExecutor Usage Example

### Description
This example shows how to use `ThreadPoolExecutor` to download web pages concurrently. It uses `executor.submit` to schedule tasks and `concurrent.futures.as_completed` to process results as they become available.

### Method
`submit`, `as_completed`

### Endpoint
N/A (This is a code example, not an HTTP endpoint)

### Parameters
None

### Request Example
```python
import concurrent.futures
import urllib.request

URLS = [
    'http://www.foxnews.com/',
    'http://www.cnn.com/',
    'http://europe.wsj.com/',
    'http://www.bbc.co.uk/',
    'http://nonexistent-subdomain.python.org/'
]

def load_url(url, timeout):
    with urllib.request.urlopen(url, timeout=timeout) as conn:
        return conn.read()

with concurrent.futures.ThreadPoolExecutor(max_workers=5) as executor:
    future_to_url = {executor.submit(load_url, url, 60): url for url in URLS}
    for future in concurrent.futures.as_completed(future_to_url):
        url = future_to_url[future]
        try:
            data = future.result()
        except Exception as exc:
            print(f'{url!r} generated an exception: {exc}')
        else:
            print(f'{url!r} page is {len(data)} bytes')
```

### Response
#### Success Response (200)
Prints the size of each successfully downloaded page.

#### Response Example
```
'http://www.foxnews.com/' page is 150000 bytes
'http://www.cnn.com/' page is 200000 bytes
'http://europe.wsj.com/' page is 180000 bytes
'http://www.bbc.co.uk/' page is 160000 bytes
'http://nonexistent-subdomain.python.org/' generated an exception: <urlopen error [Errno -2] Name or service not known>
```
```

--------------------------------

### Update Gmane domain for NNTP examples

Source: https://github.com/python/cpython/blob/main/Misc/NEWS.d/3.9.0a3.rst

The Gmane domain used in examples for the `NNTP` news reader server and `nntplib` tests has been updated from `news.gmane.org` to `news.gmane.io`.

```python
# Updated example usage for NNTP
# Assuming 'nntplib' is imported
```

--------------------------------

### Process information with multiprocessing.Process and os module

Source: https://github.com/python/cpython/blob/main/Doc/library/multiprocessing.rst

An expanded example showing how to get process information like parent process ID and current process ID using the `os` module within a multiprocessing context. This helps in understanding the process hierarchy and execution flow. It also emphasizes the necessity of the `if __name__ == '__main__'` guard for correct execution.

```python
from multiprocessing import Process
import os

def info(title):
    print(title)
    print('module name:', __name__)
    print('parent process:', os.getppid())
    print('process id:', os.getpid())

def f(name):
    info('function f')
    print('hello', name)

if __name__ == '__main__':
    info('main line')
    p = Process(target=f, args=('bob',))
    p.start()
    p.join()
```

--------------------------------

### Update Windows installer to use libmpdecimal 4.0.0

Source: https://github.com/python/cpython/blob/main/Misc/NEWS.d/3.13.0b1.rst

The Windows installer has been updated to utilize libmpdecimal version 4.0.0. This change may affect how decimal numbers are handled in applications built with this installer.

```text
.. date: 2024-05-02-09-28-04
.. gh-issue: 115119
.. nonce: cUKMXo
.. section: Windows

Update Windows installer to use libmpdecimal 4.0.0.
```

--------------------------------

### Create Dictionary using keyword arguments

Source: https://github.com/python/cpython/blob/main/Doc/whatsnew/2.3.rst

Shows how to use the `dict()` constructor with keyword arguments to create dictionaries, simplifying the creation of small dictionaries.

```python
>>> dict(red=1, blue=2, green=3, black=4)
{'blue': 2, 'black': 4, 'green': 3, 'red': 1}
```

--------------------------------

### Python Import Examples

Source: https://github.com/python/cpython/blob/main/Doc/reference/simple_stmts.rst

Demonstrates various ways to import modules and attributes in Python, including aliasing and importing specific attributes.

```python
import foo
import foo.bar.baz
import foo.bar.baz as fbb
from foo.bar import baz
from foo import attr
```

--------------------------------

### Formatter Initialization

Source: https://github.com/python/cpython/blob/main/Doc/howto/logging.rst

Describes the constructor for the `logging.Formatter` class.

```APIDOC
## Formatter Initialization

### Description
This section details how to instantiate `logging.Formatter` objects to control the structure and content of log messages.

### Method Signature
`logging.Formatter(fmt=None, datefmt=None, style='%')`

### Parameters
- **fmt** (`str`, optional): The message format string. If `None`, a default format is used.
- **datefmt** (`str`, optional): The date format string. If `None`, `asctime` will be formatted using a default format.
- **style** (`str`, optional): A character indicating the type of format string used ('%', '{', or '$'). Defaults to '%'.

### Example Initialization
```python
import logging

# Initialize a formatter with a specific format string
formatter = logging.Formatter('%(levelname)s:%(name)s:%(message)s', datefmt='%Y-%m-%d %H:%M:%S')

# Initialize a formatter with default settings
# default_formatter = logging.Formatter()
```
```

--------------------------------

### Install Python stdlib in Browser using Emscripten

Source: https://github.com/python/cpython/blob/main/Tools/wasm/README.md

This snippet shows how to install the Python standard library in a browser environment by fetching a zip archive and writing it to the Emscripten file system. It includes necessary steps for creating directories and managing run dependencies.

```javascript
import createEmscriptenModule from "./python.mjs";

await createEmscriptenModule({
  async preRun(Module) {
    Module.FS.mkdirTree("/lib/python3.14/lib-dynload/");
    Module.addRunDependency("install-stdlib");
    const resp = await fetch("python3.14.zip");
    const stdlibBuffer = await resp.arrayBuffer();
    Module.FS.writeFile(`/lib/python314.zip`, new Uint8Array(stdlibBuffer), {
      canOwn: true,
    });
    Module.removeRunDependency("install-stdlib");
  },
});
```

--------------------------------

### BaseRequestHandler Methods and Attributes

Source: https://github.com/python/cpython/blob/main/Doc/library/socketserver.rst

Documentation for the BaseRequestHandler class, including methods for setup, handling requests, and finishing, along with its key attributes.

```APIDOC
## GET /setup

### Description
Called before the handle method to perform any initialization actions required. The default implementation does nothing.

### Method
GET

### Endpoint
/setup

### Parameters
#### Query Parameters
- None

#### Request Body
- None

### Response
#### Success Response (200)
- None

#### Response Example
- None
```

```APIDOC
## POST /handle

### Description
This function must do all the work required to service a request. The default implementation does nothing. Several instance attributes are available to it; the request is available as request; the client address as client_address; and the server instance as server, in case it needs access to per-server information.

The type of request is different for datagram or stream services. For stream services, request is a socket object; for datagram services, request is a pair of string and socket.

### Method
POST

### Endpoint
/handle

### Parameters
#### Query Parameters
- None

#### Request Body
- **request** (socket | tuple) - The request data.
- **client_address** (tuple) - The client's address.
- **server** (object) - The server instance.

### Response
#### Success Response (200)
- None

#### Response Example
- None
```

```APIDOC
## GET /finish

### Description
Called after the handle method to perform any clean-up actions required. The default implementation does nothing. If setup raises an exception, this function will not be called.

### Method
GET

### Endpoint
/finish

### Parameters
#### Query Parameters
- None

#### Request Body
- None

### Response
#### Success Response (200)
- None

#### Response Example
- None
```

```APIDOC
## GET /request_attributes

### Description
Provides access to important attributes within the request handler.

### Method
GET

### Endpoint
/request_attributes

### Parameters
#### Query Parameters
- None

#### Request Body
- None

### Response
#### Success Response (200)
- **request** (socket | tuple) - The socket object or datagram pair for the request.
- **client_address** (tuple) - The address of the client making the request.
- **server** (object) - The server instance handling the request.

#### Response Example
{
  "request": "<socket object>",
  "client_address": ["127.0.0.1", 54321],
  "server": "<BaseServer object>"
}
```

--------------------------------

### xmlparser.StartElementHandler

Source: https://github.com/python/cpython/blob/main/Doc/library/pyexpat.rst

This callback method is invoked at the start of every XML element, providing the element's name and its associated attributes.

```APIDOC
## xmlparser.StartElementHandler

### Description
Called for the start of every element. `name` is a string containing the element name, and `attributes` is the element attributes. If `ordered_attributes` is true, this is a list; otherwise, it's a dictionary mapping names to values.

### Method
Callback

### Endpoint
N/A (Event Handler)

### Parameters
#### Path Parameters
N/A

#### Query Parameters
N/A

#### Handler Arguments
- **name** (string) - Required - The name of the XML element.
- **attributes** (list or dictionary) - Required - The attributes of the element. Its type depends on the `ordered_attributes` setting.

### Request Example
N/A

### Response
#### Success Response (200)
N/A (Callback, no direct HTTP response)

#### Response Example
N/A
```

--------------------------------

### Grammar Start Symbols

Source: https://github.com/python/cpython/blob/main/Doc/c-api/veryhigh.rst

Constants representing start symbols for Python grammar, used with Py_CompileString.

```APIDOC
## Grammar Start Symbols

### Description
These constants define the starting symbols for different types of Python code parsing, used with functions like `Py_CompileString`.

### Symbols
- **Py_eval_input** (int): For isolated expressions.
- **Py_file_input** (int): For sequences of statements, used for compiling arbitrarily long source code.
- **Py_single_input** (int): For a single statement, used in the interactive interpreter loop.
```

--------------------------------

### Python getopt: Optional arguments parsing

Source: https://github.com/python/cpython/blob/main/Doc/library/getopt.rst

Illustrates how to handle optional arguments for options using the getopt function. This example showcases parsing options with both required and optional arguments.

```python
import getopt
s = '-Con -C --color=off --color a1 a2'
args = s.split()
optlist, args = getopt.getopt(args, 'C::', ['color=?'])
print(optlist)
print(args)
```

--------------------------------

### XML-RPC Client Usage Example

Source: https://github.com/python/cpython/blob/main/Doc/library/xmlrpc.client.rst

Demonstrates how to use the XML-RPC client to connect to a server and make calls.

```APIDOC
## XML-RPC Client Usage Example

### Simple Client Usage

```python
from xmlrpc.client import ServerProxy, Error

# Connect to a local server (example)
# server = ServerProxy("http://localhost:8000")

# Connect to a remote server
with ServerProxy("http://betty.userland.com") as proxy:
    print(proxy)
    try:
        # Make a method call
        print(proxy.examples.getStateName(41))
    except Error as v:
        print("ERROR", v)
```

### Client Usage with HTTP Proxy

```python
import http.client
import xmlrpc.client

class ProxiedTransport(xmlrpc.client.Transport):
    def set_proxy(self, host, port=None, headers=None):
        self.proxy = host, port
        self.proxy_headers = headers

    def make_connection(self, host):
        connection = http.client.HTTPConnection(*self.proxy)
        connection.set_tunnel(host, headers=self.proxy_headers)
        self._connection = host, connection
        return connection

# Create a transport instance and set the proxy
transport = ProxiedTransport()
transport.set_proxy('proxy-server', 8080)

# Create a ServerProxy with the custom transport
server = xmlrpc.client.ServerProxy('http://betty.userland.com', transport=transport)
print(server.examples.getStateName(41))
```
```

--------------------------------

### PureWindowsPath

Source: https://github.com/python/cpython/blob/main/Doc/library/pathlib.rst

Explains the PureWindowsPath class for Windows filesystem paths, including UNC paths and provides examples.

```APIDOC
## PureWindowsPath

### Description
Represents Windows filesystem paths, including UNC paths. It inherits from PurePath and provides specific behavior for Windows systems.

### Method
N/A (Constructor)

### Endpoint
N/A

### Parameters
- **pathsegments**: A sequence of path components.

### Request Example
N/A

### Response
#### Success Response (N/A)
- **PureWindowsPath object**: An instance representing a Windows path.

#### Response Example
```python
from pathlib import PureWindowsPath

>>> PureWindowsPath('c:/', 'Users', 'Ximénez')
PureWindowsPath('c:/Users/Ximénez')
>>> PureWindowsPath('//server/share/file')
PureWindowsPath('//server/share/file')
```
```

--------------------------------

### Start Event Loop

Source: https://github.com/python/cpython/blob/main/Doc/library/turtle.rst

Starts the Tkinter event loop, essential for handling events.

```APIDOC
## mainloop / done

### Description
Starts the Tkinter event loop. This method should typically be the last statement in a turtle graphics program to keep the window open and responsive to events. It should not be used when running interactively within IDLE in '-n' mode.

### Method
`screen.mainloop()` or `done()`

### Parameters
None

### Request Example
```python
# ... turtle graphics code ...
screen.mainloop()
```

### Response
#### Success Response (200)
None (This method blocks execution until the event loop is terminated.)

#### Response Example
None
```

--------------------------------

### Fix PATH Repair in Windows Installer

Source: https://github.com/python/cpython/blob/main/Misc/NEWS.d/3.11.0a7.rst

Ensures the 'Add to PATH' option in the Windows installer correctly repairs the path when the installation is modified. This prevents potential issues with the PATH environment variable on Windows.

```text
Prevent :cve:`2022-26488` by ensuring the Add to PATH option in the Windows installer uses the correct path when being repaired.
```

--------------------------------

### Debugging Builds

Source: https://github.com/python/cpython/blob/main/Doc/c-api/intro.rst

Information on enabling and understanding different debugging builds for the Python interpreter.

```APIDOC
## Debugging Builds

### Description
This section covers the configuration and features of Python builds that include extra debugging checks for the interpreter and extension modules.

### Debug Build Macros

- **Py_DEBUG**: Defines a general debug build of Python. Enables extra checks beyond reference counting.
  - **Enabling on Unix**: Use `./configure --with-pydebug`.
  - **Enabling on Windows**: Pass `-d` to `PCbuild/build.bat`. The `_DEBUG` macro also implicitly enables `Py_DEBUG`.
- **Py_TRACE_REFS**: Enables reference tracing. Adds extra fields to `PyObject` to maintain a doubly linked list of active objects and tracks total allocations. Prints all existing references upon exit.

### Additional Resources

- **Misc/SpecialBuilds.txt**: Located in the Python source distribution, this file provides a comprehensive list of available debugging builds and their configurations.
```

--------------------------------

### Perform a GET request to a URL

Source: https://github.com/python/cpython/blob/main/Doc/library/http.client.rst

Demonstrates how to establish an HTTPS connection, send a GET request to a specified host and path, and retrieve the response status and reason. It requires the http.client library.

```python
import http.client

host = "docs.python.org"
conn = http.client.HTTPSConnection(host)
conn.request("GET", "/3/", headers={"Host": host})
response = conn.getresponse()
print(response.status, response.reason)
```

--------------------------------

### IDLE Extension Class Example (Python)

Source: https://github.com/python/cpython/blob/main/Lib/idlelib/extend.txt

A Python class demonstrating the structure of an IDLE extension. It defines menu entries using `menudefs` and includes a method to handle a virtual event.

```python
class ZzDummy:

    menudefs = [
        ('format', [
            ('Z in', '<<z-in>>'),
            ('Z out', '<<z-out>>'),
        ] )
    ]

    def __init__(self, editwin):
        self.editwin = editwin

    def z_in_event(self, event=None):
        """...Do what you want here..."""

```

--------------------------------

### Run Statistical Profiler on a Process (CLI)

Source: https://github.com/python/cpython/blob/main/Doc/library/profile.rst

This command initiates statistical profiling on a specified running process ID (PID). It's recommended for production environments due to minimal overhead.

```bash
python -m profiling.sampling 1234
```

--------------------------------

### Install Activation Scripts for Virtual Environment

Source: https://github.com/python/cpython/blob/main/Doc/library/venv.rst

Installs platform-appropriate activation scripts into the virtual environment. These scripts are used to activate and deactivate the virtual environment in different shells.

```python
class EnvBuilder:
    # ... (other methods)

    def setup_scripts(self, context):
        """
        Installs activation scripts appropriate to the platform into the virtual
        environment.
        """
        # Implementation details for installing activation scripts
        pass
```

--------------------------------

### Test Examples in a File

Source: https://github.com/python/cpython/blob/main/Doc/library/doctest.rst

The `testfile` function tests examples within a specified file. It supports various options for interpreting the filename, specifying the test name, base package, execution globals, verbosity, reporting, option flags, error handling, and parsing.

```APIDOC
## testfile

### Description
Tests examples in the file named *filename*. Returns ``(failure_count, test_count)``.

### Method
N/A (Function)

### Parameters
#### Path Parameters
None

#### Query Parameters
None

#### Request Body
None

### Request Example
```python
doctest.testfile("example.txt", "-v")
```

### Response
#### Success Response (200)
Tuple of (failure_count, test_count)

#### Response Example
```json
{
  "example": "(0, 5)"
}
```

### Arguments
- **filename** (str) - Required - The path to the file containing doctests.
- **module_relative** (bool) - Optional - If True, interprets filename as a module-relative path. Defaults to True.
- **name** (str) - Optional - The name of the test. Defaults to the basename of filename.
- **package** (str or module) - Optional - The package to use as the base directory for module-relative filenames. Defaults to the calling module's directory.
- **globs** (dict) - Optional - A dictionary to be used as the globals when executing examples. Defaults to an empty dictionary.
- **verbose** (bool) - Optional - If True, prints detailed output. Defaults to True if '-v' is in sys.argv, else False.
- **report** (bool) - Optional - If True, prints a summary at the end. Defaults to True.
- **optionflags** (int) - Optional - Bitwise OR of option flags. Defaults to 0.
- **extraglobs** (dict) - Optional - A dictionary to be merged into the globals for example execution.
- **raise_on_error** (bool) - Optional - If True, raises an exception upon the first failure or unexpected exception. Defaults to False.
- **parser** (DocTestParser) - Optional - A DocTestParser (or subclass) to extract tests. Defaults to DocTestParser().
- **encoding** (str) - Optional - The encoding to use when converting the file to unicode.
```

--------------------------------

### sitecustomize Module Initialization

Source: https://github.com/python/cpython/blob/main/Doc/library/site.rst

Describes the behavior of the sitecustomize module, which can perform arbitrary site-specific customizations. It's imported after path manipulations and failures are silently ignored under specific conditions.

```python
import sitecustomize

# If sitecustomize exists and can be imported, its code is executed.
# If it raises an ImportError with name 'sitecustomize', it's ignored.
# Other exceptions cause silent process failure.
```

--------------------------------

### make_server

Source: https://github.com/python/cpython/blob/main/Doc/library/wsgiref.rst

Creates a new WSGI server listening on a specified host and port, accepting connections for a given WSGI application.

```APIDOC
## make_server

### Description
Create a new WSGI server listening on *host* and *port*, accepting connections for *app*.

### Method
function

### Endpoint
N/A

### Parameters
#### Path Parameters
None

#### Query Parameters
None

#### Request Body
None

### Request Example
```python
from wsgiref.simple_server import make_server, demo_app

with make_server('', 8000, demo_app) as httpd:
    print("Serving HTTP on port 8000...")
    httpd.serve_forever()
```

### Response
#### Success Response (200)
N/A

#### Response Example
N/A
```

--------------------------------

### Logger Configuration and Usage

Source: https://github.com/python/cpython/blob/main/Doc/howto/logging.rst

Explains how to get logger instances, set levels, and understand message propagation.

```APIDOC
## Logger Operations

### Description
This section describes how to obtain logger instances, manage their levels, and understand how log messages propagate through the logging hierarchy.

### Methods
- `getLogger(name)`: Returns a logger instance. If `name` is not provided, it returns the root logger.
- `Logger.setLevel(level)`: Sets the logging level for the logger.
- `Logger.propagate`: A boolean attribute to control message propagation to ancestor loggers.

### Concepts
- **Effective Level**: The level of a logger, determined by its own level or inherited from its ancestors.
- **Propagation**: The process by which messages are passed up the logger hierarchy to ancestor handlers.

### Example Usage
```python
import logging

# Get a logger instance
logger = logging.getLogger('my_module')

# Set its level
logger.setLevel(logging.INFO)

# Log a message
logger.info('This is an informational message.')

# Disable propagation
logger.propagate = False
```
```

--------------------------------

### Enable py.exe Launcher Installation on Windows ARM64

Source: https://github.com/python/cpython/blob/main/Misc/NEWS.d/3.11.0a7.rst

Enables the installation of the 'py.exe' launcher on Windows ARM64 architecture. This facilitates the use of the Python launcher on a wider range of Windows systems.

```text
Enables installing the :file:`py.exe` launcher on Windows ARM64.
```

--------------------------------

### Doctest directive for normalizing whitespace

Source: https://github.com/python/cpython/blob/main/Doc/library/doctest.rst

Shows how to use the '+NORMALIZE_WHITESPACE' directive to make doctest examples tolerant of variations in whitespace.

```python
>>> print(list(range(20)))  # doctest: +NORMALIZE_WHITESPACE
[0,   1,  2,  3,  4,  5,  6,  7,  8,  9,
10,  11, 12, 13, 14, 15, 16, 17, 18, 19]
```

--------------------------------

### Python SimpleXMLRPCServer Example with Function and Instance Registration

Source: https://github.com/python/cpython/blob/main/Doc/library/xmlrpc.server.rst

This Python code demonstrates setting up an XML-RPC server, registering a built-in function (pow), a custom function (adder_function) under a specific name ('add'), and an instance (MyFuncs) with its methods. It also includes registering introspection functions and handling requests for a specific RPC path.

```python
from xmlrpc.server import SimpleXMLRPCServer
from xmlrpc.server import SimpleXMLRPCRequestHandler

# Restrict to a particular path.
class RequestHandler(SimpleXMLRPCRequestHandler):
    rpc_paths = ('/RPC2',)

# Create server
with SimpleXMLRPCServer(('localhost', 8000),
                        requestHandler=RequestHandler) as server:
    server.register_introspection_functions()

    # Register pow() function; this will use the value of
    # pow.__name__ as the name, which is just 'pow'.
    server.register_function(pow)

    # Register a function under a different name
    def adder_function(x, y):
        return x + y
    server.register_function(adder_function, 'add')

    # Register an instance; all the methods of the instance are
    # published as XML-RPC methods (in this case, just 'mul').
    class MyFuncs:
        def mul(self, x, y):
            return x * y

    server.register_instance(MyFuncs())

    # Run the server's main loop
    server.serve_forever()
```

--------------------------------

### Compare Python SequenceMatcher Ratio Methods

Source: https://github.com/python/cpython/blob/main/Doc/library/difflib.rst

This example compares the similarity ratios returned by `SequenceMatcher.ratio()`, `SequenceMatcher.quick_ratio()`, and `SequenceMatcher.real_quick_ratio()`. It demonstrates that `quick_ratio` and `real_quick_ratio` provide upper bounds on the similarity and can sometimes differ from the exact `ratio`, especially for `real_quick_ratio` which is computed very quickly but might be less precise.

```python
s = SequenceMatcher(None, "abcd", "bcde")
s.ratio()
s.quick_ratio()
s.real_quick_ratio()
```

--------------------------------

### Decimal Context Arithmetic Methods (Examples)

Source: https://github.com/python/cpython/blob/main/Doc/library/decimal.rst

Provides examples of various arithmetic methods available in the Context class, such as absolute value, addition, division, and sign manipulation. These methods operate within the specified context.

```python
>>> from decimal import Context, Decimal
>>> C = Context()
>>> C.abs(Decimal('-5'))
Decimal('5')
>>> C.add(Decimal('2'), Decimal('3'))
Decimal('5')
>>> C.divide(Decimal('10'), Decimal('2'))
Decimal('5')
>>> C.copy_abs(Decimal('-5'))
Decimal('5')
>>> C.copy_negate(Decimal('5'))
Decimal('-5')
>>> C.copy_sign(Decimal('-5'), Decimal('10'))
Decimal('5')
>>> C.compare(Decimal('5'), Decimal('10'))
-1
>>> C.compare_signal(Decimal('5'), Decimal('NaN'))
-1
>>> C.compare_total(Decimal('1.0'), Decimal('1.00'))
0
>>> C.compare_total_mag(Decimal('-1.0'), Decimal('1.00'))
0
>>> C.canonical(Decimal('1.23'))
Decimal('1.23')
>>> C.create_decimal('10')
Decimal('10')
```

--------------------------------

### Profiler Sampling Method

Source: https://github.com/python/cpython/blob/main/Doc/library/profile.rst

Details the `sample` method, which samples the target process for a specified duration, collecting stack traces and passing them to a collector.

```APIDOC
## profiler.sample(collector, duration_sec=10)

### Description
Samples the target process for the specified duration. Collects stack traces from the target process at regular intervals and passes them to the provided collector for processing. The method tracks sampling statistics and can display real-time information if `realtime_stats` is enabled.

### Method
`sample`

### Endpoint
N/A (Method within a class/module)

### Parameters
#### Path Parameters
N/A

#### Query Parameters
N/A

#### Request Body
- **collector** (object) - Required - Object that implements ``collect()`` method to process stack traces
- **duration_sec** (int) - Optional - Duration to sample in seconds (default: 10)
```

--------------------------------

### Python Multi-line Statement Example

Source: https://github.com/python/cpython/blob/main/Doc/tutorial/interpreter.rst

An example of entering a multi-line Python construct (an if statement) in interactive mode, showing the use of the secondary prompt.

```python
>>> the_world_is_flat = True
>>> if the_world_is_flat:
...     print("Be careful not to fall off!")
...
Be careful not to fall off!
```

--------------------------------

### SQLite Integration

Source: https://github.com/python/cpython/blob/main/Misc/NEWS.d/3.11.0a7.rst

Information on how the `configure` script now verifies SQLite C APIs and updates to SQLite versions in installers.

```APIDOC
## SQLite Integration

### Description
This section covers changes related to SQLite integration. The `configure` script now verifies that all necessary SQLite C APIs for the `sqlite3` extension module are present. Additionally, Windows installers have been updated to use SQLite version 3.38.1.

### Method
N/A

### Endpoint
N/A

### Parameters
N/A

### Request Example
N/A

### Response
N/A
```

--------------------------------

### Python Import Statement Examples

Source: https://github.com/python/cpython/blob/main/Lib/test/test_ast/data/ast_repr.txt

Illustrates the AST nodes for different types of import statements, including direct imports and aliased imports from modules.

```python
Module(body=[Import(names=[alias(name='sys', asname=None)])], type_ignores=[])
```

```python
Module(body=[Import(names=[alias(name='foo', asname='bar')])], type_ignores=[])
```

```python
Module(body=[ImportFrom(module='sys', names=[alias(name='x', asname='y')], level=0)], type_ignores=[])
```

```python
Module(body=[ImportFrom(module='sys', names=[alias(name='v', asname=None)], level=0)], type_ignores=[])
```

--------------------------------

### Test Examples in Docstrings

Source: https://github.com/python/cpython/blob/main/Doc/library/doctest.rst

The `testmod` function tests examples found in the docstrings of functions and classes reachable from a given module. It accepts arguments to control verbosity, reporting, and error handling.

```APIDOC
## testmod

### Description
Tests examples in docstrings in functions and classes reachable from module *m*.

### Method
N/A (Function)

### Parameters
#### Path Parameters
None

#### Query Parameters
None

#### Request Body
None

### Request Example
```python
import doctest
import my_module

doctest.testmod(my_module, "-v")
```

### Response
#### Success Response (200)
Tuple of (failure_count, test_count)

#### Response Example
```json
{
  "example": "(0, 10)"
}
```

### Arguments
- **m** (module) - Optional - The module to test. Defaults to the caller's module.
- **name** (str) - Optional - The name of the test. Defaults to the module's name.
- **globs** (dict) - Optional - A dictionary to be used as the globals when executing examples. Defaults to the module's globals.
- **verbose** (bool) - Optional - If True, prints detailed output. Defaults to True if '-v' is in sys.argv, else False.
- **report** (bool) - Optional - If True, prints a summary at the end. Defaults to True.
- **optionflags** (int) - Optional - Bitwise OR of option flags. Defaults to 0.
- **extraglobs** (dict) - Optional - A dictionary to be merged into the globals for example execution.
- **raise_on_error** (bool) - Optional - If True, raises an exception upon the first failure or unexpected exception. Defaults to False.
- **exclude_empty** (bool) - Optional - If True, skips empty docstrings. Defaults to False.
```

--------------------------------

### PyMem_SetupDebugHooks Function

Source: https://github.com/python/cpython/blob/main/Doc/c-api/memory.rst

Details the functionality and version changes for the PyMem_SetupDebugHooks function.

```APIDOC
## PyMem_SetupDebugHooks Function

### Description
Configures debug hooks for memory allocation, which can help in diagnosing memory-related issues.

### Version Changes
- **3.6**: ``PyMem_SetupDebugHooks`` now works in release mode. On error, it uses ``tracemalloc`` for tracebacks. It also checks for attached thread states for ``PYMEM_DOMAIN_OBJ`` and ``PYMEM_DOMAIN_MEM`` domains.
```

--------------------------------

### Python Assert Statement Examples

Source: https://github.com/python/cpython/blob/main/Lib/test/test_ast/data/ast_repr.txt

Shows the AST representation of assert statements, with and without an optional error message.

```python
Module(body=[Assert(test=Name(id='v', ctx=Load(...)), msg=None)], type_ignores=[])
```

```python
Module(body=[Assert(test=Name(id='v', ctx=Load(...)), msg=Constant(value='message', kind=None))], type_ignores=[])
```

--------------------------------

### script_from_examples

Source: https://github.com/python/cpython/blob/main/Doc/library/doctest.rst

Converts text containing doctest examples into a Python script format. Non-example text is converted to comments.

```APIDOC
## script_from_examples

### Description
Converts a string containing doctest examples into a Python script. Doctest examples are transformed into executable code, while other text is converted into comments. This function is useful for generating runnable scripts from interactive session examples.

### Method
`script_from_examples(s)`

### Endpoint
N/A

### Parameters
#### Path Parameters
N/A

#### Query Parameters
N/A

#### Request Body
- **s** (string) - Required - A string containing doctest examples.

### Request Example
```python
import doctest
print(doctest.script_from_examples(r"""
    Set x and y to 1 and 2.
    >>> x, y = 1, 2

    Print their sum:
    >>> print(x+y)
    3
"""))
```

### Response
#### Success Response (200)
- **output** (string) - The generated Python script.

#### Response Example
```
# Set x and y to 1 and 2.
x, y = 1, 2
#
# Print their sum:
print(x+y)
# Expected:
## 3
```
```

--------------------------------

### Making GET Request with Parameters

Source: https://github.com/python/cpython/blob/main/Doc/library/urllib.request.rst

Illustrates how to construct and make a GET request with URL parameters using urllib.request and urllib.parse.

```APIDOC
## GET Request with Parameters

### Description
Constructs a URL with query parameters using `urllib.parse.urlencode` and retrieves the content using `urllib.request.urlopen`.

### Method
GET

### Endpoint
urllib.request.urlopen(url)

### Parameters
#### Query Parameters
- **params** (dict) - Required - A dictionary of parameters to be encoded and appended to the URL.

### Request Example
```python
import urllib.request
import urllib.parse

params = urllib.parse.urlencode({'spam': 1, 'eggs': 2, 'bacon': 0})
url = "http://www.musi-cal.com/cgi-bin/query?%s" % params

with urllib.request.urlopen(url) as f:
    print(f.read().decode('utf-8'))
```

### Response
#### Success Response (200)
- **body** (string) - The response body from the server.

#### Response Example
```json
{
  "data": "Results..."
}
```
```

--------------------------------

### Python str.format(): Basic Usage

Source: https://github.com/python/cpython/blob/main/Doc/tutorial/inputoutput.rst

Demonstrates the fundamental usage of the str.format() method to insert values into a string. It replaces placeholders (curly braces) with the provided arguments.

```python
>>> print('We are the {} who say "{}"!'.format('knights', 'Ni'))
We are the knights who say "Ni!"
```

--------------------------------

### Run a WSGI Application with wsgiref

Source: https://github.com/python/cpython/blob/main/Doc/whatsnew/2.5.rst

This Python snippet demonstrates how to start a simple WSGI server using the `wsgiref` module. It requires a WSGI-compliant application object. The server listens on all interfaces by default and serves on port 8000.

```python
from wsgiref import simple_server

wsgi_app = ...

host = ''
port = 8000
httpd = simple_server.make_server(host, port, wsgi_app)
httpd.serve_forever()
```

--------------------------------

### Python Path.joinpath Example

Source: https://github.com/python/cpython/blob/main/Doc/library/importlib.resources.abc.rst

Demonstrates creating a nested file path using the joinpath method. The joinpath method accepts multiple path segments and supports forward slashes as separators.

```python
files.joinpath('subdir').joinpath('subsubdir').joinpath('file.txt')
```

--------------------------------

### GET /window/getyx

Source: https://github.com/python/cpython/blob/main/Doc/library/curses.rst

Gets the current cursor position within the window.

```APIDOC
## GET /window/getyx

### Description
Return a tuple `(y, x)` of current cursor position relative to the window's upper-left corner.

### Method
GET

### Endpoint
/window/getyx

### Response
#### Success Response (200)
- **y** (int) - The current y-coordinate of the cursor.
- **x** (int) - The current x-coordinate of the cursor.

#### Response Example
```json
{
  "y": 5,
  "x": 10
}
```
```

--------------------------------

### Running Python with Specific Architecture using `arch`

Source: https://github.com/python/cpython/blob/main/Mac/README.rst

Demonstrates how to execute Python using a specific architecture (e.g., i386 for 32-bit) via the `arch` command. This is useful for testing or ensuring compatibility with older architectures.

```bash
$ arch -i386 python
```

```bash
$ arch -i386 -ppc python
```

--------------------------------

### Context Manager __enter__ Method Example (Python)

Source: https://github.com/python/cpython/blob/main/Doc/library/stdtypes.rst

Illustrates the __enter__ method of a context manager, specifically showing how file objects return themselves to be used with the 'with' statement.

```python
An example of a context manager that returns itself is a :term:`file object`. File objects return themselves from __enter__() to allow :func:`open` to be used as the context expression in a :keyword:`with` statement.
```

--------------------------------

### Update Windows installer to SQLite 3.44.2

Source: https://github.com/python/cpython/blob/main/Misc/NEWS.d/3.13.0a3.rst

Upgrades the SQLite library used in the Windows installer to version 3.44.2. This update likely includes bug fixes and performance improvements for SQLite operations within the installer.

```python
Update Windows installer to use SQLite 3.44.2.
```

--------------------------------

### Adding Options to a Group with optparse

Source: https://github.com/python/cpython/blob/main/Doc/library/optparse.rst

Demonstrates how to add debug, SQL, and general action print options to a command-line argument parser group using the optparse library.

```python
group.add_option("-d", "--debug", action="store_true",
                 help="Print debug information")
group.add_option("-s", "--sql", action="store_true",
                 help="Print all SQL statements executed")
group.add_option("-e", action="store_true", help="Print every action done")
parser.add_option_group(group)
```

--------------------------------

### Console Output Example (Console)

Source: https://github.com/python/cpython/blob/main/Doc/howto/logging-cookbook.rst

This snippet shows example console output from running the `sender.py` script in two separate shells and the `listener.py` script in a third shell. It illustrates how log messages from different processes are interleaved in the listener's output.

```console
$ python sender.py
DEBUG         myapp    613 Message no.     1
WARNING  myapp.lib2    613 Message no.     2
CRITICAL myapp.lib2    613 Message no.     3
WARNING  myapp.lib2    613 Message no.     4
CRITICAL myapp.lib1    613 Message no.     5
DEBUG         myapp    613 Message no.     6
CRITICAL myapp.lib1    613 Message no.     7
INFO     myapp.lib1    613 Message no.     8
(and so on)

$ python sender.py
INFO     myapp.lib2    657 Message no.     1
CRITICAL myapp.lib2    657 Message no.     2
CRITICAL      myapp    657 Message no.     3
CRITICAL myapp.lib1    657 Message no.     4
INFO     myapp.lib1    657 Message no.     5
WARNING  myapp.lib2    657 Message no.     6
CRITICAL      myapp    657 Message no.     7
DEBUG    myapp.lib1    657 Message no.     8
(and so on)

$ python listener.py
Press Ctrl-C to stop.
DEBUG         myapp    613 Message no.     1
WARNING  myapp.lib2    613 Message no.     2
INFO     myapp.lib2    657 Message no.     1
CRITICAL myapp.lib2    613 Message no.     3
CRITICAL myapp.lib2    657 Message no.     2
CRITICAL      myapp    657 Message no.     3
WARNING  myapp.lib2    613 Message no.     4
CRITICAL myapp.lib1    613 Message no.     5
CRITICAL myapp.lib1    657 Message no.     4
INFO     myapp.lib1    657 Message no.     5
DEBUG         myapp    613 Message no.     6
WARNING  myapp.lib2    657 Message no.     6
CRITICAL      myapp    657 Message no.     7
CRITICAL myapp.lib1    613 Message no.     7
INFO     myapp.lib1    613 Message no.     8
DEBUG    myapp.lib1    657 Message no.     8
(and so on)
```

--------------------------------

### Python Logging Configuration: Basic Example

Source: https://github.com/python/cpython/blob/main/Doc/howto/logging.rst

Demonstrates the basic configuration of the logging system using basicConfig. It sets a default format for log messages and specifies the destination to sys.stderr if no other destination is set.

```python
import logging

logging.basicConfig()
# Example usage:
# logging.debug('This is a debug message')
# logging.info('This is an info message')
# logging.warning('This is a warning message')
# logging.error('This is an error message')
# logging.critical('This is a critical message')
```

--------------------------------

### Bash Script to Install Python Libraries for iOS App

Source: https://github.com/python/cpython/blob/main/Doc/using/ios.rst

This bash script, intended for an Xcode build step, installs Python libraries into the app bundle. It should be placed after 'Copy Bundle Resources' and before 'Embed Frameworks'. The script sources utility functions and installs Python from a specified XCframework.

```bash
set -e
source $PROJECT_DIR/Python.xcframework/build/build_utils.sh
install_python Python.xcframework app
```

--------------------------------

### Include _testinternalcapi in Windows installer

Source: https://github.com/python/cpython/blob/main/Misc/NEWS.d/3.10.0a3.rst

Includes the '_testinternalcapi' module in the Windows installer. This makes the test suite available for execution on Windows systems.

```restructuredtext
.. bpo: 40754
.. date: 2020-11-13-21-51-34
.. nonce: Ekoxkg
.. section: Tests

Include ``_testinternalcapi`` module in Windows installer for test suite

..
```

--------------------------------

### Example Python script for DOM manipulation

Source: https://github.com/python/cpython/blob/main/Doc/library/xml.dom.minidom.rst

This is a placeholder for an example Python script that demonstrates realistic usage of DOM manipulation. The actual code would be included via a literal include directive in the original documentation.

```python
# ../includes/minidom-example.py
```

--------------------------------

### Verifying Python Launcher Availability

Source: https://github.com/python/cpython/blob/main/Doc/using/windows.rst

This command checks if the Python launcher for Windows is installed and accessible in the system's PATH. If not found, it indicates that the launcher needs to be installed.

```bash
py
```

--------------------------------

### Example: Print Calendar for Year 2000

Source: https://github.com/python/cpython/blob/main/Doc/library/calendar.rst

This example demonstrates how to use the calendar module from the command line to display a calendar for a specific year (2000). The output shows the calendar formatted in text mode.

```console
$ python -m calendar 2000
                                     2000

         January                   February                   March
   Mo Tu We Th Fr Sa Su      Mo Tu We Th Fr Sa Su      Mo Tu We Th Fr Sa Su
                   1  2          1  2  3  4  5  6             1  2  3  4  5
    3  4  5  6  7  8  9       7  8  9 10 11 12 13       6  7  8  9 10 11 12
   10 11 12 13 14 15 16      14 15 16 17 18 19 20      13 14 15 16 17 18 19
   17 18 19 20 21 22 23      21 22 23 24 25 26 27      20 21 22 23 24 25 26
   24 25 26 27 28 29 30      28 29                     27 28 29 30 31
   31

          April                      May                       June
   Mo Tu We Th Fr Sa Su      Mo Tu We Th Fr Sa Su      Mo Tu We Th Fr Sa Su
                   1  2       1  2  3  4  5  6  7                1  2  3  4
    3  4  5  6  7  8  9       8  9 10 11 12 13 14       5  6  7  8  9 10 11
   10 11 12 13 14 15 16      15 16 17 18 19 20 21      12 13 14 15 16 17 18
   17 18 19 20 21 22 23      22 23 24 25 26 27 28      19 20 21 22 23 24 25
   24 25 26 27 28 29 30      29 30 31                  26 27 28 29 30

           July                     August                  September
   Mo Tu We Th Fr Sa Su      Mo Tu We Th Fr Sa Su      Mo Tu We Th Fr Sa Su
                   1  2          1  2  3  4  5  6                   1  2  3
    3  4  5  6  7  8  9       7  8  9 10 11 12 13       4  5  6  7  8  9 10
   10 11 12 13 14 15 16      14 15 16 17 18 19 20      11 12 13 14 15 16 17
   17 18 19 20 21 22 23      21 22 23 24 25 26 27      18 19 20 21 22 23 24
   24 25 26 27 28 29 30      28 29 30 31               25 26 27 28 29 30
   31

         October                   November                  December
   Mo Tu We Th Fr Sa Su      Mo Tu We Th Fr Sa Su      Mo Tu We Th Fr Sa Su
                      1             1  2  3  4  5                   1  2  3
    2  3  4  5  6  7  8       6  7  8  9 10 11 12       4  5  6  7  8  9 10
    9 10 11 12 13 14 15      13 14 15 16 17 18 19      11 12 13 14 15 16 17
   16 17 18 19 20 21 22      20 21 22 23 24 25 26      18 19 20 21 22 23 24
   23 24 25 26 27 28 29      27 28 29 30               25 26 27 28 29 30 31
   30 31
```

--------------------------------

### Formatted String Literals (f-strings) Example

Source: https://github.com/python/cpython/blob/main/Doc/tutorial/inputoutput.rst

Demonstrates the basic usage of f-strings to embed Python expressions directly within string literals. It shows how to include variables and literal values within curly braces. Requires Python 3.6+.

```python
>>> year = 2016
>>> event = 'Referendum'
>>> f'Results of the {year} {event}'
'Results of the 2016 Referendum'
```

--------------------------------

### DocTestRunner Methods

Source: https://github.com/python/cpython/blob/main/Doc/library/doctest.rst

Methods for reporting the success or failure of doctest examples and handling unexpected exceptions.

```APIDOC
## DocTestRunner Methods

### Description
Methods for reporting the success or failure of doctest examples and handling unexpected exceptions.

### Methods

`report_success(out, test, example, got)`
  Report that the given example ran successfully.

`report_failure(out, test, example, got)`
  Report that the given example failed.

`report_unexpected_exception(out, test, example, exc_info)`
  Report that the given example raised an unexpected exception.
```

--------------------------------

### Python String Indexing and Slicing Example

Source: https://github.com/python/cpython/blob/main/Doc/tutorial/introduction.rst

Demonstrates accessing characters in a Python string using positive and negative indices, and slicing to extract substrings. It also shows how out-of-bounds slice indices are handled gracefully.

```python
>>> word = "Python"
>>> word[1:3]
'yt'
>>> word[4:42]
'on'
>>> word[42:]
''
```

--------------------------------

### Multiprocessing Logging: Main Orchestration

Source: https://github.com/python/cpython/blob/main/Doc/howto/logging-cookbook.rst

Orchestrates the multiprocessing logging demo by creating a queue, starting a listener process, creating and starting ten worker processes, waiting for them to complete, and then signaling the listener to stop.

```python
# Here's where the demo gets orchestrated. Create the queue, create and start
# the listener, create ten workers and start them, wait for them to finish,
# then send a None to the queue to tell the listener to finish.
def main():
    queue = multiprocessing.Queue(-1)
    listener = multiprocessing.Process(target=listener_process,
                                       args=(queue, listener_configurer))
    listener.start()
    workers = []
    for i in range(10):
        worker = multiprocessing.Process(target=worker_process,
                                         args=(queue, worker_configurer))
        workers.append(worker)
        worker.start()
    for w in workers:
        w.join()
    queue.put_nowait(None)
    listener.join()

if __name__ == '__main__':
    main()
```

--------------------------------

### enum.Enum with start parameter

Source: https://github.com/python/cpython/blob/main/Doc/whatsnew/3.5.rst

The enum.Enum callable now has a 'start' parameter to specify the initial number for enum values when only names are provided.

```APIDOC
## enum.Enum with start parameter

### Description
The `enum.Enum` callable now accepts a new `start` parameter. This parameter allows specifying the initial number for enum values when only names are provided, offering more control over value assignment.

### Method
Callable

### Endpoint
N/A

### Parameters
None

### Request Example
```python
import enum

# Define an enum with starting value 10
Animal = enum.Enum('Animal', 'cat dog', start=10)

print(Animal.cat.value)
print(Animal.dog.value)
```

### Response
#### Success Response (200)
Creates an Enum class with specified names and starting values.

#### Response Example
```
10
11
```
```

--------------------------------

### BaseServer Methods

Source: https://github.com/python/cpython/blob/main/Doc/library/socketserver.rst

Documentation for key methods of the BaseServer class, used for server activation, binding, and request verification.

```APIDOC
## GET /server_activate

### Description
Called by the server's constructor to activate the server. The default behavior for a TCP server just invokes listen on the server's socket. May be overridden.

### Method
GET

### Endpoint
/server_activate

### Parameters
#### Query Parameters
- None

#### Request Body
- None

### Response
#### Success Response (200)
- None

#### Response Example
- None
```

```APIDOC
## GET /server_bind

### Description
Called by the server's constructor to bind the socket to the desired address. May be overridden.

### Method
GET

### Endpoint
/server_bind

### Parameters
#### Query Parameters
- None

#### Request Body
- None

### Response
#### Success Response (200)
- None

#### Response Example
- None
```

```APIDOC
## POST /verify_request

### Description
Must return a Boolean value; if the value is True, the request will be processed, and if it's False, the request will be denied. This function can be overridden to implement access controls for a server. The default implementation always returns True.

### Method
POST

### Endpoint
/verify_request

### Parameters
#### Query Parameters
- None

#### Request Body
- **request** (object) - Required - The request object.
- **client_address** (tuple) - Required - The client's address.

### Response
#### Success Response (200)
- **verified** (boolean) - Indicates if the request is verified.

#### Response Example
{
  "verified": true
}
```

--------------------------------

### Doctest Debugging with PDB

Source: https://github.com/python/cpython/blob/main/Doc/library/doctest.rst

This section explains how to integrate the Python debugger (pdb) into doctest examples for post-mortem debugging.

```APIDOC
## Doctest Debugging with PDB

### Description
Allows insertion of `pdb.set_trace()` within doctest examples to drop into the Python debugger when that line is executed. This facilitates inspecting variable values during test execution.

### Method
N/A (In-code directive)

### Endpoint
N/A

### Parameters
N/A

### Request Example
```python
"""
>>> def f(x):
...     g(x*2)
>>> def g(x):
...     print(x+3)
...     import pdb; pdb.set_trace()
>>> f(3)
9
"""
```

### Response
#### Success Response (200)
N/A

#### Response Example
```
--Return--
> <doctest a[1]>(3)g()->None
-> import pdb; pdb.set_trace()
(Pdb) list
  1     def g(x):
  2         print(x+3)
  3  ->     import pdb; pdb.set_trace()
[EOF]
(Pdb) p x
6
(Pdb) step
--Return--
> <doctest a[0]>(2)f()->None
-> g(x*2)
(Pdb) list
  1     def f(x):
  2  ->     g(x*2)
[EOF]
(Pdb) p x
3
(Pdb) step
--Return--
> <doctest a[2]>(1)?()->None
-> f(3)
(Pdb) cont
(0, 3)
>>> 
```
```

--------------------------------

### Create Python Virtual Environment

Source: https://github.com/python/cpython/blob/main/Doc/library/venv.rst

Creates a virtual Python environment in a specified directory. It ensures directories exist, sets up configuration, copies/symlinks the Python executable, installs activation scripts, and allows for post-setup actions. Dependencies include the 'os' module.

```python
import os

class EnvBuilder:
    # ... (other methods)

    def create(self, env_dir):
        """
        Create a virtualized Python environment in a directory.
        env_dir is the target directory to create an environment in.
        """
        env_dir = os.path.abspath(env_dir)
        context = self.ensure_directories(env_dir)
        self.create_configuration(context)
        self.setup_python(context)
        self.setup_scripts(context)
        self.post_setup(context)

    # Methods like ensure_directories, create_configuration, setup_python, 
    # setup_scripts, and post_setup can be overridden.
```

--------------------------------

### Custom Policy Implementation Example

Source: https://github.com/python/cpython/blob/main/Doc/library/asyncio-policy.rst

Example demonstrating how to create and set a custom event loop policy by subclassing `DefaultEventLoopPolicy`.

```APIDOC
## POST /custom_event_loop_policy

### Description
Allows setting a custom event loop policy. This is typically done by subclassing `DefaultEventLoopPolicy` and overriding specific methods.

### Method
POST

### Endpoint
/custom_event_loop_policy

### Parameters
#### Request Body
- **policy_class_name** (string) - The name of the custom policy class to instantiate.
- **module_path** (string) - The Python module path where the custom policy class is defined.

### Request Example
```json
{
  "policy_class_name": "MyCustomPolicy",
  "module_path": "my_asyncio_utils"
}
```

### Response
#### Success Response (200)
- **message** (string) - Confirmation message indicating the custom policy has been set.

#### Response Example
```json
{
  "message": "Custom event loop policy set successfully."
}
```

### Example Usage (Python)
```python
import asyncio

class MyEventLoopPolicy(asyncio.DefaultEventLoopPolicy):
    def get_event_loop(self):
        loop = super().get_event_loop()
        print("Getting custom event loop")
        return loop

# To set this policy, you would typically use:
# asyncio.set_event_loop_policy(MyEventLoopPolicy())
# Or via the API endpoint similar to:
# POST /custom_event_loop_policy with {"policy_class_name": "MyEventLoopPolicy", "module_path": "__main__"}
```
```

--------------------------------

### Start ETW Profiling with WPR

Source: https://github.com/python/cpython/blob/main/Objects/mimalloc/prim/windows/readme.md

This command starts an ETW profiling session using a Windows Performance Recorder profile. It requires administrator privileges and is used to capture performance data for applications.

```bash
wpr -start src\prim\windows\etw-mimalloc.wprp -filemode
```

--------------------------------

### Create Server

Source: https://github.com/python/cpython/blob/main/Doc/library/asyncio-eventloop.rst

Creates a server that accepts connections. This is a higher-level alternative to create_unix_server.

```APIDOC
## POST /create_server

### Description
Creates a server that accepts connections.

### Method
POST

### Endpoint
/create_server

### Parameters
#### Query Parameters
- **host** (str | list[str]) - Optional - The host to bind the server to. Defaults to '127.0.0.1'.
- **port** (int) - Optional - The port to bind the server to. If 0, an arbitrary available port is used.
- **family** (int) - Optional - The address family (e.g., socket.AF_INET or socket.AF_INET6). Defaults to AF_INET.
- **flags** (int) - Optional - Socket flags.
- **sock** (socket.socket) - Optional - A pre-existing socket to use.
- **backlog** (int) - Optional - The maximum number of queued connections. Defaults to 100.
- **ssl** (ssl.SSLContext) - Optional - An SSLContext to enable SSL/TLS.
- **ssl_handshake_timeout** (float) - Optional - Timeout for SSL handshake. Defaults to 60.0 seconds.
- **ssl_shutdown_timeout** (float) - Optional - Timeout for SSL shutdown. Defaults to 30.0 seconds.
- **start_serving** (bool) - Optional - If True, the server starts accepting connections immediately. Defaults to True.

### Request Example
```json
{
  "host": "localhost",
  "port": 8080,
  "start_serving": true
}
```

### Response
#### Success Response (200)
- **server** (asyncio.Server) - The created server object.

#### Response Example
```json
{
  "server_info": "Server created successfully"
}
```
```

--------------------------------

### Extended Interpolation Example

Source: https://github.com/python/cpython/blob/main/Doc/library/configparser.rst

Presents an example of extended interpolation syntax for configuration files, using '${section:option}' to reference values from different sections. This method supports multi-level referencing and allows omitting the section name to default to the current section.

```ini
[Paths]
home_dir: /Users
my_dir: ${home_dir}/lumberjack
my_pictures: ${my_dir}/Pictures

[Escape]
# use a $$ to escape the $ sign ($ is the only character that needs to be escaped):
cost: $$80
```

```ini
[Common]
home_dir: /Users
library_dir: /Library
system_dir: /System
macports_dir: /opt/local

[Frameworks]
Python: 3.2
path: ${Common:system_dir}/Library/Frameworks/

[Arthur]
nickname: Two Sheds
last_name: Jackson
my_dir: ${Common:home_dir}/twosheds
my_pictures: ${my_dir}/Pictures
python_dir: ${Frameworks:path}/Python/Versions/${Frameworks:Python}
```

--------------------------------

### Static Type Example

Source: https://github.com/python/cpython/blob/main/Doc/c-api/typeobj.rst

An example of defining a static Python type using the C API.

```APIDOC
## STATIC TYPE DEFINITION EXAMPLE

### Description
Example demonstrating the structure and initialization of a static Python type (`MyObject`) in C.

### Method
C Struct and `PyTypeObject` initialization

### Endpoint
N/A

### Request Body
```c
typedef struct {
    PyObject_HEAD
    const char *data;
} MyObject;

static PyTypeObject MyObject_Type = {
    PyVarObject_HEAD_INIT(NULL, 0)
    .tp_name = "mymod.MyObject",
    .tp_basicsize = sizeof(MyObject),
    .tp_doc = PyDoc_STR("My objects"),
    .tp_new = myobj_new,
    .tp_dealloc = (destructor)myobj_dealloc,
    .tp_repr = (reprfunc)myobj_repr,
};
```

### Response
N/A

### Response Example
N/A
```

--------------------------------

### Examples of Python Sequence Comparisons

Source: https://github.com/python/cpython/blob/main/Doc/tutorial/datastructures.rst

Illustrates various examples of sequence comparisons in Python, demonstrating lexicographical ordering for tuples, lists, and strings. It shows how sequences are compared element by element and how different types can be compared if they have appropriate methods.

```python
(1, 2, 3)              < (1, 2, 4)
[1, 2, 3]              < [1, 2, 4]
'ABC' < 'C' < 'Pascal' < 'Python'
(1, 2, 3, 4)           < (1, 2, 4)
(1, 2)                 < (1, 2, -1)
(1, 2, 3)             == (1.0, 2.0, 3.0)
(1, 2, ('aa', 'ab'))   < (1, 2, ('abc', 'a'), 4)
```

--------------------------------

### Create and Send Simple Text Email

Source: https://github.com/python/cpython/blob/main/Doc/library/email.examples.rst

Demonstrates how to create and send a simple email message with text content and addresses that can include unicode characters. This example utilizes functions from the email package.

```python
from email.message import EmailMessage
from smtplib import SMTP

msg = EmailMessage()
msg['To'] = 'recipient@example.com'
msg['From'] = 'sender@example.com'
msg['Subject'] = 'Test Email'

msg.set_content('This is a test email body.')

with SMTP('localhost') as s:
    s.send_message(msg)

```

--------------------------------

### Advanced Command Line Argument Parsing with argparse

Source: https://github.com/python/cpython/blob/main/Doc/tutorial/stdlib.rst

Demonstrates using the 'argparse' module for sophisticated command-line argument parsing, including handling positional arguments and optional flags with default values.

```python
import argparse

parser = argparse.ArgumentParser(
    prog='top',
    description='Show top lines from each file')
parser.add_argument('filenames', nargs='+')
parser.add_argument('-l', '--lines', type=int, default=10)
args = parser.parse_args()
print(args)
```

--------------------------------

### Python Function Annotation Example

Source: https://github.com/python/cpython/blob/main/Doc/glossary.rst

Illustrates function annotations in Python, commonly used for type hints. This example shows a function annotated to accept two integers and return an integer.

```python
def sum_two_numbers(a: int, b: int) -> int:
   return a + b
```

--------------------------------

### Port _heapq module to multiphase initialization (Python Core)

Source: https://github.com/python/cpython/blob/main/Misc/NEWS.d/3.9.0a5.rst

The '_heapq' extension module has been ported to utilize multiphase initialization. This change is part of a broader effort to standardize module initialization using the mechanisms described in PEP 489.

```c
// C-API implementation for _heapq module, updated for multiphase initialization.
// This ensures consistent module loading and setup across different Python versions and configurations.
```

--------------------------------

### PyTuple_SetItem and PyList_SetItem Reference Stealing

Source: https://github.com/python/cpython/blob/main/Doc/c-api/intro.rst

Explains how `PyTuple_SetItem` and `PyList_SetItem` steal references to items, including usage examples.

```APIDOC
## PyTuple_SetItem and PyList_SetItem

### Description
This documentation details the reference-stealing behavior of `PyTuple_SetItem` and `PyList_SetItem`. These functions steal a reference to the item being inserted into a tuple or list, respectively. This is common when populating newly created tuples or lists.

### Key Points:

*   These functions steal a reference to the *item*, not the tuple or list itself.
*   If you need to retain access to an object whose reference will be stolen, use `Py_INCREF` to create an additional reference before calling these functions.

### Example Usage (Creating a Tuple):

```c
PyObject *t;

t = PyTuple_New(3);
PyTuple_SetItem(t, 0, PyLong_FromLong(1L)); // Steals reference from PyLong_FromLong
PyTuple_SetItem(t, 1, PyLong_FromLong(2L)); // Steals reference from PyLong_FromLong
PyTuple_SetItem(t, 2, PyUnicode_FromString("three")); // Steals reference from PyUnicode_FromString
```

*Note:* `PyTuple_SetItem` is the only method to set tuple items as tuples are immutable. It should only be used for tuples being created.

### Equivalent with `Py_BuildValue`:

```c
PyObject *tuple;
tuple = Py_BuildValue("(iis)", 1, 2, "three");
```

Similar logic applies to lists using `PyList_New` and `PyList_SetItem`.
```

--------------------------------

### Basic Match-Case with Wildcard and Literal OR

Source: https://github.com/python/cpython/blob/main/Doc/tutorial/controlflow.rst

Demonstrates basic match-case syntax, including a wildcard '_' for unmatched cases and combining multiple literals using '|'.

```python
case 404:
                return "Not found"
            case 418:
                return "I'm a teapot"
            case _:
                return "Something's wrong with the internet"
```

```python
case 401 | 403 | 404:
                return "Not allowed"
```

--------------------------------

### Enable and Load SQLite Extensions in Python

Source: https://github.com/python/cpython/blob/main/Doc/library/sqlite3.rst

This example demonstrates how to enable loading of SQLite extensions, load a full-text search extension (`fts3.so`), and then disable extension loading. It also includes an example of creating a virtual table and inserting data using the loaded extension, followed by querying it.

```python
con.enable_load_extension(True)

# Load the fulltext search extension
con.execute("select load_extension('./fts3.so')")

# alternatively you can load the extension using an API call:
# con.load_extension("./fts3.so")

# disable extension loading again
con.enable_load_extension(False)

# example from SQLite wiki
con.execute("CREATE VIRTUAL TABLE recipe USING fts3(name, ingredients)")
con.executescript("""
             INSERT INTO recipe (name, ingredients) VALUES('broccoli stew', 'broccoli peppers cheese tomatoes');
             INSERT INTO recipe (name, ingredients) VALUES('pumpkin stew', 'pumpkin onions garlic celery');
             INSERT INTO recipe (name, ingredients) VALUES('broccoli pie', 'broccoli cheese onions flour');
             INSERT INTO recipe (name, ingredients) VALUES('pumpkin pie', 'pumpkin sugar flour butter');
             """)
for row in con.execute("SELECT rowid, name, ingredients FROM recipe WHERE name MATCH 'pie'"):
             print(row)
```

--------------------------------

### Basic Console Logging Example

Source: https://github.com/python/cpython/blob/main/Doc/howto/logging.rst

A minimal Python script demonstrating how to log a warning message to the console using the logging module. It also shows how INFO level messages are suppressed by default.

```python
import logging
logging.warning('Watch out!')  # will print a message to the console
logging.info('I told you so')  # will not print anything
```

--------------------------------

### Tkinter Combobox Methods: current(), get(), set()

Source: https://github.com/python/cpython/blob/main/Doc/library/tkinter.ttk.rst

Provides methods to interact with the ttk.Combobox widget. 'current()' gets or sets the current selection by index. 'get()' retrieves the current value. 'set()' updates the combobox's value.

```python
combobox.current(newindex=None)
combobox.get()
combobox.set(value)
```

--------------------------------

### Python Combined Argument Specifier Example

Source: https://github.com/python/cpython/blob/main/Doc/tutorial/controlflow.rst

Presents a Python function `combined_example` that utilizes both '/' and '*' to define positional-only, positional-or-keyword, and keyword-only parameters. This highlights a more complex argument passing structure.

```python
def combined_example(pos_only, /, standard, *, kwd_only):
    print(pos_only, standard, kwd_only)

combined_example(1, 2, kwd_only=3)
# combined_example(pos_only=1, standard=2, kwd_only=3) # This would also work
```

--------------------------------

### Unpack MIME Message into Directory

Source: https://github.com/python/cpython/blob/main/Doc/library/email.examples.rst

Demonstrates the process of unpacking a received MIME message, similar to the one created in the 'Send Entire Directory Contents as Email' example, into a directory of files. This involves iterating through the MIME parts and saving them.

```python
from email.parser import Parser
from email.policy import default
import os

def unpack_mime_message(mime_message_string, output_directory):
    parser = Parser(policy=default)
    msg = parser.parsestr(mime_message_string)

    if not os.path.exists(output_directory):
        os.makedirs(output_directory)

    for part in msg.walk():
        filename = part.get_filename()
        if filename:
            filepath = os.path.join(output_directory, filename)
            with open(filepath, 'wb') as fp:
                fp.write(part.get_payload(decode=True))
            print(f"Saved: {filepath}")

# Example usage:
# Assume raw_mime_message is a string containing the MIME message
# unpack_mime_message(raw_mime_message, './unpacked_files')

```

--------------------------------

### Pdb Initialization and Usage

Source: https://github.com/python/cpython/blob/main/Doc/library/pdb.rst

Demonstrates how to initialize and use the Pdb debugger, including setting breakpoints and available methods.

```APIDOC
## Pdb Initialization and Usage

### Description
This section covers the initialization of the Pdb debugger and its core methods for setting breakpoints and controlling execution.

### Method
Not Applicable (Code examples demonstrate library usage)

### Endpoint
Not Applicable

### Parameters
#### Path Parameters
None

#### Query Parameters
None

#### Request Body
None

### Request Example
```python
import pdb; pdb.Pdb(skip=['django.*']).set_trace()
```

### Response
#### Success Response (200)
Not Applicable

#### Response Example
Not Applicable
```

--------------------------------

### Archive and Unpack Directories (Python)

Source: https://github.com/python/cpython/blob/main/Doc/whatsnew/3.2.rst

Demonstrates how to create archives (like zip, tar.gz) from directories and unpack them using shutil.make_archive and shutil.unpack_archive. It also shows how to register new archive formats and list available formats.

```python
import shutil, pprint, os

# Example assumes 'mydata' directory exists
# os.makedirs('mydata', exist_ok=True)
# with open('mydata/file.txt', 'w') as f: f.write('test')

# Create an archive
# os.chdir('mydata') # change to the source directory
# archive_name = shutil.make_archive('/tmp/mydata_archive', 'zip')
# print(f"Archive created: {archive_name}")
# os.chdir('..') # change back

# Unpack an archive
# os.makedirs('unpacked_data', exist_ok=True)
# os.chdir('unpacked_data')
# shutil.unpack_archive('/tmp/mydata_archive.zip')
# print("Archive unpacked.")
# os.chdir('..')

# List available archive formats
print("Available archive formats:")
pprint.pprint(shutil.get_archive_formats())

# Example of registering a new format (requires 'xz' module)
# try:
#     import xz
#     shutil.register_archive_format(
#         name='xz',
#         function=xz.compress,
#         extra_args=[('level', 8)],
#         description='xz compression'
#     )
#     print("xz archive format registered.")
# except ImportError:
#     print("xz module not found, skipping registration.")

```

--------------------------------

### Update CPython macOS installer to use OpenSSL 1.0.2m

Source: https://github.com/python/cpython/blob/main/Misc/NEWS.d/3.7.0a3.rst

Updates the macOS installer for CPython to utilize OpenSSL version 1.0.2m. This change ensures the installer is bundled with a specific, potentially more secure or compatible, version of OpenSSL.

```build
# macOS installer build configuration
OPENSSL_VERSION = "1.0.2m"
```

--------------------------------

### Python classmethod dict.fromkeys Emulation

Source: https://github.com/python/cpython/blob/main/Doc/howto/descriptor.rst

Shows a pure Python emulation of the class method `dict.fromkeys`. This method is used to create a new dictionary from an iterable of keys, demonstrating a common use case for class methods as alternative constructors.

```python
class Dict(dict):
    @classmethod
    def fromkeys(cls, iterable, value=None):
        """Emulate dict_fromkeys() in Objects/dictobject.c"""
        d = cls()
        for key in iterable:
            d[key] = value
        return d
```

--------------------------------

### Client-Side SSL Connection Example

Source: https://github.com/python/cpython/blob/main/Doc/library/ssl.rst

Demonstrates how to establish a secure client-side SSL connection, send a HEAD request, and print the server's response headers.

```APIDOC
## GET / HTTP/1.0

### Description
Establishes an SSL connection to a server and sends an HTTP HEAD request to retrieve headers.

### Method
GET

### Endpoint
/

### Parameters
#### Query Parameters
None

#### Request Body
None

### Request Example
```python
conn.sendall(b"HEAD / HTTP/1.0\r\nHost: linuxfr.org\r\n\r\n")
```

### Response
#### Success Response (200)
Headers returned by the server.

#### Response Example
```json
{
  "example": "[b'HTTP/1.1 200 OK', b'Date: Sat, 18 Oct 2014 18:27:20 GMT', b'Server: nginx', b'Content-Type: text/html; charset=utf-8', b'X-Frame-Options: SAMEORIGIN', b'Content-Length: 45679', b'Accept-Ranges: bytes', b'Via: 1.1 varnish', b'Age: 2188', b'X-Served-By: cache-lcy1134-LCY', b'X-Cache: HIT', b'X-Cache-Hits: 11', b'Vary: Cookie', b'Strict-Transport-Security: max-age=63072000; includeSubDomains', b'Connection: close', b'', b'']"
}
```
```

--------------------------------

### Fix pydoc.writedoc for 'self' in examples

Source: https://github.com/python/cpython/blob/main/Misc/NEWS.d/3.5.0a1.rst

Corrects the pydoc.writedoc function to accurately generate HTML documentation for methods that use 'self' within their example code. This ensures that doctests and examples involving instance methods are rendered correctly in the generated documentation.

```python
import pydoc

# Conceptual: pydoc.writedoc will now handle 'self' in examples correctly.
# class MyClass:
#     def my_method(self):
#         """Example:
#         >>> obj = MyClass()
#         >>> obj.my_method()
#         """
#         pass
# pydoc.writedoc(MyClass.my_method)
```

--------------------------------

### Struct Examples

Source: https://github.com/python/cpython/blob/main/Doc/library/struct.rst

Illustrative examples demonstrating the usage of the `struct` module for packing and unpacking binary data, including byte ordering and error handling.

```APIDOC
## Struct Examples

### Description
This section provides practical examples of using the `struct` module for common operations.

### Example 1: Packing and Unpacking Integers with Big-Endian Ordering

```python
from struct import *

# Pack integers (1, 2, 3) into a bytes object using big-endian format
packed_data = pack(">bhl", 1, 2, 3)
print(packed_data)
# Output: b'\x01\x00\x02\x00\x00\x00\x03'

# Unpack the bytes object back into integers
unpacked_data = unpack('>bhl', packed_data)
print(unpacked_data)
# Output: (1, 2, 3)

# Calculate the size of the packed data
size = calcsize('>bhl')
print(size)
# Output: 7
```

### Example 2: Handling Out-of-Range Integer Values

```python
from struct import pack, error

try:
    # Attempt to pack an integer (99999) that is too large for a short ('h')
    pack(">h", 99999)
except error as e:
    print(e)
    # Output: 'h' format requires -32768 <= number <= 32767
```

### Example 3: Difference Between `'s'` and `'c'` Format Characters

```python
from struct import pack

# Packing three individual characters
packed_chars = pack("@ccc", b'1', b'2', b'3')
print(packed_chars)
# Output: b'123'

# Packing a 3-byte string
packed_string = pack("@3s", b'123')
print(packed_string)
# Output: b'123'
```

### Example 4: Unpacking into Named Variables and Named Tuples

```python
from struct import unpack
from collections import namedtuple

record = b'raymond   \x32\x12\x08\x01\x08'

# Unpack into individual variables
name, serialnum, school, gradelevel = unpack('<10sHHb', record)
print(f"Name: {name}, Serial: {serialnum}, School: {school}, Grade: {gradelevel}")
# Output: Name: b'raymond   ', Serial: 4658, School: 264, Grade: 8

# Unpack into a named tuple
Student = namedtuple('Student', 'name serialnum school gradelevel')
student_record = Student._make(unpack('<10sHHb', record))
print(student_record)
# Output: Student(name=b'raymond   ', serialnum=4658, school=264, gradelevel=8)
```

### Note on Native Byte Order
Examples using native byte order (prefixed with `@` or no prefix) may produce different results depending on the platform and compiler.
```

--------------------------------

### Python - Execute program using spawnvpe (searches PATH, specifies environment)

Source: https://github.com/python/cpython/blob/main/Doc/library/os.rst

Executes a program specified by 'file' in a new process, searching for it in the PATH environment variable, and replaces the current process's environment with a new one provided as a mapping. Arguments are passed as a list of strings. 'mode' controls whether to wait or not. Keys and values in env must be strings.

```python
import os

# Example: Execute 'env' to display environment variables,
# specifying a custom PATH and another environment variable.
custom_env = {
    "PATH": "/usr/bin:/bin",
    "MY_VAR": "hello"
}

# The first argument in args should be the program name itself.
exit_status = os.spawnvpe(os.P_WAIT, 'env', ['env'], custom_env)

print(f"'env' process exited with status: {exit_status}")
```

--------------------------------

### HTTP GET Request with Response Reading (Python)

Source: https://github.com/python/cpython/blob/main/Doc/library/http.client.rst

Demonstrates making a GET request, printing the status and reason, and reading the entire response content. Also shows how to read the response in chunks.

```python
import http.client

conn = http.client.HTTPSConnection("www.python.org")
conn.request("GET", "/")
r1 = conn.getresponse()
print(r1.status, r1.reason)
data1 = r1.read()  # This will return entire content.

# Reading data in chunks
conn.request("GET", "/")
r1 = conn.getresponse()
while chunk := r1.read(200):
    print(repr(chunk))
```

--------------------------------

### Display Help Information

Source: https://github.com/python/cpython/blob/main/Doc/using/cmdline.rst

Prints concise descriptions of all command-line options, environment variables, and their corresponding functionalities. This is a crucial option for understanding how to use the Python interpreter effectively.

```none
-?, -h, --help
```

--------------------------------

### Install a Specific Package Version using pip

Source: https://github.com/python/cpython/blob/main/Doc/tutorial/venv.rst

Installs a specific version of a package from PyPI into the active virtual environment. This is useful for ensuring compatibility with project requirements.

```console
(tutorial-env) $ python -m pip install requests==2.6.0
```

--------------------------------

### Installing Development Headers for Python Extensions

Source: https://github.com/python/cpython/blob/main/Doc/faq/extending.rst

Explains how to install necessary development files for compiling Python extensions on different Linux distributions. It specifies the package names for Red Hat (python3-devel) and Debian (python3-dev).

```shell
For Red Hat, install the python3-devel RPM to get the necessary files.

For Debian, run "apt-get install python3-dev".
```

--------------------------------

### Server Socket Example

Source: https://github.com/python/cpython/blob/main/Doc/library/ssl.rst

Illustrates how to create a server socket that listens for incoming connections and provides SSL/TLS encryption.

```APIDOC
## POST /server/listen

### Description
Sets up a secure server socket to listen for incoming client connections.

### Method
POST

### Endpoint
/server/listen

### Parameters
#### Request Body
- **cert_chain** (string) - Required - Path to the certificate chain file.
- **private_key** (string) - Required - Path to the private key file.
- **host** (string) - Optional - The host address to bind to (defaults to '127.0.0.1').
- **port** (integer) - Optional - The port to listen on (defaults to 8443).

### Request Example
```json
{
  "cert_chain": "/path/to/certchain.pem",
  "private_key": "/path/to/private.key",
  "host": "0.0.0.0",
  "port": 8443
}
```

### Response
#### Success Response (200)
- **status** (string) - Indicates the server is listening.

#### Response Example
```json
{
  "status": "Server is listening on port 8443"
}
```
```

--------------------------------

### subprocess.getoutput example

Source: https://github.com/python/cpython/blob/main/Doc/library/subprocess.rst

Shows an example of using subprocess.getoutput to execute a command and retrieve only its output (stdout and stderr). The exit code is ignored with this function.

```Python
>>> subprocess.getoutput('ls /bin/ls')
'/bin/ls'
```

--------------------------------

### Root Logger Configuration Example

Source: https://github.com/python/cpython/blob/main/Doc/library/logging.config.rst

Illustrates the configuration for the root logger, including its logging level and the handlers it uses. The 'NOTSET' level means all messages will be logged.

```ini
[logger_root]
level=NOTSET
handlers=hand01
```

--------------------------------

### Python: Configure Proxy Handler

Source: https://github.com/python/cpython/blob/main/Doc/howto/urllib2.rst

Sets up a custom ProxyHandler to override default proxy settings. This example creates an opener that explicitly defines no proxies, which is useful for bypassing automatic proxy detection.

```python
import urllib.request

# Setup proxy support with no proxies defined
proxy_support = urllib.request.ProxyHandler({})
opener = urllib.request.build_opener(proxy_support)
urllib.request.install_opener(opener)
```

--------------------------------

### macOS Installer - OpenSSL Version

Source: https://github.com/python/cpython/blob/main/Misc/NEWS.d/3.10.0a6.rst

Update to the macOS installer build to utilize OpenSSL version 1.1.1j.

```APIDOC
## macOS Installer - OpenSSL Version

### Description
The macOS installer build has been updated to use OpenSSL version 1.1.1j.

### Method
N/A (Build Update)

### Endpoint
N/A

### Parameters
N/A

### Request Example
N/A

### Response
N/A
```

--------------------------------

### Defining and Calling a Simple Python Function

Source: https://github.com/python/cpython/blob/main/Doc/howto/a-conceptual-overview-of-asyncio.rst

Illustrates the definition and execution of a standard Python function. When called, the function's code is executed immediately.

```python
def hello_printer():
    print(
        "Hi, I am a lowly, simple printer, though I have all I "
        "need in life -- \nfresh paper and my dearly beloved octopus "
        "partner in crime."
    )

>>> hello_printer()
Hi, I am a lowly, simple printer, though I have all I need in life -- 
fresh paper and my dearly beloved octopus partner in crime.
```

--------------------------------

### QueueManager Example: Server

Source: https://github.com/python/cpython/blob/main/Doc/library/multiprocessing.rst

Illustrates how to set up a server process that manages a local queue and makes it accessible via a QueueManager.

```APIDOC
## QueueManager Server Example

### Description
This code sets up a server process that creates a local queue, registers it with a QueueManager, and serves it to clients.

### Method
N/A (This is a usage example, not an API endpoint)

### Endpoint
N/A

### Parameters
N/A

### Request Example
```python
from multiprocessing import Process, Queue
from multiprocessing.managers import BaseManager

class Worker(Process):
    def __init__(self, q):
        self.q = q
        super().__init__()
    def run(self):
        self.q.put('local hello')

queue = Queue()
w = Worker(queue)
w.start()

class QueueManager(BaseManager):
    pass

QueueManager.register('get_queue', callable=lambda: queue)

m = QueueManager(address=('', 50000), authkey=b'abracadabra')
s = m.get_server()
s.serve_forever()
```

### Response
#### Success Response (N/A)
N/A

#### Response Example
N/A
```

--------------------------------

### Python Global Statement Example

Source: https://github.com/python/cpython/blob/main/Lib/test/test_ast/data/ast_repr.txt

Represents the AST node for the 'global' keyword, declaring variables that refer to globals.

```python
Module(body=[Global(names=['v'])], type_ignores=[])
```

--------------------------------

### Example of asyncio.Event usage

Source: https://github.com/python/cpython/blob/main/Doc/library/asyncio-sync.rst

Illustrates how to use asyncio.Event to signal between tasks. One task waits for the event, while another task sets the event after a delay. This example showcases basic event-driven communication in asyncio.

```python
import asyncio

async def waiter(event):
    print('waiting for it ...')
    await event.wait()
    print('... got it!')

async def main():
    event = asyncio.Event()
    waiter_task = asyncio.create_task(waiter(event))
    await asyncio.sleep(1)
    event.set()
    await waiter_task

asyncio.run(main())
```

--------------------------------

### Add posix_venv and nt_venv schemes for venv bootstrapping

Source: https://github.com/python/cpython/blob/main/Misc/NEWS.d/3.11.0a7.rst

Introduces `posix_venv` and `nt_venv` sysconfig installation schemes for bootstrapping virtual environments. The `venv` module now uses the `venv` scheme, ensuring compatibility with custom installation schemes.

```python
Define *posix_venv* and *nt_venv* :ref:`sysconfig installation schemes
<installation_paths>` to be used for bootstrapping new virtual environments.
Add *venv* sysconfig installation scheme to get the appropriate one of the
above. The schemes are identical to the pre-existing *posix_prefix* and *nt*
install schemes. The :mod:`venv` module now uses the *venv* scheme to create
new virtual environments instead of hardcoding the paths depending only on
the platform. Downstream Python distributors customizing the *posix_prefix*
or *nt* install scheme in a way that is not compatible with the install
scheme used in virtual environments are encouraged not to customize the
*venv* schemes. When Python itself runs in a virtual environment,
:func:`sysconfig.get_default_scheme` and
:func:`sysconfig.get_preferred_scheme` with ``key="prefix"`` returns *venv*.
```

--------------------------------

### Fix virtual environments not launching from Store install on Windows

Source: https://github.com/python/cpython/blob/main/Misc/NEWS.d/3.13.0b1.rst

Addresses an issue where virtual environments created from a Microsoft Store installation of Python were not launching correctly on Windows. This ensures proper execution of virtual environments.

```text
.. date: 2024-04-12-13-18-42
.. gh-issue: 117786
.. nonce: LpI01s
.. section: Windows

Fixes virtual environments not correctly launching when created from a Store
install.
```

--------------------------------

### Hello World with asyncio.call_soon

Source: https://github.com/python/cpython/blob/main/Doc/library/asyncio-eventloop.rst

Demonstrates a basic asyncio application using `call_soon` to schedule a callback. The callback prints 'Hello World' and then stops the event loop. It requires the `asyncio` library and shows manual loop creation and closing.

```python
import asyncio

def hello_world(loop):
    """A callback to print 'Hello World' and stop the event loop"""
    print('Hello World')
    loop.stop()

loop = asyncio.new_event_loop()

# Schedule a call to hello_world()
loop.call_soon(hello_world, loop)

# Blocking call interrupted by loop.stop()
try:
    loop.run_forever()
finally:
    loop.close()
```

--------------------------------

### Ensuring Landmark File for Direct Execution

Source: https://github.com/python/cpython/blob/main/Doc/using/windows.rst

When users run python.exe directly, ensure the standard library's landmark file (e.g., Lib\os.py) is present in the install directory. ZIP files named correctly are also detected.

```text
Directory structure:
YourApp/          <-- Executable directory
  python.exe
  Lib/              <-- Standard library directory
    os.py           <-- Landmark file
    ... other stdlib modules ...
```

--------------------------------

### cProfile as a Context Manager

Source: https://github.com/python/cpython/blob/main/Doc/library/profile.rst

Shows how to use the cProfile.Profile class as a context manager for profiling code blocks. This is a convenient way to automatically enable and disable profiling.

```python
import cProfile

with cProfile.Profile() as pr:
    # ... do something ...

    pr.print_stats()
```

--------------------------------

### Python Doctest Handling of Leading Whitespace

Source: https://github.com/python/cpython/blob/main/Doc/library/doctest.rst

Demonstrates doctest's ability to handle inconsistent leading whitespace in examples and expected output by stripping it appropriately.

```python
>>> assert "Easy!"
      >>> import math
          >>> math.floor(1.9)
              1
```

--------------------------------

### DocTest Objects

Source: https://github.com/python/cpython/blob/main/Doc/library/doctest.rst

Details the DocTest class, which represents a collection of interactive examples extracted from a single docstring or text file.

```APIDOC
## class DocTest(examples, globs, name, filename, lineno, docstring)

### Description
Represents a collection of doctest examples intended to be run within a single namespace. The constructor initializes attributes that store the examples, the execution namespace, and metadata about the test's origin.

### Attributes
- **examples** (list of :class:`Example`) - A list of `Example` objects representing the interactive Python examples.
- **globs** (dict) - The namespace (globals) in which the examples are executed. Modifications made by examples are reflected here.
- **name** (str) - A string identifying the `DocTest`, typically the name of the object or file it was extracted from.
- **filename** (str or None) - The name of the file from which this `DocTest` was extracted, or None if unknown.
- **lineno** (int or None) - The zero-based line number within `filename` where the `DocTest` begins, or None if unavailable.
- **docstring** (str or None) - The string from which the test was extracted, or None if unavailable.
```

--------------------------------

### Initialize PyMutex for Unlocked State (C)

Source: https://github.com/python/cpython/blob/main/Doc/c-api/init.rst

This C code demonstrates how to initialize a `PyMutex` instance to its unlocked state. A `PyMutex` must be initialized to zero to represent the unlocked state before it can be used. Instances of `PyMutex` should not be copied or moved, as both their contents and address are significant for their operation.

```c
PyMutex mutex = {0};
```

--------------------------------

### Build Python Binary Distribution (Python)

Source: https://github.com/python/cpython/blob/main/Mac/README.rst

A Python script used to create a binary distribution of Python for macOS. This script automates downloading and building third-party libraries, configuring and building Python, installing it, creating installer package files, and packing everything into a DMG image. It requires macOS 10.4+ and Xcode 2.1+.

```python
build-installer.py
```

--------------------------------

### Create Executable Python Zip Application (zipapp)

Source: https://github.com/python/cpython/blob/main/Doc/whatsnew/3.5.rst

Demonstrates how to create an executable Python Zip Application using the new zipapp module. This involves packaging application files, including a __main__.py, into a directory and then using the python -m zipapp command to create a .pyz file.

```shell-session
$ python -m zipapp myapp
$ python myapp.pyz
```

--------------------------------

### Python re.Pattern.fullmatch() Method Example

Source: https://github.com/python/cpython/blob/main/Doc/library/re.rst

Provides an example of the fullmatch() method for compiled regex patterns, which attempts to match the entire string. It demonstrates usage with optional 'pos' and 'endpos' parameters.

```python
>>> import re
>>> pattern = re.compile("o[gh]")
>>> pattern.fullmatch("dog")      # No match as "o" is not at the start of "dog".
>>> pattern.fullmatch("ogre")     # No match as not the full string matches.
>>> pattern.fullmatch("doggie", 1, 3)   # Matches within given limits.
<re.Match object; span=(1, 3), match='og'>
```

--------------------------------

### Python StringIO Example

Source: https://github.com/python/cpython/blob/main/Doc/library/io.rst

Demonstrates the behavior of StringIO, noting its speed similarity to BytesIO for in-memory unicode operations.

```python
from io import StringIO

# StringIO is a native in-memory unicode container
string_io = StringIO()
string_io.write("Some text")
print(string_io.getvalue())
```

--------------------------------

### List Installed Python Packages with Pip

Source: https://github.com/python/cpython/blob/main/Doc/tutorial/venv.rst

Displays all packages currently installed in the active Python virtual environment along with their versions. This is useful for auditing project dependencies.

```console
(tutorial-env) $ python -m pip list
novas (3.1.1.3)
numpy (1.9.2)
pip (7.0.3)
requests (2.7.0)
setuptools (16.0)
```

--------------------------------

### Query all entry points in Python

Source: https://github.com/python/cpython/blob/main/Doc/library/importlib.metadata.rst

Retrieves all installed entry points in the current Python environment. The result is an EntryPoints object which contains collections of EntryPoint objects, along with attributes for accessing groups and names.

```python
from importlib.metadata import entry_points

eps = entry_points()
```

--------------------------------

### Windows STARTUPINFO Class in Python

Source: https://github.com/python/cpython/blob/main/Doc/library/subprocess.rst

Demonstrates the usage of the `STARTUPINFO` class in Python for configuring Windows process creation. It highlights settable attributes like `dwFlags` and `hStdInput`.

```python
STARTUPINFO(*, dwFlags=0, hStdInput=None, hStdOutput=None, hStdError=None, wShowWindow=0, lpAttributeList=None)
```

--------------------------------

### Executing Modules as Scripts

Source: https://github.com/python/cpython/blob/main/Doc/whatsnew/2.5.rst

Illustrates how to execute a module as a script using the -m switch, including modules within packages.

```bash
python -m pychecker.checker
```

--------------------------------

### Define Function with Arguments and Type Hints (Python - Alternative)

Source: https://github.com/python/cpython/blob/main/Lib/test/test_ast/data/ast_repr.txt

An alternative representation of a Python function definition in an AST, showcasing variations in keyword-only argument defaults.

```python
Module(body=[FunctionDef(name='f', args=arguments(posonlyargs=[arg(...)], args=[arg(...)], vararg=None, kwonlyargs=[arg(...)], kw_defaults=[None], kwarg=arg(...), defaults=[Constant(...), Constant(...)]), body=[Pass()], decorator_list=[], returns=None, type_comment=None, type_params=[])], type_ignores=[])
```

--------------------------------

### Python Library Search Path Example

Source: https://github.com/python/cpython/blob/main/PC/readme.txt

Demonstrates how to view the current Python library search path by importing the sys module and printing sys.path. This is useful for understanding where Python looks for modules.

```python
import sys
print sys.path
```

--------------------------------

### Argument Parsing for Virtual Environment Creation in Python

Source: https://github.com/python/cpython/blob/main/Doc/library/venv.rst

Sets up command-line argument parsing for a script that creates Python virtual environments. It defines arguments for target directories, options to skip setuptools/pip installation, access to system site-packages, and the use of symlinks. Dependencies include 'argparse' and 'os'.

```python
import argparse
import os

def main(args=None):
    parser = argparse.ArgumentParser(prog=__name__,
                                     description='Creates virtual Python '
                                                 'environments in one or ' 
                                                 'more target ' 
                                                 'directories.')
    parser.add_argument('dirs', metavar='ENV_DIR', nargs='+',
                        help='A directory in which to create the ' 
                             'virtual environment.')
    parser.add_argument('--no-setuptools', default=False,
                        action='store_true', dest='nodist',
                        help="Don't install setuptools or pip in the "
                             "virtual environment.")
    parser.add_argument('--no-pip', default=False,
                        action='store_true', dest='nopip',
                        help="Don't install pip in the virtual "
                             "environment.")
    parser.add_argument('--system-site-packages', default=False,
                        action='store_true', dest='system_site',
                        help='Give the virtual environment access to the ' 
                             'system site-packages dir.')
    if os.name == 'nt':
        use_symlinks = False
    else:
        use_symlinks = True
    parser.add_argument('--symlinks', default=use_symlinks,
                        action='store_true', dest='symlinks',
                        help='Try to use symlinks rather than copies, ' 
                             'when symlinks are not the default for ' 
                             'the platform.')
    parser.add_argument('--clear', default=False, action='store_true',
                        dest='clear', help='Delete the contents of the '
```

--------------------------------

### Help and Documentation Access (Python)

Source: https://github.com/python/cpython/blob/main/Lib/idlelib/README.txt

Offers access to help resources, including an 'About IDLE' dialog, general IDLE help, Python documentation, and a Turtle graphics demo.

```python
help_about.AboutDialog
help.show_idlehelp
```

--------------------------------

### Install Dependencies for Zipapp

Source: https://github.com/python/cpython/blob/main/Doc/library/zipapp.rst

Installs project dependencies into a target directory using pip, preparing them for inclusion in a zip application archive. Assumes a requirements.txt file is present.

```shell
python -m pip install -r requirements.txt --target myapp
```

--------------------------------

### Platform Information

Source: https://github.com/python/cpython/blob/main/Doc/library/platform.rst

Functions to get general system information and platform-specific details.

```APIDOC
## GET /system/info/uname

### Description
Provides detailed system information including system name, node name, release, version, machine, and processor.

### Method
GET

### Endpoint
/system/info/uname

### Parameters
None

### Request Example
None

### Response
#### Success Response (200)
- **system** (string) - The operating system name.
- **node** (string) - The network name of the computer.
- **release** (string) - The operating system's release.
- **version** (string) - The operating system's version.
- **machine** (string) - The machine type.
- **processor** (string) - The processor name.

#### Response Example
{
  "system": "Linux",
  "node": "my-server",
  "release": "5.15.0-52-generic",
  "version": "#58-Ubuntu SMP Tue Mar 22 19:54:11 UTC 2022",
  "machine": "x86_64",
  "processor": "x86_64"
}

## GET /system/info/version

### Description
Retrieves the system's release version string.

### Method
GET

### Endpoint
/system/info/version

### Parameters
None

### Request Example
None

### Response
#### Success Response (200)
- **version** (string) - The system's release version, or an empty string if undetermined.

#### Response Example
{
  "version": "#3 on degas"
}

## POST /system/info/invalidate_caches

### Description
Clears the internal cache of system information, useful after external changes to the system's node name.

### Method
POST

### Endpoint
/system/info/invalidate_caches

### Parameters
None

### Request Example
None

### Response
#### Success Response (200)
- **message** (string) - Confirmation message.

#### Response Example
{
  "message": "System information cache invalidated."
}

## GET /platform/windows/version

### Description
Retrieves additional Windows version information, including OS release, version number, CSD level (service pack), and OS type.

### Method
GET

### Endpoint
/platform/windows/version

### Parameters
None (defaults can be provided as query parameters if needed for specific scenarios, but typically not used for retrieval)

### Request Example
None

### Response
#### Success Response (200)
- **release** (string) - The OS release version.
- **version** (string) - The OS version number.
- **csd** (string) - The CSD level (e.g., service pack).
- **ptype** (string) - The OS type (e.g., 'Uniprocessor Free', 'Multiprocessor Free').

#### Response Example
{
  "release": "10",
  "version": "10.0.19045",
  "csd": "KB5017383",
  "ptype": "Multiprocessor Free"
}

## GET /platform/windows/edition

### Description
Returns the current Windows edition as a string, or None if it cannot be determined.

### Method
GET

### Endpoint
/platform/windows/edition

### Parameters
None

### Request Example
None

### Response
#### Success Response (200)
- **edition** (string or null) - The Windows edition (e.g., 'Enterprise', 'ServerStandard').

#### Response Example
{
  "edition": "Enterprise"
}

## GET /platform/windows/is_iot

### Description
Determines if the current Windows edition is recognized as an IoT edition.

### Method
GET

### Endpoint
/platform/windows/is_iot

### Parameters
None

### Request Example
None

### Response
#### Success Response (200)
- **is_iot** (boolean) - True if the edition is an IoT edition, False otherwise.

#### Response Example
{
  "is_iot": false
}

## GET /platform/macos/version

### Description
Retrieves macOS version information, including release, version details, and machine identifier.

### Method
GET

### Endpoint
/platform/macos/version

### Parameters
None

### Request Example
None

### Response
#### Success Response (200)
- **release** (string) - The macOS release version.
- **versioninfo** (object) - A tuple containing version, development stage, and non-release version.
  - **version** (string) - The macOS version number.
  - **dev_stage** (string) - The development stage.
  - **non_release_version** (string) - Non-release version information.
- **machine** (string) - The machine identifier.

#### Response Example
{
  "release": "13.4.1",
  "versioninfo": {
    "version": "22F77",
    "dev_stage": "Customer",
    "non_release_version": "Darwin Kernel Version 22.5.0: Mon Jun  5 21:25:33 PDT 2023; root:xnu-8796.121.3~1/RELEASE_ARM64_T6000"
  },
  "machine": "arm64"
}

## GET /platform/ios/version

### Description
Retrieves iOS version information, including OS name, release version, device model, and simulator status.

### Method
GET

### Endpoint
/platform/ios/version

### Parameters
None

### Request Example
None

### Response
#### Success Response (200)
- **system** (string) - The OS name ('iOS' or 'iPadOS').
- **release** (string) - The iOS version number.
- **model** (string) - The device model identifier.
- **is_simulator** (boolean) - True if running on a simulator, False otherwise.

#### Response Example
{
  "system": "iOS",
  "release": "17.2",
  "model": "iPhone13,2",
  "is_simulator": false
}

## GET /platform/unix/libc_ver

### Description
Determines the libc version against which the executable is linked. Returns the library name and version.

### Method
GET

### Endpoint
/platform/unix/libc_ver

### Parameters
- **executable** (string) - Optional: Path to the executable to check (defaults to the Python interpreter).
- **chunksize** (integer) - Optional: Size of chunks to read from the file.

### Request Example
None

### Response
#### Success Response (200)
- **lib** (string) - The name of the libc library.
- **version** (string) - The version of the libc library.

#### Response Example
{
  "lib": "glibc",
  "version": "2.35"
}

## GET /platform/linux/os_release

### Description
Retrieves operating system identification details from the ``os-release`` file on Linux systems.

### Method
GET

### Endpoint
/platform/linux/os_release

### Parameters
None

### Request Example
None

### Response
#### Success Response (200)
- **os_release** (object) - A dictionary containing OS identification details like ID, NAME, PRETTY_NAME, VERSION_ID, etc.

#### Response Example
{
  "os_release": {
    "ID": "ubuntu",
    "NAME": "Ubuntu",
    "PRETTY_NAME": "Ubuntu 22.04.3 LTS",
    "VERSION_ID": "22.04",
    "HOME_URL": "https://www.ubuntu.com/",
    "SUPPORT_URL": "https://help.ubuntu.com/"
  }
}
```

--------------------------------

### Proxy Handler Configuration

Source: https://github.com/python/cpython/blob/main/Doc/howto/urllib2.rst

Explains how to configure proxy settings, including disabling automatic proxy detection by setting up a `ProxyHandler` with no defined proxies.

```APIDOC
## Proxy Handler Configuration

### Description
This section describes how `urllib` handles proxy settings. It shows how to manually configure a `ProxyHandler`, specifically how to disable automatic proxy detection by providing an empty dictionary for proxy definitions.

### Disabling Automatic Proxy Detection

To override default proxy settings or disable auto-detection:

1. Create a `ProxyHandler` with no proxies defined: `proxy_support = urllib.request.ProxyHandler({})`.
2. Build an opener using this handler: `opener = urllib.request.build_opener(proxy_support)`.
3. Install the opener to apply the new proxy settings globally: `urllib.request.install_opener(opener)`.
```

--------------------------------

### Python str.format(): Using vars()

Source: https://github.com/python/cpython/blob/main/Doc/tutorial/inputoutput.rst

Demonstrates using the built-in vars() function with dictionary unpacking in str.format() to format local variables. This provides a dynamic way to include variable information in strings.

```python
>>> table = {k: str(v) for k, v in vars().items()}
>>> message = " ".join([f'{k}: ' + '{' + k +'};' for k in table.keys()])
>>> print(message.format(**table))
__name__: __main__; __doc__: None; __package__: None; __loader__: ...
```

--------------------------------

### Install LLVM 19 with Homebrew on macOS

Source: https://github.com/python/cpython/blob/main/Tools/jit/README.md

Installs LLVM version 19 on macOS using the Homebrew package manager. Note that Homebrew does not add LLVM tools to the PATH by default.

```shell
brew install llvm@19
```

--------------------------------

### Printing Version String

Source: https://github.com/python/cpython/blob/main/Doc/library/optparse.rst

Demonstrates how to print a version string for a program using optparse, including automatic addition of a --version option.

```APIDOC
## Printing a Version String

### Description
This section explains how to configure and display a version string for your program using the optparse module. When a `version` argument is provided to `OptionParser`, an automatic `--version` option is added. This option, when invoked, prints the version string (with `%prog` expanded) and exits.

### Method
`OptionParser(usage=..., version=...)`

### Endpoint
N/A (Configuration during OptionParser initialization)

### Parameters
#### Path Parameters
N/A

#### Query Parameters
N/A

#### Request Body
N/A

### Request Example
```python
from optparse import OptionParser

parser = OptionParser(usage="%prog [-f] [-q]", version="%prog 1.0")
(options, args) = parser.parse_args()
```

### Response
#### Success Response (200)
- **stdout** - Prints the version string (e.g., "foo 1.0") and exits.

#### Response Example
```shell
$ /usr/bin/foo --version
foo 1.0
```
```

--------------------------------

### Build CPython with profile-guided optimization (PGO)

Source: https://github.com/python/cpython/blob/main/Doc/using/configure.rst

Executes the `make profile-opt` target to build Python with profile-guided optimization. This can be made the default for `make all` by configuring with `--enable-optimizations`.

```make
make profile-opt
```

--------------------------------

### Creating a Document

Source: https://github.com/python/cpython/blob/main/Doc/library/xml.dom.minidom.rst

Shows how to create a new XML document programmatically using getDOMImplementation and createDocument.

```APIDOC
## POST /api/xml/minidom/createDocument

### Description
Creates a new XML document using a DOM Implementation.

### Method
POST

### Endpoint
/api/xml/minidom/createDocument

### Parameters
#### Request Body
- **namespaceURI** (string) - Optional - The namespace URI for the root element.
- **qualifiedName** (string) - Required - The qualified name for the root element.
- **doctype** (object) - Optional - The DocumentType node to associate with the document.

### Request Example
```json
{
  "namespaceURI": null,
  "qualifiedName": "some_tag",
  "doctype": null
}
```

### Response
#### Success Response (200)
- **document** (object) - A new DOM Document object.

#### Response Example
```json
{
  "document": "<some_tag></some_tag>"
}
```
```

--------------------------------

### StreamHandler Configuration

Source: https://github.com/python/cpython/blob/main/Doc/library/logging.config.rst

Example configuration for a StreamHandler, specifying its class, logging level, formatter, and constructor arguments (e.g., sys.stdout).

```ini
[handler_hand01]
class=StreamHandler
level=NOTSET
formatter=form01
args=(sys.stdout,)
```

--------------------------------

### Asyncio Future Example: Creating and Awaiting a Future

Source: https://github.com/python/cpython/blob/main/Doc/library/asyncio-future.rst

An example showcasing the creation of an asyncio Future, scheduling a coroutine to set its result after a delay, and then awaiting the Future's result. This illustrates a common pattern for managing asynchronous operations and their outcomes.

```python
import asyncio
import functools

async def set_after(fut, delay, value):
    # Sleep for *delay* seconds.
    await asyncio.sleep(delay)

    # Set *value* as a result of *fut* Future.
    fut.set_result(value)

async def main():
    # Get the current event loop.
    loop = asyncio.get_running_loop()

    # Create a new Future object.
    fut = loop.create_future()

    # Run "set_after()" coroutine in a parallel Task.
    # We are using the low-level "loop.create_task()" API here because
    # we already have a reference to the event loop at hand.
    # Otherwise we could have just used "asyncio.create_task()".
    loop.create_task(
        set_after(fut, 1, '... world'))

    print('hello ...')

    # Wait until *fut* has a result (1 second) and print it.
    print(await fut)

asyncio.run(main())
```

--------------------------------

### Adding Program Description and Epilog

Source: https://github.com/python/cpython/blob/main/Doc/library/argparse.rst

Shows how to include a program description displayed before argument help and an epilog displayed after argument help using the 'description' and 'epilog' arguments of ArgumentParser.

```Python
>>> parser = argparse.ArgumentParser(
...     description='A foo that bars',
...     epilog="And that's how you'd foo a bar")
>>> parser.print_help()
usage: argparse.py [-h]

A foo that bars

options:
  -h, --help  show this help message and exit

And that's how you'd foo a bar
```

--------------------------------

### Selecting Python Runtimes by Company and Tag

Source: https://github.com/python/cpython/blob/main/Doc/using/windows.rst

These commands illustrate advanced usage of the Python launcher to select specific Python runtimes based on company identifiers and version tags, following PEP 514.

```bash
py -V:3
```

```bash
py -V:PythonCore/
```

```bash
py -V:PythonCore/3
```

--------------------------------

### Python Callable Syntax Example

Source: https://github.com/python/cpython/blob/main/Doc/glossary.rst

Demonstrates the syntax for calling a callable object in Python. Callables include functions, methods, and class instances with a __call__ method.

```python
callable(argument1, argument2, argumentN)
```

--------------------------------

### Update macOS installers to update Current version symlink

Source: https://github.com/python/cpython/blob/main/Misc/NEWS.d/3.9.0a6.rst

Modifies the python.org macOS installers to correctly update the `Current` version symlink in `/Library/Frameworks/Python.framework/Versions/` for Python 3.9 installations. Previously, this symlink was only updated for Python 2.x, which could complicate embedding Python 3 in macOS applications.

```bash
# During installation process on macOS...
INSTALL_PATH="/Library/Frameworks/Python.framework/Versions"
PYTHON_VERSION="3.9"

# Remove existing symlink if it exists
rm -f "$INSTALL_PATH/Current"

# Create new symlink pointing to the installed version
ln -s "$PYTHON_VERSION" "$INSTALL_PATH/Current"

# Ensure permissions are correct
chown -h root:wheel "$INSTALL_PATH/Current"

```