================
CODE SNIPPETS
================
### Build and Install Verilator from Source on Ubuntu

Source: https://github.com/chipsalliance/chisel/blob/main/SETUP.md

Details the steps to compile and install Verilator from its source code on Ubuntu, including installing prerequisites, cloning the repository, checking out a specific version, and then building and installing.

```bash
sudo apt-get install git make autoconf g++ flex bison
```

```bash
git clone https://github.com/verilator/verilator
```

```bash
git pull
git checkout v5.004
```

```bash
unset VERILATOR_ROOT # For bash, unsetenv for csh
autoconf # Create ./configure script
./configure
make
sudo make install
```

--------------------------------

### Download Chisel Scala CLI Example

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/installation.md

Command to download the Chisel Scala CLI example file from GitHub, suitable for Linux, MacOS, and Windows Subsystem for Linux (WSL).

```bash
curl -O -L https://github.com/chipsalliance/chisel/releases/latest/download/chisel-example.scala
```

--------------------------------

### Compile and Run Chisel Scala CLI Example

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/installation.md

Command to compile and execute the downloaded Chisel Scala CLI example using Scala CLI, which emits Verilog to the screen.

```bash
scala-cli chisel-example.scala
```

--------------------------------

### Install JVM on Ubuntu

Source: https://github.com/chipsalliance/chisel/blob/main/SETUP.md

Installs the default Java Development Kit (JDK) on Ubuntu Linux, a prerequisite for SBT.

```bash
sudo apt-get install default-jdk
```

--------------------------------

### Install Firtool on Ubuntu

Source: https://github.com/chipsalliance/chisel/blob/main/SETUP.md

Provides methods to install Firtool on Ubuntu: either by downloading a pre-built binary and adding it to PATH, or by moving it to a standard system location. Choose the method that best suits your environment.

```bash
wget -q -O - https://github.com/llvm/circt/releases/download/firtool-1.56.1/circt-full-shared-linux-x64.tar.gz | tar -zx
```

```bash
export PATH=$PATH:$PWD/firtool-1.56.1/bin
```

```bash
mv firtool-1.56.1/bin/firtool /usr/local/bin/
```

--------------------------------

### Install Verilator and SBT on Arch Linux

Source: https://github.com/chipsalliance/chisel/blob/main/SETUP.md

Installs Verilator and SBT using the pacman package manager on Arch Linux.

```bash
pacman -Sy verilator sbt
```

--------------------------------

### Install FileCheck on Ubuntu

Source: https://github.com/chipsalliance/chisel/blob/main/SETUP.md

Provides two methods to install FileCheck on Ubuntu: via apt-get from LLVM tools packages or by downloading a static binary and configuring its path. Choose the method that best suits your environment.

```bash
sudo apt-get install llvm-12-tools
```

```bash
export PATH=$PATH:/usr/lib/llvm-12/bin
```

```bash
mkdir filecheck
cd filecheck
wget -q https://github.com/jackkoenig/FileCheck/releases/download/FileCheck-16.0.6/FileCheck-linux-x64
mv FileCheck-linux-x64 FileCheck
chmod +x FileCheck
export PATH=$PATH:$PWD
```

```bash
mv FileCheck /usr/local/bin
```

--------------------------------

### Install Website Dependencies using Make

Source: https://github.com/chipsalliance/chisel/blob/main/website/README.md

This command initiates the installation of all required dependencies for the website. It is a prerequisite step and should be executed before attempting any build or development operations.

```Shell
make install
```

--------------------------------

### Install Verilator and SBT on macOS

Source: https://github.com/chipsalliance/chisel/blob/main/SETUP.md

This command uses Homebrew, the macOS package manager, to install the Verilator simulator and SBT (Scala Build Tool). These are fundamental dependencies required for compiling and simulating Chisel designs.

```bash
brew install sbt verilator
```

--------------------------------

### Install SBT on Windows with Scoop

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/installation.md

Installs the Scala Build Tool (SBT) on Windows using the Scoop package manager.

```sh
scoop install sbt
```

--------------------------------

### Scala Driver Setup for Help Output

Source: https://github.com/chipsalliance/chisel/wiki/Running-Stuff

This Scala code defines a minimal Chisel module and a tester, then uses `iotesters.Driver.execute` to run the application. This setup is essential for demonstrating how to programmatically invoke the toolchain's help functionality by passing the `--help` argument.

```Scala
package xyz
import chisel3.iotesters.PeekPokeTester
import chisel3._

class Dummy extends Module { val io = IO(new Bundle {}) }
class DummyTester(c: Dummy) extends PeekPokeTester(c) {}
object Dummy extends App { iotesters.Driver.execute(args, () => new Dummy){ c => new DummyTester(c) }}
```

--------------------------------

### Chisel Module Definition Example

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/reset.md

An invisible mdoc snippet demonstrating a basic Chisel module definition, used for setup in the documentation.

```Scala
import chisel3._

class Submodule extends Module
```

--------------------------------

### Install Temurin JDK 17 on Ubuntu

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/installation.md

Commands to add the Eclipse Adoptium repository and install Temurin JDK 17 on Ubuntu systems, including GPG key setup and apt updates. Superuser privileges may be required.

```sh
# Ensure the necessary packages are present:
apt install -y wget gpg apt-transport-https

# Download the Eclipse Adoptium GPG key:
wget -qO - https://packages.adoptium.net/artifactory/api/gpg/key/public | gpg --dearmor | tee /etc/apt/trusted.gpg.d/adoptium.gpg > /dev/null

# Configure the Eclipse Adoptium apt repository
echo "deb https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | tee /etc/apt/sources.list.d/adoptium.list

# Update the apt packages
apt update

# Install
apt install temurin-17-jdk
```

--------------------------------

### Install Temurin JDK 17 on Windows with Scoop

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/installation.md

Command to install Temurin JDK 17 using the Scoop package manager on Windows.

```sh
scoop install temurin17-jdk
```

--------------------------------

### Run FIRRTL Tutorial Examples

Source: https://github.com/chipsalliance/chisel/blob/main/firrtl/README.md

Commands to compile the FIRRTL project and execute specific lessons from the tutorial, demonstrating how to apply custom transformations to a circuit.

```bash
sbt assembly
./utils/bin/firrtl -td regress -i regress/RocketCore.fir --custom-transforms tutorial.lesson1.AnalyzeCircuit
./utils/bin/firrtl -td regress -i regress/RocketCore.fir --custom-transforms tutorial.lesson2.AnalyzeCircuit
```

--------------------------------

### Import Chisel3 and Define Boolean Input

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/sequential-circuits.md

Imports the necessary Chisel3 library and defines a boolean input signal 'in' for subsequent examples, serving as an invisible setup block.

```scala
import chisel3._
val in = Bool()
```

--------------------------------

### Install SBT on Linux manually

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/installation.md

Downloads and extracts the SBT tarball, then moves the sbt bootstrap script to a global executable path for manual installation on Linux.

```sh
curl -s -L https://github.com/sbt/sbt/releases/download/v1.9.7/sbt-1.9.7.tgz | tar xvz
sudo mv sbt/bin/sbt /usr/local/bin/
```

--------------------------------

### Install Verilator on Linux with apt

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/installation.md

Installs the Verilator simulator on Debian/Ubuntu-based Linux distributions using the apt package manager. Note that this may install an older version.

```sh
apt install -y verilator
```

--------------------------------

### Chisel: Elaborating Module for Instance Access Example

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/hierarchy.md

Helper code to elaborate the `Top` module from the previous example, ensuring the `println` statement for instance field access is executed and displayed during documentation generation.

```scala
println("```")
circt.stage.ChiselStage.elaborate(new Top)
println("```")
```

--------------------------------

### Scala Range Creation Examples

Source: https://github.com/chipsalliance/chisel/wiki/CS250-Chisel+Scala-Primer

Provides examples of creating different types of numeric ranges in Scala using to, until, and by keywords, including integer and floating-point ranges.

```Scala
val a = 0 to 5            // a = (0, 1, 2, 3, 4, 5)
val b = 0 until 5         // b = (0, 1, 2, 3, 4)
val c = 0 to 4 by 2       // c = (0, 2, 4)
val d = 1.5 to 3.0 by 0.5 // d = (1.5, 2.0, 2.5, 3.0)
```

--------------------------------

### Install and Build FIRRTL from Source

Source: https://github.com/chipsalliance/chisel/blob/main/firrtl/README.md

Step-by-step commands to clone the FIRRTL repository, compile the project, run tests, build the executable, and publish the current version locally for use by other tools.

```bash
git clone https://github.com/freechipsproject/firrtl.git && cd firrtl
sbt compile
sbt test
sbt assembly
sbt publishLocal
```

--------------------------------

### Publish Chisel Project Artifacts

Source: https://github.com/chipsalliance/chisel/wiki/how-to-publish

This sequence of shell commands guides the user through preparing and publishing a Chisel project. It involves navigating to the project directory, updating the version number in `project/build.scala`, and executing the `sbt publish-signed` command to sign and publish the artifact to the configured repository.

```shell
cd ~/bar/chisel
edit ~/bar/chisel/project/build.scala and put in version number
sbt publish-signed
```

--------------------------------

### Install Mill Build Tool on Windows with Scoop

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/installation.md

Command to install the Mill build tool using the Scoop package manager on Windows.

```sh
scoop install mill
```

--------------------------------

### Chisel Experiment Setup Imports

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/connection-operators.md

Imports necessary Chisel and Chisel.util libraries, including `DecoupledIO`, required for the connection operator experiments.

```Scala
// Imports used by the following examples
import chisel3._
import chisel3.util.DecoupledIO
```

--------------------------------

### Initial SystemVerilog Emission Example

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/dataview.md

Demonstrates the basic usage of `chisel3.docs.emitSystemVerilog` to generate hardware description language from a Chisel module.

```scala
chisel3.docs.emitSystemVerilog(new ConnectionExample)
```

--------------------------------

### Clone Chisel3 GitHub Repository

Source: https://github.com/chipsalliance/chisel/wiki/intellij-setup

This command is used to clone the chisel3 project repository from GitHub to your local machine, which is the first step before importing it into IntelliJ.

```Shell
git clone https://github.com/ucb-bar/chisel3.git
```

--------------------------------

### Install SBT on MacOS with MacPorts

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/installation.md

Installs the Scala Build Tool (SBT) on MacOS using the MacPorts package manager.

```sh
sudo port install sbt
```

--------------------------------

### Install Verilator on MacOS with Homebrew

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/installation.md

Installs the Verilator simulator on MacOS using the Homebrew package manager.

```sh
brew install verilator
```

--------------------------------

### Install SBT on MacOS with Homebrew

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/installation.md

Installs the Scala Build Tool (SBT) on MacOS using the Homebrew package manager.

```sh
brew install sbt
```

--------------------------------

### Discover Chisel Tasks and Commands

Source: https://github.com/chipsalliance/chisel/blob/main/CONTRIBUTING.md

Use Mill's `resolve` command to see all available tasks and commands for the 'chisel' build unit.

```sh
./mill resolve chisel.__
```

--------------------------------

### Example Generated SystemVerilog Bind Module for Chisel Memory

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/appendix/experimental-features.md

Provides an example of the SystemVerilog bind module generated by Chisel when loadMemoryFromFile is used. This module contains an initial block with a $readmemh statement that points to the memory initialization file, effectively loading the memory contents at simulation or synthesis time.

```verilog
module BindsTo_0_Foo(
  input         clock,
  input         reset,
  input  [31:0] io_nia,
  output [31:0] io_insn
);

initial begin
  $readmemh("test.hex", Foo.memory);
end
endmodule

bind Foo BindsTo_0_Foo BindsTo_0_Foo_Inst(.*);
```

--------------------------------

### Chisel Read Probe Definition and Usage Example

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/probes.md

This Chisel example demonstrates how to define and use read probes. It showcases the `Probe`, `ProbeValue`, `define`, and `read` APIs for creating and interacting with hardware references. The example also illustrates using standard Chisel connection operators (`:<=`) with probes and the importance of `dontTouch` to prevent compiler optimizations from removing the probed signals.

```scala
import chisel3._
import chisel3.probe.{Probe, ProbeValue, define, read}

class Bar extends RawModule {
  val a_port = IO(Probe(Bool()))
  val b_port = IO(Probe(Bool()))

  private val a = dontTouch(WireInit(Bool(), true.B))
  private val a_probe = ProbeValue(a)
  define(a_port, a_probe)
  b_port :<= a_probe
}

class Foo extends RawModule {

  private val bar = Module(new Bar)

  private val a_read = dontTouch(WireInit(read(bar.a_port)))
  private val b_read = dontTouch(WireInit(read(bar.b_port)))
}
```

--------------------------------

### Install Verilator on MacOS with MacPorts

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/installation.md

Installs the Verilator simulator on MacOS using the MacPorts package manager.

```sh
sudo port install verilator
```

--------------------------------

### Query Chisel's recommended firtool version using Scala CLI

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/installation.md

Executes a Scala CLI command to programmatically retrieve the recommended firtool version for a specific Chisel library version.

```bash
scala-cli -S 2.13 -e 'println(chisel3.BuildInfo.firtoolVersion)' --dep org.chipsalliance::chisel:6.0.0
```

--------------------------------

### Download and Prepare FileCheck on macOS

Source: https://github.com/chipsalliance/chisel/blob/main/SETUP.md

This sequence of commands creates a new directory, navigates into it, downloads the FileCheck binary from GitHub, renames it for convenience, and makes it executable. FileCheck is a utility used for pattern matching and verification, often in test suites.

```bash
mkdir filecheck
cd filecheck
wget -q https://github.com/jackkoenig/FileCheck/releases/download/FileCheck-16.0.6/FileCheck-macos-x64
mv FileCheck-macos-x64 FileCheck
chmod +x FileCheck
```

--------------------------------

### Discover All Mill Projects

Source: https://github.com/chipsalliance/chisel/blob/main/CONTRIBUTING.md

Use Mill's `resolve` command with a wildcard to list all available projects in the build system.

```sh
./mill resolve _
```

--------------------------------

### Download Mill Wrapper Script (millw) for Linux/MacOS

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/installation.md

Command to download the Mill wrapper script (`millw`) and make it executable, for use on Linux and MacOS systems.

```sh
curl -L https://raw.githubusercontent.com/lefou/millw/0.4.11/millw > mill && chmod +x mill
```

--------------------------------

### Running Scala REPL with SBT

Source: https://github.com/chipsalliance/chisel/wiki/CS250-Chisel+Scala-Primer

Demonstrates how to start the Scala Read-Evaluate-Print Loop (REPL) using the sbt build tool. It shows basic variable assignments and range operations within the interactive console, illustrating immediate execution of Scala code.

```Scala
> sbt console

[info] Compiling 4 Scala sources to /Volumes/UCB-BAR/chisel-template/target/scala-2.11/classes...
[warn] there were 48 feature warnings; re-run with -feature for details
[warn] one warning found
[info] Starting scala interpreter...
[info]
Welcome to Scala version 2.11.7 (Java HotSpot(TM) 64-Bit Server VM, Java 1.8.0_20).
Type in expressions to have them evaluated.
Type :help for more information.

scala> val a = 1
a: Int = 1

scala> val b = 7
b: Int = 7

scala> val c = a + b
c: Int = 8

scala> val z = (0 to 10 by 2).reverse
z: scala.collection.immutable.Range = Range(10, 8, 6, 4, 2, 0)

scala>
```

--------------------------------

### Define and execute a basic Chisel 'HelloWorld' module in Scala

Source: https://github.com/chipsalliance/chisel/wiki/Frequently-Asked-Questions

This Scala code defines a simple Chisel module named `HelloWorld` that prints 'hello world' during elaboration, and an accompanying `App` object to execute it using the Chisel driver. This setup allows for the generation of Verilog from the Chisel design.

```Scala
package intro
import chisel3._
class HelloWorld extends Module {
  val io = IO(new Bundle{})
  printf("hello world\n")
}
```

```Scala
object HelloWorld extends App {
  chisel3.Driver.execute(args, () => new HelloWorld)
  // Alternate version if there are no args
  // chisel3.Driver.execute(Array[String](), () => new HelloWorld)
}
```

--------------------------------

### Generate Verilog for Chisel '<>' Operator Example

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/connection-operators.md

Command to emit SystemVerilog code for the `Wrapper` module, illustrating the hardware generated by the `<>` operator connections.

```Scala
chisel3.docs.emitSystemVerilog(new Wrapper)
```

--------------------------------

### Generate Verilog from Chisel using SBT Scala console

Source: https://github.com/chipsalliance/chisel/wiki/Frequently-Asked-Questions

This bash command sequence demonstrates how to start the SBT console and then directly execute the Chisel driver from within the Scala interpreter to generate Verilog for a Chisel module.

```bash
sbt
> console
scala> chisel3.Driver.execute(Array[String](), () => new HelloWorld)
```

--------------------------------

### Chisel Example: Defining and Using Read-Write Probes

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/probes.md

This Chisel code defines a `Bar` module with read-write probe ports and a `Foo` module that instantiates `Bar` and demonstrates the full lifecycle of read-write probes. It showcases the use of `RWProbe` for type definition, `RWProbeValue` for creating probe instances, and the `force`, `release`, `forceInitial`, `releaseInitial`, and `read` APIs for controlling and observing probed signals. The example also illustrates `dontTouch` to prevent optimization interference.

```scala
import chisel3._
import chisel3.probe.{RWProbe, RWProbeValue, force, forceInitial, read, release, releaseInitial}

class Bar extends RawModule {
  val a_port = IO(RWProbe(Bool()))
  val b_port = IO(RWProbe(UInt(8.W)))

  private val a = WireInit(Bool(), true.B)
  a_port :<= RWProbeValue(a)

  private val b = WireInit(UInt(8.W), 0.U)
  b_port :<= RWProbeValue(b)
}

class Foo extends Module {
  val cond = IO(Input(Bool()))

  private val bar = Module(new Bar)

  // Example usage of forceInitial/releaseInitial:
  forceInitial(bar.a_port, false.B)
  releaseInitial(bar.a_port)

  // Example usage of force/release:
  when (cond) {
    force(bar.b_port, 42.U)
  }.otherwise {
    release(bar.b_port)
  }

  // The read API may still be used:
  private val a_read = dontTouch(WireInit(read(bar.a_port)))
}
```

--------------------------------

### Install Temurin JDK 17 on MacOS with Homebrew

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/installation.md

Command to install Temurin JDK 17 using the Homebrew package manager on macOS.

```sh
brew install temurin@17
```

--------------------------------

### Chisel ScalaDoc Comment Style

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/developers/style.md

Describes the use of ScalaDoc for generating documentation from source code. Comments should be formatted for ScalaDoc, even if the examples provided are in Javadoc style. The guidance emphasizes writing documentation for a knowledgeable audience and considering refactoring complex comments into separate methods.

```Java
/** Multiple lines of ScalaDoc text are written here,
  * wrapped normally...
  */
public int method(String p1) { ... }
```

```Java
/** An especially short bit of Javadoc. */
```

--------------------------------

### Convert Chisel UInt to Vec of Bools

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/cookbook.md

This example illustrates how to convert a Chisel UInt into a Vec of Bools. It leverages the `asBools` method to get a sequence of Bools from the UInt, which is then used with `VecInit` to construct the Vec.

```Scala
import chisel3._

class Foo extends Module {
  val uint = 0xc.U
  val vec = VecInit(uint.asBools)

  printf(cf"$vec") // Vec(0, 0, 1, 1)

  // Test
  assert(vec(0) === false.B)
  assert(vec(1) === false.B)
  assert(vec(2) === true.B)
  assert(vec(3) === true.B)
}
```

--------------------------------

### Example Scala Function for Integer Addition

Source: https://github.com/chipsalliance/chisel/wiki/CS250-Chisel+Scala-Primer

A concise example of a Scala function that adds two integers. The return type is inferred by the compiler in this case, demonstrating Scala's type inference capabilities.

```Scala
def addInt(c: Int, d: Int) = c + d
```

--------------------------------

### FIRRTL Interpreter REPL Help Commands

Source: https://github.com/chipsalliance/chisel/wiki/Debugging-with-the-Interpreter-REPL-2

This snippet lists all available commands in the FIRRTL interpreter REPL, providing a comprehensive guide for interacting with and debugging circuits. Commands range from loading files and running scripts to inspecting and manipulating circuit components.

```REPL Command
load fileName                                    load/replace the current firrtl file
script fileName                                  load a script from a text file
run [linesToRun|all|list|reset]                  run loaded script
vcd [load|run|list|test|help]                    control vcd input file
record-vcd [<fileName>]|[done]                   firrtl_interpreter.vcd loaded script
type regex                                       show the current type of things matching the regex
poke inputPortName value                         set an input port to the given integer value
mempoke memory-instance-name index value         set memory at index to value
rpoke regex value                                poke value into ports that match regex
eval componentName                               show the computation of the component
peek componentName                               show the current value of the named circuit component
mempeek memory-instance-name index               peek memory at index
rpeek regex                                      show the current value of things matching the regex
randomize                                        randomize all inputs except reset)
poison                                           poison everything)
reset [numberOfSteps]                            assert reset (if present) for numberOfSteps (default 1)
step [numberOfSteps]                             cycle the clock numberOfSteps (default 1) times, and show state
waitfor componentName value [maxNumberOfSteps]   wait for particular value (default 1) on component, up to maxNumberOfSteps (default 100)
show [state|input|lofirrtl]                      show useful things
info                                             show information about the circuit
timing [clear|bin]                               show the current timing state
verbose [true|false|toggle]                      set evaluator verbose mode (default toggle) during dependency evaluation
eval-all [true|false|toggle]                     set evaluator to execute un-needed branches (default toggle) during dependency evaluation
allow-cycles [true|false|toggle]                 set evaluator allow combinational loops (could cause correctness problems
ordered-exec [true|false|toggle]                 set evaluator execute circuit in dependency order, now recursive component evaluation
help                                             show available commands
quit                                             exit the interpreter
```

--------------------------------

### Chisel Imports for Examples

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/chisel-enum.md

Standard imports required for the Chisel examples demonstrating ChiselEnum functionality, including core Chisel3 utilities.

```Scala
import chisel3._
import chisel3.util._
```

--------------------------------

### Convert UInt to Chisel Bundle

Source: https://github.com/chipsalliance/chisel/wiki/Cookbook

Illustrates how to create a Chisel Bundle from a UInt by calling the `fromBits` method on a Bundle instance, passing the UInt as an argument. Shows an example converting a UInt back into a `MyBundle`.

```Scala
  // Example
  class MyBundle extends Bundle {
    val foo = UInt(4.W)
    val bar = UInt(4.W)
  }
  val uint = 0xb4.U
  val bundle = (new MyBundle).fromBits(uint)
  printf(p"$bundle") // Bundle(foo -> 11, bar -> 4)

  // Test
  assert(bundle.foo === 0xb.U)
  assert(bundle.bar === 0x4.U)
```

--------------------------------

### Serve Website Locally for Development using Make

Source: https://github.com/chipsalliance/chisel/blob/main/website/README.md

This command launches a local web server to host the built website. It enables developers to preview changes in real-time, facilitating an efficient development workflow by instantly reflecting local modifications.

```Shell
make serve
```

--------------------------------

### Install Temurin JDK 17 on MacOS with MacPorts

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/installation.md

Command to install OpenJDK 17 Temurin using the MacPorts package manager on macOS.

```sh
sudo port install openjdk17-temurin
```

--------------------------------

### FIRRTL Source Locator Syntax Example

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/source-locators.md

Illustrates the syntax of a source locator comment within a FIRRTL wire declaration, showing the file path and line number.

```FIRRTL
wire w : UInt<3> @[src/main/scala/MyProject/MyFile.scala 1210:21]
```

--------------------------------

### Scala Constant Naming Conventions

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/developers/style.md

Defines and demonstrates the UpperCamelCase convention for constants in Scala, which are final fields (val or object) with deeply immutable contents. Examples contrast true constants with non-constant variables to clarify the definition and proper usage.

```Scala
// Constants
object Constants {
  val Number = 5
  val Names = "Ed" :: "Ann" :: Nil
  val Ages = Map("Ed" -> 35, "Ann" -> 32)
}

// Not constants
class NonConstantsInClass {
  val inClass: String = "in-class"
}

object nonConstantsInObject {
  var varString = "var-string"
  val mutableCollection: scala.collection.mutable.Set[String]
  val mutableElements = Set(mutable)
}
```

--------------------------------

### FIRRTL Command Line Tool Usage

Source: https://github.com/chipsalliance/chisel/blob/main/firrtl/README.md

Examples demonstrating how to use the compiled `firrtl` command-line tool to compile a FIRRTL input file to Verilog and to display the tool's usage string.

```bash
utils/bin/firrtl -i regress/rocket.fir -o regress/rocket.v -X verilog // Compiles rocket-chip to Verilog
utils/bin/firrtl --help // Returns usage string
```

--------------------------------

### Run Chisel Unit Tests

Source: https://github.com/chipsalliance/chisel/blob/main/README.md

Command to execute the included unit tests for the Chisel library. Successful execution requires `verilator`, `yosys`, and `espresso` to be installed and accessible on the system's PATH.

```bash
./mill chisel[].test
```

--------------------------------

### Discover Chisel Cross-Compile Versions

Source: https://github.com/chipsalliance/chisel/blob/main/CONTRIBUTING.md

Use Mill's `resolve` command to see all cross-compile versions available for the 'chisel' build unit.

```sh
./mill resolve chisel._
```

--------------------------------

### Emit SystemVerilog for Working Tuple Example

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/dataview.md

Confirms the successful generation of SystemVerilog for the `TupleExample` after applying `DataView` and implicit conversions, verifying the functionality.

```scala
// Always emit Verilog to make sure it actually works
chisel3.docs.emitSystemVerilog(new TupleExample)
```

--------------------------------

### Build Static Website using Make

Source: https://github.com/chipsalliance/chisel/blob/main/website/README.md

This command compiles and generates the complete static website, outputting it into the 'build' directory. The process involves multiple automated steps handled by the Makefile, including Scala source compilation, markdown generation, file copying, contributor determination, and Docusaurus execution.

```Shell
make build
```

--------------------------------

### Download and Extract firtool on macOS

Source: https://github.com/chipsalliance/chisel/blob/main/SETUP.md

This command downloads the firtool binary for macOS from the official LLVM CIRCT GitHub releases using `wget` and extracts it. firtool is a crucial tool for Chisel compilation, converting FIRRTL to Verilog.

```bash
wget -q -O - https://github.com/llvm/circt/releases/download/firtool-1.56.1/circt-full-shared-macos-x64.tar.gz | tar -zx
```

--------------------------------

### ChiselSim Custom and Reusable Stimulus Patterns Example in ScalaTest

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/testing.md

This comprehensive ScalaTest example demonstrates various ChiselSim simulation techniques within a single `ChiselSimExample` test suite. It includes custom stimulus using `poke` and `expect` for a `Foo` module, and the application of reusable stimulus patterns like `RunUntilFinished` for a `Bar` module and `RunUntilSuccess` for a `Baz` module.

```Scala
import chisel3._
import chisel3.simulator.scalatest.ChiselSim
import chisel3.simulator.stimulus.{RunUntilFinished, RunUntilSuccess}
import chisel3.util.Counter
import org.scalatest.funspec.AnyFunSpec

class ChiselSimExample extends AnyFunSpec with ChiselSim {

  class Foo extends Module {
    val a, b = IO(Input(UInt(8.W)))
    val c = IO(Output(chiselTypeOf(a)))

    private val r = Reg(chiselTypeOf(a))

    r :<= a +% b
    c :<= r
  }

  describe("Baz") {

    it("adds two numbers") {

      simulate(new Foo) { foo =>
        // Poke different values on the two input ports.
        foo.a.poke(1)
        foo.b.poke(2)

        // Step the clock by one cycle.
        foo.clock.step(1)

        // Expect that the sum of the two inputs is on the output port.
        foo.c.expect(3)
      }

    }

  }

  class Bar extends Module {

    val (_, done) = Counter(true.B, 10)

    when (done) {
      stop()
    }

  }

  describe("Bar") {

    it("terminates cleanly before 11 cycles have elapsed") {

      simulate(new Bar)(RunUntilFinished(11))

    }

  }

  class Baz extends Module {

    val success = IO(Output(Bool()))

    val (_, done) = Counter(true.B, 20)

    success :<= done

  }

  describe("Baz") {

    it("asserts success before 21 cycles have elapsed") {

      simulate(new Baz)(RunUntilSuccess(21, _.success))

    }

  }

}
```

--------------------------------

### Examples of `desiredName` in Chisel Modules

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/naming.md

Provides practical examples demonstrating the effect of `desiredName` on the generated Verilog module names for both custom Chisel modules and built-in utilities like `Queue`. It shows how type parameters are incorporated into the module names, resulting in descriptive and unique identifiers.

```Scala
val foo = Module(new MyModule(UInt(4.W))) // MyModule_UInt4
val bar = Module(new MyModule(Vec(3, UInt(4.W)))) // MyModule_Vec3_UInt4
```

```Scala
val fooQueue = Module(new Queue(UInt(8.W), 4)) // Verilog module would be named 'Queue4_UInt8'
val barQueue = Module(new Queue(SInt(12.W), 3)) // ... and 'Queue3_SInt12'
val bazQueue = Module(new Queue(Bool(), 16)) // ... and 'Queue16_Bool'
```

--------------------------------

### Chisel Example: Annotating I/Os with Select.ios Function

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/hierarchy.md

This Scala code illustrates how to use `Select.ios` on both `Definition` and `Instance` objects to annotate the input/output ports of modules within a Chisel design. It shows how to traverse the hierarchy and apply annotations to specific I/Os.

```Scala
@instantiable
class InOutModule extends Module {
  @public val in = IO(Input(Bool()))
  @public val out = IO(Output(Bool()))
  out := in
}

@instantiable
class TwoInOutModules extends Module {
  val in = IO(Input(Bool()))
  val out = IO(Output(Bool()))
  val definition = Definition(new InOutModule)
  val i0         = Instance(definition)
  val i1         = Instance(definition)
  i0.in := in
  i1.in := i0.out
  out := i1.out
}

class InOutTop extends Module {
  val definition = Definition(new TwoInOutModules)
  val instance   = Instance(definition)
  aop.Select.allInstancesOf[InOutModule](instance).foreach { i =>
    aop.Select.ios(i).foreach { io =>
      experimental.annotate(io) {
        println("instance io: " + io.toTarget)
        Nil
      }
    }
  }
  aop.Select.allDefinitionsOf[InOutModule](instance).foreach { d =>
    aop.Select.ios(d).foreach { io =>
      experimental.annotate(io) {
        println("definition io: " + io.toTarget)
        Nil
      }
    }
  }
}
```

--------------------------------

### Run Tests for Chisel Build Unit

Source: https://github.com/chipsalliance/chisel/blob/main/CONTRIBUTING.md

Execute tests specifically for the Chisel build unit. The `[]` syntax picks the default Scala version for cross-compilation.

```sh
./mill chisel[].test.test
```

--------------------------------

### Chisel BlackBox Instantiation with Verilog Parameters

Source: https://github.com/chipsalliance/chisel/wiki/BlackBoxes

Demonstrates how to instantiate a Chisel `BlackBox` and pass Verilog parameters using a `Map` in the constructor. This example shows the instantiation of a Xilinx IBUFDS with `DIFF_TERM` and `IOSTANDARD` parameters. The accompanying Verilog snippet illustrates the resulting generated Verilog code with parameters correctly applied.

```Scala
import chisel3._
import chisel3.util._
import chisel3.experimental._ // To enable experimental features

class IBUFDS extends BlackBox(Map("DIFF_TERM" -> "TRUE",
                                  "IOSTANDARD" -> "DEFAULT")) {
  val io = IO(new Bundle {
    val O = Output(Clock())
    val I = Input(Clock())
    val IB = Input(Clock())
  })
}
```

```Verilog
IBUFDS #(.DIFF_TERM("TRUE"), .IOSTANDARD("DEFAULT")) ibufds (
  .IB(ibufds_IB),
  .I(ibufds_I),
  .O(ibufds_O)
);
```

--------------------------------

### Move firtool to standard system binary path

Source: https://github.com/chipsalliance/chisel/blob/main/SETUP.md

This command moves the firtool binary to a common system-wide executable directory, `/usr/local/bin`. This makes `firtool` permanently available to all users and shell sessions without needing to manually modify the PATH environment variable.

```bash
mv firtool-1.56.1/bin/firtool /usr/local/bin/
```

--------------------------------

### Convert Chisel Bundle to UInt

Source: https://github.com/chipsalliance/chisel/wiki/Cookbook

Demonstrates how to convert an instance of a Chisel Bundle into a UInt by calling the `asUInt` method on the Bundle instance. Includes an example with a `MyBundle` containing `foo` and `bar` UInts.

```Scala
  // Example
  class MyBundle extends Bundle {
    val foo = UInt(4.W)
    val bar = UInt(4.W)
  }
  val bundle = Wire(new MyBundle)
  bundle.foo := 0xc.U
  bundle.bar := 0x3.U
  val uint = bundle.asUInt
  printf(p"$uint") // 195

  // Test
  assert(uint === 0xc3.U)
```

--------------------------------

### Creating a Finite State Machine (FSM) in Chisel

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/cookbook.md

Illustrates the recommended approach for building FSMs in Chisel using ChiselEnum for state definition and switch/is along with when/.elsewhen/.otherwise for state transitions. The example demonstrates a simple FSM to detect two consecutive '1's.

```Scala
import chisel3._
import chisel3.util.{switch, is}

object DetectTwoOnes {
  object State extends ChiselEnum {
    val sNone, sOne1, sTwo1s = Value
  }
}

/* This FSM detects two 1's one after the other */
class DetectTwoOnes extends Module {
  import DetectTwoOnes.State
  import DetectTwoOnes.State._

  val io = IO(new Bundle {
    val in = Input(Bool())
    val out = Output(Bool())
    val state = Output(State())
  })

  val state = RegInit(sNone)

  io.out := (state === sTwo1s)
  io.state := state

  switch (state) {
    is (sNone) {
      when (io.in) {
        state := sOne1
      }
    }
    is (sOne1) {
      when (io.in) {
        state := sTwo1s
      } .otherwise {
        state := sNone
      }
    }
    is (sTwo1s) {
      when (!io.in) {
        state := sNone
      }
    }
  }
}
```

--------------------------------

### Simplified Chisel Module Instantiation with Instantiate

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/hierarchy.md

This example demonstrates the `Instantiate` API, a streamlined approach for creating multiple instances of a Chisel module. Similar to `Definition` and `Instance`, `Instantiate` ensures that modules are elaborated only once for a given set of parameters, simplifying the instantiation process while maintaining efficiency.

```Scala
import chisel3.experimental.hierarchy.Instantiate

class AddTwoInstantiate(width: Int) extends Module {
  val in  = IO(Input(UInt(width.W)))
  val out = IO(Output(UInt(width.W)))
  val i0 = Instantiate(new AddOne(width))
  val i1 = Instantiate(new AddOne(width))
  i0.in := in
  i1.in := i0.out
  out   := i1.out
}
```

```SystemVerilog
chisel3.docs.emitSystemVerilog(new AddTwoInstantiate(16))
```

--------------------------------

### Run All Project Tests

Source: https://github.com/chipsalliance/chisel/blob/main/CONTRIBUTING.md

Execute all tests across the entire project. The cross-version behavior may change in future updates.

```sh
./mill __.test
```

--------------------------------

### Example Scala Procedure for Printing

Source: https://github.com/chipsalliance/chisel/wiki/CS250-Chisel+Scala-Primer

A simple Scala procedure that takes an integer and prints its value to the console. This demonstrates a function with side effects and no explicit return value, typical for I/O operations.

```Scala
def printMe(a: Int) {println("Val="+a)}
```

--------------------------------

### Execute Chisel Driver with Help Flag via SBT

Source: https://github.com/chipsalliance/chisel/wiki/Running-Stuff

This bash command demonstrates how to execute the previously defined Scala `Dummy` application using `sbt`. The `--help` flag is passed as an argument to the main method, triggering the display of all available command-line options for the Chisel/FIRRTL toolchain.

```Bash
sbt 'run-main xyz.Dummy --help'
```

--------------------------------

### Create a Finite State Machine (FSM) in Chisel

Source: https://github.com/chipsalliance/chisel/wiki/Cookbook

Demonstrates how to construct a finite state machine using Chisel's Enum for state definition and `switch`/`is` for control logic. The example implements a 2-ones detector.

```scala
import chisel3._
import chisel3.util._

class DetectTwoOnes extends Module {
  val io = IO(new Bundle {
    val in = Input(Bool())
    val out = Output(Bool())
  })

  val sNone :: sOne1 :: sTwo1s :: Nil = Enum(3)
  val state = RegInit(sNone)

  io.out := (state === sTwo1s)

  switch (state) {
    is (sNone) {
      when (io.in) {
        state := sOne1
      }
    }
    is (sOne1) {
      when (io.in) {
        state := sTwo1s
      } .otherwise {
        state := sNone
      }
    }
    is (sTwo1s) {
      when (!io.in) {
        state := sNone
      }
    }
  }
}
```

--------------------------------

### Uninstall Homebrew Java dependency for SBT

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/installation.md

Removes the Java version installed by Homebrew as an SBT dependency, which may not be compatible with SBT.

```sh
brew uninstall --ignore-dependencies java
```

--------------------------------

### Verilog Source Locator Comment Example

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/source-locators.md

Demonstrates how Chisel's source locator appears as a comment next to a wire declaration in a generated Verilog file.

```Verilog
wire [2:0] w; // @[src/main/scala/MyProject/MyFile.scala 1210:21]
```

--------------------------------

### Move Mill Wrapper Script to Global Path (Linux/MacOS)

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/installation.md

Command to move the downloaded Mill wrapper script to a global executable path (`/usr/local/bin/`) for system-wide access on Linux and MacOS.

```sh
sudo mv mill /usr/local/bin/
```

--------------------------------

### Chisel Intrinsics: Example of IntrinsicExpr Usage

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/intrinsics.md

This example demonstrates how to define an `IntrinsicExpr` within a Chisel `RawModule`. It shows the creation of an intrinsic named 'MyIntrinsic' with a parameterized string 'STRING' and two `UInt` inputs, producing a 32-bit `UInt` result.

```Scala
class Foo extends RawModule {
  val myresult = IntrinsicExpr("MyIntrinsic", UInt(32.W), "STRING" -> "test")(3.U, 5.U)
}
```

--------------------------------

### Move FileCheck to standard system binary path

Source: https://github.com/chipsalliance/chisel/blob/main/SETUP.md

This command moves the FileCheck binary to a common system-wide executable directory, `/usr/local/bin`. This makes `FileCheck` permanently available to all users and shell sessions without requiring manual PATH configuration.

```bash
mv FileCheck /usr/local/bin
```

--------------------------------

### Scala Pattern Matching Example

Source: https://github.com/chipsalliance/chisel/wiki/CS250-Chisel+Scala-Primer

Demonstrates Scala's powerful pattern matching (match expression) with case statements, including guards (if i > 5) and wildcard (_) patterns, to process values from a sequence.

```Scala
val a = Seq(8, 6, 7, 5, 3, 0, 9)

for( i <- a ){
	val rtn = i match {
		case _ if i > 5 => "over"
		case 5          => "five"
		case _         => "under"
	}
	println(rtn)
}
```

--------------------------------

### Add sbt-pgp Plugin and Resolver

Source: https://github.com/chipsalliance/chisel/wiki/how-to-publish

This sbt configuration, usually found in `~/.sbt/plugins/build.sbt`, adds the `sbt-pgp` plugin for PGP signing and defines a resolver for sbt plugin releases. This plugin is essential for signing artifacts before publishing them.

```sbt
resolvers += Resolver.url("scalasbt", new URL("http://scalasbt.artifactoryonline.com/scalasbt/sbt-plugin-releases")) (Resolver.ivyStylePatterns)

addSbtPlugin("com.typesafe.sbt" % "sbt-pgp" % "0.8")
```

--------------------------------

### Start VCD Recording in Repl

Source: https://github.com/chipsalliance/chisel/wiki/Debugging-with-the-Interpreter-REPL-3

This Repl command initiates VCD recording during execution. All subsequent circuit changes (from poke, step, etc.) will be logged to the specified file. Remember to include the `.vcd` suffix as it is not automatically appended.

```Repl
record-vcd gcd-run-1.vcd
```

--------------------------------

### Create Chisel Reg of Vec Type

Source: https://github.com/chipsalliance/chisel/wiki/Cookbook

Provides examples for creating a `Reg` of type `Vec` in Chisel, emphasizing that `Vec` is a type, not a value. Includes examples for creating a `Reg` of `Vec` of `UInt`s without initialization and with initialization to zero using `RegInit` and `VecInit`.

```Scala
  // Reg of Vec of 32-bit UInts without initialization
  val regOfVec = Reg(Vec(4, UInt(32.W)))
  regOfVec(0) := 123.U // a couple of assignments
  regOfVec(2) := regOfVec(0)

  // Reg of Vec of 32-bit UInts initialized to zero
  //   Note that Seq.fill constructs 4 32-bit UInt literals with the value 0
  //   VecInit(...) then constructs a Wire of these literals
  //   The Reg is then initialized to the value of the Wire (which gives it the same type)
  val initRegOfVec = RegInit(VecInit(Seq.fill(4)(0.U(32.W))))

  // Simple test (cycle comes from superclass)
  when (cycle === 2.U) { assert(regOfVec(2) === 123.U) }
  for (elt <- initRegOfVec) { assert(elt === 0.U) }
```

--------------------------------

### Convert Chisel UInt to Bundle

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/cookbook.md

This example illustrates the process of converting a UInt back into a Chisel Bundle. It uses the `asTypeOf` method on the UInt, reinterpreting its bits according to the structure and types defined in the target Bundle.

```Scala
import chisel3._

class MyBundle extends Bundle {
  val foo = UInt(4.W)
  val bar = UInt(4.W)
}

class Foo extends Module {
  val uint = 0xb4.U
  val bundle = uint.asTypeOf(new MyBundle)

  printf(cf"$bundle") // Bundle(foo -> 11, bar -> 4)

  // Test
  assert(bundle.foo === 0xb.U)
  assert(bundle.bar === 0x4.U)
}
```

--------------------------------

### Chisel3 Subword Assignment Error Example

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/cookbook.md

This example demonstrates an attempt to perform direct subword assignment to a UInt in Chisel3, which is not supported. Compiling this code will result in an error, highlighting Chisel's design philosophy against direct bit manipulation in favor of structured types.

```Scala
import chisel3._

class Foo extends Module {
  val io = IO(new Bundle {
    val bit = Input(Bool())
    val out = Output(UInt(10.W))
  })
  io.out(0) := io.bit
}
```

```Scala
getVerilogString(new Foo)
```

--------------------------------

### Example Hardware Boolean Literal (Chisel/Verilog)

Source: https://github.com/chipsalliance/chisel/wiki/ChiselSheet

This example demonstrates a hardware boolean literal `true` in Chisel, written as `true.B`. Its direct Verilog equivalent is `1`, representing a constant high signal in hardware.

```Chisel
true.B
```

```Verilog
1
```

--------------------------------

### Run Chisel FIRRTL generation application via sbt

Source: https://github.com/chipsalliance/chisel/wiki/Frequently-Asked-Questions

Command to execute the Scala application for FIRRTL generation using sbt's `runMain` command. Replace 'intro.Main' with the actual main class.

```Shell
sbt 'runMain intro.Main'
```

--------------------------------

### Start Repl with Specific VCD Script Override

Source: https://github.com/chipsalliance/chisel/wiki/Debugging-with-the-Interpreter-REPL-3

This command line invocation starts the Repl and instructs it to use a specific VCD file as an input script, overriding the default VCD script behavior. The VCD file provides input and controls stepping for the simulation.

```Shell
test:runMain gcd.GCDRepl --vcdScriptOverride test_run_dir/gcd.GCDMain2061991994/GCD.vcd
```

--------------------------------

### Example Compile-time Logic Assignment (Scala/Verilog)

Source: https://github.com/chipsalliance/chisel/wiki/ChiselSheet

This example illustrates compile-time logic assignments in Scala, such as `val sum = a ^ b; val carry = a && b`. These assignments define variables that are resolved during hardware generation, resulting in corresponding `wire` declarations and assignments in Verilog, like `wire sum = a ^ b; wire carry = a && b;`.

```Scala
val sum = a ^ b; val carry = a && b
```

```Verilog
wire sum = a ^ b; wire carry = a && b;
```

--------------------------------

### Build Chisel from Source

Source: https://github.com/chipsalliance/chisel/blob/main/README.md

Instructions to clone the Chisel repository and compile the library using the `mill` build tool. This sets up a local development environment for Chisel.

```bash
git clone https://github.com/chipsalliance/chisel.git
cd chisel
./mill chisel[].compile
```

--------------------------------

### Chisel Property[Int] Integer Addition Example

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/properties.md

This Scala example demonstrates how to perform integer addition using `Property[Int]` types in Chisel. An output `address` is computed by adding an `offset` `Property[Int]` to a `base` `Property[Int]` input, showcasing basic arithmetic operations on Chisel properties.

```scala
class IntegerArithmeticExample extends RawModule {
  val base = IO(Input(Property[Int]()))
  val address = IO(Output(Property[Int]()))
  val offset = Property(1024)
  address := base + offset
}
```

--------------------------------

### Instantiate and Access Elements of a Chisel Vec

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/bundles-and-vecs.md

This example shows how to create a `Vec` of 5 signed 23-bit integers. It also demonstrates how to access individual elements of the `Vec` using an index, similar to array access.

```scala
class ModuleWithVec extends RawModule {
  // Vector of 5 23-bit signed integers.
  val myVec = Wire(Vec(5, SInt(23.W)))

  // Connect to one element of vector.
  val reg3 = myVec(3)
}
```

--------------------------------

### ChiselStage.emitSystemVerilog String Return Example

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/resources/faqs.md

This Scala snippet illustrates a direct call to `ChiselStage.emitSystemVerilog` that returns the Verilog as a string rather than emitting a file, as noted in the documentation.

```scala
ChiselStage.emitSystemVerilog(new HelloWorld())
```

--------------------------------

### Generate Verilog from Chisel using SBT run-main

Source: https://github.com/chipsalliance/chisel/wiki/Frequently-Asked-Questions

These bash commands demonstrate how to invoke the Chisel driver via SBT to elaborate a Chisel module and generate its corresponding Verilog file. Both interactive and one-liner approaches are shown.

```bash
sbt
> run-main intro.HelloWorld
```

```bash
sbt 'runMain intro.HelloWorld'
```

--------------------------------

### Create Multi-dimensional Vectors with VecInit.fill and VecInit.tabulate in Chisel

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/cookbook.md

This Chisel snippet demonstrates how to construct 2D and 3D vectors using VecInit.fill for uniform initialization and VecInit.tabulate for index-based initialization. It includes examples with basic UInt types and custom Bundle types, showcasing how to create complex data structures in hardware.

```scala
import chisel3._

class MyBundle extends Bundle {
  val foo = UInt(4.W)
  val bar = UInt(4.W)
}

class Foo extends Module {
  //2D Fill
  val twoDVec = VecInit.fill(2, 3)(5.U)
  //3D Fill
  val myBundle = Wire(new MyBundle)
  myBundle.foo := 0xc.U
  myBundle.bar := 0x3.U
  val threeDVec = VecInit.fill(1, 2, 3)(myBundle)
  assert(threeDVec(0)(0)(0).foo === 0xc.U && threeDVec(0)(0)(0).bar === 0x3.U)

  //2D Tabulate
  val indexTiedVec = VecInit.tabulate(2, 2){ (x, y) => (x + y).U }
  assert(indexTiedVec(0)(0) === 0.U)
  assert(indexTiedVec(0)(1) === 1.U)
  assert(indexTiedVec(1)(0) === 1.U)
  assert(indexTiedVec(1)(1) === 2.U)
  //3D Tabulate
  val indexTiedVec3D = VecInit.tabulate(2, 3, 4){ (x, y, z) => (x + y * z).U }
  assert(indexTiedVec3D(0)(0)(0) === 0.U)
  assert(indexTiedVec3D(1)(1)(1) === 2.U)
  assert(indexTiedVec3D(1)(1)(2) === 3.U)
  assert(indexTiedVec3D(1)(1)(3) === 4.U)
  assert(indexTiedVec3D(1)(2)(3) === 7.U)
}
```

--------------------------------

### Migrating Verilog Generation from Chisel2 to Chisel3

Source: https://github.com/chipsalliance/chisel/wiki/Chisel3-vs-Chisel2

Details the change in the main entry point for Verilog generation. Chisel3 uses `chisel3.Driver.execute` instead of `chiselMain` for compiling and generating Verilog.

```Scala
// Chisel2
object Hello {
  def main(args: Array[String]): Unit = {
    chiselMain(Array("--backend", "v"), () => Module(new Hello()))
  }
}
```

```Scala
// Chisel3
object Hello {
  def main(args: Array[String]): Unit = {
    chisel3.Driver.execute(Array[String](), () => new Hello())
  }
}
```

--------------------------------

### Chisel Property[Seq[Int]] Sequence Concatenation Example

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/properties.md

This Scala example illustrates how to concatenate sequences using `Property[Seq[Int]]` types in Chisel. An output `c` is formed by concatenating two input sequences, `a` and `b`, demonstrating sequence manipulation with the `++` operator.

```scala
class SequenceOperationExample extends RawModule {
  val a = IO(Input(Property[Seq[Int]]()))
  val b = IO(Input(Property[Seq[Int]]()))
  val c = IO(Output(Property[Seq[Int]]()))
  c := a ++ b
}
```

--------------------------------

### Example Compile-time Boolean Parameter (Scala/Verilog)

Source: https://github.com/chipsalliance/chisel/wiki/ChiselSheet

This example shows defining a compile-time boolean parameter in Scala, `val boolParam: Boolean = false`. This translates to `localparam boolParam = 0;` in Verilog, where `false` is represented by `0`, fixed at synthesis time.

```Scala
val boolParam: Boolean = false
```

```Verilog
localparam boolParam = 0;
```

--------------------------------

### Chisel: Basic Decoder with TruthTable

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/decoder.md

This Chisel example demonstrates creating a simple decoder using `chisel3.util.experimental.decode.TruthTable`. It maps input `BitPat` patterns to output `BitPat` patterns. The `decoder` function applies the defined truth table to an input `UInt`.

```Scala
import chisel3._
import chisel3.util.BitPat
import chisel3.util.experimental.decode._

class SimpleDecoder extends Module {
  val table = TruthTable(
    Map(
      BitPat("b001") -> BitPat("b?"),
      BitPat("b010") -> BitPat("b?"),
      BitPat("b100") -> BitPat("b1"),
      BitPat("b101") -> BitPat("b1"),
      BitPat("b111") -> BitPat("b1")
    ),
    BitPat("b0"))
  val input = IO(Input(UInt(3.W)))
  val output = IO(Output(UInt(1.W)))
  output := decoder(input, table)
}
```

--------------------------------

### Example Firrtl 'Not Fully Initialized' Error Message

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/unconnected-wires.md

Provides a typical Firrtl error message indicating an uninitialized signal. The example shows the structure of the error, with the initial report followed by indented lines detailing connections involving the problematic signal, and the final line pinpointing the uninitialized component.

```Bash
firrtl.passes.CheckInitialization$RefNotInitializedException:  @[:@6.4] : [module Router]  Reference io is not fully initialized.
   @[Decoupled.scala 38:19:@48.12] : node _GEN_23 = mux(and(UInt<1>("h1"), eq(UInt<2>("h3"), _T_84)), _GEN_2, VOID) @[Decoupled.scala 38:19:@48.12]
   @[Router.scala 78:30:@44.10] : node _GEN_36 = mux(_GEN_0.ready, _GEN_23, VOID) @[Router.scala 78:30:@44.10]
   @[Router.scala 75:26:@39.8] : node _GEN_54 = mux(io.in.valid, _GEN_36, VOID) @[Router.scala 75:26:@39.8]
   @[Router.scala 70:50:@27.6] : node _GEN_76 = mux(io.load_routing_table_request.valid, VOID, _GEN_54) @[Router.scala 70:50:@27.6]
   @[Router.scala 65:85:@19.4] : node _GEN_102 = mux(_T_62, VOID, _GEN_76) @[Router.scala 65:85:@19.4]
   : io.outs[3].bits.body <= _GEN_102
```

--------------------------------

### Local Chisel Development Branch Publishing Commands

Source: https://github.com/chipsalliance/chisel/wiki/Frequently-Asked-Questions

Provides commands to checkout and locally publish Chisel development (`master`) branches using `sbt publishLocal`. This process requires checking out all relevant repositories and publishing them in a specific dependency order (firrtl, firrtl-interpreter, chisel3, chisel-testers, then user-facing repos like chisel-tutorial and chisel-template).

```Shell
git checkout master
sbt publishLocal
```

--------------------------------

### Reformat Chisel Source Files

Source: https://github.com/chipsalliance/chisel/blob/main/CONTRIBUTING.md

Command to reformat normal source files in the project using Scalafmt to enforce code style.

```sh
./mill __.reformat
```

--------------------------------

### Scala Higher-Order Function Example

Source: https://github.com/chipsalliance/chisel/wiki/CS250-Chisel+Scala-Primer

Illustrates a higher-order function in Scala that takes another function as an argument. Shows how to define a function addInt and pass it to highOrder to perform operations.

```Scala
def highOrder(a: Int, b: Int, c:Int, fun:(Int,Int) => Int) = {
	val tmp1 = fun(a, b)
	val tmp2 = fun(b, c)
	fun(tmp1, tmp2)
}

def addInt(a:Int, b:Int) = a + b

val result = highOrder(2, 5, 7, addInt)
```

--------------------------------

### Scala List Operations: zip, unzip, and zipWithIndex

Source: https://github.com/chipsalliance/chisel/wiki/CS250-Chisel+Scala-Primer

Provides examples of common Scala sequence operations. `zip` combines two lists into a list of pairs, `unzip` splits a list of tuples back into a tuple of lists, and `zipWithIndex` pairs each element of a list with its corresponding index.

```scala
val list1 = Seq(1, 2, 3, 4)
val list2 = Seq(5, 6, 7, 8)
val zipped = list1 zip list2   // zipped: Seq[(Int, Int)] = List((1,5), (2,6), (3,7), (4,8))

val unzipped = zipped.unzip   // unzipped: (Seq[Int], Seq[Int]) = (List(1, 2, 3, 4),List(5, 6, 7, 8))

val list1WInd = list1.zipWithIndex  // list1WInd: Seq[(Int, Int)] = List((1,0), (2,1), (3,2), (4,3))
```

--------------------------------

### Implement Chisel ModuleChoice for Instance Selection (Scala)

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/instchoice.md

This example illustrates how to use `ModuleChoice` to select between different module implementations (FPGATarget, ASICTarget) based on the defined `Platform` option group. All target modules must share a common IO interface by extending `FixedIOExtModule` or `FixedIORawModule` from `FixedIOBaseModule`.

```scala
import chisel3._
import chisel3.choice.ModuleChoice

class TargetIO extends Bundle {
  val in = Flipped(UInt(8.W))
  val out = UInt(8.W)
}

class FPGATarget extends FixedIOExtModule[TargetIO](new TargetIO)

class ASICTarget extends FixedIOExtModule[TargetIO](new TargetIO)

class VerifTarget extends FixedIORawModule[TargetIO](new TargetIO)

class SomeModule extends RawModule {
  val inst = ModuleChoice(new VerifTarget)(Seq(
    Platform.FPGA -> new FPGATarget,
    Platform.ASIC -> new ASICTarget
  ))
}
```

--------------------------------

### Chisel Mixed-Alignment Connection (:<>=) Example

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/connectable.md

This Scala example demonstrates the :<>= operator in Chisel, showing that the alignment of submembers to their parent components is irrelevant when using this operator. The connection's alignment is computed solely relative to the directly connected elements, incoming.alignedChild and outgoing.alignedChild.

```Scala
class Example1a extends RawModule {
  val incoming = IO(Flipped(new MixedAlignmentBundle))
  val outgoing = IO(new MixedAlignmentBundle)
  outgoing.alignedChild :<>= incoming.alignedChild // whether incoming.alignedChild is aligned/flipped to incoming is IRRELEVANT to what gets connected with :<>= 
}
```

--------------------------------

### Generate Verilog with custom options using SBT

Source: https://github.com/chipsalliance/chisel/wiki/Frequently-Asked-Questions

These bash commands show how to pass command-line arguments to the Chisel driver via SBT, allowing users to specify output directories or view available options for Verilog generation.

```bash
sbt 'runMain intro.HelloWorld --help'
```

```bash
sbt 'runMain intro.HelloWorld --target-dir buildstuff --top-name HelloWorld'
```

--------------------------------

### Chisel: Equivalent Wire Assignment (Final Value)

Source: https://github.com/chipsalliance/chisel/wiki/Combinational-Circuits

Presents an equivalent Chisel circuit to the previous example, explicitly showing that only the final assignment to a `Wire` matters. This snippet directly assigns `0.U` to `myNode`, achieving the same result as the previous example's multiple assignments.

```scala
val myNode = Wire(UInt(8.W))
myNode := 0.U
```

--------------------------------

### Example Hardware Unsigned Integer Literal (Chisel/Verilog)

Source: https://github.com/chipsalliance/chisel/wiki/ChiselSheet

This example illustrates a 4-bit unsigned integer literal with the value 15 in Chisel, written as `15.U(4.W)`. Its direct Verilog equivalent is `4'd15`, demonstrating how Chisel literals map to fixed-width Verilog constants for hardware implementation.

```Chisel
15.U(4.W)
```

```Verilog
4'd15
```

--------------------------------

### Chisel Example: Annotating Instances and Definitions with Select Functions

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/hierarchy.md

This Scala code demonstrates the usage of `Select.allInstancesOf` and `Select.allDefinitionsOf` to annotate instances and definitions of a module (`EmptyModule`) after elaboration. It highlights how different targets are generated based on the selection method, even if the underlying module is elaborated only once.

```Scala
import chisel3._
import chisel3.experimental.hierarchy.{Definition, Instance, Hierarchy, instantiable, public}

@instantiable
class EmptyModule extends Module {
  println("Elaborating EmptyModule!")
}

@instantiable
class TwoEmptyModules extends Module {
  val definition = Definition(new EmptyModule)
  val i0         = Instance(definition)
  val i1         = Instance(definition)
}

class Top extends Module {
  val definition = Definition(new TwoEmptyModules)
  val instance   = Instance(definition)
  aop.Select.allInstancesOf[EmptyModule](instance).foreach { i =>
    experimental.annotate(i) {
      println("instance: " + i.toTarget)
      Nil
    }
  }
  aop.Select.allDefinitionsOf[EmptyModule](instance).foreach { d =>
    experimental.annotate(d) {
      println("definition: " + d.toTarget)
      Nil
    }
  }
}
```

--------------------------------

### Run Chisel REPL via sbt

Source: https://github.com/chipsalliance/chisel/wiki/Debugging-with-the-Interpreter-REPL-1

This sbt command executes the `GCDMain` object, which in turn launches the firrtl-interpreter REPL. It's the command-line method to start the interactive debugging environment for Chisel circuits from within an sbt session.

```Shell
test:runMain example.test.GCDMain
```

--------------------------------

### Example Compile-time Integer Parameter (Scala/Verilog)

Source: https://github.com/chipsalliance/chisel/wiki/ChiselSheet

This snippet provides an example of defining a compile-time integer parameter in Scala, `val param: Int = 16`. This parameter is used during the hardware generation process and results in a `localparam param = 16;` declaration in the generated Verilog, ensuring the value is fixed at synthesis.

```Scala
val param: Int = 16
```

```Verilog
localparam param = 16;
```

--------------------------------

### Generate GPG Key

Source: https://github.com/chipsalliance/chisel/wiki/how-to-publish

This command initiates the GPG key generation process, which is necessary for signing artifacts before publishing them to repositories like Sonatype. A GPG key ensures the authenticity and integrity of the published artifacts.

```shell
pgp-cmd key-gen
```

--------------------------------

### Verbose Tuple Usage with Explicit `viewAs`

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/dataview.md

Demonstrates how to explicitly use the `.viewAs` method with the defined `HWTuple2` and `DataView` to make the tuple example work. While functional, this approach is more verbose than desired.

```scala
class TupleVerboseExample extends RawModule {
  val a, b, c, d = IO(Input(UInt(8.W)))
  val cond = IO(Input(Bool()))
  val x, y = IO(Output(UInt(8.W)))
  (x, y).viewAs[HWTuple2[UInt, UInt]] := Mux(cond, (a, b).viewAs[HWTuple2[UInt, UInt]], (c, d).viewAs[HWTuple2[UInt, UInt]])
}
```

--------------------------------

### Compile All Chisel Components

Source: https://github.com/chipsalliance/chisel/blob/main/CONTRIBUTING.md

Command to compile all components of the Chisel project, including CIRCT Panama bindings. Note that this custom command requires Java 21.

```sh
./mill compileAll
```

--------------------------------

### Defining Basic Chisel Modules with IO Bundles

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/appendix/upgrading-from-chisel-3-4.md

Illustrates the definition of two simple Chisel modules, `Foo` and `Bar`, each with an `io` bundle containing an 8-bit input (`in`) and output (`out`). These modules demonstrate basic signal assignment and arithmetic operations.

```scala
class Foo extends Module {
  val io = IO(new Bundle {
    val in = Input(UInt(8.W))
    val out = Output(UInt(8.W))
  })
  io.out := io.in
}

class Bar extends Module {
  val io = IO(new Bundle {
    val in = Input(UInt(8.W))
    val out = Output(UInt(8.W))
  })
  io.out := io.in + 1.U
}
```

--------------------------------

### Chisel Flipped Connection Operator (:>=) Example

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/connectable.md

This Scala example demonstrates the :>= operator, also known as the 'flipped connection' or 'backpressure connection'. It connects only the flipped members from the consumer (outgoing) to the producer (incoming), ignoring aligned members. A DontCare assignment is used for outgoing.alignedChild to prevent FIRRTL uninitialization errors.

```Scala
class Example3 extends RawModule {
  val incoming = IO(Flipped(new MixedAlignmentBundle))
  val outgoing = IO(new MixedAlignmentBundle)
  outgoing.alignedChild := DontCare // Otherwise FIRRTL throws an uninitialization error
  outgoing :>= incoming
}
```

--------------------------------

### Chisel Module Instantiation Patterns

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/developers/style.md

Illustrates two primary ways to instantiate modules in Chisel. The first is a Verilog-like explicit instantiation using `Module(new MyMod())`, which returns a module reference. The second is a more programmatic, inline style using factory methods, which return a part of the IO bundle, enabling functional composition.

```Scala
val myMod = Module(new MyMod())
myMod.io <> hookUp
```

```Scala
val queueOut = Queue(queueIn, entries=10)
```

```Scala
val queueOut = Queue(
  Arbitrate.byRoundRobin(
    Queue(a), // depth assumed to be 1
    Queue(b, entries=3),
    Queue(c, entries=4)
  ),
  entries=10
)
```

--------------------------------

### Instantiating Chisel `Bundle` with 0-arity Function Parameter

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/cookbook.md

Illustrates the correct way to instantiate `UsingAFunctionBundle` by passing a lambda function, such as `() => UInt(8.W)`. This ensures that new `UInt` instances are created for `foo` and `bar` when the bundle is constructed.

```scala
chisel3.docs.emitSystemVerilog(new Top(new UsingAFunctionBundle(() => UInt(8.W))))
```

--------------------------------

### Chisel Module Instantiation Syntax

Source: https://github.com/chipsalliance/chisel/wiki/Frequently-Asked-Questions

Explains the necessity of wrapping Chisel module instantiations with `Module(...)` due to limitations in Scala's object initialization lifecycle. This allows Chisel to perform post-initialization actions for hardware construction.

```Chisel
Module(...)
```

--------------------------------

### Configure sbt for GPG and Sonatype Credentials

Source: https://github.com/chipsalliance/chisel/wiki/how-to-publish

This sbt configuration snippet, typically placed in `~/.sbt/sonatype.sbt`, sets the GPG passphrase and defines credentials for publishing artifacts to Sonatype Nexus Repository Manager. It's crucial for authenticating with the repository.

```sbt
import com.typesafe.sbt.pgp._

pgpPassphrase := Some("".toArray)

credentials += Credentials("Sonatype Nexus Repository Manager", 
                           "oss.sonatype.org", 
                           "jenkinss142",
                           "xxxx")
```

--------------------------------

### Chisel3 Scala Import for Documentation

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/appendix/upgrading-from-scala-2-11.md

An invisible Scala import statement used within documentation to ensure the `chisel3._` package is available for subsequent code examples.

```Scala
import chisel3._
```

--------------------------------

### Chisel Scala Example: Automatic Signal Probing with BoringUtils

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/probes.md

This Chisel Scala code demonstrates the use of `BoringUtils.tapAndRead` to automatically create a read probe for a signal (`bar.a`) within a `RawModule`. It simplifies the process of exposing internal signals without manually adding probe ports, making the design more concise.

```scala
import chisel3._
import chisel3.util.experimental.BoringUtils

class Bar extends RawModule {
  val a = dontTouch(WireInit(Bool(), true.B))
}

class Foo extends RawModule {

  private val bar = Module(new Bar)

  private val a_read = dontTouch(WireInit(BoringUtils.tapAndRead(bar.a)))
}
```

--------------------------------

### Chisel Module Definitions for '<>' Operator Experiment

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/connection-operators.md

Defines a `Wrapper` module connecting input/output `DecoupledIO`s to two `PipelineStage` modules. This setup demonstrates the use of the `<>` connection operator for data flow between stages and I/O in a typical Chisel design.

```Scala
class Wrapper extends Module{
  val io = IO(new Bundle {
  val in = Flipped(DecoupledIO(UInt(8.W)))
  val out = DecoupledIO(UInt(8.W))
  })
  val p = Module(new PipelineStage)
  val c = Module(new PipelineStage)
  // connect Producer to IO
  p.io.a <> io.in
  // connect producer to consumer
  c.io.a <> p.io.b
  // connect consumer to IO
  io.out <> c.io.b
}
class PipelineStage extends Module{
  val io = IO(new Bundle{
    val a = Flipped(DecoupledIO(UInt(8.W)))
    val b = DecoupledIO(UInt(8.W))
  })
  io.b <> io.a
}
```

--------------------------------

### Run Chisel Test with Verbose Output

Source: https://github.com/chipsalliance/chisel/wiki/Debugging-with-the-Interpreter-REPL-2

Demonstrates how to execute a specific Chisel test (`gcd.GCDTester`) using `sbt testOnly` with the `--is-verbose` flag to get detailed output for debugging purposes.

```sbt
testOnly gcd.GCDTester -- -z "running with --is-verbose"
```

--------------------------------

### Successful `PartialDataView` for Non-Total Mappings

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/dataview.md

Illustrates the use of `PartialDataView`, which allows for non-total mappings from the source type. This example successfully maps `BundleA.bar` to `BundleB.fizz` while intentionally omitting `BundleA.foo`.

```scala
// A PartialDataView does not have to be total for the Target
implicit val myView: DataView[BundleA, BundleB] = PartialDataView[BundleA, BundleB](_ => new BundleB, _.bar -> _.fizz)
class PartialDataViewModule extends Module {
   val in = IO(Input(new BundleA))
   val out = IO(Output(new BundleB))
   out := in.viewAs[BundleB]
}
```

--------------------------------

### Define a simple Chisel module

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/appendix/migrating-from-chiseltest.md

This Scala code defines a basic Chisel module named `MyModule` with a 16-bit input and output, where the output is a registered version of the input. This module serves as the design under test for the migration examples.

```Scala
import chisel3._
class MyModule extends Module {
  val io = IO(new Bundle {
    val in = Input(UInt(16.W))
    val out = Output(UInt(16.W))
  })

  io.out := RegNext(io.in)
}
```

--------------------------------

### Chisel Example: Using Decoupled for Producer and Consumer Interfaces

Source: https://github.com/chipsalliance/chisel/wiki/Interfaces-Bulk-Connections

This Chisel code demonstrates how to use the `Decoupled` utility to create both producer and consumer ready-valid interfaces. The `ProducingData` module shows a producer interface where `bits` is an output, while the `ConsumingData` module illustrates a consumer interface where `bits` is an input, achieved by `Flipped(Decoupled(...))`. The comments within the code explain the generated Verilog ports for each case.

```Scala
import chisel3._
import chisel3.util.Decoupled

/**
  * Using Decoupled(...) creates a producer interface.
  * i.e. it has bits as an output.
  * This produces the following ports:
  *   input         io_readyValid_ready,
  *   output        io_readyValid_valid,
  *   output [31:0] io_readyValid_bits
  */
class ProducingData extends Module {
  val io = IO(new Bundle {
    val readyValid = Decoupled(UInt(32.W))
  })
  // do something with io.readyValid.ready
  io.readyValid.valid := true.B
  io.readyValid.bits := 5.U
}

/**
  * Using Flipped(Decoupled(...)) creates a consumer interface.
  * i.e. it has bits as an input.
  * This produces the following ports:
  *   output        io_readyValid_ready,
  *   input         io_readyValid_valid,
  *   input  [31:0] io_readyValid_bits
  */
class ConsumingData extends Module {
  val io = IO(new Bundle {
    val readyValid = Flipped(Decoupled(UInt(32.W)))
  })
  io.readyValid.ready := false.B
  // do something with io.readyValid.valid
  // do something with io.readyValid.bits
}
```

--------------------------------

### Reformat Mill Build Files

Source: https://github.com/chipsalliance/chisel/blob/main/CONTRIBUTING.md

Command to reformat Mill build files using Scalafmt, operating at the meta-level to ensure consistent build script formatting.

```sh
./mill --meta-level 1 mill.scalalib.scalafmt.ScalafmtModule/reformatAll sources
```

--------------------------------

### Define MyCounter Chisel Class

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/dataview.md

Defines a basic MyCounter class in Chisel, illustrating RegInit, WireDefault, and methods for incrementing/resetting. This class serves as an example for DataProduct integration.

```scala
// Loosely based on chisel3.util.Counter
class MyCounter(val width: Int) {
  /** Indicates if the Counter is incrementing this cycle */
  val active = WireDefault(false.B)
  val value = RegInit(0.U(width.W))
  def inc(): Unit = {
    active := true.B
    value := value + 1.U
  }
  def reset(): Unit = {
    value := 0.U
  }
}
```

--------------------------------

### Add FileCheck to PATH environment variable (Temporary)

Source: https://github.com/chipsalliance/chisel/blob/main/SETUP.md

This command adds the current directory (where FileCheck was downloaded and made executable) to the system's PATH. This allows the `FileCheck` command to be found and run from any location during the current terminal session.

```bash
export PATH=$PATH:$PWD
```

--------------------------------

### Simplified Equivalent of Overwritten Wire Assignment in Chisel

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/combinational-circuits.md

Presents the simplified and functionally equivalent Chisel code for the previous example, demonstrating that only the final assignment to a `Wire` is relevant for hardware synthesis.

```Scala
val myNode = Wire(UInt(8.W))
myNode := 0.U
```

--------------------------------

### Chisel Decoupled Producer and Consumer Interface Examples

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/interfaces-and-connections.md

This Chisel (Scala) code demonstrates the creation of ready-valid interfaces using `Decoupled`. The `ProducingData` module shows how `Decoupled(UInt(32.W))` creates an output-oriented producer interface. The `ConsumingData` module illustrates how `Flipped(Decoupled(UInt(32.W)))` creates an input-oriented consumer interface, detailing the generated hardware ports for each.

```Scala
import chisel3._
import chisel3.util.Decoupled

/**
  * Using Decoupled(...) creates a producer interface.
  * i.e. it has bits as an output.
  * This produces the following ports:
  *   input         io_readyValid_ready,
  *   output        io_readyValid_valid,
  *   output [31:0] io_readyValid_bits
  */
class ProducingData extends Module {
  val io = IO(new Bundle {
    val readyValid = Decoupled(UInt(32.W))
  })
  // do something with io.readyValid.ready
  io.readyValid.valid := true.B
  io.readyValid.bits := 5.U
}

/**
  * Using Flipped(Decoupled(...)) creates a consumer interface.
  * i.e. it has bits as an input.
  * This produces the following ports:
  *   output        io_readyValid_ready,
  *   input         io_readyValid_valid,
  *   input  [31:0] io_readyValid_bits
  */
class ConsumingData extends Module {
  val io = IO(new Bundle {
    val readyValid = Flipped(Decoupled(UInt(32.W)))
  })
  io.readyValid.ready := false.B
  // do something with io.readyValid.valid
  // do something with io.readyValid.bits
}
```

--------------------------------

### Chisel/FIRRTL Command-Line Options Reference

Source: https://github.com/chipsalliance/chisel/wiki/Running-Stuff

This section provides a comprehensive reference of all available command-line options for the `chisel-testers` driver, encompassing common options, tester-specific options, FIRRTL interpreter options, Chisel3 options, and FIRRTL options. Each option includes its short and long forms, along with a brief description of its purpose and default values where applicable.

```APIDOC
Usage: chisel-testers [options]

common options
  -tn <top-level-circuit-name> | --top-name <top-level-circuit-name>
        This options defines the top level circuit, defaults to dut when possible
  -td <target-directory> | --target-dir <target-directory>
        This options defines a work directory for intermediate files, default is .
  -ll <Error|Warn|Info|Debug|Trace> | --log-level <Error|Warn|Info|Debug|Trace>
        This options defines a work directory for intermediate files, default is .
  -cll <FullClassName:[Error|Warn|Info|Debug|Trace]>[,...] | --class-log-level <FullClassName:[Error|Warn|Info|Debug|Trace]>[,...]
        This options defines a work directory for intermediate files, default is .
  -ltf | --log-to-file
        default logs to stdout, this flags writes to topName.log or firrtl.log if no topName
  -lcn | --log-class-names
        shows class names and log level in logging output, useful for target --class-log-level
  --help
        prints this usage text
tester options
  -tbn <firrtl|verilator|vcs> | --backend-name <firrtl|verilator|vcs>
        backend to use with tester, default is firrtl
  -tigv | --is-gen-verilog
        has verilog already been generated
  -tigh | --is-gen-harness
        has harness already been generated
  -tic | --is-compiling
        has harness already been generated
  -tiv | --is-verbose
        set verbose flag on PeekPokeTesters, default is false
  -tdb <value> | --display-base <value>
        provides a seed for random number generator, default is 10
  -ttc <value> | --test-command <value>
        run this as test command
  -tlfn <value> | --log-file-name <value>
        write log file
  -twffn <value> | --wave-form-file-name <value>
        wave form file name
  -tts <value> | --test-seed <value>
        provides a seed for random number generator
firrtl-interpreter-options
  -fiwv | --fint-write-vcd
        writes vcd execution log, filename will be base on top
  -fivsuv | --fint-vcd-show-underscored-vars
        vcd output by default does not show var that start with underscore, this overrides that
  -fiv | --fint-verbose
        makes interpreter very verbose
  -fioe | --fint-ordered-exec
        operates on dependencies optimally, can increase overhead, makes verbose mode easier to read
  -fiac | --fr-allow-cycles
        allow combinational loops to be processed, though unreliable, default is false
  -firs <long-value> | --fint-random-seed <long-value>
        seed used for random numbers generated for tests and poison values, default is current time in ms
  -fimed <long-value> | --fint-max-execution-depth <long-value>
        depth of stack used to evaluate expressions
  -fisfas | --show-firrtl-at-load
        compiled low firrtl at firrtl load time
  -filcol | --run-lower-compiler-on-load
        run lowering compuler when firrtl file is loaded
chisel3 options
  -chnrf | --no-run-firrtl
        Stop after chisel emits chirrtl file
firrtl options
  -i <firrtl-source> | --input-file <firrtl-source>
        use this to override the default input file name , default is empty
  -o <output> | --output-file <output>
        use this to override the default output file name, default is empty
  -faf <output> | --annotation-file <output>
        use this to override the default annotation file name, default is empty
  -ffaaf | --force-append-anno-file
        use this to force appending annotation file to annotations being passed in through optionsManager
  -X <high|low|verilog> | --compiler <high|low|verilog>
        compiler to use, default is verilog
  --info-mode <ignore|use|gen|append>
        specifies the source info handling, default is append
  -fil <circuit>[.<module>[.<instance>]][,..], | --inline <circuit>[.<module>[.<instance>]][,..],
        Inline one or more module (comma separated, no spaces) module looks like \"MyModule\" or \"MyModule.myinstance\"
  -firw <circuit> | --infer-rw <circuit>
        Enable readwrite port inference for the target circuit
```

--------------------------------

### Basic Parametrized Chisel Bundle (Pre-Chisel 3.5)

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/bundles-and-vecs.md

Illustrates a simple parametrized `Bundle` definition in Chisel, relevant for versions prior to 3.5. This example shows a `Bundle` with a `bitwidth` parameter and a `UInt` field, demonstrating a common `Bundle` structure where `cloneType` might be implicitly handled.

```scala
class MyCloneTypeBundle(val bitwidth: Int) extends Bundle {
   val field = UInt(bitwidth.W)
   // ...
}
```

--------------------------------

### Chisel Module Instantiation with Definition and Instance

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/hierarchy.md

Learn how to use Chisel's `Definition` and `Instance` APIs, along with `@instantiable` and `@public` annotations, to create multiple instances of a module with identical parameterization. This method allows for explicit control over module elaboration, avoiding reliance on FIRRTL deduplication. The example demonstrates defining a reusable `AddOne` module and instantiating it twice within an `AddTwo` module.

```Scala
import chisel3._
import chisel3.experimental.hierarchy.{Definition, Instance, instantiable, public}

@instantiable
class AddOne(width: Int) extends Module {
  @public val in  = IO(Input(UInt(width.W)))
  @public val out = IO(Output(UInt(width.W)))
  out := in + 1.U
}

class AddTwo(width: Int) extends Module {
  val in  = IO(Input(UInt(width.W)))
  val out = IO(Output(UInt(width.W)))
  val addOneDef = Definition(new AddOne(width))
  val i0 = Instance(addOneDef)
  val i1 = Instance(addOneDef)
  i0.in := in
  i1.in := i0.out
  out   := i1.out
}
```

```SystemVerilog
chisel3.docs.emitSystemVerilog(new AddTwo(10))
```

--------------------------------

### Run Specific ScalaTest Case

Source: https://github.com/chipsalliance/chisel/blob/main/CONTRIBUTING.md

Run an individual ScalaTest test using standard ScalaTest commands and arguments, targeting a specific test class and applying a filter.

```sh
./mill chisel[].test.testOnly chiselTests.VecLiteralSpec -- -z "lits must fit in vec element width"
```

--------------------------------

### Define DataBundle for Generic FIFO

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/polymorphism-and-parameterization.md

Defines a simple Bundle named DataBundle containing two 32-bit unsigned integers. This bundle serves as a custom data type example for the generic FIFO implementation.

```Scala
class DataBundle extends Bundle {
  val a = UInt(32.W)
  val b = UInt(32.W)
}
```

--------------------------------

### Directly Obtain Verilog String from Chisel Module

Source: https://github.com/chipsalliance/chisel/blob/main/README.md

Provides a method to directly get the generated Verilog code as a string for immediate inspection, useful for debugging or quick verification.

```Scala
val verilogString = chisel3.getVerilogString(new FirFilter(8, Seq(0.U, 1.U)))
println(verilogString)
```

--------------------------------

### Generating Verilog for Chisel Bidirectional Connection

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/connectable.md

Illustrates how to generate SystemVerilog from a Chisel design using `chisel3.docs.emitSystemVerilog`. This specific example generates Verilog for the `Example1` module, which uses the `:<>=` operator for mixed-alignment connections.

```Scala
chisel3.docs.emitSystemVerilog(new Example1)
```

--------------------------------

### Generating Verilog for Chisel Monodirectional Connection

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/connectable.md

Illustrates how to generate SystemVerilog from a Chisel design using `chisel3.docs.emitSystemVerilog`. This specific example generates Verilog for the `Example0` module, which uses the `:=` operator.

```Scala
chisel3.docs.emitSystemVerilog(new Example0)
```

--------------------------------

### Chisel cf-interpolator: Simple formatting options

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/printing.md

Examples of using `cf` with common format specifiers like hexadecimal (`%x`), binary (`%b`), and character (`%c`) for `UInt` values, demonstrating different output formats.

```Scala
val myUInt = 33.U
// Hexadecimal
printf(cf"myUInt = 0x$myUInt%x") // myUInt = 0x21
// Binary
printf(cf"myUInt = $myUInt%b") // myUInt = 100001
// Character
printf(cf"myUInt = $myUInt%c") // myUInt = !
```

--------------------------------

### Migrating I/O Declaration Style from Chisel2 to Chisel3

Source: https://github.com/chipsalliance/chisel/wiki/Chisel3-vs-Chisel2

Illustrates the updated syntax for declaring module I/O. Chisel3 uses `Output()` or `Input()` to wrap the type, replacing the `OUTPUT` or `INPUT` arguments.

```Scala
// Chisel2
val done = Bool(OUTPUT)
```

```Scala
// Chisel3
val wire = Output(Bool())
```

--------------------------------

### Minor Chisel Renames and API Changes

Source: https://github.com/chipsalliance/chisel/wiki/Chisel3-vs-Chisel2

Documents minor renames of common signals and methods in Chisel3, such as the clock signal and width retrieval method.

```Scala
// Chisel2 -> Chisel3
clk -> clock
getWidth() -> getWidth
```

--------------------------------

### Example Chisel Circuit Test Harness Invocation

Source: https://github.com/chipsalliance/chisel/wiki/Running-Stuff

This Scala snippet demonstrates how to invoke a Chisel circuit within a test harness using chisel3.iotesters.Driver. It shows the instantiation of a FixedPrecisionChanger module and its testing with FixedPointTruncatorTester, asserting the test outcome.

```scala
   "here we assign to a F8.1 from a F8.3" in {
      chisel3.iotesters.Driver(() => new FixedPrecisionChanger(8, 3, 8, 1)) { c=>
        new FixedPointTruncatorTester(c, 6.875, 6.5)
      } should be (true)
    }
```

--------------------------------

### Construct a 4-input Multiplexer Hierarchy in Chisel

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/modules.md

This example demonstrates building a hierarchical module, `Mux4`, by instantiating and wiring together three instances of the previously defined `Mux2` module. It shows how to create child modules using `Module(new Mux2)` and connect their inputs and outputs to form a larger circuit.

```Scala
class Mux4IO extends Bundle {
  val in0 = Input(UInt(1.W))
  val in1 = Input(UInt(1.W))
  val in2 = Input(UInt(1.W))
  val in3 = Input(UInt(1.W))
  val sel = Input(UInt(2.W))
  val out = Output(UInt(1.W))
}
class Mux4 extends Module {
  val io = IO(new Mux4IO)

  val m0 = Module(new Mux2)
  m0.io.sel := io.sel(0)
  m0.io.in0 := io.in0
  m0.io.in1 := io.in1

  val m1 = Module(new Mux2)
  m1.io.sel := io.sel(0)
  m1.io.in0 := io.in2
  m1.io.in1 := io.in3

  val m3 = Module(new Mux2)
  m3.io.sel := io.sel(1)
  m3.io.in0 := m0.io.out
  m3.io.in1 := m1.io.out

  io.out := m3.io.out
}
```

--------------------------------

### Chisel Mux2 Circuit Testing Example

Source: https://github.com/chipsalliance/chisel/wiki/Tutorial-Problems

This Scala code demonstrates how to test a `Mux2` circuit using Chisel's `PeekPokeTester`. It iterates through all possible input combinations, uses `poke` to assign values to the circuit's inputs (`sel`, `in0`, `in1`), `step` to advance the simulation by one clock cycle, and `expect` to verify that the circuit's output (`out`) matches the expected value based on the multiplexer's logic.

```Scala
class Mux2Tests(c: Mux2, b: Option[TesterBackend] = None) extends PeekPokeTester(c, _backend=b) {
  val n = pow(2, 3).toInt 
  for (s <- 0 until 2) {
    for (i0 <- 0 until 2) { for (i1 <- 0 until 2) {
      poke(c.io.sel, s)
      poke(c.io.in1, i1)
      poke(c.io.in0, i0)
      step(1)
      expect(c.io.out, (if (s == 1) i1 else i0))
    }}
  }
}
```

--------------------------------

### ChiselSim ScalaTest Default Command Line Options

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/testing.md

This snippet provides the standard help output for ChiselSim ScalaTest, detailing the default command line options available. It explains how to use the ScalaTest 'config map' feature with `-D<name>=<value>` and lists options such as `chiselOpts`, `emitVcd`, `firtoolOpts`, and `help` with their purposes.

```APIDOC
Usage: <ScalaTest> [-D<name>=<value>...]

This ChiselSim ScalaTest test supports passing command line arguments via
ScalaTest's "config map" feature.  To access this, append `-D<name>=<value>` for
a legal option listed below.

Options:

  chiselOpts
      additional options to pass to the Chisel elaboration
  emitVcd
      compile with VCD waveform support and start dumping waves at time zero
  firtoolOpts
      additional options to pass to the firtool compiler
  help
      display this help text
```

--------------------------------

### Chisel3 Optional Output Port in a Bundle

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/cookbook.md

This example illustrates how to conditionally include an output port within a Chisel Bundle based on a boolean flag. The optional port is wrapped in an Option type, allowing it to be Some or None at elaboration time.

```Scala
import chisel3._

class ModuleWithOptionalIOs(flag: Boolean) extends Module {
  val io = IO(new Bundle {
    val in = Input(UInt(12.W))
    val out = Output(UInt(12.W))
    val out2 = if (flag) Some(Output(UInt(12.W))) else None
  })

  io.out := io.in
  if (flag) {
    io.out2.get := io.in
  }
}
```

--------------------------------

### Import Chisel3 Libraries

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/interfaces-and-connections.md

Imports necessary Chisel3 libraries and the `emitSystemVerilog` utility, which is used for generating SystemVerilog from Chisel code.

```scala
import chisel3._
import chisel3.docs.emitSystemVerilog
```

--------------------------------

### Swap JDK to GraalVM Java 21

Source: https://github.com/chipsalliance/chisel/blob/main/CONTRIBUTING.md

Command to switch the current shell's JDK to the latest release of GraalVM Java 21 using Coursier. This is required for developing CIRCT Panama bindings.

```sh
eval $(cs java --jvm graalvm-java21 --env)
```

--------------------------------

### Example Firrtl Reference Not Initialized Error

Source: https://github.com/chipsalliance/chisel/wiki/Unconnected-Wires

A sample Firrtl `RefNotInitializedException` error message, illustrating how to interpret the output to identify the uninitialized signal component and its source location.

```bash
firrtl.passes.CheckInitialization$RefNotInitializedException:  @[:@6.4] : [module Router]  Reference io is not fully initialized.
   @[Decoupled.scala 38:19:@48.12] : node _GEN_23 = mux(and(UInt<1>("h1"), eq(UInt<2>("h3"), _T_84)), _GEN_2, VOID) @[Decoupled.scala 38:19:@48.12]
   @[Router.scala 78:30:@44.10] : node _GEN_36 = mux(_GEN_0.ready, _GEN_23, VOID) @[Router.scala 78:30:@44.10]
   @[Router.scala 75:26:@39.8] : node _GEN_54 = mux(io.in.valid, _GEN_36, VOID) @[Router.scala 75:26:@39.8]
   @[Router.scala 70:50:@27.6] : node _GEN_76 = mux(io.load_routing_table_request.valid, VOID, _GEN_54) @[Router.scala 70:50:@27.6]
   @[Router.scala 65:85:@19.4] : node _GEN_102 = mux(_T_62, VOID, _GEN_76) @[Router.scala 65:85:@19.4]
   : io.outs[3].bits.body <= _GEN_102
```

--------------------------------

### Demonstrate Flipped() Function for Chisel Bundles

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/bundles-and-vecs.md

This example shows the usage of the `Flipped()` function to recursively reverse the direction of all elements within a Bundle. It defines an `ABBundle` with input and output signals and then demonstrates how `Flipped()` changes their direction when instantiated.

```scala
class ABBundle extends Bundle {
  val a = Input(Bool())
  val b = Output(Bool())
}
class MyFlippedModule extends RawModule {
  // Normal instantiation of the bundle
  // 'a' is an Input and 'b' is an Output
  val normalBundle = IO(new ABBundle)
  normalBundle.b := normalBundle.a

  // Flipped recursively flips the direction of all Bundle fields
  // Now 'a' is an Output and 'b' is an Input
  val flippedBundle = IO(Flipped(new ABBundle))
  flippedBundle.a := flippedBundle.b
}
```

--------------------------------

### Chisel Scala Example: Generating SystemVerilog from BoringUtils Circuit

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/probes.md

This Scala code snippet shows how to use `circt.stage.ChiselStage.emitSystemVerilog` to generate the SystemVerilog representation of the Chisel circuit (Foo) that utilizes `BoringUtils`. It includes `firtoolOpts` for configuring the output, such as stripping debug info and disabling randomization, providing a clean SystemVerilog output.

```scala
circt.stage.ChiselStage.emitSystemVerilog(
  new Foo,
  firtoolOpts = Array(
    "-strip-debug-info",
    "-disable-all-randomization",
    "-enable-layers=Verification",
    "-enable-layers=Verification.Assert",
    "-enable-layers=Verification.Assume",
    "-enable-layers=Verification.Cover"
  )
)
```

--------------------------------

### Chisel Scala Helper Function for Compilation

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/warnings.md

Defines a Scala helper function `compile` that uses `circt.stage.ChiselStage.emitCHIRRTL` to compile a Chisel `RawModule`. This function is used in examples to suppress return values from `mdoc`.

```scala
// Helper to throw away return value so it doesn't show up in mdoc
def compile(gen: => chisel3.RawModule, args: Array[String] = Array()): Unit = {
  circt.stage.ChiselStage.emitCHIRRTL(gen, args = args)
}
```

--------------------------------

### Successful SBT Test Output for Chisel GCD

Source: https://github.com/chipsalliance/chisel/wiki/Debugging-with-the-Interpreter-REPL-1

This output shows the successful execution of the GCD unit tests with both Firrtl and Verilator backends. It confirms that the initial Chisel setup and the GCD module are functioning correctly before any modifications are made.

```Shell
[info] [0.083] RAN 1102 CYCLES PASSED
[info] GCDTester:
[info] GCD
[info] - should calculate proper greatest common denominator (with firrtl)
[info] GCD
[info] - should calculate proper greatest common denominator (with verilator)
[info] Basic test using Driver.execute
[info] using --backend-name verilator
[info] running with --is-verbose creats a lot
[info] running with --fint-write-vcd
[info] using --help
[info] ScalaTest
[info] Run completed in 4 seconds, 427 milliseconds.
[info] Total number of tests run: 2
[info] Suites: completed 1, aborted 0
[info] Tests: succeeded 2, failed 0, canceled 0, ignored 0, pending 0
[info] All tests passed.
[info] Passed: Total 2, Failed 0, Errors 0, Passed 2
[success] Total time: 5 s, completed Sep 27, 2017 5:11:56 PM
```

--------------------------------

### Chisel Module Definitions for Assignment ':=' Operator Test

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/connection-operators.md

Defines `Wrapper` and `PipelineStage` modules, replacing all `<>` connections with `:=` to demonstrate the behavior of the assignment operator. This setup is designed to highlight errors when `:=` is used with `Flipped` I/O or incorrect signal directions.

```Scala
import chisel3._
import chisel3.util.DecoupledIO

class Wrapper extends Module{
  val io = IO(new Bundle {
  val in = Flipped(DecoupledIO(UInt(8.W)))
  val out = DecoupledIO(UInt(8.W))
  })
  val p = Module(new PipelineStage)
  val c = Module(new PipelineStage)
  // connect producer to I/O
  p.io.a := io.in
  // connect producer  to consumer
  c.io.a := p.io.b
  // connect consumer to I/O
  io.out := c.io.b
}
class PipelineStage extends Module{
  val io = IO(new Bundle{
    val a = Flipped(DecoupledIO(UInt(8.W)))
    val b = DecoupledIO(UInt(8.W))
  })
  io.a := io.b
}
```

--------------------------------

### Initialize and Access Chisel ROM with VecInit

Source: https://github.com/chipsalliance/chisel/wiki/Memories

Demonstrates initializing a small ROM with specific values (1, 2, 4, 8) using `VecInit` and accessing its elements with a counter as an address generator, showcasing a simple ROM usage pattern.

```Scala
val m = VecInit(Array(1.U, 2.U, 4.U, 8.U))
val r = m(counter(m.length.U))
```

--------------------------------

### Chisel Top Module for CSR Definition and Instantiation

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/properties.md

This Chisel `Top` module serves as an entry point, defining and instantiating `CSRDescription` and `CSRModule` instances. It collects references to the generated CSR description objects and exposes them via an output property port, demonstrating how to manage and expose hardware configuration metadata.

```Scala
// The entrypoint module.
class Top extends Module {
  // Create a Definition for the CSRDescription Class.
  val csrDescDef = Definition(new CSRDescription)

  // Get the CSRDescription ClassType.
  val csrDescType = csrDescDef.getClassType

  // Create a property port to collect all the CSRDescription object references.
  val descriptions = IO(Output(Property[Seq[csrDescType.Type]]()))

  // Instantiate a couple CSR modules.
  val mcycle = Module(new CSRModule(csrDescDef, 64, "mcycle", "Machine cycle counter."))
  val minstret = Module(new CSRModule(csrDescDef, 64, "minstret", "Machine instructions-retired counter."))

  // Assign references to the CSR description objects to the property port.
  descriptions := Property(Seq(mcycle.description.as(csrDescType), minstret.description.as(csrDescType)))
}
```

--------------------------------

### svsim Simulation and Controller API Reference

Source: https://github.com/chipsalliance/chisel/blob/main/svsim/README.md

Details the programmatic interface for managing simulation execution. The `Workspace.compile` method yields a `Simulation` instance, which can be run with a closure providing a `Simulation.Controller`. The controller offers low-level methods like `get`, `set`, and `run(0)` for explicit state manipulation and advancing simulation time.

```APIDOC
Workspace.compile() -> Simulation instance
Simulation.run(closure: (controller: Simulation.Controller) => Unit)
Simulation.Controller:
  get(): Reads simulation state
  set(): Writes simulation state
  run(cycles: Int): Advances simulation by specified cycles (e.g., run(0) to evaluate state)
```

--------------------------------

### Chisel Package and Object Renames

Source: https://github.com/chipsalliance/chisel/wiki/Chisel3-vs-Chisel2

Lists common package and object renames from Chisel2 to Chisel3, affecting fully qualified names for utilities like `log2Ceil`, `BitPat`, and `Decoupled`.

```Scala
// Chisel2 -> Chisel3
Chisel.log2Ceil -> chisel3.util.log2Ceil
BitPat (usage/location change)
Decoupled (usage/location change)
```

--------------------------------

### Enable Explicit Invalidate for Chisel Modules (Inheritance)

Source: https://github.com/chipsalliance/chisel/wiki/Unconnected-Wires

Example of enabling `explicitInvalidate` for a group of Chisel modules by extending an abstract class with custom `compileOptions`.

```Scala
abstract class ExplicitInvalidateModule extends Module()(chisel3.core.ExplicitCompileOptions.NotStrict.copy(explicitInvalidate = true))
```

--------------------------------

### Add firtool to PATH environment variable (Temporary)

Source: https://github.com/chipsalliance/chisel/blob/main/SETUP.md

This command adds the directory containing the extracted firtool binary to the system's PATH environment variable. This allows the `firtool` command to be executed from any location in the terminal, but the setting is temporary and only applies to the current shell session.

```bash
export PATH=$PATH:$PWD/firtool-1.56.1/bin
```

--------------------------------

### Disable Explicit Invalidate for Chisel Modules (Inheritance)

Source: https://github.com/chipsalliance/chisel/wiki/Unconnected-Wires

Example of disabling `explicitInvalidate` for a group of Chisel modules by extending an abstract class with custom `compileOptions`.

```Scala
abstract class ImplicitInvalidateModule extends Module()(chisel3.core.ExplicitCompileOptions.Strict.copy(explicitInvalidate = false))
```

--------------------------------

### Concatenate Strings in Scala

Source: https://github.com/chipsalliance/chisel/wiki/Scala-Things-You-Should-Know

Presents a basic example of string concatenation using the '+' operator in Scala. While functional, this method can become cumbersome for complex string constructions.

```Scala
println("my dog " + dogsName + " went to the " + destination)
```

--------------------------------

### Instantiate a Scala class using the 'new' keyword

Source: https://github.com/chipsalliance/chisel/wiki/Scala-Cheatsheet

Demonstrates how to create an instance of a previously defined Scala class, `Foo`, using the `new` keyword. It shows how to pass required arguments to the class's primary constructor during instantiation.

```Scala
val foo = new Foo(5, "public message")
```

--------------------------------

### Convert Chisel UInt to Vec of Bools

Source: https://github.com/chipsalliance/chisel/wiki/Cookbook

Explains how to convert a Chisel UInt into a `Vec` of `Bool`s. This is achieved by first using `chisel3.core.Bits.toBools` to get a Scala `Seq` of `Bool`s, then wrapping it in `Vec(...)`.

```Scala
  // Example
  val uint = 0xc.U
  val vec = Vec(uint.toBools)
  printf(p"$vec") // Vec(0, 0, 1, 1)

  // Test
  assert(vec(0) === false.B)
  assert(vec(1) === false.B)
  assert(vec(2) === true.B)
  assert(vec(3) === true.B)
```

--------------------------------

### Declare a Scala class with constructor parameters and methods

Source: https://github.com/chipsalliance/chisel/wiki/Scala-Cheatsheet

Illustrates how to define a Scala class using the `class` keyword. It demonstrates passing arguments to the primary constructor, distinguishing between private fields and public `val` members. The example includes a method that accesses these constructor parameters.

```Scala
// value is a private field of the class while message is public (making it a val makes it public)
class Foo(value: Int, val message: String) {
  def func() = println("My value is " + value + " and my message is \"" + message + "\"")
}
```

--------------------------------

### Demonstrate implicit Scala 'apply' method calls with List

Source: https://github.com/chipsalliance/chisel/wiki/Scala-Cheatsheet

Explains how the `apply` method is implicitly invoked when parentheses are used on an object or its companion. This example illustrates two `apply` calls: one for `List` creation via its companion object, and another for element access on the `List` instance.

```Scala
val xs = List("a", "b", "c")
println(xs(1))
```

--------------------------------

### Write simulation logs to a file using SimLog

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/printing.md

Illustrates how to create a SimLog instance to write output to a specified file, demonstrating printf usage with a Chisel module's input.

```Scala
class MyModule extends Module {
  val log = SimLog.file("logfile.log")
  val in = IO(Input(UInt(8.W)))
  log.printf(cf"in = $in%d\n")
}
```

--------------------------------

### Untitled

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/polymorphism-and-parameterization.md

No description

--------------------------------

### Scala Example: Defining and Using a Custom Integer CLI Option

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/testing.md

This Scala code demonstrates how to integrate a custom integer command line option, 'seed', into a ChiselSim ScalaTest. It shows the declaration of the option using `CliOption.int` and its subsequent retrieval within a Chisel module's elaboration stage via `getOption`, allowing for test-time configurable parameters.

```Scala
import chisel3._
import chisel3.simulator.scalatest.ChiselSim
import chisel3.simulator.scalatest.HasCliOptions.CliOption
import chisel3.util.random.LFSR
import circt.stage.ChiselStage
import org.scalatest.funspec.AnyFunSpec

class ChiselSimExample extends AnyFunSpec with ChiselSim {

  CliOption.int("seed", "the seed to use for the test")

  class Foo(seed: Int) extends Module {
    private val lfsr = LFSR(64, seed = Some(seed))
  }

  describe("Foo") {
    it("generates FIRRTL for a module with a test-time configurable seed") {
      ChiselStage.emitCHIRRTL(new Foo(getOption[Int]("seed").getOrElse(42)))
    }
  }

}
```

--------------------------------

### Create a Chisel MixedVec with Different Widths

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/bundles-and-vecs.md

This example introduces `MixedVec`, which allows elements of the same type but different parameterizations (e.g., different bit widths). It shows how to define a `MixedVec` containing `UInt`s of 3-bit and 10-bit widths and assign values to its elements.

```scala
import chisel3.util.MixedVec
class ModuleMixedVec extends Module {
  val io = IO(new Bundle {
    val x = Input(UInt(3.W))
    val y = Input(UInt(10.W))
    val vec = Output(MixedVec(UInt(3.W), UInt(10.W)))
  })
  io.vec(0) := io.x
  io.vec(1) := io.y
}
```

--------------------------------

### Initialize Chisel Memory via SystemVerilog Bind Module

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/appendix/experimental-features.md

Illustrates the use of loadMemoryFromFile to initialize a Chisel Mem by generating a SystemVerilog bind module. This method allows the memory to be loaded from an external file using $readmemh or $readmemb statements within the generated bind module, which is then bound to the main Chisel-generated Verilog.

```scala
import chisel3._
import chisel3.util.experimental.loadMemoryFromFile

class InitMemBind(val bits: Int, val size: Int, filename: String) extends Module {
  val io = IO(new Bundle {
    val nia = Input(UInt(bits.W))
    val insn = Output(UInt(32.W))
  })

  val memory = Mem(size, UInt(32.W))
  io.insn := memory(io.nia >> 2);
  loadMemoryFromFile(memory, filename)
}
```

--------------------------------

### Import Chisel and CIRCT Stages

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/chisel-type-vs-scala-type.md

Imports essential Chisel libraries and the CIRCT stage, which are required for defining and elaborating hardware designs in Chisel. This setup is typically used for compilation and testing purposes.

```Scala
import chisel3._
import circt.stage.ChiselStage
```

--------------------------------

### Chisel Bit Field Extraction

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/operators.md

Extracts a range of bits (bit field) from a Chisel hardware signal, specified by start and end bit positions. Valid for SInt, UInt, and Bool types.

```Chisel
val xTopNibble = x(15, 12)
```

--------------------------------

### Migrating Wire Declaration Style from Chisel2 to Chisel3

Source: https://github.com/chipsalliance/chisel/wiki/Chisel3-vs-Chisel2

Demonstrates the change in syntax for declaring wires. In Chisel3, `Wire` is explicitly used to wrap the type, and width is specified using `.W` suffix.

```Scala
// Chisel2
val wire = UInt(width = 15)
```

```Scala
// Chisel3
val wire = Wire(UInt(15.W))
```

--------------------------------

### Chisel Scala Test File and Package Structure

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/developers/style.md

Outlines the conventions for organizing test files and packages in Chisel projects. Test classes and files should be named by appending 'Test' to the name of the class they are testing. Test files must reside in a 'tests' subdirectory, and their package should mirror the package of the class under test.

```Scala
package class.under.test.class
package tests
```

--------------------------------

### Chisel: Interact with SRAM Ports (Read, Write, Read/Write)

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/memories.md

This example illustrates how to interact with the explicitly declared read, write, and read-write ports of an `SRAM` instance. It shows how to set addresses, enable signals, write data, and read data for each type of port.

```Scala
class TopModule extends Module {
  // Declare a 2 read, 2 write, 2 read-write ported SRAM with 8-bit UInt data members
  val mem = SRAM(1024, UInt(8.W), 2, 2, 2)

  // Whenever we want to read from the first read port
  mem.readPorts(0).address := 100.U
  mem.readPorts(0).enable := true.B

  // Read data is returned one cycle after enable is driven
  val foo = WireInit(UInt(8.W), mem.readPorts(0).data)

  // Whenever we want to write to the second write port
  mem.writePorts(1).address := 5.U
  mem.writePorts(1).enable := true.B
  mem.writePorts(1).data := 12.U

  // Whenever we want to read or write to the third read-write port
  // Write:
  mem.readwritePorts(2).address := 5.U
  mem.readwritePorts(2).enable := true.B
  mem.readwritePorts(2).isWrite := true.B
  mem.readwritePorts(2).writeData := 100.U

  // Read:
  mem.readwritePorts(2).address := 5.U
  mem.readwritePorts(2).enable := true.B
  mem.readwritePorts(2).isWrite := false.B
  val bar = WireInit(UInt(8.W), mem.readwritePorts(2).readData)
}
```

--------------------------------

### Define a Basic Chisel Module

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/resources/faqs.md

This Scala snippet defines a simple 'HelloWorld' module using Chisel3, demonstrating a basic hardware component with a printf statement.

```scala
package intro

import chisel3._
class HelloWorld extends Module {
  val io = IO(new Bundle{})
  printf("hello world\n")
}
```

--------------------------------

### Chisel Coercion Connection (`:#=`) for Bundle Initialization

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/connectable.md

Demonstrates the `:#=` operator to initialize a `Wire` of a `MixedAlignmentBundle` type from a `BundleLiteral`. This ensures all members of the bundle are driven, regardless of their alignment, making it suitable for complex bundle types. The example also shows how to generate the corresponding Verilog.

```Scala
import chisel3.experimental.BundleLiterals._
class Example4 extends RawModule {
  val w = Wire(new MixedAlignmentBundle)
  dontTouch(w) // So we see it in the output Verilog
  w :#= (new MixedAlignmentBundle).Lit(_.alignedChild -> true.B, _.flippedChild -> true.B)
}
```

```Scala
chisel3.docs.emitSystemVerilog(new Example4)
```

--------------------------------

### Example Usage of Generic Mux Function

Source: https://github.com/chipsalliance/chisel/wiki/Polymorphism-and-Parameterization

Demonstrates how to use the generic `Mux` function with `UInt` types. Scala infers the return type as `UInt` based on the input arguments, ensuring type consistency at compilation.

```Scala
Mux(c, UInt(10), UInt(11))
```

--------------------------------

### Working Chisel Mux with Implicitly Converted Tuples

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/dataview.md

The final, working version of the tuple example. With the implicit `DataView` and conversion in place, Scala Tuples can be used directly with Chisel's `Mux` and `:=` operators, achieving the desired concise syntax.

```scala
class TupleExample extends RawModule {
  val a, b, c, d = IO(Input(UInt(8.W)))
  val cond = IO(Input(Bool()))
  val x, y = IO(Output(UInt(8.W)))
  (x, y) := Mux(cond, (a, b), (c, d))
}
```

--------------------------------

### Define a Chisel Vec

Source: https://github.com/chipsalliance/chisel/wiki/Bundles-and-Vecs

Illustrates how to create an indexable vector of elements using `Vec` in Chisel. This example creates a vector of five 23-bit signed integers and shows how to access an individual element.

```Scala
// Vector of 5 23-bit signed integers.
val myVec = Wire(Vec(5, SInt(23.W)))

// Connect to one element of vector. 
val reg3 = myVec(3)
```

--------------------------------

### Define Chisel Module with Synchronous Reset

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/reset.md

Example of a Chisel module that explicitly requires a synchronous reset. By mixing in `RequireSyncReset`, the module's implicit `reset` signal will be of type `Bool`, ensuring any `RegInit` within uses synchronous reset.

```Scala
class MyAlwaysSyncResetModule extends Module with RequireSyncReset {
  val mySyncResetReg = RegInit(false.B) // reset is of type Bool
}
```

--------------------------------

### Verilog Implementation for BlackBoxRealAdd

Source: https://github.com/chipsalliance/chisel/wiki/BlackBoxes

Provides the Verilog implementation for the `BlackBoxRealAdd` module. It defines a module that takes two 64-bit inputs, converts them to real numbers using `$bitstoreal`, performs addition, and converts the result back to a 64-bit unsigned integer using `$realtobits`. This module serves as the external logic for the Chisel BlackBox.

```Verilog
module BlackBoxRealAdd(
    input  [63:0] in1,
    input  [63:0] in2,
    output reg [63:0] out
);
  always @* begin
  out <= $realtobits($bitstoreal(in1) + $bitstoreal(in2));
  end
endmodule
```

--------------------------------

### Define Chisel Module with Asynchronous Reset

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/reset.md

Example of a Chisel module that explicitly requires an asynchronous reset. By mixing in `RequireAsyncReset`, the module's implicit `reset` signal will be of type `AsyncReset`, ensuring any `RegInit` within uses asynchronous reset.

```Scala
class MyAlwaysAsyncResetModule extends Module with RequireAsyncReset {
  val myAsyncResetReg = RegInit(false.B) // reset is of type AsyncReset
}
```

--------------------------------

### Define and Inspect ChiselEnum for Mux Selection

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/chisel-enum.md

Defines a ChiselEnum named AluMux1Sel to represent selection signals for a RISC-V core's multiplexer. This example demonstrates how to create an enumeration with implicitly assigned values and how to print their underlying mappings.

```Scala
object AluMux1Sel extends ChiselEnum {
  val selectRS1, selectPC = Value
}
// We can see the mapping by printing each Value
AluMux1Sel.all.foreach(println)
```

--------------------------------

### Repl Command Line Flags for VCD Creation

Source: https://github.com/chipsalliance/chisel/wiki/Debugging-with-the-Interpreter-REPL-3

These command line flags enable VCD file generation during Repl execution. `--fint-write-vcd` writes the VCD log, and `--fint-vcd-show-underscored-vars` includes variables starting with an underscore, which are typically hidden by default.

```Shell
-fiwv, --fint-write-vcd  writes vcd execution log, filename will be base on top
-fivsuv, --fint-vcd-show-underscored-vars
                           vcd output by default does not show var that start with underscore, this overrides that
```

--------------------------------

### Chisel Test Failure Log Analysis

Source: https://github.com/chipsalliance/chisel/wiki/Debugging-with-the-Interpreter-REPL-2

Illustrates the verbose output from a failed Chisel test, highlighting the `EXPECT ... FAIL` line which indicates a discrepancy between expected and actual values, guiding the user to the point of failure.

```console
[info] [0.090] EXPECT AT 316   io_outputValid got 1 expected 1 PASS
[info] [0.090]   POKE io_value1 <- 13
[info] [0.091]   POKE io_value2 <- 29
[info] [0.091]   POKE io_loadingValues <- 1
[info] [0.091] STEP 316 -> 317
[info] [0.091]   POKE io_loadingValues <- 0
[info] [0.091] STEP 317 -> 326
[info] [0.092] EXPECT AT 326   io_outputGCD got 13 expected 1 FAIL
[info] [0.092] EXPECT AT 326   io_outputValid got 1 expected 1 PASS
```

--------------------------------

### Determine Specified Direction with DataMirror.specifiedDirectionOf

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/chisel-type-vs-scala-type.md

Explains that DataMirror.specifiedDirectionOf can be used to get the specified direction of both hardware instances and Chisel data types, providing a more flexible way to query direction information.

```Scala
elaborate(new Module {
  val child = Module(new Child())
  child.hardware := DontCare
  val direction0 = DataMirror.specifiedDirectionOf(child.hardware)
  val direction1 = DataMirror.specifiedDirectionOf(child.chiselType)
})
```

--------------------------------

### Chisel Module Definitions for Commutative '<>' Operator Test

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/connection-operators.md

Redefines `Wrapper` and `PipelineStage` modules, demonstrating the commutativity of the `<>` operator by flipping the LHS and RHS of connections. This setup confirms that the data flow remains consistent regardless of operand order.

```Scala
import chisel3._
import chisel3.util.DecoupledIO

class Wrapper extends Module{
  val io = IO(new Bundle {
  val in = Flipped(DecoupledIO(UInt(8.W)))
  val out = DecoupledIO(UInt(8.W))
  })
  val p = Module(new PipelineStage)
  val c = Module(new PipelineStage)
  // connect producer to I/O
  io.in <> p.io.a
  // connect producer  to consumer
  p.io.b <> c.io.a
  // connect consumer to I/O
  c.io.b <> io.out
}
class PipelineStage extends Module{
  val io = IO(new Bundle{
    val a = Flipped(DecoupledIO(UInt(8.W)))
    val b = DecoupledIO(DecoupledIO(UInt(8.W)))
  })
  io.a <> io.b
}
```

--------------------------------

### SystemVerilog Compilation Result for Illegal Chisel Probes

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/probes.md

This SystemVerilog code snippet shows the potential, problematic output if the illegal Chisel input probe example were to be compiled. It highlights the simple module structure that would result, which then relies on SystemVerilog's hierarchical name resolution, leading to the discussed limitations and unpredictability.

```verilog
module Baz();

  wire b = Foo.a;

endmodule

module Bar();

  Baz baz();

endmodule

module Foo();

  wire a;

  Bar bar();

endmodule
```

--------------------------------

### Swap JDK to Temurin Java 11

Source: https://github.com/chipsalliance/chisel/blob/main/CONTRIBUTING.md

Command to switch the current shell's JDK to the latest patch release of Temurin Java 11 using Coursier. This is necessary for publishing the Chisel plugin for versions < 2.13.11.

```sh
eval $(cs java --jvm temurin:11 --env)
```

--------------------------------

### Generate SystemVerilog from Chisel using ChiselStage

Source: https://github.com/chipsalliance/chisel/blob/main/README.md

Shows how to use ChiselStage to compile Chisel code into SystemVerilog, including options for target language and randomization control.

```Scala
import chisel3.stage.ChiselGeneratorAnnotation
import circt.stage.{ChiselStage, FirtoolOption}

(new ChiselStage).execute(
  Array("--target", "systemverilog"),
  Seq(ChiselGeneratorAnnotation(() => new FirFilter(8, Seq(1.U, 1.U, 1.U))),
    FirtoolOption("--disable-all-randomization"))
)
```

--------------------------------

### SBT Configuration: Add Chisel Plugin Option

Source: https://github.com/chipsalliance/chisel/blob/main/plugin/README.md

Example of how to add a Chisel compiler plugin option to a `build.sbt` file. This line appends the `-P:chiselplugin:genBundleElements` flag to the `scalacOptions`, enabling specific plugin features during compilation.

```SBT Configuration
scalacOptions += "-P:chiselplugin:genBundleElements",
```

--------------------------------

### Migrating Sequential Memory (Mem) Usage from Chisel2 to Chisel3

Source: https://github.com/chipsalliance/chisel/wiki/Chisel3-vs-Chisel2

Shows the migration of sequential memory declarations and access. Chisel3 introduces `SyncReadMem` for synchronous read memories, where the address register is internal, and `read` method is used for access.

```Scala
// Chisel2
val addr = Reg(UInt())
val mem = Mem(UInt(8.W), 1024, seqRead = true)
val dout = when(enable) { mem(addr) }
```

```Scala
// Chisel3
val addr = UInt()
val mem = SyncReadMem(1024, UInt(8.W))
val dout = mem.read(addr, enable)
```

--------------------------------

### Chisel Error Handling API Migration

Source: https://github.com/chipsalliance/chisel/wiki/Chisel3-vs-Chisel2

Shows the changes in error and info message handling. `ChiselError` class is removed, requiring standard Scala exception throwing and printing for error and info messages respectively.

```Scala
// Chisel2
ChiselError.error("error msg")
ChiselError.info("info msg")
```

```Scala
// Chisel3
throw new Error("error msg")
println("info msg")
```

--------------------------------

### Implicit Strict Options with Chisel3 Package

Source: https://github.com/chipsalliance/chisel/wiki/Chisel3-vs-Chisel2

The standard `chisel3._` package import implicitly defines the compile options as `chisel3.core.ExplicitCompileOptions.Strict`. This is the default behavior for modern Chisel3 development, promoting stricter error checking.

```Scala
import chisel3._
```

--------------------------------

### ChiselSim Simulation APIs Reference

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/testing.md

ChiselSim offers two primary simulation APIs: `simulate` for `Module`s, which includes an initialization procedure, and `simulateRaw` for `RawModule`s, requiring manual reset stimulus. These APIs are part of `chisel3.simulator.SimulatorAPI`.

```APIDOC
simulate(module: chisel3.Module): Unit
  - Purpose: Runs simulation for a Chisel Module.
  - Behavior: Performs an initial setup/reset sequence before applying user stimulus.
  - Usage: Intended for standard Chisel Modules with defined clock/reset.

simulateRaw(rawModule: chisel3.RawModule): Unit
  - Purpose: Runs simulation for a Chisel RawModule.
  - Behavior: Applies no automatic initialization; user is responsible for providing all stimulus, including reset.
  - Usage: Intended for low-level modules or when fine-grained control over initialization is needed.
```

--------------------------------

### Inspect Chisel Module Ports using DataMirror.modulePorts

Source: https://github.com/chipsalliance/chisel/wiki/Ports

This example illustrates how to use the `chisel3.experimental.DataMirror.modulePorts` API (available in Chisel 3.2+) to programmatically inspect the input/output ports of a Chisel module. It defines an `Adder` module and a `Test` module that instantiates the `Adder`, then iterates through its ports, printing their names and types for debugging or introspection purposes.

```scala
import chisel3.experimental.DataMirror

class Adder extends MultiIOModule {
  val a = IO(Input(UInt(8.W)))
  val b = IO(Input(UInt(8.W)))
  val c = IO(Output(UInt(8.W)))
  c := a +& b
}

class Test extends MultiIOModule {
  val adder = Module(new Adder)
  // for debug only
  adder.a := DontCare
  adder.b := DontCare

  // Inspect ports of adder
  // Prints something like this
  /**
    * Found port clock: Clock(IO clock in Adder)
    * Found port reset: Bool(IO reset in Adder)
    * Found port a: UInt<8>(IO a in Adder)
    * Found port b: UInt<8>(IO b in Adder)
    * Found port c: UInt<8>(IO c in Adder)
    */
  DataMirror.modulePorts(adder).foreach { case (name, port) => {
    println(s"Found port $name: $port")
  }}
}

chisel3.Driver.execute(Array[String](), () => new Test)
```

--------------------------------

### Instantiate a Generic FIFO with DataBundle

Source: https://github.com/chipsalliance/chisel/wiki/Polymorphism-and-Parameterization

Example of instantiating the generic `Fifo` module with `DataBundle` as its data type and a depth of 8 elements. This shows how to create a concrete FIFO instance from the parameterized class, ready for use in a larger design.

```Scala
val fifo = Module(new Fifo(new DataBundle, 8))
```

--------------------------------

### Implicit NotStrict Options with Chisel Compatibility Layer

Source: https://github.com/chipsalliance/chisel/wiki/Chisel3-vs-Chisel2

Using the `Chisel._` import, which provides a compatibility layer for Chisel2, implicitly sets the compile options to `chisel3.core.ExplicitCompileOptions.NotStrict`. This maintains behavior consistent with older Chisel versions.

```Scala
import Chisel._
```

--------------------------------

### Create a Register of Type Vec in Chisel

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/cookbook.md

This Chisel example illustrates the correct way to create a register that holds a vector (Reg of Vec). It shows how to declare a Reg of Vec of UInts and how to initialize it using RegInit with VecInit and Seq.fill for a collection of initial values.

```scala
import chisel3._

class Foo extends Module {
  val regOfVec = Reg(Vec(4, UInt(32.W))) // Register of 32-bit UInts
  regOfVec(0) := 123.U                   // Assignments to elements of the Vec
  regOfVec(1) := 456.U
  regOfVec(2) := 789.U
  regOfVec(3) := regOfVec(0)

  // Reg of Vec of 32-bit UInts initialized to zero
  //   Note that Seq.fill constructs 4 32-bit UInt literals with the value 0
  //   VecInit(...) then constructs a Wire of these literals
  //   The Reg is then initialized to the value of the Wire (which gives it the same type)
  val initRegOfVec = RegInit(VecInit(Seq.fill(4)(0.U(32.W))))
}
```

--------------------------------

### Chisel: Conditional Assignment to Wires with `when` and `otherwise`

Source: https://github.com/chipsalliance/chisel/wiki/Combinational-Circuits

Shows how to declare a hardware wire using `Wire(UInt(8.W))` and conditionally assign values to it based on a condition using the `when` and `otherwise` constructs. This example assigns `255.U` if `isReady` is true, otherwise `0.U`.

```scala
val myNode = Wire(UInt(8.W))
when (isReady) {
  myNode := 255.U
} .otherwise {
  myNode := 0.U
}
```

--------------------------------

### Run Chisel Unit Tests with SBT

Source: https://github.com/chipsalliance/chisel/wiki/Debugging-with-the-Interpreter-REPL-1

This command executes a specific unit test for the GCD module using SBT. The `-z` flag filters tests by name, ensuring only the 'calculate proper greatest common' test runs, demonstrating the initial setup and test execution.

```sbt
sbt
testOnly gcd.GCDTester -- -z "calculate proper greatest common"
```

--------------------------------

### Chisel Ready/Valid Interfaces API Reference

Source: https://github.com/chipsalliance/chisel/wiki/Frequently-Asked-Questions

Documents the behavior and guarantees of key Ready/Valid interfaces in Chisel, including `DecoupledIO` and `IrrevocableIO`, which define different communication protocols between hardware modules.

```APIDOC
DecoupledIO:
  Description: No guarantees on producer/consumer behavior.
  API Link: https://chisel.eecs.berkeley.edu/api/index.html#chisel3.util.DecoupledIO

IrrevocableIO:
  Description: Producer promises not to change the value of 'bits' after a cycle where 'valid' is high and 'ready' is low. Additionally, once 'valid' is raised it will never be lowered until after 'ready' has also been raised.
  API Link: https://chisel.eecs.berkeley.edu/api/index.html#chisel3.util.IrrevocableIO
```

--------------------------------

### Parametrizing Chisel Modules with Other Modules

Source: https://github.com/chipsalliance/chisel/wiki/Polymorphism-and-Parameterization

This Scala/Chisel example demonstrates how to create a generic `X` module that can be parametrized by other modules implementing the `MyAdder` trait. It shows how `Mod1` (adder) and `Mod2` (subtractor) can be swapped into `X` at compile time, allowing for flexible hardware generation. The `emitVerilog` calls show how different instantiations are generated.

```Scala
import chisel3.experimental.{BaseModule, RawModule}

// Provides a more specific interface since generic Module
// provides no compile-time information on generic module's IOs.
trait MyAdder {
    def in1: UInt
    def in2: UInt
    def out: UInt
}

class Mod1 extends RawModule with MyAdder {
    val in1 = IO(Input(UInt(8.W)))
    val in2 = IO(Input(UInt(8.W)))
    val out = IO(Output(UInt(8.W)))
    out := in1 + in2
}

class Mod2 extends RawModule with MyAdder {
    val in1 = IO(Input(UInt(8.W)))
    val in2 = IO(Input(UInt(8.W)))
    val out = IO(Output(UInt(8.W)))
    out := in1 - in2
}

class X[T <: BaseModule with MyAdder](genT: => T) extends Module {
    val io = IO(new Bundle {
        val in1 = Input(UInt(8.W))
        val in2 = Input(UInt(8.W))
        val out = Output(UInt(8.W))
    })
    val subMod = Module(genT)
    io.out := subMod.out
    subMod.in1 := io.in1
    subMod.in2 := io.in2
}

println(chisel3.Driver.emitVerilog(new X(new Mod1)))
println(chisel3.Driver.emitVerilog(new X(new Mod2)))
```

--------------------------------

### Enable NotStrict Compile Options in Chisel3

Source: https://github.com/chipsalliance/chisel/wiki/Chisel3-vs-Chisel2

This Scala import statement defers connection and usage checks from the Chisel3 front end to the FIRRTL compiler. This can be useful for compatibility or when more lenient front-end checks are desired.

```Scala
import chisel3.core.ExplicitCompileOptions.NotStrict
```

--------------------------------

### Generate FIRRTL from Chisel using a Scala application

Source: https://github.com/chipsalliance/chisel/wiki/Frequently-Asked-Questions

This Scala application demonstrates how to elaborate a Chisel module (e.g., 'Multiplier') and dump its FIRRTL representation to a file. It uses `chisel3.Driver.elaborate` and `chisel3.Driver.dumpFirrtl`.

```Scala
package intro

import chisel3._
import java.io.File

object Main extends App {
  val f = new File("Multiplier.fir")
  chisel3.Driver.dumpFirrtl(chisel3.Driver.elaborate(() => new Multiplier), Option(f))
}
```

--------------------------------

### Reusing Subexpressions with `val` for Fan-Out in Chisel

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/combinational-circuits.md

Illustrates how Scala's `val` keyword is used in Chisel to name intermediate wire outputs, enabling the reuse of subexpressions (fan-out) across multiple parts of a circuit, as shown in a multiplexer example.

```Scala
val sel = a | b
val out = (sel & in1) | (~sel & in0)
```

--------------------------------

### Instantiate a Parameterized Filter with PLink

Source: https://github.com/chipsalliance/chisel/wiki/Polymorphism-and-Parameterization

Example of instantiating the generic `Filter` module with a specific `PLink` type. This demonstrates how to use the parameterized class to create a concrete filter instance tailored to a particular data link type.

```Scala
val f = Module(new Filter(new PLink))
```

--------------------------------

### Chisel Bidirectional Connection Operator (:<>=) Example

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/connectable.md

Demonstrates the `:<>=` operator in Chisel for connecting components with mixed alignment members. This operator provides 'bulk-connect-like-semantics', where aligned members are driven producer-to-consumer and flipped members are driven consumer-to-producer.

```Scala
class Example1 extends RawModule {
  val incoming = IO(Flipped(new MixedAlignmentBundle))
  val outgoing = IO(new MixedAlignmentBundle)
  outgoing :<>= incoming
}
```

--------------------------------

### Apply `prefix` to Loop-Generated Chisel Signals

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/naming.md

Demonstrates how to use `chisel3.experimental.prefix` within `Seq.tabulate` loops to assign meaningful names to intermediate signals. This prevents Chisel from generating generic `_T` or uniquified names, improving the readability of the resulting Verilog. The example shows how to apply a unique prefix based on loop indices.

```Scala
import chisel3.experimental.prefix
class ExamplePrefix extends Module {

  Seq.tabulate(2) { i =>
    Seq.tabulate(2) { j =>
      prefix(s"loop_${i}_${j}"){
        val x = WireInit((i*0x10+j).U(8.W))
        dontTouch(x)
      }
    }
  }
}
```

```Scala
emitSystemVerilog(new ExamplePrefix)
```

--------------------------------

### Navigate to Chisel's Latest Temporary Simulation Directory

Source: https://github.com/chipsalliance/chisel/wiki/tips-and-tricks

This shell function allows users to quickly change their current directory to the latest temporary directory created by Chisel for a simulation. It searches for directories in $TMPDIR matching a given pattern, typically the name of the Scala-Chisel source file, and navigates to the most recently modified one. Useful for inspecting intermediate files.

```Shell
# Usage goto_chisel_temp <pattern>
# Example:
# >> goto_chisel_temp Small
Changing to latest tempdir for Small SmallOdds3Tester7903104241751344739/
# will place the user in latest temp directory associated with a chisel simulation
# >>>
function goto_chisel_temp {
      cd $TMPDIR
      dir=`\ls -ltr | awk "/$1/"' { print $NF }' | tail -1`
      if test -n "4dir"; then
        echo "Changing to latest tempdir for $1 $dir"
        cd $dir
      else
        echo "Could not find latest tempdir for $1"
      fi
    }
```

--------------------------------

### Chisel: Masked Read/Write Memory with Combined Port

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/memories.md

This example illustrates how to implement masked read and write operations using a combined read/write port on a `SyncReadMem`. It shows conditional logic for writing specific subwords based on mask bits and reading from the same port.

```Scala
import chisel3._
class MaskedRWSmem extends Module {
  val width: Int = 32
  val io = IO(new Bundle {
    val enable = Input(Bool())
    val write = Input(Bool())
    val mask = Input(Vec(2, Bool()))
    val addr = Input(UInt(10.W))
    val dataIn = Input(Vec(2, UInt(width.W)))
    val dataOut = Output(Vec(2, UInt(width.W)))
  })

  val mem = SyncReadMem(1024, Vec(2, UInt(width.W)))
  io.dataOut := DontCare
  when(io.enable) {
    val rdwrPort = mem(io.addr)
    when (io.write) {
      when(io.mask(0)) {
        rdwrPort(0) := io.dataIn(0)
      }
      when(io.mask(1)) {
        rdwrPort(1) := io.dataIn(1)
      }
    }.otherwise { io.dataOut := rdwrPort }
  }
}
```

--------------------------------

### Chisel Scala Import Style Guidelines

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/developers/style.md

Specifies rules for import statements in Chisel Scala code. Wildcard imports are generally discouraged, with the exception of `chisel3._`. The `chisel3._` import must be placed first, followed by a blank line, and then all other specific imports listed alphabetically. This promotes clarity on method origins.

```Scala
import chisel3._

import the.other.thing.that.i.reference.inline
import the.other.things.that.i.reference.{ClassOne, ClassTwo}


val myInline = inline.MakeAnInline()
val myClassOne = new ClassOne
```

--------------------------------

### Chisel: Parameterize Module by Child Definitions

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/hierarchy.md

This example demonstrates a powerful feature where a parent Chisel module can be parameterized by a child `Definition`. This allows the child's parameters to influence the parent's design, reducing coupling and enabling more flexible module composition.

```scala
import chisel3._
import chisel3.experimental.hierarchy.{Definition, Instance, instantiable, public}

@instantiable
class AddOne(val width: Int) extends Module {
  @public val width = width
  @public val in  = IO(Input(UInt(width.W)))
  @public val out = IO(Output(UInt(width.W)))
  out := in + 1.U
}

class AddTwo(addOneDef: Definition[AddOne]) extends Module {
  val i0 = Instance(addOneDef)
  val i1 = Instance(addOneDef)
  val in  = IO(Input(UInt(addOneDef.width.W)))
  val out = IO(Output(UInt(addOneDef.width.W)))
  i0.in := in
  i1.in := i0.out
  out   := i1.out
}
```

```verilog
chisel3.docs.emitSystemVerilog(new AddTwo(Definition(new AddOne(10))))
```

--------------------------------

### Chisel: Instantiating and Using DecoderTable for Structured Decoding

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/decoder.md

This example shows how to use `DecodeTable` within a Chisel module for structured decoding. It demonstrates passing a sequence of `DecodePattern` and `DecodeField` instances to the `DecodeTable` constructor. The `decode` method processes the input, and individual fields can be accessed using their `DecodeField` object.

```Scala
import chisel3._
import chisel3.util.experimental.decode._

class SimpleDecodeTable extends Module {
  val allPossibleInputs = Seq(Pattern("addi", BigInt("0x2")) /* can be generated */)
  val decodeTable = new DecodeTable(allPossibleInputs, Seq(NameContainsAdd))
  
  val input = IO(Input(UInt(4.W)))
  val isAddType = IO(Output(Bool()))
  val decodeResult = decodeTable.decode(input)
  isAddType := decodeResult(NameContainsAdd)
}
```

--------------------------------

### Run Until Condition Met with `waitfor` (Firrtl REPL)

Source: https://github.com/chipsalliance/chisel/wiki/Debugging-with-the-Interpreter-REPL-2

The `waitfor` command allows the circuit to run automatically until a specified condition is met, eliminating the need for manual stepping. This is particularly useful for observing circuit behavior over multiple cycles until a desired output or state is reached. The example demonstrates setting inputs, stepping, and then waiting for a valid output.

```Firrtl
firrtl>> poke io_loadingValues 1 ; poke io_value1 10 ; poke io_value2 15 ; step
step 1 in 0.001061492
firrtl>> poke io_loadingValues 0
firrtl>> waitfor io_outputValid 1 100
io_outputValid == value 1 in 3 cycles
firrtl>> peek io_outpugGCD
peek io_outputGCD  5
```

--------------------------------

### Enable Strict Compile Options in Chisel3

Source: https://github.com/chipsalliance/chisel/wiki/Chisel3-vs-Chisel2

This Scala import statement enables stricter connection and usage checks within the Chisel3 front end. It ensures more rigorous validation of hardware constructs at compile time.

```Scala
import chisel3.core.ExplicitCompileOptions.Strict
```

--------------------------------

### Chisel Values and Scala Method Naming Conventions

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/developers/style.md

Illustrates the lowerCamelCase convention for naming Chisel values (like registers) and Scala methods. This convention promotes readability and is applied to most variables and functions, unless the value is a constant.

```Scala
val mySuperReg = Reg(init = 0.asUInt(32))
def myImportantMethod(a: UInt): Bool = a < 23.asUInt
```

--------------------------------

### Programmatically Inspect Chisel Module I/O Ports using DataMirror

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/ports.md

This Scala example demonstrates the use of `DataMirror.modulePorts` (introduced in Chisel 3.2+) to introspect the input/output ports of any Chisel module. It defines an `Adder` module and a `Test` module that instantiates it. The `Test` module then iterates through the `Adder`'s ports, printing their names and associated `Data` objects, which is valuable for debugging, verification, and automated analysis of hardware designs.

```Scala
import chisel3.reflect.DataMirror
import chisel3.stage.ChiselGeneratorAnnotation

class Adder extends Module {
  val a = IO(Input(UInt(8.W)))
  val b = IO(Input(UInt(8.W)))
  val c = IO(Output(UInt(8.W)))
  c := a +& b
}

class Test extends Module {
  val adder = Module(new Adder)
  // for debug only
  adder.a := DontCare
  adder.b := DontCare

  // Inspect ports of adder
  // See the result below.
   DataMirror.modulePorts(adder).foreach { case (name, port) => {
    println(s"Found port $name: $port")
  }}
}
```

--------------------------------

### Scala: Defining Chisel Bundles and Default `DataView` Implicits

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/dataview.md

This example defines two Chisel `Bundle` types, `Foo` and `Bar`, and provides default implicit `DataView` instances within the `Foo` companion object. These implicits enable a standard mapping between `Foo` and `Bar` without explicit imports, demonstrating the 'low priority default' pattern.

```Scala
class Foo extends Bundle {
  val a = UInt(8.W)
  val b = UInt(8.W)
}
class Bar extends Bundle {
  val c = UInt(8.W)
  val d = UInt(8.W)
}
object Foo {
  implicit val f2b: DataView[Foo, Bar] = DataView(_ => new Bar, _.a -> _.c, _.b -> _.d)
  implicit val b2f: DataView[Bar, Foo] = f2b.invert(_ => new Foo)
}
```

--------------------------------

### Chisel Connectable for Partial Record Connections with Waive

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/connectable.md

Demonstrates how to use the `Connectable` mechanism to connect two `Record` components that are not type-equivalent but share common fields. By employing the `:<>=` operator with `.waive`, only the matching members are connected, while unmatched fields are ignored, preventing errors. The example provides the Scala implementation and the command to generate its Verilog.

```Scala
import scala.collection.immutable.SeqMap

class Example9 extends RawModule {
  val abType = new Record { val elements = SeqMap("a" -> Bool(), "b" -> Flipped(Bool())) }
  val bcType = new Record { val elements = SeqMap("b" -> Flipped(Bool()), "c" -> Bool()) }

  val p = IO(Flipped(abType))
  val c = IO(bcType)

  DontCare :>= p
  c :<= DontCare

  c.waive(_.elements("c")):<>= p.waive(_.elements("a"))
}
```

```Scala
chisel3.docs.emitSystemVerilog(new Example9)
```

--------------------------------

### Chisel Output Initialization (Problematic)

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/unconnected-wires.md

An example of Chisel code that only initializes the `valid` bit of an output queue, but fails to initialize the actual data bits. This incomplete initialization can lead to 'not fully initialized' errors in Firrtl, as the data path remains undriven.

```Scala
io.outs.foreach { out => out.noenq() }
```

--------------------------------

### Casting Chisel Clock Types

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/data-types.md

Provides examples of casting `Bool` to `Clock` and `Clock` to `UInt` or `Bool`. This highlights the special considerations and methods available for manipulating clock signals in Chisel, which require careful handling in hardware design.

```scala
val bool: Bool = false.B        // always-low wire
val clock = bool.asClock        // always-low clock

clock.asUInt                    // convert clock to UInt (width 1)
clock.asUInt.asBool             // convert clock to Bool (Chisel 3.2+)
clock.asUInt.toBool             // convert clock to Bool (Chisel 3.0 and 3.1 only)
```

--------------------------------

### Chisel C-style printf Basic Usage

Source: https://github.com/chipsalliance/chisel/wiki/Printing-in-Chisel

Demonstrates basic usage of Chisel's C-style `printf` with a format string and arguments, similar to C's `printf`. This provides a familiar syntax for users accustomed to C-style debugging.

```scala
val myUInt = 32.U
printf("myUInt = %d", myUInt)
```

--------------------------------

### Define Implicit DataView for Chisel Bundle Subtyping

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/dataview.md

This example demonstrates how to define an implicit `DataView` using `PartialDataView.supertype`. This simplifies type casting between a subtype (`Bar`) and its supertype (`Foo`) by automatically mapping fields, eliminating the need for explicit type templates with `viewAsSupertype`.

```Scala
import chisel3._
import chisel3.experimental.dataview._

class Foo(x: Int) extends Bundle {
  val foo = UInt(x.W)
}
class Bar(val x: Int) extends Foo(x) {
  val bar = UInt(x.W)
}
// Define a DataView without having to specify the mapping!
implicit val view: DataView[Bar, Foo] = PartialDataView.supertype[Bar, Foo](b => new Foo(b.x))

class MyModule extends Module {
  val foo = IO(Input(new Foo(8)))
  val bar = IO(Output(new Bar(8)))
  bar.viewAs[Foo] := foo // bar.foo := foo.foo
  bar.bar := 123.U       // all fields need to be connected
}
```

--------------------------------

### Declare a Scala singleton object with methods

Source: https://github.com/chipsalliance/chisel/wiki/Scala-Cheatsheet

Illustrates the declaration of a Scala singleton object using the `object` keyword. This example defines a method `func` within the singleton, demonstrating how to call it directly via the object's name without instantiation.

```Scala
object MySingleton {
  def func(): Unit = println("A function in a singleton!")
}
```

--------------------------------

### Deprecated Chisel API Usage and Replacements

Source: https://github.com/chipsalliance/chisel/wiki/Chisel3-vs-Chisel2

Provides a comprehensive list of deprecated API usages in Chisel2 and their recommended replacements in Chisel3, covering common patterns like Vec/Reg nesting, type-only vals, bit patterns, cloning, comparisons, memory types, and I/O methods.

```Scala
Old: Vec(Reg) -> New: Reg(Vec)
Old: type-only vals (no associated data) -> New: wrapped in Wire()
Old: masked bit patterns with UInt() or Bits() -> New: BitPat()
Old: clone method for parameterized Bundles -> New: cloneType
Old: != operator -> New: =/=
Old: Mem(..., seqRead) -> New: SyncReadMem(...)
Old: SyncReadMem(out: => T, n:Int) -> New: SyncReadMem(n:Int, out: => T)
Old: SeqMem(...) -> New: SyncReadMem(...)
Old: Mem(out:T, n:Int) -> New: Mem(n:Int, t:T)
Old: Vec(gen: => T, n:Int) -> New: Vec(n:Int, gen: => T)
Old: module io's not wrapped -> New: module io's wrapped in IO()
Old: asInput, asOutput, flip methods -> New: Input(), Output(), Flipped() object apply methods
```

--------------------------------

### Chisel Example: Automatic `cloneType` Inference with `val` Arguments

Source: https://github.com/chipsalliance/chisel/wiki/Bundles-and-Vecs

Illustrates how `cloneType` can be automatically inferred in Chisel `Bundle`s when all arguments are declared as `val`s, simplifying bundle definition by removing the need for explicit `cloneType` implementation.

```scala
class MyBundle(val width: Int) extends Bundle {
   val field = UInt(width.W)
   // ...
}
```

--------------------------------

### Instantiate a Scala Class using 'new'

Source: https://github.com/chipsalliance/chisel/wiki/Scala-Things-You-Should-Know

Demonstrates the explicit way to create an instance of a Scala class using the `new` keyword, passing the required arguments to its constructor. This is the standard mechanism for object creation.

```Scala
val x = new WrapCounter(4)
```

--------------------------------

### Declare Nested Chisel Layers

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/layers.md

This example illustrates how to declare nested layers in Chisel. A parent layer (C) can contain child layers (D, E), which can themselves contain further nested layers (F), demonstrating hierarchical layer organization.

```Scala
object C extends Layer(LayerConfig.Extract()) {
  object D extends Layer(LayerConfig.Extract())
  object E extends Layer(LayerConfig.Inline) {
    object F extends Layer(LayerConfig.Inline)
  }
}
```

--------------------------------

### Defining Modules with Different Clock Domains using withClock (Implicit Reset)

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/multi-clock.md

This example demonstrates the use of `withClock` to define a clock domain where synchronous elements use a specified clock but inherit the implicit reset signal from the parent context. It shows how to apply this to both internal registers within a module and to the instantiation of a child module, providing flexibility when explicit reset control is not required for the new domain.

```scala
import chisel3._

class MultiClockModule extends Module {
  val io = IO(new Bundle {
    val clockB = Input(Clock())
    val stuff = Input(Bool())
  })

  // This register is clocked against the module clock.
  val regClock = RegNext(io.stuff)

  withClock (io.clockB) {
    // In this withClock scope, all synchronous elements are clocked against io.clockB.

    // This register is clocked against io.clockB, but uses implict reset from the parent context.
    val regClockB = RegNext(io.stuff)
  }

  // This register is also clocked against the module clock.
  val regClock2 = RegNext(io.stuff)
}

// Instantiate module in another clock domain with implicit reset.
class MultiClockModule2 extends Module {
  val io = IO(new Bundle {
    val clockB = Input(Clock())
    val stuff = Input(Bool())
  })
  val clockB_child = withClock(io.clockB) { Module(new ChildModule) }
  clockB_child.io.in := io.stuff
}

class ChildModule extends Module {
  val io = IO(new Bundle{
    val in = Input(Bool())
  })
}
```

--------------------------------

### Chisel Monodirectional Connection Operator (:=) Example

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/connectable.md

Demonstrates the use of the `:=` operator in Chisel for simple, fully aligned connections. It shows how to connect an `IO` bundle with flipped direction to a regular `IO` bundle, ensuring all members are aligned and connected unidirectionally.

```Scala
import chisel3._
class FullyAlignedBundle extends Bundle {
  val a = Bool()
  val b = Bool()
}
class Example0 extends RawModule {
  val incoming = IO(Flipped(new FullyAlignedBundle))
  val outgoing = IO(new FullyAlignedBundle)
  outgoing := incoming
}
```

--------------------------------

### Obtain Chisel Circuit Calculation Result in REPL

Source: https://github.com/chipsalliance/chisel/wiki/Debugging-with-the-Interpreter-REPL-2

Demonstrates the final steps to get a calculated result from the circuit by clearing loading values (`poke io_loadingValues 0`) and stepping the simulation. The output verifies `io_outputValid` is high and `io_outputGCD` shows the correct result, indicating successful computation.

```CLI-Command
poke io_loadingValues 0 ; step ; show
```

```CLI-Output
CircuitState 6 (FRESH)
Inputs: clock= 0, io_loadingValues= 0, io_value1= 4, io_value2= 4, reset= 0
Outputs: io_outputGCD= 4, io_outputValid= 1
Registers      : x= 4, y= 0
FutureRegisters: x= 4, y= 0
Ephemera: _GEN_0= 4, _GEN_1= 0, _GEN_2= 4, _GEN_3= 0, _T_10= 4, _T_11= 4, _T_12= 4, _T_17= 1, _T_9= 1
```

--------------------------------

### Example of Illegal Input Probe Usage in Chisel

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/probes.md

This Chisel code snippet illustrates a hypothetical, illegal pattern for using input probes. It defines three modules (Baz, Bar, Foo) demonstrating how an input probe might be passed and used, which would lead to compilation issues due to SystemVerilog's hierarchical naming rules.

```scala
import chisel3._
import chisel3.probe.{Probe, ProbeValue, read}

module Baz extends RawModule {
  val probe = IO(Input(Probe(Bool())))

  val b = WireInit(read(probe))
}

module Bar extends RawModule {
  val probe = IO(Input(Probe(Bool())))

  val baz = Module(new Baz)
  baz.probe :<= probe

}

module Foo extends RawModule {

  val w = Wire(Bool())

  val bar = Module(new Bar)
  bar.probe :<= ProbeValue(w)
}
```

--------------------------------

### Compilation Error: Value Not a Member of Chisel Bundle

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/appendix/upgrading-from-scala-2-11.md

An example of the specific compilation error message encountered when Scala 2.12's stricter type inference fails to recognize members of a Chisel `Bundle`, often seen during upgrades.

```Log
[error] /workspace/src/main/scala/gcd/Foo.scala:9:6: value out is not a member of chisel3.Bundle
[error]   io.out := ~io.in
[error]      ^
[error] /workspace/src/main/scala/gcd/Foo.scala:9:17: value in is not a member of chisel3.Bundle
[error]   io.out := ~io.in
[error]                 ^
[error] two errors found
```

--------------------------------

### Test Chisel Enum Value with `litValue`

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/chisel-enum.md

Example of a Scala function that takes a Chisel Enum value and uses `.litValue` to retrieve its underlying integer representation. This is useful for pattern matching or comparing enum values based on their literal integer equivalents.

```Scala
def expectedSel(sel: AluMux1Sel.Type): Boolean = sel match {
  case AluMux1Sel.selectRS1 => (sel.litValue == 0)
  case AluMux1Sel.selectPC  => (sel.litValue == 1)
  case _                    => false
}
```

--------------------------------

### Poke Chisel Circuit Inputs and Observe State in REPL

Source: https://github.com/chipsalliance/chisel/wiki/Debugging-with-the-Interpreter-REPL-2

Shows how to set multiple input values for a Chisel circuit directly in the REPL using consecutive `poke` commands. The `show` command immediately after demonstrates that poked values are visible in inputs, and the circuit enters a 'STALE' state until propagation.

```CLI-Command
poke io_value1 4
poke io_value2 4
poke io_loadingValues 1
show
```

```CLI-Output
CircuitState 4 (STALE)
Inputs: clock= 0, io_loadingValues= 1, io_value1= 4, io_value2= 4, reset= 0
Outputs: io_outputGCD=☠ 9☠, io_outputValid= 0
Registers      : x=☠ 9☠, y=☠ 1☠
FutureRegisters: x=☠ 9☠, y=☠ 1☠
Ephemera: _GEN_2=☠ 59401☠, _GEN_3=☠ 23169☠, _T_17= 0
```

--------------------------------

### Publish Chisel to Local Ivy Repository

Source: https://github.com/chipsalliance/chisel/blob/main/README.md

Command to publish the locally built Chisel version to the Ivy repository. This makes the development version of Chisel available for other projects on the local machine, typically placed in `~/.ivy2/local/org.chipsalliance/`.

```bash
./mill unipublish.publishLocal
```

--------------------------------

### Construct a 4-input multiplexer hierarchy in Chisel (Scala)

Source: https://github.com/chipsalliance/chisel/wiki/Modules

This example illustrates how to build a larger, hierarchical module by instantiating and connecting smaller Chisel sub-modules. It shows the creation of three Mux2 instances using Module(new Mux2) and how their inputs and outputs are wired together to form a Mux4 module.

```Scala
class Mux4 extends Module {
  val io = IO(new Bundle {
    val in0 = Input(UInt(1.W))
    val in1 = Input(UInt(1.W))
    val in2 = Input(UInt(1.W))
    val in3 = Input(UInt(1.W))
    val sel = Input(UInt(2.W))
    val out = Output(UInt(1.W))
  })
  val m0 = Module(new Mux2)
  m0.io.sel := io.sel(0)
  m0.io.in0 := io.in0
  m0.io.in1 := io.in1

  val m1 = Module(new Mux2)
  m1.io.sel := io.sel(0)
  m1.io.in0 := io.in2
  m1.io.in1 := io.in3

  val m3 = Module(new Mux2)
  m3.io.sel := io.sel(1)
  m3.io.in0 := m0.io.out
  m3.io.in1 := m1.io.out

  io.out := m3.io.out
}
```

--------------------------------

### Define a Basic Chisel Bundle Interface

Source: https://github.com/chipsalliance/chisel/wiki/Interfaces-Bulk-Connections

Illustrates how to define a simple hardware interface (Bundle) in Chisel with basic output signals for data and validity. This serves as a foundational building block for more complex interfaces.

```scala
class SimpleLink extends Bundle {
  val data = Output(UInt(16.W))
  val valid = Output(Bool())
}
```

--------------------------------

### Define a Scala Class with Constructor, Members, and Method

Source: https://github.com/chipsalliance/chisel/wiki/Scala-Things-You-Should-Know

Presents a detailed example of defining a `WrapCounter` class in Scala. It demonstrates constructor parameters, immutable (`val`) and mutable (`var`) member variables, a method (`inc`) with implicit return, and string interpolation for output during initialization.

```Scala
class WrapCounter(counterBits: Int) {
  val max: Long = (1 << counterBits) - 1
  var counter = 0L
  def inc(): Long = {
    counter = counter + 1
    if(counter > max) counter = 0
    counter
  }
  println(s"counter created with max value $max")
}
```

--------------------------------

### Chisel Module and Scala Class Naming Conventions

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/developers/style.md

Shows the UpperCamelCase convention for naming Chisel Modules, Scala classes, traits, and companion objects. This convention aligns with standard Scala practices and ensures consistency across the codebase for structural elements.

```Scala
class ModuleNamingExample extends Module {
  ...
}

trait UsefulScalaUtilities {
  def isEven(n: Int): Boolean = (n % 2) == 0
  def isOdd(n: Int): Boolean = !isEven(n)
}

class MyCustomBundle extends Bundle {
  ...
}
// Companion object to MyCustomBundle
object MyCustomBundle {
  ...
}
```

--------------------------------

### Assigning DontCare to Directioned IOs in Chisel

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/connection-operators.md

This Chisel example illustrates that both `:=` and `<>` operators can be used interchangeably when assigning `DontCare` to directioned hardware elements like `IOs` or module ports. Both operators correctly infer the direction from the left-hand side in this context.

```scala
import chisel3._
import chisel3.util.DecoupledIO

class Wrapper extends Module{
  val io = IO(new Bundle {
  val in = Flipped(DecoupledIO(UInt(8.W)))
  val out = DecoupledIO(UInt(8.W))
  })
  val p = Module(new PipelineStage)
  val c = Module(new PipelineStage)
  //connect Producer to IO
  io.in := DontCare
  p.io.a <> DontCare
  val tmp = Wire(Flipped(DecoupledIO(UInt(8.W))))
  tmp := DontCare
  p.io.a <> io.in
  // connect producer to consumer
  c.io.a <> p.io.b
  //connect consumer to IO
  io.out <> c.io.b
}
class PipelineStage extends Module{
  val io = IO(new Bundle{
    val a = Flipped(DecoupledIO(UInt(8.W)))
    val b = DecoupledIO(UInt(8.W))
  })
  io.b <> io.a
}
```

```scala
chisel3.docs.emitSystemVerilog(new Wrapper)
```

--------------------------------

### Define DataBundle for Generic FIFO

Source: https://github.com/chipsalliance/chisel/wiki/Polymorphism-and-Parameterization

Defines a `DataBundle` class, a specific bundle of `UInt` types, to be used as the generic data type for the FIFO example. This illustrates how custom data structures can be integrated with parameterized classes for flexible hardware design.

```Scala
class DataBundle extends Bundle {
  val a = UInt(32.W)
  val b = UInt(32.W)
}
```

--------------------------------

### Chisel Core and Experimental Feature Imports

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/naming.md

Essential Scala imports for Chisel hardware description, including core functionalities and experimental features like `prefix` and `noPrefix` which are utilized by the compiler plugin for automatic naming.

```Scala
import chisel3._
import chisel3.experimental.{prefix, noPrefix}
```

--------------------------------

### Declarative Chisel I/O Assignment (Best Practice)

Source: https://github.com/chipsalliance/chisel/wiki/Scala-land-vs.-Chisel-land

This Chisel snippet illustrates the preferred declarative style for I/O assignments in Chisel. By assigning `module.io.in.a` and `module.io.in.valid` outside `when` clauses, the code clearly defines the continuous connection, with `valid` being directly driven by `condition`. This reflects the concurrent nature of hardware and avoids imperative pitfalls.

```Scala
  val index = RegInit(0.U(log2Up(max_index).W))
  module.io.in.a := vector(index)
  module.io.in.valid := condition
  when(module.io.in.ready) {
    index := index + 1.U
  }
```

--------------------------------

### Override ChiselSim Build Directory in Scala

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/testing.md

To change the default output directory for Chisel simulation results, override the `buildDir` method within your `ChiselSim` test class. This example sets the output path to a 'test' directory, ensuring simulation artifacts are stored in a custom location.

```Scala
import chisel3._
import chisel3.simulator.scalatest.ChiselSim
import java.nio.file.Paths
import org.scalatest.funspec.AnyFunSpec

class FooSpec extends FunSpec with ChiselSim {

  override def buildDir: Path = Paths.get("test")

}
```

--------------------------------

### Chisel Example: `cloneType` for Bundles with Type Parameters

Source: https://github.com/chipsalliance/chisel/wiki/Bundles-and-Vecs

Shows a `Bundle` (`RegisterWriteIO`) that takes a type parameter (`T <: Data`) as a generator. This scenario typically requires a custom `cloneType` implementation because the type parameter prevents automatic inference.

```scala
class RegisterWriteIO[T <: Data](gen: T) extends Bundle {
  val request  = Flipped(Decoupled(gen))
  val response = Irrevocable(Bool()) // ignore .bits

  override def cloneType = new RegisterWriteIO(gen).asInstanceOf[this.type]
}
```

--------------------------------

### Run GCD Tests and Generate VCD via Command Line

Source: https://github.com/chipsalliance/chisel/wiki/Debugging-with-the-Interpreter-REPL-3

This command line invocation runs the GCD tests using the Repl and automatically generates a VCD file based on the `--fr-use-vcd-script` flag. The VCD file will be placed in a subdirectory of `test_run_dir`.

```Shell
test:runMain gcd.GCDRepl --fr-use-vcd-script
```

--------------------------------

### Defining and Using Chisel Bundle Literals (Scala)

Source: https://github.com/chipsalliance/chisel/wiki/Experimental-Features

This experimental Chisel 3.2 feature allows library writers to define literal constructors for Bundles. The first code block shows how to implement full and partial literal constructors within a Bundle class. The second code block provides an example of how to instantiate and use such a Bundle literal.

```Scala
class MyBundle extends Bundle {
  val a = UInt(8.W)
  val b = Bool()

  // Bundle literal constructor code, which will be auto-generated using macro annotations in
  // the future.
  import chisel3.core.BundleLitBinding
  import chisel3.internal.firrtl.{ULit, Width}

  // Full bundle literal constructor
  def Lit(aVal: UInt, bVal: Bool): MyBundle = {
    val clone = cloneType
    clone.selfBind(BundleLitBinding(Map(
      clone.a -> litArgOfBits(aVal),
      clone.b -> litArgOfBits(bVal)
    )))
    clone
  }

  // Partial bundle literal constructor
  def Lit(aVal: UInt): MyBundle = {
    val clone = cloneType
    clone.selfBind(BundleLitBinding(Map(
      clone.a -> litArgOfBits(aVal)
    )))
    clone
  }
}
```

```Scala
val outsideBundleLit = (new MyBundle).Lit(42.U, true.B)
```

--------------------------------

### Verilog Implementation of Vending Machine FSM

Source: https://github.com/chipsalliance/chisel/wiki/A-Detailed-Example

This Verilog module implements a simple finite state machine for a vending machine. It accepts nickel (5¢) and dime (10¢) inputs, dispenses a product when 20¢ is reached, and does not provide change. States are defined for different accumulated amounts, and the FSM transitions based on coin inputs.

```Verilog
// A simple Verilog FSM vending machine implementation
module VerilogVendingMachine(
  input clock,
  input reset,
  input nickel,
  input dime,
  output dispense
);
  parameter sIdle = 3'd0, s5 = 3'd1, s10 = 3'd2, s15 = 3'd3, sOk = 3'd4;
  reg [2:0] state;
  wire [2:0] next_state;

  assign dispense = (state == sOk) ? 1'd1 : 1'd0;

  always @(*) begin
    case (state)
      sIdle: if (nickel) next_state <= s5;
             else if (dime) next_state <= s10;
             else next_state <= state;
      s5: if (nickel) next_state <= s10;
             else if (dime) next_state <= s15;
             else next_state <= state;
      s10: if (nickel) next_state <= s15;
             else if (dime) next_state <= sOk;
             else next_state <= state;
      s15: if (nickel) next_state <= sOk;
             else if (dime) next_state <= sOk;
             else next_state <= state;
      sOk: next_state <= sIdle;
    endcase
  end

  // Go to next state
  always @(posedge clock) begin
    if (reset) begin
      state <= sIdle;
    end else begin
      state <= next_state;
    end
  end
endmodule
```

--------------------------------

### Nest Chisel Bundles and Vecs

Source: https://github.com/chipsalliance/chisel/wiki/Bundles-and-Vecs

Shows how to build complex hierarchical data structures in Chisel by arbitrarily nesting `Bundle` and `Vec` types. This example defines `BigBundle` which contains both a `Vec` and an instance of a previously defined `MyFloat` bundle.

```Scala
class BigBundle extends Bundle {
 // Vector of 5 23-bit signed integers.
 val myVec = Vec(5, SInt(23.W))
 val flag  = Bool()
 // Previously defined bundle.
 val f     = new MyFloat
}
```

--------------------------------

### Chisel BlackBox with External Verilog Resource

Source: https://github.com/chipsalliance/chisel/wiki/BlackBoxes

Illustrates how to associate an external Verilog file with a Chisel `BlackBox` using the `HasBlackBoxResource` trait and `setResource` method. This approach allows the Chisel execution harness to locate and include the Verilog implementation from a specified resource path (e.g., `src/main/resources/real_math.v`), facilitating modular design and reuse of Verilog IP.

```Scala
class BlackBoxRealAdd extends BlackBox with HasBlackBoxResource {
  val io = IO(new Bundle() {
    val in1 = Input(UInt(64.W))
    val in2 = Input(UInt(64.W))
    val out = Output(UInt(64.W))
  })
  setResource("/real_math.v")
}
```

--------------------------------

### Dynamically name SimLog files using Printable values

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/printing.md

Demonstrates creating SimLog files with dynamic names based on Chisel Printable values, recommending %0d for UInts to avoid spaces.

```Scala
class MyModule extends Module {
  val idx = IO(Input(UInt(8.W)))
  val log = SimLog.file(cf"logfile_$idx%0d.log")
  val in = IO(Input(UInt(8.W)))
  log.printf(cf"in = $in%d\n")
}
```

--------------------------------

### Partially Reset Chisel Aggregate Register with Wire and DontCare

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/cookbook.md

This Chisel example provides an alternative method for partially resetting an aggregate register. It uses a Wire as the initial value for RegInit, allowing specific fields to be set while others are explicitly marked with DontCare to prevent them from being reset.

```scala
class MyModule2 extends Module {
  val reg = RegInit({
    // The wire could be constructed before the reg rather than in the RegInit scope,
    // but this style has nice lexical scoping behavior, keeping the Wire private
    val init = Wire(new MyBundle)
    init := DontCare // No fields will be reset
    init.foo := 123.U // Last connect override, .foo is reset
    init
  })
}
```

--------------------------------

### Generate Verilog for Chisel Wrapper Module

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/connection-operators.md

This Scala code snippet invokes the Chisel compiler to emit SystemVerilog for the `Wrapper` module defined previously. It demonstrates the resulting hardware description generated by Chisel, showcasing the successful translation of the signal connections.

```scala
chisel3.docs.emitSystemVerilog(new Wrapper)
```

--------------------------------

### Chisel Scala Package Naming Conventions

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/developers/style.md

Defines the standard for package declarations in Chisel Scala projects. Packages should use full paths, follow Java naming conventions (all lowercase, no underscores), and avoid using 'chisel3' as a final package name to prevent namespace collisions.

```Scala
package directory.name.to.get.you.to.your.source
```

```Scala
// Do this
package hardware.chips.topsecret.masterplan

// Not this
package hardware.chips.veryObvious.bad_style
```

```Scala
// Don't do this
package hardware.chips.newchip.superfastcomponent.chisel3

// This will lead to instantiating package members like so:
val module = Module(new chisel3.FastModule)

// Which collides with the chisel namespace
import chisel3._
```

--------------------------------

### Cast Chisel SInt and UInt Types

Source: https://github.com/chipsalliance/chisel/wiki/Datatypes-in-Chisel

This example shows how to cast between SInt and UInt types in Chisel using the .asUInt and .asSInt methods. When casting, Chisel automatically handles padding or truncation as needed. Note that explicit width parameters are not accepted for these casting methods.

```Scala
val sint = 3.S(4.W)             // 4-bit SInt

val uint = sint.asUInt          // cast SInt to UInt
uint.asSInt                     // cast UInt to SInt
```

--------------------------------

### Chisel3 Override Implicit Clock with Gated Clock

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/cookbook.md

This example demonstrates how to override the default implicit clock for a Chisel module by mixing in the ImplicitClock trait. A custom gated clock is defined and assigned, allowing fine-grained control over the module's clocking domain.

```Scala
import chisel3._
class MyModule extends Module with ImplicitClock {
  val gate = IO(Input(Bool()))
  val in = IO(Input(UInt(8.W)))
  val out = IO(Output(UInt(8.W)))
  // We could just assign this to val implicitClock, but this allows us to give it a custom name
  val gatedClock = (clock.asBool || gate).asClock
  // The trait requires us to implement this method referring to the clock
  // Note that this is a def, but the actual clock value must be assigned to a val
  override protected def implicitClock = gatedClock

  val r = Reg(UInt(8.W))
  out := r
  r := in
}
```

```Verilog
module MyModule(
  input        clock,
  input        reset,
  input        gate,
  input  [7:0] in,
  output [7:0] out
);
  wire  gatedClock = clock | gate;
  reg  [7:0] r;
  assign out = r;
  always @(posedge gatedClock) begin
    if (reset) begin
      r <= 8'h0;
    end else begin
      r <= in;
    end
  end
endmodule
```

--------------------------------

### Access and Print OM Data using PanamaCIRCTOM

Source: https://github.com/chipsalliance/chisel/blob/main/CONTRIBUTING.md

This Scala code snippet demonstrates how to access and print Object Model (OM) data after lowering FIRRTL Dialect to HW Dialect using the `PanamaCIRCTPassManager`. It initializes a pass manager, runs it, then retrieves the OM evaluator to instantiate a 'Top_Class' and iterate through its fields, printing their names and string representations.

```Scala
val pm = converter.passManager()
assert(pm.populateFinalizeIR())
assert(pm.run())

val om = converter.om()
val evaluator = om.evaluator()

val top = evaluator.instantiate("Top_Class", Seq(om.newBasePathEmpty)).get
top.foreachField((name, value) => println(s".${name} => { ${value.toString} }"))
```

--------------------------------

### Emit SystemVerilog for Chisel Probe Example

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/probes.md

This snippet uses `circt.stage.ChiselStage.emitSystemVerilog` to generate SystemVerilog from the `Foo` Chisel module. It configures `firtoolOpts` to strip debug information, disable randomization, and enable specific layers for verification. This demonstrates how Chisel probes translate into hierarchical names in the generated SystemVerilog, allowing access to internal signals without adding explicit hardware ports.

```scala
circt.stage.ChiselStage.emitSystemVerilog(
  new Foo,
  firtoolOpts = Array(
    "-strip-debug-info",
    "-disable-all-randomization",
    "-enable-layers=Verification",
    "-enable-layers=Verification.Assert",
    "-enable-layers=Verification.Assume",
    "-enable-layers=Verification.Cover"
  )
)
```

--------------------------------

### Get Chisel Type from Hardware with chiselTypeOf

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/chisel-type-vs-scala-type.md

Illustrates that the chiselTypeOf function is designed to extract the Chisel data type from a hardware instance, and will cause an error if called on a Chisel data type directly, as it expects a hardware element.

```Scala
// Do this...
elaborate(new Module {
  val hardware = Wire(new MyBundle(3))
  hardware := DontCare
  val chiselType = chiselTypeOf(hardware)
})
```

```Scala
// Not this...
elaborate(new Module {
  val chiselType = new MyBundle(3)
  val crash = chiselTypeOf(chiselType)
})
```

--------------------------------

### Import Chisel3 Library

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/functional-abstraction.md

Imports the necessary Chisel3 library components, specifically the `chisel3._` package, to enable hardware description using Chisel constructs.

```Scala
import chisel3._
```

--------------------------------

### List VCD Events

Source: https://github.com/chipsalliance/chisel/wiki/Debugging-with-the-Interpreter-REPL-3

The `vcd list` command displays the next 10 events from the VCD file. Repeated calls show subsequent batches. You can specify a starting event number, e.g., `vcd list 23`, to begin listing from that point. Avoid using `list all` as it can cause the session to hang.

```Interpreter Command
vcd list
```

```Interpreter Command
vcd list 23
```

--------------------------------

### Cast UInt to Chisel Enum

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/chisel-enum.md

Shows how to cast a UInt to a Chisel Enum type by passing the UInt to the Enum's apply method. This example will produce a warning if the UInt value can represent an undefined enum state, indicating a potential issue in the hardware logic.

```Scala
class FromUInt extends Module {
  val in = IO(Input(UInt(7.W)))
  val out = IO(Output(Opcode()))
  out := Opcode(in)
}
```

--------------------------------

### Chisel Connection Operator <> with Directioned Elements

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/connection-operators.md

This Chisel example demonstrates that the `<>` operator successfully connects hardware elements as long as at least one of the connected elements has a defined direction (e.g., an `IO` or a submodule's `IO`). The operator can infer the correct flow from the directioned element, facilitating connections through intermediate wires.

```scala
import chisel3._
import chisel3.util.DecoupledIO

class Wrapper extends Module{
  val io = IO(new Bundle {
  val in = Flipped(DecoupledIO(UInt(8.W)))
  val out = DecoupledIO(UInt(8.W))
  })
  val p = Module(new PipelineStage)
  val c = Module(new PipelineStage)
  //connect Producer to IO
    // For this experiment, we add a temporary wire and see if it works...
  //p.io.a <> io.in
  val tmp = Wire(DecoupledIO(UInt(8.W)))
  // connect intermediate wire
  tmp <> io.in
  p.io.a <> tmp
  // connect producer to consumer
  c.io.a <> p.io.b
  //connect consumer to IO
  io.out <> c.io.b
}
class PipelineStage extends Module{
  val io = IO(new Bundle{
    val a = Flipped(DecoupledIO(UInt(8.W)))
    val b = DecoupledIO(UInt(8.W))
  })
  io.b <> io.a
}
```

```scala
chisel3.docs.emitSystemVerilog(new Wrapper)
```

--------------------------------

### Test Chisel module using ChiselSim

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/appendix/migrating-from-chiseltest.md

This Scala code illustrates the updated method for testing `MyModule` using ChiselSim, the recommended replacement for ChiselTest. It shows the `simulate` method and similar `poke`, `step`, `expect` APIs, demonstrating the migration from ChiselTest to ChiselSim.

```Scala
import chisel3._
import chisel3.simulator.EphemeralSimulator._
import org.scalatest.flatspec.AnyFlatSpec

class MyModuleSpec extends AnyFlatSpec {
  behavior of "MyModule"
  it should "do something" in {
    simulate(new MyModule) { c =>
      c.io.in.poke(0.U)
      c.clock.step()
      c.io.out.expect(0.U)
      c.io.in.poke(42.U)
      c.clock.step()
      c.io.out.expect(42.U)
      println("Last output value : " + c.io.out.peek().litValue)
    }
  }
}
```

--------------------------------

### Attempting Direct Supertype View with Abstract Trait in Chisel

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/dataview.md

This example illustrates a common pitfall when attempting to use `viewAsSupertype` with an abstract `trait` directly. Since traits cannot be instantiated, passing `new Super` as a type template results in a compilation error, highlighting the need for a concrete instance.

```Scala
class MyModule extends Module {
  val foo = IO(Input(new Foo(8)))
  val bar = IO(Output(new Bar(8)))
  bar.viewAsSupertype(new Super) := foo.viewAsSupertype(new Super)
}
```

--------------------------------

### Instantiate and Reuse Chisel FIR Filter Modules

Source: https://github.com/chipsalliance/chisel/blob/main/README.md

Illustrates how to instantiate the generalized FirFilter module with different coefficient sets to create various filter types, demonstrating module reuse in Chisel.

```Scala
val movingSum3Filter = Module(new FirFilter(8, Seq(1.U, 1.U, 1.U)))  // same 3-point moving sum filter as before
val delayFilter = Module(new FirFilter(8, Seq(0.U, 1.U)))  // 1-cycle delay as a FIR filter
val triangleFilter = Module(new FirFilter(8, Seq(1.U, 2.U, 3.U, 2.U, 1.U)))  // 5-point FIR filter with a triangle impulse response
```

--------------------------------

### Chisel Reset Last-Connect Semantics Example

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/reset.md

Explains Chisel's last-connect semantics specifically for reset signals. It demonstrates that overriding a `DontCare` is permissible, but attempting to override a concrete reset type with a different concrete type (e.g., `Bool` with `AsyncReset`) will result in a FIRRTL error.

```Scala
class MyModule extends Module {
  val resetBool = Wire(Reset())
  resetBool := DontCare
  resetBool := false.B // this is fine
  withReset(resetBool) {
    val mySubmodule = Module(new Submodule())
  }
  resetBool := true.B // this is fine
  resetBool := false.B.asAsyncReset // this will error in FIRRTL
}
```

--------------------------------

### Chisel Coercion Connection (`:#=`) for Mixed-Directional Bundles

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/connectable.md

Illustrates another application of the `:#=` operator for connecting a mixed-directional bundle to a fully-aligned monitor. It shows initializing a wire with `DontCare` and then coercing its connection to an output monitor, ensuring all members are driven. The example includes the Scala code and the command to generate its Verilog output.

```Scala
import chisel3.experimental.BundleLiterals._
class Example4b extends RawModule {
  val monitor = IO(Output(new MixedAlignmentBundle))
  val w = Wire(new MixedAlignmentBundle)
  dontTouch(w) // So we see it in the output Verilog
  w :#= DontCare
  monitor :#= w
}
```

```Scala
chisel3.docs.emitSystemVerilog(new Example4b)
```

--------------------------------

### Example Chisel Module Using Identity Annotator

Source: https://github.com/chipsalliance/chisel/wiki/Annotations-Extending-Chisel-and-Firrtl

Demonstrates how to integrate and use the `IdentityAnnotator` trait within a Chisel `Module` definition. The `ModC` module mixes in `IdentityAnnotator` and uses its `identify` method to attach annotations to both the module instance itself and one of its I/O ports, showcasing how to pass dynamic parameters to annotations.

```Scala
class ModC(widthC: Int) extends Module with IdentityAnnotator {
  val io = IO(new Bundle {
    val in = Input(UInt(widthC.W))
    val out = Output(UInt(widthC.W))
  })
  io.out := io.in

  identify(this, s"ModC($widthC)")

  identify(io.out, s"ModC(ignore param)")
}
```

--------------------------------

### Enable Chisel Layers for Probe Access

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/layers.md

This Scala example demonstrates how to use the `chisel3.layer.enable` API to grant access to layer-colored probes from instantiated modules. By enabling specific layers (e.g., A and B), the design can read and combine values from probes associated with those layers, facilitating advanced verification scenarios.

```scala
import chisel3.layer.enable
import chisel3.probe.read

class Bar extends RawModule {

  enable(A)
  enable(B)

  val foo = Module(new Foo)

  val c = read(foo.a) ^ read(foo.b)

}
```

--------------------------------

### Declare FixedPoint I/O Ports and Registers in Chisel

Source: https://github.com/chipsalliance/chisel/wiki/FixedPoint

This Chisel code demonstrates how to declare FixedPoint I/O ports with specified total width and binary point (mantissa) width. It also shows how to declare a FixedPoint register where its width and binary point are inferred, and how to assign a FixedPoint constant value to it conditionally.

```Chisel
val io = IO(new Bundle {
  val fixedInput = FixedPoint(32.W, 16.BP)  // create a io port FixedPoint number with 32 
                                             // total bits 16 bits of which are mantissa
  val fixedOutput = FixedPoint(24.W, 8.BP)  // create a io port FixedPoint number with 24 
                                             // total bits 16 bits of which are mantissa
}

val fixedReg1 = FixedPoint(Width(), BP())  // create a register whose width and binary point will be inferred 

when(cond) {
  fixedReg1 = 6.77.F                     // set register to a FixedPoint constant
}
```

--------------------------------

### Create DataView for Bundles with Optional Fields in Chisel

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/dataview.md

This example demonstrates how to construct a DataView for Bundles that contain optional fields. Instead of the default DataView apply method, DataView.mapping is used, allowing for conditional inclusion of field mappings based on the presence of optional fields. This ensures flexibility in handling varying Bundle structures.

```Scala
import chisel3._
import chisel3.experimental.dataview._

class Foo(val w: Option[Int]) extends Bundle {
  val foo = UInt(8.W)
  val opt = w.map(x => UInt(x.W))
}
class Bar(val w: Option[Int]) extends Bundle {
  val bar = UInt(8.W)
  val opt = w.map(x => UInt(x.W))
}

object Foo {
  implicit val view: DataView[Foo, Bar] =
    DataView.mapping(
      // First argument is always the function to make the view from the target
      f => new Bar(f.w),
      // Now instead of a varargs of tuples of individual mappings, we have a single function that
      // takes a target and a view and returns an Iterable of tuple
      (f, b) =>  List(f.foo -> b.bar) ++ f.opt.map(_ -> b.opt.get)
                                   // ^ Note that we can append options since they are Iterable!

    )
}
```

--------------------------------

### Chisel LowerCamelCase Naming Convention for Variables

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/developers/style.md

Demonstrates the recommended lowerCamelCase naming convention for variables in Chisel to avoid conflicts with the compiler's underscore insertion. By using lowerCamelCase, the resulting Verilog accurately reflects the intended structure of the Chisel design, preventing ambiguity.

```Scala
val msg = Wire(new Bundle {
  val valid = Bool()
  val addr = UInt(32)
  val data = UInt(64)
})
val msgRec = Wire(Bool())
```

```Verilog
wire  msg_valid;
wire [31:0] msg_addr;
wire [63:0] msg_data;
wire  msgRec;
```

--------------------------------

### Assigning DontCare to Undirectioned Wires in Chisel

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/connection-operators.md

This Chisel example demonstrates that the `:=` operator must be used when assigning `DontCare` to an undirectioned `Wire`. Using the `<>` operator for this purpose would result in an error, as `:=` correctly handles the assignment without inferring directionality for the wire.

```scala
import chisel3._
import chisel3.util.DecoupledIO

class Wrapper extends Module{
  val io = IO(new Bundle {
  val in = Flipped(DecoupledIO(UInt(8.W)))
  val out = DecoupledIO(UInt(8.W))
  })
  val p = Module(new PipelineStage)
  val c = Module(new PipelineStage)
  //connect Producer to IO
  io.in := DontCare
  p.io.a <> DontCare
  val tmp = Wire(Flipped(DecoupledIO(UInt(8.W))))
  tmp := DontCare
  p.io.a <> io.in
  // connect producer to consumer
  c.io.a <> p.io.b
  //connect consumer to IO
  io.out <> c.io.b
}
class PipelineStage extends Module{
  val io = IO(new Bundle{
    val a = Flipped(DecoupledIO(UInt(8.W)))
    val b = DecoupledIO(UInt(8.W))
  })
  io.b <> io.a
}
```

```scala
chisel3.docs.emitSystemVerilog(new Wrapper)
```

--------------------------------

### Create a Chisel MixedVec with Fixed Types

Source: https://github.com/chipsalliance/chisel/wiki/Bundles-and-Vecs

Introduces `MixedVec` (Chisel 3.2+) as a way to create vectors where elements can have different types, unlike a regular `Vec`. This example shows a `MixedVec` defined with two distinct `UInt` types.

```Scala
class MyModule extends Module {
  val io = IO(new Bundle {
    val x = Input(UInt(3.W))
    val y = Input(UInt(10.W))
    val vec = Output(MixedVec(UInt(3.W), UInt(10.W)))
  })
  io.vec(0) := io.x
  io.vec(1) := io.y
}
```

--------------------------------

### Chisel Mux4 Implementation Using Functional Mux2 Interface

Source: https://github.com/chipsalliance/chisel/wiki/Functional-Module-Creation

This Chisel code demonstrates a more concise implementation of the `Mux4` module by leveraging the functional `apply` method defined for `Mux2`. Instead of explicit instantiation and wiring, `Mux2` is called directly as a function, making the hardware connection description resemble a software expression evaluation. This improves readability and simplifies complex module composition.

```scala
class Mux4 extends Module {
  val io = IO(new Bundle {
    val in0 = Input(UInt(1.W))
    val in1 = Input(UInt(1.W))
    val in2 = Input(UInt(1.W))
    val in3 = Input(UInt(1.W))
    val sel = Input(UInt(2.W))
    val out = Output(UInt(1.W))
  })
  io.out := Mux2(io.sel(1),
                 Mux2(io.sel(0), io.in0, io.in1),
                 Mux2(io.sel(0), io.in2, io.in3))
}
```

--------------------------------

### Chisel: Emitting SystemVerilog for `FooToBar` Module

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/dataview.md

This command instructs Chisel to emit the SystemVerilog hardware description for the `FooToBar` module. This shows how the Chisel code, including the `DataView` transformation, is synthesized into hardware.

```Chisel
chisel3.docs.emitSystemVerilog(new FooToBar)
```

--------------------------------

### Define Chisel Instance Choice Option Group (Scala)

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/instchoice.md

This snippet demonstrates how to define an option group using `chisel3.choice.Group` and `chisel3.choice.Case` in Chisel. This group, `Platform`, enumerates possible specialization targets like FPGA and ASIC, allowing for configurable design variants.

```scala
import chisel3.choice.{Case, Group}

object Platform extends Group {
  object FPGA extends Case
  object ASIC extends Case
}
```

--------------------------------

### Defining a Module with Multiple Clock Domains using withClockAndReset

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/multi-clock.md

This Chisel example demonstrates how to define a module that incorporates synchronous elements operating on different clock domains. The `withClockAndReset` scope explicitly assigns a custom clock (`io.clockB`) and reset (`io.resetB`) to the registers defined within it, while other registers use the module's default clock.

```scala
import chisel3._

class MultiClockModule extends Module {
  val io = IO(new Bundle {
    val clockB = Input(Clock())
    val resetB = Input(Bool())
    val stuff = Input(Bool())
  })

  // This register is clocked against the module clock.
  val regClock = RegNext(io.stuff)

  withClockAndReset (io.clockB, io.resetB) {
    // In this withClock scope, all synchronous elements are clocked against io.clockB.
    // Reset for flops in this domain is using the explicitly provided reset io.resetB.

    // This register is clocked against io.clockB.
    val regClockB = RegNext(io.stuff)
  }

  // This register is also clocked against the module clock.
  val regClock2 = RegNext(io.stuff)
}
```

--------------------------------

### Generate FIRRTL from Chisel using sbt console

Source: https://github.com/chipsalliance/chisel/wiki/Frequently-Asked-Questions

Demonstrates how to directly invoke the Chisel FIRRTL driver from within the sbt console. This allows for interactive elaboration and dumping of a Chisel module's FIRRTL output to a specified file.

```Shell
$ sbt
> console
[info] Starting scala interpreter...
[info] 
Welcome to Scala 2.11.11 (OpenJDK 64-Bit Server VM, Java 1.8.0_151).
Type in expressions for evaluation. Or try :help.
scala> chisel3.Driver.dumpFirrtl(chisel3.Driver.elaborate(() => new HelloWorld), Option(new java.io.File("output.fir")))
chisel3.Driver.dumpFirrtl(chisel3.Driver.elaborate(() => new HelloWorld), Option(new java.io.File("output.fir")))
[info] [0.000] Elaborating design...
[info] [0.001] Done elaborating.
res3: java.io.File = output.fir
```

--------------------------------

### Chisel: Defining Custom DecodePattern and DecodeField for DecoderTable

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/decoder.md

This snippet illustrates how to define custom `DecodePattern` and `DecodeField` traits for structured decoding with `DecoderTable`. `DecodePattern` specifies the input `BitPat`, while `DecodeField` defines how output fields are generated from the pattern. An example `Pattern` case class and a boolean `NameContainsAdd` field are provided.

```Scala
import chisel3.util.BitPat
import chisel3.util.experimental.decode._

case class Pattern(val name: String, val code: BigInt) extends DecodePattern {
  def bitPat: BitPat = BitPat("b" + code.toString(2))
}

object NameContainsAdd extends BoolDecodeField[Pattern] {
  def name = "name contains 'add'"
  def genTable(i: Pattern) = if (i.name.contains("add")) y else n
}
```

--------------------------------

### Scala: Match Statement for Ad-hoc Combinations (Tuples)

Source: https://github.com/chipsalliance/chisel/wiki/Scala-Things-You-Should-Know

This example illustrates how to use a "match" statement with tuples to test ad-hoc combinations of values. The "animalType" function takes two booleans, forms a tuple, and matches it against all possible true/false combinations to return a specific animal string, effectively implementing a truth table.

```Scala
def animalType(biggerThanBreadBox: Boolean, meanAsCanBe: Boolean): String = {
  (biggerThanBreadBox, meanAsCanBe) match {
    case (true, true) => "wolverine"
    case (true, false) => "elephant"
    case (false, true) => "shrew"
    case (false, false) => "puppy"
  }
}
```

--------------------------------

### Chisel Example: Custom `cloneType` for Parametrized Bundle

Source: https://github.com/chipsalliance/chisel/wiki/Bundles-and-Vecs

Demonstrates the implementation of a custom `cloneType` method for a parametrized `Bundle` (`ExampleBundle`) in Chisel, along with its usage within a `Module` (`ExampleBundleModule`) and a top-level module (`Top`). This is typically required when Chisel cannot automatically infer the cloning mechanism for complex parametrized bundles.

```scala
class ExampleBundle(a: Int, b: Int) extends Bundle {
    val foo = UInt(a.W)
    val bar = UInt(b.W)
    override def cloneType = (new ExampleBundle(a, b)).asInstanceOf[this.type]
}

class ExampleBundleModule(btype: ExampleBundle) extends Module {
    val io = IO(new Bundle {
        val out = Output(UInt(32.W))
        val b = Input(chiselTypeOf(btype))
    })
    io.out := io.b.foo + io.b.bar
}

class Top extends Module {
    val io = IO(new Bundle {
        val out = Output(UInt(32.W))
        val in = Input(UInt(17.W))
    })
    val x = Wire(new ExampleBundle(31, 17))
    x := DontCare
    val m = Module(new ExampleBundleModule(x))
    m.io.b.foo := io.in
    m.io.b.bar := io.in
    io.out := m.io.out
}
```

--------------------------------

### Define Layer-Colored Probes and Wires in Chisel

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/layers.md

This Scala example demonstrates how to define and drive layer-colored probes and wires using `chisel3.layer` and `chisel3.probe`. It shows the creation of `Layer` objects, `Probe` types for IO and internal wires, and the use of `layer.block` and `define` to conditionally assign probe values based on layer enablement.

```scala
import chisel3._
import chisel3.layer.{Layer, LayerConfig}
import chisel3.probe.{Probe, ProbeValue, define}

object A extends Layer(LayerConfig.Extract())
object B extends Layer(LayerConfig.Extract())

class Foo extends RawModule {
  val a = IO(Output(Probe(Bool(), A)))
  val b = IO(Output(Probe(Bool(), B)))

  layer.block(A) {
    val a_wire = WireInit(false.B)
    define(a, ProbeValue(a_wire))
  }

  val b_wire_probe = Wire(Probe(Bool(), B))
  define(b, b_wire_probe)

  layer.block(B) {
    val b_wire = WireInit(false.B)
    define(b_wire_probe, ProbeValue(b_wire))
  }

}
```

--------------------------------

### Chisel 3 Core Library Import

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/appendix/upgrading-from-chisel-3-4.md

Imports the core Chisel3 library, providing fundamental classes and functions for hardware description in Scala.

```scala
import chisel3._
```

--------------------------------

### Flexible Chisel Connection with .unsafe Operator

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/connectable.md

This example demonstrates the highly flexible .unsafe operator in Chisel, used with :<>= for connections that will never error. It connects fields with matching names (e.g., bar) between bundles, while ignoring non-matching fields (e.g., foo, baz), providing maximum leniency.

```Scala
class ExampleUnsafe extends RawModule {
  val in  = IO(Flipped(new Bundle { val foo = Bool(); val bar = Bool() }))
  val out = IO(new Bundle { val baz = Bool(); val bar = Bool() })
  out.unsafe :<>= in.unsafe // bar is connected, and nothing errors
}
```

--------------------------------

### Chisel Stage Configuration for SystemVerilog Generation

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/probes.md

This Scala snippet demonstrates how to configure the `circt.stage.ChiselStage` to emit SystemVerilog from a Chisel design. It specifies `firtoolOpts` such as stripping debug information, disabling randomization, and enabling verification layers, which are crucial for generating clean and verifiable SystemVerilog output from Chisel projects.

```scala
circt.stage.ChiselStage.emitSystemVerilog(
  new Foo,
  Array("--throw-on-first-error"),
  firtoolOpts = Array(
    "-strip-debug-info",
    "-disable-all-randomization",
    "-enable-layers=Verification",
    "-enable-layers=Verification.Assert",
    "-enable-layers=Verification.Assume",
    "-enable-layers=Verification.Cover"
  )
)
```

--------------------------------

### Chisel3 CompileOptions Trait Definition

Source: https://github.com/chipsalliance/chisel/wiki/Chisel3-vs-Chisel2

This API documentation defines the `CompileOptions` trait in Chisel3, which specifies various boolean flags controlling front-end validation checks. These options determine how strict the Chisel3 compiler is regarding connections, type usage, IO wrapping, and other design rules.

```APIDOC
trait CompileOptions {
  // Should Bundle connections require a strict match of fields.
  // If true and the same fields aren't present in both source and sink, a MissingFieldException,
  // MissingLeftFieldException, or MissingRightFieldException will be thrown.
  val connectFieldsMustMatch: Boolean
  // When creating an object that takes a type argument, the argument must be unbound (a pure type).
  val declaredTypeMustBeUnbound: Boolean
  // Module IOs should be wrapped in an IO() to define their bindings before the reset of the module is defined.
  val requireIOWrap: Boolean
  // If a connection operator fails, don't try the connection with the operands (source and sink) reversed.
  val dontTryConnectionsSwapped: Boolean
  // If connection directionality is not explicit, do not use heuristics to attempt to determine it.
  val dontAssumeDirectionality: Boolean
  // Issue a deprecation warning if Data.{flip, asInput,asOutput} is used
  // instead of Flipped, Input, or Output.
  val deprecateOldDirectionMethods: Boolean
  // Check that referenced Data have actually been declared.
  val checkSynthesizable: Boolean
}
```

--------------------------------

### ChiselSim Peek/Poke and Control APIs Reference

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/testing.md

ChiselSim extends Chisel types like `Data` with methods for direct stimulus and observation. These include `poke` to set values, `peek` to read, `expect` to assert, `step` to advance the clock, and `stepUntil` to advance until a condition is met. These APIs are part of `chisel3.simulator.PeekPokeAPI`.

```APIDOC
Data.poke(value: BigInt): Unit
  - Purpose: Sets the value of a Chisel port or signal.
  - Parameter: value - The BigInt value to set.

Data.peek(): BigInt
  - Purpose: Reads the current value of a Chisel port or signal.
  - Returns: The current value as a BigInt.

Data.expect(expectedValue: BigInt): Unit
  - Purpose: Reads the current value of a Chisel port or signal and asserts it matches an expected value.
  - Parameter: expectedValue - The BigInt value to compare against.

Clock.step(cycles: Int = 1): Unit
  - Purpose: Advances the simulation clock by a specified number of cycles.
  - Parameter: cycles - The number of clock cycles to advance (default is 1).

Clock.stepUntil(condition: => Boolean): Unit
  - Purpose: Advances the simulation clock until a specified condition becomes true.
  - Parameter: condition - A boolean expression that, when true, stops the clock advancement.
```

--------------------------------

### Use Underscores for Readability in Chisel String Literals

Source: https://github.com/chipsalliance/chisel/wiki/Datatypes-in-Chisel

This example illustrates the use of underscores within hexadecimal string literals for improved readability. Chisel ignores these underscores when parsing the string to create the UInt value. This feature helps in representing long bit patterns more clearly.

```Scala
"h_dead_beef".U   // 32-bit lit of type UInt
```

--------------------------------

### Chisel: Make Case Classes with Many Fields Accessible

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/hierarchy.md

This example demonstrates how to define an implicit `Lookupable` for Chisel case classes that have more than five fields. Since `Lookupable` provides factories up to `product5`, nested tuples are used as 'pseudo-fields' to map the class's members, allowing for proper accessibility.

```scala
case class LotsOfFields(a: Data, b: Data, c: Data, d: Data, e: Data, f: Data)
object LotsOfFields {
  implicit val lookupable: Lookupable.Simple[LotsOfFields] =
    Lookupable.product5[LotsOfFields, Data, Data, Data, Data, (Data, Data)](
      x => (x.a, x.b, x.c, x.d, (x.e, x.f)),
      // Cannot use factory method directly this time since we have to unpack the tuple.
      { case (a, b, c, d, (e, f)) => LotsOfFields(a, b, c, d, e, f) },
    )
}
```

--------------------------------

### Define a Chisel Bundle

Source: https://github.com/chipsalliance/chisel/wiki/Bundles-and-Vecs

Defines a custom `Bundle` class in Chisel, similar to a C struct, allowing the grouping of several named fields of potentially different types into a coherent unit. This example creates a `MyFloat` bundle with sign, exponent, and significand fields.

```Scala
class MyFloat extends Bundle {
  val sign        = Bool()
  val exponent    = UInt(8.W)
  val significand = UInt(23.W)
}

val x  = Wire(new MyFloat)
val xs = x.sign
```

--------------------------------

### Create a Bundle literal with full specification in Chisel

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/appendix/experimental-features.md

Demonstrates how to create a fully specified Bundle literal using `BundleLiterals` in Chisel. It defines a `MyBundle` with `UInt` and `Bool` fields and initializes an instance with specific values for all fields.

```scala
import chisel3._
import chisel3.experimental.BundleLiterals._

class MyBundle extends Bundle {
  val a = UInt(8.W)
  val b = Bool()
}

class Example extends RawModule {
  val out = IO(Output(new MyBundle))
  out := (new MyBundle).Lit(_.a -> 8.U, _.b -> true.B)
}
```

```verilog
// Verilog output for the above Chisel code (generated by mdoc:verilog)
// Actual Verilog content not provided in source text.
```

--------------------------------

### Chisel Aligned Connection Operator (:<=) Example

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/connectable.md

This Scala code illustrates the :<= operator, which performs an 'aligned connection'. It connects only the aligned members from the producer (incoming) to the consumer (outgoing), while ignoring any flipped members. A DontCare assignment is included to prevent uninitialization errors for incoming.flippedChild.

```Scala
class Example2 extends RawModule {
  val incoming = IO(Flipped(new MixedAlignmentBundle))
  val outgoing = IO(new MixedAlignmentBundle)
  incoming.flippedChild := DontCare // Otherwise FIRRTL throws an uninitialization error
  outgoing :<= incoming
}
```

--------------------------------

### Chisel MuxLookup (n-way indexed multiplexer)

Source: https://github.com/chipsalliance/chisel/wiki/Muxes-and-Input-Selection

`MuxLookup` is an n-way indexed multiplexer, similar to `MuxCase` but with conditions based on an index. It takes an index, a default value, and an array of index-value pairs. The second code example shows its equivalent implementation using `MuxCase`.

```scala
MuxLookup(idx, default, 
          Array(0.U -> a, 1.U -> b, ...))
```

```scala
MuxCase(default, 
        Array((idx === 0.U) -> a,
              (idx === 1.U) -> b, ...))
```

--------------------------------

### Chisel Layer Block Return Value Shorthand

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/layers.md

This Scala example illustrates a shorthand for defining layer-colored wires by allowing a `layer.block` to return a `Data` subtype. This simplifies the pattern of driving a layer-colored probe wire from within a layer block, effectively creating a wire before the block and assigning its value.

```scala
class Bar extends RawModule {
  val b = IO(Output(Probe(Bool(), B)))

  val b_wire_probe = layer.block(B) {
    val b_wire = WireInit(false.B)
    define(b_wire_probe, ProbeValue(b_wire))
  }

  define(b, b_wire_probe)
}
```

--------------------------------

### Display VCD Submenu Help in Repl

Source: https://github.com/chipsalliance/chisel/wiki/Debugging-with-the-Interpreter-REPL-3

This Repl command displays the available subcommands for the `vcd` command, providing a comprehensive list of options for running, listing, and managing VCD events within the interpreter.

```Repl
vcd help
```

--------------------------------

### Chisel BiConnect Error with Mismatched Bundle Fields

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/interfaces-and-connections.md

This Scala example illustrates a common error when using Chisel's `BiConnect` (`<>`) operator: attempting to connect `Bundle`s with non-matching named signals. The `NotReallyAFilterIO` `Bundle` introduces an extra field (`z`), causing Chisel to throw an error during the bulk connection with `FilterIO`.

```Scala
class NotReallyAFilterIO extends Bundle {
  val x = Flipped(new PLink)
  val y = new PLink
  val z = Output(new Bool())
}
class Block2 extends Module {
  val io1 = IO(new FilterIO)
  val io2 = IO(Flipped(new NotReallyAFilterIO))

  io1 <> io2
}
```

--------------------------------

### Scala While Loop

Source: https://github.com/chipsalliance/chisel/wiki/CS250-Chisel+Scala-Primer

Shows the syntax for a while loop in Scala, which functions identically to its Java counterpart.

```Scala
while(n < len) {
  //do something
}
```

--------------------------------

### Connect Chisel Sub-types to Super-types by Waiving Members

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/connectable.md

This example demonstrates connecting a Chisel sub-type (MyDecoupled) to a super-type (MyReadyValid) using the :<>= operator and .waiveAs. It shows how to ignore specific members (like bits) during the connection, ensuring only common fields (ready, valid) are connected in the generated Verilog.

```Scala
class MyReadyValid extends Bundle {
  val valid = Bool()
  val ready = Flipped(Bool())
}
class MyDecoupled extends MyReadyValid {
  val bits = UInt(32.W)
}
class Example5 extends RawModule {
  val in  = IO(Flipped(new MyDecoupled))
  val out = IO(new MyReadyValid)
  out :<>= in.waiveAs[MyReadyValid](_.bits)
}
```

```Scala
chisel3.docs.emitSystemVerilog(new Example5)
```

--------------------------------

### Useful SBT Commands for FIRRTL Development

Source: https://github.com/chipsalliance/chisel/blob/main/firrtl/README.md

Common SBT commands for developers working with FIRRTL, including running a single test suite, continuously executing a command, and invoking multiple commands within a single SBT session.

```sbt
sbt "testOnly firrtlTests.UnitTests"
sbt ~compile
sbt
> compile
> test
```

--------------------------------

### Instantiating Chisel `Bundle` with By-Name Parameter

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/cookbook.md

Demonstrates the instantiation of `UsingByNameParameters`, highlighting that the argument `UInt(8.W)` is passed directly without a lambda. The by-name parameter implicitly handles the delayed evaluation, creating fresh `Data` instances.

```scala
chisel3.docs.emitSystemVerilog(new Top(new UsingByNameParameters(UInt(8.W))))
```

--------------------------------

### Demonstrate Chisel Type, Hardware, and Literal Instantiation

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/chisel-type-vs-scala-type.md

Illustrates the fundamental differences between pure Chisel types, hardware-bound types (like `Reg` and `IO`), and literal instantiations of a `MyBundle`. It shows how objects with the same Scala type can have distinct Chisel properties and binding behaviors, requiring explicit initialization for hardware values.

```Scala
import chisel3.experimental.BundleLiterals._

class MyModule(gen: () => MyBundle) extends Module {
                                                            //   Hardware   Literal
    val xType:    MyBundle     = new MyBundle(3)            //      -          -
    val dirXType: MyBundle     = Input(new MyBundle(3))     //      -          -
    val xReg:     MyBundle     = Reg(new MyBundle(3))       //      x          -
    val xIO:      MyBundle     = IO(Input(new MyBundle(3))) //      x          -
    val xRegInit: MyBundle     = RegInit(xIO)               //      x          -
    val xLit:     MyBundle     = xType.Lit(                 //      x          x
      _.foo -> 0.U(3.W),
      _.bar -> 0.U(3.W)
    )
    val y:        MyBundle = gen()                          //      ?          ?

    // Need to initialize all hardware values
    xReg := DontCare
}
```

--------------------------------

### Implement an Inner Product FIR Filter Generically in Chisel

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/polymorphism-and-parameterization.md

This example demonstrates how to define an inner product FIR digital filter generically over Chisel `Num` types. It includes two functions: `delays` to create a list of incrementally delayed inputs, and `FIR` which uses `delays` and `reduce` to construct the summation circuit for the filter. The `FIR` function is constrained to work on types where Chisel multiplication and addition are defined.

```scala
def delays[T <: Data](x: T, n: Int): List[T] =
  if (n <= 1) List(x) else x :: delays(RegNext(x), n - 1)

def FIR[T <: Data with Num[T]](ws: Seq[T], x: T): T =
  ws zip delays(x, ws.length) map { case (a, b) => a * b } reduce (_ + _)
```

--------------------------------

### Standard Chisel Driver Companion Object Definition

Source: https://github.com/chipsalliance/chisel/wiki/Running-Stuff

This Scala code illustrates the typical structure of a Driver companion object in Chisel. It defines two overloaded execute methods: one for command-line arguments (args) and another for an optionsManager, facilitating flexible invocation and data passing within the Chisel toolchain.

```scala
object Driver {
  def execute(optionsManager: ..., ): ExecutionResult {
    ???  
  }
  def execute(args: Array[String]: ..., ): ExecutionResult {
    ???  
  }
}
```

--------------------------------

### Chisel Mux4 Module using Explicit Mux2 Instances

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/functional-module-creation.md

Illustrates a traditional implementation of a `Mux4` module in Chisel. It explicitly instantiates and connects multiple `Mux2` modules (`m0`, `m1`, `m3`) to build the 4-to-1 multiplexer logic, demonstrating a verbose connection style.

```Scala
class Mux4 extends Module {
  val io = IO(new Bundle {
    val in0 = Input(UInt(1.W))
    val in1 = Input(UInt(1.W))
    val in2 = Input(UInt(1.W))
    val in3 = Input(UInt(1.W))
    val sel = Input(UInt(2.W))
    val out = Output(UInt(1.W))
  })
  val m0 = Module(new Mux2)
  m0.io.sel := io.sel(0)
  m0.io.in0 := io.in0
  m0.io.in1 := io.in1

  val m1 = Module(new Mux2)
  m1.io.sel := io.sel(0)
  m1.io.in0 := io.in2
  m1.io.in1 := io.in3

  val m3 = Module(new Mux2)
  m3.io.sel := io.sel(1)
  m3.io.in0 := m0.io.out
  m3.io.in1 := m1.io.out

  io.out := m3.io.out
}
```

--------------------------------

### Chisel Type Mismatch Debugging for UInt Operations

Source: https://github.com/chipsalliance/chisel/wiki/CS250-Chisel+Scala-Primer

This example demonstrates a common type mismatch error in Chisel when performing arithmetic operations with `UInt` types and Scala `Int` literals. The first code block shows the problematic code that results in a compile-time error, specifically requiring `chisel3.core.UInt` but finding `Int`. The second code block provides the corrected solution by explicitly converting the integer literal to a `UInt` using the `.U` suffix.

```Scala
  when(io.en) {
    index := 0.U
  }
  .otherwise {
    index := index + 1
  }
```

```Scala
  when(io.en) {
    index := 0.U
  }
  .otherwise {
    index := index + 1.U
  }
```

--------------------------------

### Build Scaladoc Locally with sbt

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/developers/scaladoc.md

This sbt command builds the Scaladoc documentation for the Chisel project. The generated documentation can then be viewed locally in a web browser by opening 'unidoc/index.html' located in the 'unipublish/target/scala-2.13/unidoc' directory.

```sbt
sbt:chisel> unipublish / doc
```

--------------------------------

### Recommended `firtool` Options for SystemVerilog Output

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/testing.md

These `firtool` options are recommended when emitting SystemVerilog from Chisel to make the output more amenable for FileCheck testing. They control line length to prevent wrapping and disable automatic logic temporaries that might cause unexpected structure.

```APIDOC
firtool Options for emitSystemVerilog:
  -loweringOptions=emittedLineLength=160
  -loweringOptions=disallowLocalVariables
```

--------------------------------

### Chisel BlackBox Definition for Real Number Addition

Source: https://github.com/chipsalliance/chisel/wiki/BlackBoxes

Defines a Chisel `BlackBox` named `BlackBoxRealAdd` that takes two 64-bit unsigned integers as input and outputs a 64-bit unsigned integer. This black box serves as an interface for an external module intended to perform real number addition, with its actual implementation provided in Verilog.

```Scala
class BlackBoxRealAdd extends BlackBox {
  val io = IO(new Bundle() {
    val in1 = Input(UInt(64.W))
    val in2 = Input(UInt(64.W))
    val out = Output(UInt(64.W))
  })
}
```

--------------------------------

### Flip Chisel Bundles for Bidirectional Interfaces

Source: https://github.com/chipsalliance/chisel/wiki/Bundles-and-Vecs

Explains the `Flipped()` function in Chisel, which recursively reverses the direction of all elements within a `Bundle` or `Record`. This is particularly useful for creating bidirectional interfaces. The example demonstrates a normal bundle instantiation and a flipped one, along with the resulting Verilog.

```Scala
import chisel3.experimental.RawModule
class MyBundle extends Bundle {
  val a = Input(Bool())
  val b = Output(Bool())
}
class MyModule extends RawModule {
  // Normal instantiation of the bundle
  // 'a' is an Input and 'b' is an Output
  val normalBundle = IO(new MyBundle)
  normalBundle.b := normalBundle.a

  // Flipped recursively flips the direction of all Bundle fields
  // Now 'a' is an Output and 'b' is an Input
  val flippedBundle = IO(Flipped(new MyBundle))
  flippedBundle.a := flippedBundle.b
}
```

```Verilog
module MyModule( // @[:@3.2]
  input   normalBundle_a, // @[:@4.4]
  output  normalBundle_b, // @[:@4.4]
  output  flippedBundle_a, // @[:@5.4]
  input   flippedBundle_b // @[:@5.4]
);
  assign normalBundle_b = normalBundle_a;
  assign flippedBundle_a = flippedBundle_b;
endmodule
```

--------------------------------

### Chisel Snake_Case Naming Issue and Verilog Output

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/developers/style.md

Illustrates how using snake_case for variable names in Chisel can lead to ambiguous Verilog output. The Chisel compiler inserts underscores when splitting aggregate types into Verilog, which can conflict with user-defined snake_case names, making it appear as if a bundle has more fields than intended.

```Scala
val msg = Wire(new Bundle {
  val valid = Bool()
  val addr = UInt(32)
  val data = UInt(64)
})
val msg_rec = Wire(Bool())
```

```Verilog
wire  msg_valid;
wire [31:0] msg_addr;
wire [63:0] msg_data;
wire  msg_rec;
```

--------------------------------

### Generated Verilog Output from Chisel Module

Source: https://github.com/chipsalliance/chisel/blob/main/docs/README.md

Presents the original Chisel Scala code for `MyModule` alongside its automatically generated Verilog equivalent. This illustrates the transformation from high-level Chisel design to low-level hardware description, as rendered by the `mdoc` documentation system.

```scala
class MyModule extends RawModule {
  val in = IO(Input(UInt(8.W)))
  val out = IO(Output(UInt(8.W)))
  out := in + 1.U
}
```

```verilog
module MyModule(
  input  [7:0] in,
  output [7:0] out
);
  assign out = in + 8'h1; // @[main.scala 9:13]
endmodule
```

--------------------------------

### Customizing Chisel Bundle Type Names with `override def typeName`

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/naming.md

This snippet demonstrates how to manually override the `typeName` method for a user-defined Chisel `Bundle`. It shows how to construct a descriptive type name by combining the bundle's parameters and the type name of its generic data type, following a suggested naming pattern for clarity. A usage example with a `Queue` is also provided.

```Scala
class MyBundle[T <: Data](gen: T, intParam: Int) extends Bundle {
  // Generate a stable typeName for this Bundle. Two 'words' are present
  // in this implementation: the bundle's name plus its integer parameter
  // (something like 'MyBundle9')
  // and the generator's typeName, which itself can be composed of 'words'
  // (something like 'Vec3_UInt4')
  override def typeName = s"MyBundle${intParam}_${gen.typeName}"

  // ...
}
```

```Scala
val fooQueue = Module(new Queue(new MyBundle(UInt(4.W), 3), 16)) // Queue16_MyBundle3_UInt4
```

--------------------------------

### Chisel Repl: Poke Inputs and Show State

Source: https://github.com/chipsalliance/chisel/wiki/Debugging-with-the-Interpreter-REPL-2

Shows a sequence of commands in the Chisel Repl to manually set input values (`poke`) and then inspect the current state of the design (`show`), useful for isolating issues found in test logs.

```Chisel Repl
poke io_value1 13
poke io_value2 13
poke io_loadingValues 1
step 
show
```

--------------------------------

### Create Chisel Bundle with Vector of Interfaces

Source: https://github.com/chipsalliance/chisel/wiki/Interfaces-Bulk-Connections

Demonstrates how to define a Chisel Bundle (`CrossbarIo`) that includes vectors of other Bundles (`PLink`) using the `Vec` constructor. This is useful for creating interfaces for components like crossbars that handle multiple identical connections, simplifying the definition of repetitive I/O.

```scala
import chisel3.util.log2Ceil
class CrossbarIo(n: Int) extends Bundle {
  val in = Vec(n, Flipped(new PLink))
  val sel = Input(UInt(log2Ceil(n).W))
  val out = Vec(n, new PLink)
}
```

--------------------------------

### Chisel Example: Inferring `cloneType` with `private val` Type Parameters

Source: https://github.com/chipsalliance/chisel/wiki/Bundles-and-Vecs

Demonstrates how to enable automatic `cloneType` inference for a Chisel `Bundle` that uses a type parameter as a generator by declaring the generator as `private val`. This is a best practice for type parameters that act as 'generators' to avoid explicit `cloneType` definitions.

```scala
class RegisterWriteIO[T <: Data](private val gen: T) extends Bundle {
  val request  = Flipped(Decoupled(gen))
  val response = Irrevocable(Bool()) // ignore .bits
}
```

--------------------------------

### Handle Chisel Property Sequences

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/properties.md

Demonstrates the use of `Property[Seq[Int]]` for ports and values. It shows how to create a property from a sequence of literals and how to combine property ports with literals within a sequence.

```Scala
class SequenceExample extends RawModule {
  val inPort = IO(Input(Property[Int]()))
  val outPort1 = IO(Output(Property[Seq[Int]]()))
  val outPort2 = IO(Output(Property[Seq[Int]]()))
  // A Seq of literals can by turned into a Property
  outPort1 := Property(Seq(123, 456))
  // Property ports and literals can be mixed together into a Seq
  outPort2 := Property(Seq(inPort, Property(789)))
}
```

--------------------------------

### Aliasing Chisel Bundles in FIRRTL with `HasTypeAlias`

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/naming.md

This snippet explains how to use the `HasTypeAlias` trait in Chisel to generate type aliases for bundles in the emitted FIRRTL code. It includes an example of the resulting FIRRTL type alias definition and the Scala code to define and emit a bundle with an alias, preventing excessively long type names.

```FIRRTL
circuit Top :
  type MyBundle = { foo : UInt<8>, bar : UInt<1>}

  module Top :
    //...
```

```Scala
import chisel3._
import chisel3.experimental.{HasTypeAlias, RecordAlias}

class AliasedBundle extends Bundle with HasTypeAlias {
  override def aliasName = RecordAlias("MyAliasedBundle")
  val foo = UInt(8.W)
  val bar = Bool()
}
```

```Scala
import chisel3._
import circt.stage.ChiselStage.{emitCHIRRTL => emitFIRRTL}
emitFIRRTL(new Module {
  val wire = Wire(new AliasedBundle)
})
```

--------------------------------

### Explicit `cloneType` Override for Chisel Bundle (Pre-Chisel 3.5)

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/bundles-and-vecs.md

Demonstrates a Chisel `Bundle` (before version 3.5) that requires an explicit `cloneType` override. This is necessary when a 'generator' parameter, like `gen: T`, is not a `private val`, preventing automatic `cloneType` inference. The example defines a `Bundle` for register write I/O using `Decoupled` and `Irrevocable`.

```scala
import chisel3.util.{Decoupled, Irrevocable}
class RegisterWriteIOExplicitCloneType[T <: Data](gen: T) extends Bundle {
  val request  = Flipped(Decoupled(gen))
  val response = Irrevocable(Bool())
  override def cloneType = new RegisterWriteIOExplicitCloneType(gen).asInstanceOf[this.type]
}
```

--------------------------------

### Handling Invalid @public Annotation Usage in Chisel

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/hierarchy.md

This example demonstrates an incorrect usage of the `@public` annotation in Chisel, specifically when attempting to mark a field with a type that is not supported (i.e., does not implement `Lookupable` or is not a basic type). It illustrates the error message generated in such cases, helping users understand and avoid common pitfalls.

```Scala
import chisel3._
import chisel3.experimental.hierarchy.{instantiable, public}

object NotValidType

@instantiable
class MyModule extends Module {
  @public val x = NotValidType
}
```

--------------------------------

### Automatic `cloneType` Inference for Chisel Bundle (Chisel 3.5+)

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/bundles-and-vecs.md

Shows how to enable automatic `cloneType` inference for a Chisel `Bundle` in Chisel 3.5 and later. By declaring the 'generator' parameter `gen` as `private val`, the compiler plugin can correctly infer the `cloneType`, eliminating the need for manual overrides. This example defines a `Bundle` for register write I/O.

```scala
import chisel3.util.{Decoupled, Irrevocable}
class RegisterWriteIO[T <: Data](private val gen: T) extends Bundle {
  val request  = Flipped(Decoupled(gen))
  val response = Irrevocable(Bool())
}
```

--------------------------------

### svsim Backend and Compilation Settings API

Source: https://github.com/chipsalliance/chisel/blob/main/svsim/README.md

Describes the available simulation backends and their associated compilation settings. `svsim` supports `verilator.Backend` and `vcs.Backend`. Common settings for all backends are defined in `CommonCompilationSettings`, while `CompilationSettings` holds backend-specific configurations.

```APIDOC
Backend types:
  verilator.Backend
  vcs.Backend
CommonCompilationSettings: Defines global compilation settings (e.g., SystemVerilog preprocessor defines).
CompilationSettings: Defines backend-specific compilation settings.
```

--------------------------------

### Nesting User-Defined Layers under Built-in Layers in Chisel

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/layers.md

This Scala example demonstrates how to extend Chisel's built-in layers by nesting a user-defined layer, such as `Debug`, under an existing built-in layer like `Verification`. This is achieved by defining an implicit `val root` of type `Layer` to specify the parent layer for new user-defined layers.

```Scala
object UserDefined {
  // Define an implicit val `root` of type `Layer` to cause layers which can see
  // this to use `root` as their parent layer.  This allows us to nest the
  // user-defined `Debug` layer under the built-in `Verification` layer.
  implicit val root: Layer = chisel3.layers.Verification
  object Debug extends Layer(LayerConfig.Inline)
}
```

--------------------------------

### Correctly Connecting Bidirectional Bundle to Chisel Register using Output Coercion

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/cookbook.md

This Scala code demonstrates the correct method to connect a bidirectional `Decoupled` bundle to a Chisel `Reg`. By wrapping the register's type definition with `Output(...)`, all elements of the bundle are coerced to an output direction, allowing the register to correctly capture and store the bundle's signals without directionality conflicts. The invisible code block provides additional setup for verification.

```Scala
import chisel3._
import chisel3.util.Decoupled
class CoercedRegConnect extends Module {
  val io = IO(new Bundle {
    val enq = Flipped(Decoupled(UInt(8.W)))
  })

  // Make a Reg which contains all of the bundle's signals, regardless of their directionality
  val monitor = Reg(Output(chiselTypeOf(io.enq)))
  // Even though io.enq is bidirectional, := will drive all fields of monitor with the fields of io.enq
  monitor := io.enq
}
```

```Scala
chisel3.docs.emitSystemVerilog(new CoercedRegConnect {
  // Provide default connections that would just muddy the example
  io.enq.ready := true.B
  // dontTouch so that it shows up in the Verilog
  dontTouch(monitor)
})
```

--------------------------------

### Basic C-style printf usage in Chisel

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/printing.md

Demonstrates how to use Chisel's printf function, similar to C, with a format string and arguments to print a UInt value.

```Scala
val myUInt = 32.U
printf("myUInt = %d", myUInt) // myUInt = 32
```

--------------------------------

### Correct Chisel Vector Register Instantiation with Initialization

Source: https://github.com/chipsalliance/chisel/wiki/Scala-land-vs.-Chisel-land

This Chisel snippet shows the correct way to create and initialize a vector of registers. `Reg(Vec.fill(100) { true.B })` uses `Vec.fill` to create 100 Boolean registers, each explicitly initialized to `true.B`, ensuring all elements have the desired initial value.

```Scala
  val found = Reg(Vec.fill(100) { true.B })
```

--------------------------------

### Poke Chisel Circuit Inputs in Scala Test Harness

Source: https://github.com/chipsalliance/chisel/wiki/Debugging-with-the-Interpreter-REPL-2

Illustrates how to set input values for a Chisel circuit programmatically within a Scala test harness using the `poke` function, followed by a `step` to advance the simulation.

```scala
poke(gcd.io.value1, i)
      poke(gcd.io.value2, j)
      poke(gcd.io.loadingValues, 1)
      step(1)
      poke(gcd.io.loadingValues, 0)
```

--------------------------------

### Generate Verilog for Flipped Chisel '<>' Operator Test

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/connection-operators.md

Command to emit SystemVerilog code for the `Wrapper` module after flipping the operands of the `<>` operator, confirming that the generated hardware is identical to the non-flipped version.

```Scala
chisel3.docs.emitSystemVerilog(new Wrapper)
```

--------------------------------

### Instantiating Chisel `Bundle` with `Output` Wrapped Fields

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/cookbook.md

Shows the successful instantiation of `DirectionedBundle`, confirming that wrapping fields with `Output` prevents aliasing. This method leverages Chisel's internal handling of `Output` to generate distinct hardware elements.

```scala
chisel3.docs.emitSystemVerilog(new Top(new DirectionedBundle(UInt(8.W))))
```

--------------------------------

### Advance Chisel Circuit Simulation Cycle in REPL

Source: https://github.com/chipsalliance/chisel/wiki/Debugging-with-the-Interpreter-REPL-2

Explains how to advance the circuit simulation by one clock cycle using the `step` command in the REPL. This action propagates poked values, clearing 'poisoned' states and updating the circuit to a 'FRESH' state, reflecting the new internal values.

```CLI-Command
step ; show
```

```CLI-Output
CircuitState 5 (FRESH)
Inputs: clock= 0, io_loadingValues= 1, io_value1= 4, io_value2= 4, reset= 0
Outputs: io_outputGCD= 4, io_outputValid= 0
Registers      : x= 4, y= 4
FutureRegisters: x= 4, y= 4
Ephemera: _GEN_2= 4, _GEN_3= 4, _T_17= 0
```

--------------------------------

### Exposing Internal Chisel Module Fields with @public Annotation

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/hierarchy.md

Learn how to make internal members of an `@instantiable` Chisel module accessible from an `Instance` object using the `@public` annotation. This snippet outlines the requirements for fields to be marked `@public` (publicly accessible `val` or `lazy val` implementing `Lookupable`) and lists supported data types. An example shows how to correctly mark a superclass member as `@public`.

```Scala
import chisel3._
import chisel3.experimental.hierarchy.{instantiable, public}

@instantiable
class MyModule extends Module {
  @public val clock = clock
}
```

--------------------------------

### Display ChiselSim Scalatest Options via Mill Shell Command

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/testing.md

To view all supported options for a `ChiselSim` Scalatest test, pass the `-Dhelp=1` argument to Scalatest. This command, executed via a build tool like `mill`, provides a comprehensive list of configurable parameters for the test runner.

```Shell
./mill 'chisel[2.13.16].test.testOnly' chiselTests.ShiftRegistersSpec -- -Dhelp=1
```

--------------------------------

### Scala: Explicit Match in Map for Heterogeneous List Processing

Source: https://github.com/chipsalliance/chisel/wiki/Scala-Things-You-Should-Know

This example provides an alternative, more explicit syntax for using "match" within a "map" operation when processing heterogeneous lists. It demonstrates passing each list element to the "map"'s code block as a named variable ("element"), which is then explicitly processed by a nested "match" statement.

```Scala
val stringList = mixedList.map { element => 
  element match {
    case i: Int => i.toString
    ...
  }
}
```

--------------------------------

### Chisel DecoupledIO Interface Definition

Source: https://github.com/chipsalliance/chisel/wiki/CS250-Chisel+Scala-Primer

This snippet defines the `DecoupledIO` bundle in Chisel, which is a fundamental component for implementing ready/valid handshake protocols in hardware. It encapsulates the `ready` (input), `valid` (output), and `bits` (output) signals necessary for synchronized data transfer between modules, adhering to the Decoupled interface specification.

```Scala
class DecoupledIO[+T <: Data](gen: T) extends Bundle {
    val ready = Input(Bool())
    val valid = Output(Bool())
    val bits  = Output(gen) 
//…
}
```

--------------------------------

### Run Chisel FIRRTL Emission via sbt Command

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/resources/faqs.md

This bash command demonstrates how to invoke the `FirrtlMain` object using sbt to generate FIRRTL output.

```bash
sbt 'runMain intro.FirrtlMain'
```

--------------------------------

### Directly Create Nested Chisel Layer Block

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/layers.md

This example demonstrates that it is legal to directly create a layer block associated with a nested layer (C.D) within a Chisel module, even if its parent layer's block is not explicitly defined in the current scope. The layer block API automatically handles the creation of parent layer blocks if possible.

```Scala
class Bar extends RawModule {
  block (C.D) {}
}
```

--------------------------------

### Apply `prefix` to Chisel `when` Clauses

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/naming.md

Illustrates the use of `chisel3.experimental.prefix` to provide better naming for signals generated inside `when` conditional blocks. By wrapping the `when` block with a `prefix`, the resulting Verilog signals gain more context-dependent names, enhancing debuggability and clarity.

```Scala
class ExampleWhenPrefix extends Module {

  val in = IO(Input(UInt(4.W)))
  val out = IO(Output(UInt(4.W)))

  out := DontCare

  Seq.tabulate(2) { i =>
    val j = i + 1
    prefix(s"clause_${j}") {
      when (in === j.U) {
        val foo = Reg(UInt(4.W))
        foo := in + j.U(4.W)
        out := foo
      }
    }
  }
}
```

```Scala
emitSystemVerilog(new ExampleWhenPrefix)
```

--------------------------------

### Scala Basic For Loop with Range

Source: https://github.com/chipsalliance/chisel/wiki/CS250-Chisel+Scala-Primer

Demonstrates a basic for loop in Scala using the until keyword to iterate over a range of numbers, which differs from traditional Java for loops.

```Scala
for (i <- 0 until len){
	//do something
}
```

--------------------------------

### Run Chisel Verilog Emission via sbt Commands

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/resources/faqs.md

These bash commands demonstrate various ways to invoke the Chisel Verilog generator using sbt, including interactive mode, one-liner execution, and specifying output options like target directory and top-level name.

```bash
sbt
run-main intro.VerilogMain
```

```bash
sbt 'runMain intro.VerilogMain'
```

```bash
sbt 'runMain intro.HelloWorld --help'
```

```bash
sbt 'runMain intro.HelloWorld --target-dir buildstuff --top-name HelloWorld'
```

--------------------------------

### Implement LED Blinker in Chisel

Source: https://github.com/chipsalliance/chisel/blob/main/README.md

This Chisel code defines a `Blinky` module that toggles an LED output (`io.led0`) at a specified frequency (`freq`) using Chisel's built-in `Counter` utility. The `Main` object demonstrates how to use `ChiselStage.emitSystemVerilog` to generate the corresponding Verilog hardware description from the Chisel design.

```scala
import chisel3._
import chisel3.util.Counter
import circt.stage.ChiselStage

class Blinky(freq: Int, startOn: Boolean = false) extends Module {
  val io = IO(new Bundle {
    val led0 = Output(Bool())
  })
  // Blink LED every second using Chisel built-in util.Counter
  val led = RegInit(startOn.B)
  val (_, counterWrap) = Counter(true.B, freq / 2)
  when(counterWrap) {
    led := ~led
  }
  io.led0 := led
}

object Main extends App {
  // These lines generate the Verilog output
  println(
    ChiselStage.emitSystemVerilog(
      new Blinky(1000),
      firtoolOpts = Array("-disable-all-randomization", "-strip-debug-info")
    )
  )
}
```

--------------------------------

### Compose Chisel Modules with Bulk Connections

Source: https://github.com/chipsalliance/chisel/wiki/Interfaces-Bulk-Connections

Shows how to instantiate and connect multiple Chisel modules (`Filter` instances) within a larger module (`Block`) using the bulk connection operator (`<>`). This simplifies wiring by connecting identically named leaf ports, reducing boilerplate code for complex interconnections.

```scala
class Block extends Module {
  val io = IO(new FilterIO)
  val f1 = Module(new Filter)
  val f2 = Module(new Filter)
  f1.io.x <> io.x
  f1.io.y <> f2.io.x
  f2.io.y <> io.y
}
```

--------------------------------

### Import for Chisel SystemVerilog Emission

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/naming.md

This import enables the `emitSystemVerilog` function, used to generate SystemVerilog code from Chisel designs. It's crucial for verifying the effects of the Chisel compiler plugin on the final hardware output.

```Scala
import chisel3.docs.emitSystemVerilog
```

--------------------------------

### Chisel Bundle for Verilog-style AXI4 Interface

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/dataview.md

Translates the flat Verilog AXI4 interface into a Chisel `Bundle` structure. It demonstrates how to define `Input` and `Output` signals with specified widths to match a Verilog module for `BlackBox` instantiation, ensuring compatibility with existing Verilog IP.

```Scala
class VerilogAXIBundle(val addrWidth: Int) extends Bundle {
  val AWVALID = Output(Bool())
  val AWREADY = Input(Bool())
  val AWID = Output(UInt(4.W))
  val AWADDR = Output(UInt(addrWidth.W))
  val AWLEN = Output(UInt(2.W))
  val AWSIZE = Output(UInt(2.W))
  // The rest of AW and other AXI channels here
}

// Instantiated as
class my_module extends RawModule {
  val AXI = IO(new VerilogAXIBundle(20))
}
```

--------------------------------

### Chisel `Bundle` Using `Output` Wrapper for Field Instantiation

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/cookbook.md

Introduces `DirectionedBundle`, a solution that wraps fields with `Output(...)` to create fresh instances of the passed argument. While effective, this approach might be semantically misleading as it implies a specific direction for the Bundle fields.

```scala
class DirectionedBundle[T <: Data](gen: T) extends Bundle {
  val foo = Output(gen)
  val bar = Output(gen)
}
```

--------------------------------

### Suggest a name for Chisel signals or module instances using `.suggestName`

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/naming.md

Shows how to use the `.suggestName` API to propose a name for a signal. It's important to note that suggested names will still be subject to prefixing, including by the compiler plugin, unless `noPrefix` is explicitly used.

```Scala
class Example8 extends Module {
  val in = IO(Input(UInt(2.W)))
  val out = IO(Output(UInt(4.W)))

  val add = {
    val sum = RegNext(in + 1.U).suggestName("foo")
    sum + 1.U
  }

  out := add
}
```

```Verilog
emitSystemVerilog(new Example8)
```

--------------------------------

### Chisel Type Casting and Conversion

Source: https://github.com/chipsalliance/chisel/wiki/CS250-Chisel+Scala-Primer

Demonstrates how to handle type conversions and casting between Scala `Int` and Chisel `UInt` types, and how to convert a Chisel `UInt` to `Bits`. This is crucial in Chisel due to its distinct type system and the need for explicit bit width information.

```scala
val a = 1.U(8.W)
a.toBits //converts to bits
val b = 5
val c = b.U(8.W) //cast from Int to UInt 							//(actually construct obj)
```

--------------------------------

### Chisel3 I/O Without Prefix using FlatIO

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/cookbook.md

FlatIO allows defining module ports from a Bundle without the default io_ prefix. This is useful when you want to group related signals in a Bundle but expose them directly at the module's top level.

```Scala
import chisel3._

class MyBundle extends Bundle {
  val foo = Input(UInt(8.W))
  val bar = Output(UInt(8.W))
}

class MyModule extends Module {
  val io = FlatIO(new MyBundle)

  io.bar := io.foo +% 1.U
}
```

```Verilog
module MyModule(
  input  [7:0] foo,
  output [7:0] bar
);
  assign bar = foo + 8'h1;
endmodule
```

--------------------------------

### Extend DecoupledIO with Specific DataBundle

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/polymorphism-and-parameterization.md

Demonstrates how to extend the generic DecoupledIO bundle with a concrete DataBundle type, showing how to create a specific handshaking interface for a predefined data structure.

```Scala
class DecoupledDemo extends DecoupledIO(new DataBundle)
```

--------------------------------

### Migrating UInt/SInt literal creation from Chisel2 to Chisel3

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/troubleshooting.md

This section explains the change in syntax for creating `UInt` and `SInt` literals. It shows the deprecated Chisel2 method of direct `Int` conversion and the correct Chisel3 approach using the `.U` or `.S` methods, including how to specify a literal with a particular width.

```Scala
UInt(42)
```

```Scala
42.U
```

```Scala
1.S(8.W)
```

--------------------------------

### Chisel Module Definition for Signal Connection Experiment

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/connection-operators.md

This Scala code defines `MockDecoupledIO`, `Wrapper`, and `PipelineStage` Chisel modules. It demonstrates how `MockDecoupledIO`, which has fields matching `DecoupledIO` by name, can be connected using the `<>` operator, allowing signal flow even with different bundle types. The `Wrapper` module connects pipeline stages and I/O.

```scala
import chisel3._
import chisel3.util.DecoupledIO

class MockDecoupledIO extends Bundle {
  val valid = Output(Bool())
  val ready = Input(Bool())
  val bits = Output(UInt(8.W))
}
class Wrapper extends Module{
  val io = IO(new Bundle {
  val in = Flipped(new MockDecoupledIO())
  val out = new MockDecoupledIO()
  })
  val p = Module(new PipelineStage)
  val c = Module(new PipelineStage)
  // connect producer to I/O
  p.io.a <> io.in
  // connect producer  to consumer
  c.io.a <> p.io.b
  // connect consumer to I/O
  io.out <> c.io.b
}
class PipelineStage extends Module{
  val io = IO(new Bundle{
    val a = Flipped(DecoupledIO(UInt(8.W)))
    val b = DecoupledIO(UInt(8.W))
  })
  io.a <> io.b
}
```

--------------------------------

### Chisel Mux4 Module using Functional Mux2 Calls

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/functional-module-creation.md

Demonstrates a more concise and readable implementation of a `Mux4` module in Chisel. By leveraging the functional `apply` method of `Mux2`, it directly uses `Mux2` calls as expressions, simplifying the hardware connection description.

```Scala
class Mux4 extends Module {
  val io = IO(new Bundle {
    val in0 = Input(UInt(1.W))
    val in1 = Input(UInt(1.W))
    val in2 = Input(UInt(1.W))
    val in3 = Input(UInt(1.W))
    val sel = Input(UInt(2.W))
    val out = Output(UInt(1.W))
  })
  io.out := Mux2(io.sel(1),
                 Mux2(io.sel(0), io.in0, io.in1),
                 Mux2(io.sel(0), io.in2, io.in3))
}
```

--------------------------------

### Generate Verilog from Chisel-idiomatic AXI4 Bundle

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/dataview.md

Demonstrates how to emit SystemVerilog from a Chisel design that uses the idiomatic `AXIBundle`. This highlights that while the Chisel code is structured, the generated Verilog will reflect the compositional nature, potentially differing from a flat Verilog interface.

```Scala
chisel3.docs.emitSystemVerilog(new MyModule {
  override def desiredName = "MyModule"
  axi := DontCare // Just to generate Verilog in this stub
})
```

--------------------------------

### Create Generalized FIR Filter in Chisel with Coefficients

Source: https://github.com/chipsalliance/chisel/blob/main/README.md

Shows how to build a parameterized FIR filter in Chisel, allowing coefficients to be passed as arguments. This highlights Chisel's generator capabilities for flexible hardware design.

```Scala
// Generalized FIR filter parameterized by the convolution coefficients
class FirFilter(bitWidth: Int, coeffs: Seq[UInt]) extends Module {
  val io = IO(new Bundle {
    val in = Input(UInt(bitWidth.W))
    val out = Output(UInt(bitWidth.W))
  })
  // Create the serial-in, parallel-out shift register
  val zs = Reg(Vec(coeffs.length, UInt(bitWidth.W)))
  zs(0) := io.in
  for (i <- 1 until coeffs.length) {
    zs(i) := zs(i-1)
  }

  // Do the multiplies
  val products = VecInit.tabulate(coeffs.length)(i => zs(i) * coeffs(i))

  // Sum up the products
  io.out := products.reduce(_ + _)
}
```

--------------------------------

### Generate SystemVerilog from Chisel Module

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/dataview.md

This snippet shows how to use `chisel3.docs.emitSystemVerilog` to generate SystemVerilog code from a Chisel module. This is a common step for hardware synthesis and simulation.

```Scala
chisel3.docs.emitSystemVerilog(new MyModule)
```

--------------------------------

### Reset Chisel Circuit for Multiple Cycles in REPL

Source: https://github.com/chipsalliance/chisel/wiki/Debugging-with-the-Interpreter-REPL-2

Demonstrates how to reset the circuit for a specified number of cycles (e.g., 3) using the `reset` command, and how to combine multiple commands on one line using a semicolon. The output shows the circuit state after the reset.

```CLI-Command
reset 3 ; show
```

```CLI-Output
CircuitState 3 (STALE)
Inputs: clock= 0, io_loadingValues=☠ 1☠, io_value1=☠ 59401☠, io_value2=☠ 23169☠, reset= 0
Outputs: io_outputGCD=☠ 9☠, io_outputValid= 0
Registers      : x=☠ 9☠, y=☠ 1☠
FutureRegisters: x=☠ 9☠, y=☠ 1☠
Ephemera: _GEN_2=☠ 59401☠, _GEN_3=☠ 23169☠, _T_17= 0
```

--------------------------------

### Chisel Module Prefixing with `Instantiate` API

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/moduleprefix.md

Shows how `withModulePrefix` interacts with the `Instantiate` API. It demonstrates that `withModulePrefix` applies to `Instantiate` calls within its block, creating prefixed instances, while `Instantiate` calls outside remain unprefixed. It also clarifies that `Definition` calls are affected, but `Instance` calls are not.

```scala
import chisel3._
import chisel3.experimental.hierarchy.{instantiable, Instantiate}

@instantiable
class Sub extends Module {
  // ...
}

class Top extends Module {
  val foo_sub = withModulePrefix("Foo") {
    Instantiate(new Sub)
  }

  val bar_sub = withModulePrefix("Bar") {
    Instantiate(new Sub)
  }

  val noprefix_sub = Instantiate(new Sub)
}
```

--------------------------------

### Define Read-Only Memory (ROM) with VecInit in Chisel

Source: https://github.com/chipsalliance/chisel/wiki/Memories

Illustrates the basic syntax for `VecInit` to define a read-only memory (ROM) in Chisel, showing how to initialize it with a sequence of Data literals.

```Scala
VecInit(inits: Seq[T])
VecInit(elt0: T, elts: T*)
```

--------------------------------

### Scala Class and Companion Object with Apply Method

Source: https://github.com/chipsalliance/chisel/wiki/CS250-Chisel+Scala-Primer

Demonstrates how to define an apply method in both a class and its companion object in Scala. The class apply overloads the () operator for instances, while the companion object apply acts as a factory method. Shows usage of both forms.

```Scala
class MyClass (name: String, id: Int) {
    var myName = name
    var myId = id
    def printMe() {println(myName + " ID: " + myId)}
    def apply() = myId
    def apply(a: Int) {myId = a}}

object MyClass {
    def apply(s: String) = new MyClass(s, 0)
}
val a = MyClass("bob")
a.printMe()
a(10)          // output bob ID: 0
a.printMe()    // output bob ID: 10
```

--------------------------------

### Chisel Code to Generate Verilog for Flipped Bundle

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/bundles-and-vecs.md

This Scala code snippet demonstrates how to use `chisel3.docs.emitSystemVerilog` to generate SystemVerilog from a Chisel module that uses the `Flipped()` construct. This is the command used to produce the hardware description, illustrating the translation of Chisel constructs to Verilog.

```scala
chisel3.docs.emitSystemVerilog(new MyFlippedModule())
```

--------------------------------

### svsim Workspace API

Source: https://github.com/chipsalliance/chisel/blob/main/svsim/README.md

The `Workspace` component in `svsim` is responsible for managing filesystem interactions related to SystemVerilog simulations. It provides methods for initializing the workspace, elaborating SystemVerilog modules, generating test harnesses, and compiling simulations using various backends.

```APIDOC
Workspace:
  reset(): void
    Description: Deletes any previous state and creates necessary folders for the workspace.

  elaborate(moduleInfo: ModuleInfo): void
    moduleInfo: ModuleInfo - Describes the SystemVerilog module to be simulated.
    Description: Takes a ModuleInfo object to prepare the SystemVerilog module for simulation.

  generateAdditionalSources(): void
    Description: Uses the ModuleInfo from a previous elaborate call to generate the test harness.

  compile(backend: Backend, workingDirectoryTag: String): Simulation
    backend: Backend - The simulation backend to use (e.g., Verilator, VCS).
    workingDirectoryTag: String - A tag to create a separate directory for the simulation output.
    Returns: Simulation - An object representing the compiled simulation.
    Description: Compiles the simulation using the specified backend, allowing for multiple simulations to be created with different settings or backends.
```

--------------------------------

### Generate Firtool Pre-release Version Table (Scala)

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/appendix/versioning.md

Scala code snippet used by `mdoc` to dynamically generate the Firtool pre-release version compatibility table for Chisel documentation. It calls `FirtoolVersionsTable.prereleaseTable`.

```Scala
// This table is generated by SBT
println(FirtoolVersionsTable.prereleaseTable)
```

--------------------------------

### Write generic logging code with SimLog

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/printing.md

Illustrates how to write reusable Chisel components that accept a SimLog instance, allowing the same code to target different log destinations (file or stderr).

```Scala
class MyLogger(log: SimLog) extends Module {
  val in = IO(Input(UInt(8.W)))
  log.printf(cf"in = $in%d\n")
}

// Use with a file
val withFile = Module(new MyLogger(SimLog.file("data.log")))

// Use with stderr
val withStderr = Module(new MyLogger(SimLog.StdErr))
```

--------------------------------

### Create Optional I/O Ports in Chisel

Source: https://github.com/chipsalliance/chisel/wiki/Cookbook

Demonstrates how to create optional input/output ports in a Chisel module. The presence of the port is determined by a constructor parameter, utilizing Scala's `Option` type for conditional I/O.

```scala
class ModuleWithOptionalIOs(flag: Boolean) extends Module {
  val io = IO(new Bundle {
    val in = Input(UInt(12.W))
    val out = Output(UInt(12.W))
    val out2 = if (flag) Some(Output(UInt(12.W))) else None
  })
  
  io.out := io.in
  if (flag) {
    io.out2.get := io.in
  }
}
```

--------------------------------

### Defining a Generic Scala Function

Source: https://github.com/chipsalliance/chisel/wiki/CS250-Chisel+Scala-Primer

Illustrates the general syntax for defining a function in Scala, including parameters with their types and an optional return type. The function body is enclosed in curly braces, allowing for multiple statements.

```Scala
def fctnName(a: Type, b: AnotherType): ReturnType = {
  function body …
}
```

--------------------------------

### SBT Project Management Commands

Source: https://github.com/chipsalliance/chisel/wiki/Useful-SBT-Commands

A collection of standard SBT commands for compiling, running, and testing Chisel projects. These commands are typically executed within the SBT console or prefixed with 'sbt' from the shell.

```SBT
run
```

```SBT
runMain example.Driver
```

```SBT
compile
```

```SBT
test:compile
```

```SBT
test
```

```SBT
testOnly example.AdderSpec
```

```SBT
console
```

```SBT
help
```

```Shell
sbt "testOnly example.AdderSpec"
```

--------------------------------

### Create a Chisel Hardware Module (CSRModule) with a CSR Description Object

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/properties.md

This Scala code defines `CSRModule`, a Chisel hardware module that incorporates a CSR and its associated description. It takes a `Definition[CSRDescription]` as an argument, allowing it to instantiate an `Object` of the previously defined `CSRDescription` class using `Instance`. The module connects concrete string and integer values to the input properties of the `csrDescription` object and exposes a reference to this object via a property port, demonstrating how `Class` and `Object` instances can coexist within the hardware instance graph.

```scala
// A hardware module representing a CSR and its description.
class CSRModule(
  csrDescDef:     Definition[CSRDescription],
  width:          Int,
  identifierStr:  String,
  descriptionStr: String)
    extends Module {
  override def desiredName = identifierStr

  // Create a hardware port for the CSR value.
  val value = IO(Output(UInt(width.W)))

  // Create a property port for a reference to the CSR description object.
  val description = IO(Output(csrDescDef.getPropertyType))

  // Instantiate a CSR description object, and connect its input properties.
  val csrDescription = Instance(csrDescDef)
  csrDescription.identifierIn := Property(identifierStr)
  csrDescription.descriptionIn := Property(descriptionStr)
  csrDescription.widthIn := Property(width)

  // Create a register for the hardware CSR. A real implementation would be more involved.
  val csr = RegInit(0.U(width.W))

  // Assign the CSR value to the hardware port.
  value := csr

  // Assign a reference to the CSR description object to the property port.
}
```

--------------------------------

### Chisel Bulk Connection Operators

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/interfaces-and-connections.md

Describes the `MonoConnect` (`:=`) and `BiConnect` (`<>`) operators used for bulk connections between Chisel interfaces. It details the `MonoConnect` algorithm, including its non-commutative nature, element-wise recursion, and rules for writable LHS and readable RHS elements.

```APIDOC
MonoConnect (:=)
  Description: Executes a mono-directional connection element-wise. Non-commutative.
  Algorithm:
    - Recurses down the left Data (with the right Data).
    - Throws exception if movement through left cannot be matched in right.
    - Right side allowed to have extra fields.
    - Vecs must be exactly the same size.
  LHS (Left-Hand Side) Writable Rules:
    - Is an internal writable node (Reg or Wire)
    - Is an output of the current module
    - Is an input of a submodule of the current module
  RHS (Right-Hand Side) Readable Rules:
    - Is an internal readable node (Reg, Wire, Op)
    - Is a literal
    - Is a port of the current module or submodule of the current module

BiConnect (<>)
  Description: Bi-directional connection operator.
```

--------------------------------

### Configure SBT Dependencies for Chisel < 5.0.0

Source: https://github.com/chipsalliance/chisel/blob/main/README.md

Provides the build.sbt configuration for older versions of Chisel (prior to 5.0.0), including the chiseltest library for unit testing.

```Scala
// build.sbt
scalaVersion := "2.13.10"
addCompilerPlugin("edu.berkeley.cs" % "chisel3-plugin" % "3.6.0" cross CrossVersion.full)
libraryDependencies += "edu.berkeley.cs" %% "chisel3" % "3.6.0"
// We also recommend using chiseltest for writing unit tests
libraryDependencies += "edu.berkeley.cs" %% "chiseltest" % "0.6.0" % "test"
```

--------------------------------

### Scala Tuple Definition and Access

Source: https://github.com/chipsalliance/chisel/wiki/CS250-Chisel+Scala-Primer

Illustrates how to define tuples in Scala with mixed data types and how to access individual elements using ._N syntax. Also shows the -> operator for creating 2-tuples (key-value pairs).

```Scala
val stuff = (3, 5.6, "hello")        
println(stuff._1)
println(stuff._2)
println(stuff._3)
val keyValPair = "name" -> "Oski"
```

--------------------------------

### Chisel BlackBox with Inline Verilog Implementation

Source: https://github.com/chipsalliance/chisel/wiki/BlackBoxes

Shows how to embed Verilog code directly within a Chisel `BlackBox` definition using the `HasBlackBoxInline` trait and `setInline` method. This technique copies the provided inline Verilog into a target file during compilation, simplifying the management of small Verilog snippets without requiring separate resource files.

```Scala
class BlackBoxRealAdd extends BlackBox with HasBlackBoxInline {
  val io = IO(new Bundle() {
    val in1 = Input(UInt(64.W))
    val in2 = Input(UInt(64.W))
    val out = Output(UInt(64.W))
  })
  setInline("BlackBoxRealAdd.v",
    s"""
      |module BlackBoxRealAdd(
      |    input  [15:0] in1,
      |    input  [15:0] in2,
      |    output [15:0] out
      |);
      |always @* begin
      |  out <= $realtobits($bitstoreal(in1) + $bitstoreal(in2));
      |end
      |endmodule
    """.stripMargin)
}
```

--------------------------------

### BibTeX Citation for Chisel Hardware Description Language

Source: https://github.com/chipsalliance/chisel/blob/main/website/src/pages/community.md

This BibTeX entry provides the recommended citation for the original Chisel paper, 'Chisel: Constructing hardware in a Scala embedded language', published in DAC 2012. Use this when citing Chisel in academic research.

```bib
@inproceedings{bachrach:2012:chisel,
  author={J. {Bachrach} and H. {Vo} and B. {Richards} and Y. {Lee} and A. {Waterman} and R {Avižienis} and J. {Wawrzynek} and K. {Asanović}},
  booktitle={DAC Design Automation Conference 2012},
  title={Chisel: Constructing hardware in a Scala embedded language},
  year={2012},
  volume={},
  number={},
  pages={1212-1221},
  keywords={application specific integrated circuits;C++ language;field programmable gate arrays;hardware description languages;Chisel;Scala embedded language;hardware construction language;hardware design abstraction;functional programming;type inference;high-speed C++-based cycle-accurate software simulator;low-level Verilog;FPGA;standard ASIC flow;Hardware;Hardware design languages;Generators;Registers;Wires;Vectors;Finite impulse response filter;CAD},
  doi={10.1145/2228360.2228584},
  ISSN={0738-100X},
  month={June},}
```

--------------------------------

### Nest Chisel Bundles for Complex Interfaces

Source: https://github.com/chipsalliance/chisel/wiki/Interfaces-Bulk-Connections

Shows how to create a more complex Chisel interface (`FilterIO`) by nesting instances of other Bundles (`PLink`). It also demonstrates the use of `Flipped` to invert the direction of a nested bundle's signals, which is crucial for connecting producer-consumer interfaces.

```scala
class FilterIO extends Bundle {
  val x = Flipped(new PLink)
  val y = new PLink
}
```

--------------------------------

### Tieoff Chisel Bundle or Vec to Zero

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/cookbook.md

This snippet demonstrates how to initialize a Chisel Bundle or Vec to a zero value. It shows two approaches: directly using `asTypeOf` with a zero-valued UInt when the target type is known, and using `chiselTypeOf` for a more generic solution that works regardless of the specific type of the hardware element.

```Scala
import chisel3._

class MyBundle extends Bundle {
  val foo = UInt(4.W)
  val bar = Vec(4, UInt(1.W))
}

class Foo(typ: MyBundle) extends Module {
  val bundleA = IO(Output(typ))
  val bundleB = IO(Output(typ))

  // typ is already a Chisel Data Type, so can use it directly here, but you
  // need to know that bundleA is of type typ
  bundleA := 0.U.asTypeOf(typ)

  // bundleB is a Hardware data IO(Output(...)) so need to call chiselTypeOf,
  // but this will work no matter the type of bundleB:
  bundleB := 0.U.asTypeOf(chiselTypeOf(bundleB))
}
```

--------------------------------

### Enable VCD Waveform Generation for Chisel Simulations via Mill Shell Command

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/testing.md

Enable Value Change Dump (VCD) waveform output for Chisel simulations run with Scalatest and `ChiselSim` by passing the `-DemitVcd=1` argument. This is typically done through your build tool, such as `mill`, to generate waveforms for debugging.

```Shell
./mill 'chisel[2.13.16].test.testOnly' chiselTests.ShiftRegistersSpec -- -DemitVcd=1
```

--------------------------------

### Chisel Register Instantiation with Initialization

Source: https://github.com/chipsalliance/chisel/wiki/Scala-land-vs.-Chisel-land

This Chisel snippet shows the correct method to declare and initialize a register with a specific value. `RegInit(42.U)` both infers the necessary width from `42.U` and sets the initial value of the register to 42.

```Scala
  val accumulator = RegInit(42.U)
```

--------------------------------

### Creating `UInt`/`SInt` literals in Chisel3

Source: https://github.com/chipsalliance/chisel/wiki/Troubleshooting

This snippet demonstrates the updated syntax for creating `UInt` and `SInt` literals in Chisel3, contrasting it with the Chisel2 approach. Chisel3 introduces `.U` and `.S` methods for creating unsigned and signed literals from integers, and allows specifying a precise width using the `.W` method.

```scala
UInt(42)
```

```scala
42.U
```

```scala
1.S(8.W)
```

--------------------------------

### Show Chisel Circuit State in REPL

Source: https://github.com/chipsalliance/chisel/wiki/Debugging-with-the-Interpreter-REPL-2

Explains how to view the current state of a Chisel circuit, including inputs, outputs, registers, and ephemeral signals, using the `show` command in the REPL. It also clarifies the meaning of 'poisoned' values, indicating uninitialized data.

```CLI-Command
show
```

```CLI-Output
CircuitState 0 (FRESH)
Inputs: clock= 0, io_loadingValues=☠ 1☠, io_value1=☠ 59401☠, io_value2=☠ 23169☠, reset=☠ 1☠
Outputs: io_outputGCD=☠ 5☠, io_outputValid= 0
Registers      : x=☠ 5☠, y=☠ 11☠
FutureRegisters: x=☠ 9☠, y=☠ 1☠
Ephemera: _GEN_0=☠ 5☠, _GEN_1=☠ 6☠, _GEN_2=☠ 59401☠, _GEN_3=☠ 23169☠, _T_10=☠ -6☠, _T_11=☠ 26☠, _T_12=☠ 10☠, _T_13=☠ 6☠, _T_14=☠ 6☠, _T_15=☠ 6☠, _T_17= 0, _T_9= 0
Memories
```

--------------------------------

### Import `chisel3.experimental.conversions`

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/dataview.md

Shows the necessary import statement to access the `DataView` utilities and implicit conversions for Scala Tuples provided by the Chisel library.

```scala
import chisel3.experimental.conversions._
```

--------------------------------

### Instantiate Parameterized Xilinx IBUFDS BlackBox in Chisel

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/blackboxes.md

Defines a Chisel `BlackBox` for the Xilinx IBUFDS, demonstrating how to pass Verilog parameters via a `Map` and connect its clock I/O. The generated Verilog instantiation is also shown, illustrating how Chisel translates the BlackBox definition.

```scala
import chisel3._
import chisel3.util._
import chisel3.experimental._ // To enable experimental features

class IBUFDS extends BlackBox(Map("DIFF_TERM" -> "TRUE",
                                  "IOSTANDARD" -> "DEFAULT")) {
  val io = IO(new Bundle {
    val O = Output(Clock())
    val I = Input(Clock())
    val IB = Input(Clock())
  })
}

class Top extends Module {
  val io = IO(new Bundle {})
  val ibufds = Module(new IBUFDS)
  // connecting one of IBUFDS's input clock ports to Top's clock signal
  ibufds.io.I := clock
}
```

```verilog
IBUFDS #(.DIFF_TERM("TRUE"), .IOSTANDARD("DEFAULT")) ibufds (
  .IB(ibufds_IB),
  .I(ibufds_I),
  .O(ibufds_O)
);
```

--------------------------------

### Instantiating Chisel `Bundle` with `.cloneType` Fields

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/cookbook.md

Illustrates the instantiation of `UsingCloneTypeBundle`, confirming that explicitly calling `.cloneType` on `gen` for `foo` and `bar` fields successfully resolves the aliasing issue. This approach offers fine-grained control over instance creation.

```scala
chisel3.docs.emitSystemVerilog(new Top(new UsingCloneTypeBundle(UInt(8.W))))
```

--------------------------------

### Generate Chisel Code Coverage Report using Makefile

Source: https://github.com/chipsalliance/chisel/wiki/Chisel-Developer-Stuff

Execute this command from your project's root directory to initiate the scoverage report generation process. This command leverages the project's Makefile to run tests and collect coverage data.

```bash
make coverage
```

--------------------------------

### Define a Scala companion object for class X

Source: https://github.com/chipsalliance/chisel/wiki/Scala-Things-You-Should-Know

This snippet defines a companion object `X` for the `class X`. It includes a constant `const`, two `apply` factory methods for creating `X` instances with different arguments, and a `show` method to print an `X` object's internal state.

```Scala
object X {
  val const = 77
  def apply(i: Int): X = { new X(i, const)  }
  def apply(i: Int, j: Int): X = { new X(i, j) }
  def show(x: X): Unit = { println(s"x contains value z = ${x.z}") }
}
```

--------------------------------

### Define SimpleLink and PLink Bundles

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/polymorphism-and-parameterization.md

Defines SimpleLink and PLink bundles, which serve as concrete data types for demonstrating the instantiation of parameterized modules. PLink extends SimpleLink by adding a parity field.

```Scala
class SimpleLink extends Bundle {
  val data = Output(UInt(16.W))
  val valid = Output(Bool())
}
class PLink extends SimpleLink {
  val parity = Output(UInt(5.W))
}
```

--------------------------------

### HW Attribute and Instance Graph API Functions

Source: https://github.com/chipsalliance/chisel/blob/main/circtpanamabinding/includeFunctions.txt

Provides API functions for handling hardware (HW) attributes like inner references and symbols, and for interacting with the hardware instance graph. These functions are crucial for analyzing and manipulating hardware module hierarchies.

```APIDOC
hwInnerRefAttrGet()
hwInnerSymAttrGet()
hwInnerSymAttrGetEmpty()
hwInstanceGraphGet()
hwInstanceGraphGetTopLevelNode()
hwInstanceGraphForEachNode()
hwInstanceGraphNodeEqual()
hwInstanceGraphNodeGetModuleOp()
```

--------------------------------

### Instantiate a Chisel/Scala Function in a Hardware Design

Source: https://github.com/chipsalliance/chisel/wiki/Functional-Abstraction

This snippet demonstrates how to instantiate and use the previously defined `clb` function within another part of a Chisel hardware design. It shows how the function's output can be assigned to a `val`, effectively integrating the reusable logic block.

```Scala
val out = clb(a,b,c,d)
```

--------------------------------

### Chisel Mux2 Module with Functional Apply Method

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/functional-module-creation.md

Defines a `Mux2` hardware module in Chisel and its companion object. The `object Mux2` includes an `apply` method that instantiates the `Mux2` module, connects its inputs, and returns its output, enabling a functional style of module instantiation and connection.

```Scala
import chisel3._

class Mux2 extends Module {
  val io = IO(new Bundle {
    val sel = Input(Bool())
    val in0 = Input(UInt())
    val in1 = Input(UInt())
    val out = Output(UInt())
  })
  io.out := Mux(io.sel, io.in0, io.in1)
}

object Mux2 {
  def apply(sel: UInt, in0: UInt, in1: UInt) = {
    val m = Module(new Mux2)
    m.io.in0 := in0
    m.io.in1 := in1
    m.io.sel := sel
    m.io.out
  }
}
```

--------------------------------

### Chisel Hierarchy-Specific Select Functions API Reference

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/hierarchy.md

Detailed API reference for the seven hierarchy-specific Select functions available in Chisel, outlining their purpose, parameters, and return types for navigating and querying the hardware design hierarchy.

```APIDOC
Chisel Hierarchy-Specific Select Functions:
  - instancesIn(parent: Any): Returns all instances directly instantiated locally within 'parent'. Returns: Instance
  - instancesOf[type](parent: Any): Returns all instances of provided 'type' directly instantiated locally within 'parent'. Returns: Instance
  - allInstancesOf[type](root: Any): Returns all instances of provided 'type' directly and indirectly instantiated, locally and deeply, starting from 'root'. Returns: Instance
  - definitionsIn(parent: Any): Returns definitions of all instances directly instantiated locally within 'parent'. Returns: Definition
  - definitionsOf[type](parent: Any): Returns definitions of all instances of provided 'type' directly instantiated locally within 'parent'. Returns: Definition
  - allDefinitionsOf[type](root: Any): Returns all definitions of instances of provided 'type' directly and indirectly instantiated, locally and deeply, starting from 'root'. Returns: Definition
  - ios(target: Definition | Instance): Returns all the I/Os of the provided definition or instance. Returns: IO
```

--------------------------------

### Chisel Register Instantiation with Explicit Width and Initialization

Source: https://github.com/chipsalliance/chisel/wiki/Scala-land-vs.-Chisel-land

This Chisel snippet demonstrates how to initialize a register with a specific value while also explicitly defining its width. `42.U(64.W)` ensures the register is 64 bits wide and initialized to 42, overriding any width inference.

```Scala
  val accumulator = RegInit(42.U(64.W))
```

--------------------------------

### Flush buffered SimLog output to file

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/printing.md

Shows how to explicitly flush a SimLog object writing to a file, ensuring all buffered output is immediately written, useful for co-simulation.

```Scala
val log = SimLog.file("logfile.log")
val in = IO(Input(UInt(8.W)))
log.printf(cf"in = $in%d\n")
log.flush() // Flush buffered output right away.
```

--------------------------------

### Define a Crossbar Interface with Vector Bundles (CrossbarIo)

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/interfaces-and-connections.md

Defines `CrossbarIo` for a crossbar module, utilizing `Vec` to create vectors of `PLink` instances for inputs and outputs, and a `UInt` for selection. `log2Ceil` is used for calculating the selection bit width, demonstrating how to create richer hierarchical interfaces with vectors.

```scala
import chisel3.util.log2Ceil
class CrossbarIo(n: Int) extends Bundle {
  val in = Vec(n, Flipped(new PLink))
  val sel = Input(UInt(log2Ceil(n).W))
  val out = Vec(n, new PLink)
}
```

--------------------------------

### Extend Chisel Bundle Interface with Inheritance

Source: https://github.com/chipsalliance/chisel/wiki/Interfaces-Bulk-Connections

Demonstrates extending an existing Chisel Bundle, `SimpleLink`, by adding a new signal (`parity`) using Scala's inheritance mechanism. This shows how to build hierarchical interfaces and reuse existing definitions.

```scala
class PLink extends SimpleLink {
  val parity = Output(UInt(5.W))
}
```

--------------------------------

### Generate Chisel Test Coverage Report using sbt

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/developers/test-coverage.md

This sbt command sequence cleans the project, runs tests with coverage enabled, and then generates a comprehensive test coverage report. The reports, including `scoverage.xml` and `index.html`, are typically found in the `target/scala-x.yy/scoverage-report/` directory.

```sbt
sbt clean coverage test
sbt coverageReport
```

--------------------------------

### Chisel Plugin Rewriting for Bundle and Module I/O

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/naming.md

Demonstrates how the Chisel compiler plugin automatically rewrites `val` declarations for `Bundle` members and `Module` I/O. The plugin inserts `withName` calls, ensuring these hardware elements are properly named in the generated design.

```Scala
class MyBundle extends Bundle {
  val foo = Input(UInt(3.W))
  // val foo = withName("foo")(Input(UInt(3.W)))
}
class Example1 extends Module {
  val io = IO(new MyBundle())
  // val io = withName("io")(IO(new MyBundle()))
}
```

```Scala
emitSystemVerilog(new Example1)
```

--------------------------------

### Basic Chisel cf-interpolator usage

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/printing.md

Illustrates the correct way to use Chisel's `cf` string interpolator for printing hardware signals, showing a simple variable interpolation.

```Scala
val myUInt = 33.U
printf(cf"myUInt = $myUInt") // myUInt = 33
```

--------------------------------

### List Generated Files in Test Directory

Source: https://github.com/chipsalliance/chisel/wiki/Debugging-with-the-Interpreter-REPL-3

This shell command lists the contents of the `test_run_dir` subdirectory, showing the generated files including the VCD file, after running the GCD tests with VCD generation enabled.

```Shell
ls test_run_dir/gcd.GCDMain2061991994/
```

--------------------------------

### OM (Object Model) C-API Reference

Source: https://github.com/chipsalliance/chisel/blob/main/circtpanamabinding/includeFunctions.txt

Detailed C-API documentation for the OM library, providing functions for interacting with the Object Model. It includes APIs for type introspection, evaluator operations, object manipulation, value handling, and various attribute types.

```APIDOC
OM C-API:
  Type:
    omTypeIsAClassType()
    omClassTypeGetTypeID()
    omClassTypeGetName()
    omTypeIsAFrozenBasePathType()
    omFrozenBasePathTypeGetTypeID()
    omTypeIsAFrozenPathType()
    omFrozenPathTypeGetTypeID()
    omTypeIsAMapType()
    omMapTypeGetKeyType()
    omTypeIsAStringType()
  Evaluator:
    omEvaluatorNew()
    omEvaluatorInstantiate()
    omEvaluatorGetModule()
  Object:
    omEvaluatorObjectIsNull()
    omEvaluatorObjectGetType()
    omEvaluatorObjectGetField()
    omEvaluatorObjectGetHash()
    omEvaluatorObjectIsEq()
    omEvaluatorObjectGetFieldNames()
  EvaluatorValue:
    omEvaluatorValueGetContext()
    omEvaluatorValueGetLoc()
    omEvaluatorValueIsNull()
    omEvaluatorValueIsAObject()
    omEvaluatorValueIsAPrimitive()
    omEvaluatorValueGetPrimitive()
    omEvaluatorValueFromPrimitive()
    omEvaluatorValueIsAList()
    omEvaluatorListGetNumElements()
    omEvaluatorListGetElement()
    omEvaluatorValueIsATuple()
    omEvaluatorTupleGetNumElements()
    omEvaluatorTupleGetElement()
    omEvaluatorMapGetElement()
    omEvaluatorMapGetKeys()
    omEvaluatorValueIsAMap()
    omEvaluatorMapGetType()
    omEvaluatorValueIsABasePath()
    omEvaluatorBasePathGetEmpty()
    omEvaluatorValueIsAPath()
    omEvaluatorPathGetAsString()
    omEvaluatorValueIsAReference()
    omEvaluatorValueGetReferenceValue()
  ReferenceAttr API:
    omAttrIsAReferenceAttr()
    omReferenceAttrGetInnerRef()
  IntegerAttr API:
    omAttrIsAIntegerAttr()
    omIntegerAttrGetInt()
    omIntegerAttrGet()
  ListAttr API:
    omAttrIsAListAttr()
    omListAttrGetNumElements()
    omListAttrGetElement()
  MapAttr API:
    omAttrIsAMapAttr()
    omMapAttrGetNumElements()
    omMapAttrGetElementKey()
    omMapAttrGetElementValue()
```

--------------------------------

### Define Chisel Mux2 with `apply` Method for Functional Interface

Source: https://github.com/chipsalliance/chisel/wiki/Functional-Module-Creation

This Scala/Chisel code defines an `object Mux2` with an `apply` method. This method acts as a functional constructor, taking multiplexer inputs (`sel`, `in0`, `in1`) and returning the `Mux2` module's output (`m.io.out`). This approach simplifies module instantiation and allows for more intuitive hardware connection descriptions.

```scala
object Mux2 {
  def apply(sel: UInt, in0: UInt, in1: UInt) = {
    val m = Module(new Mux2)
    m.io.in0 := in0
    m.io.in1 := in1
    m.io.sel := sel
    m.io.out
  }
}
```

--------------------------------

### Call Scala companion object apply methods

Source: https://github.com/chipsalliance/chisel/wiki/Scala-Things-You-Should-Know

This snippet demonstrates various ways to invoke the `apply` factory methods defined in a Scala companion object. It shows both explicit `X.apply(...)` calls and the more concise `X(...)` syntax, which implicitly calls `apply`.

```Scala
val x1 = X.apply(4)
val x2 = X.apply(33)
val x1 = X(4)
val x2 = X(33)
```

--------------------------------

### CIRCT Firtool Options

Source: https://github.com/chipsalliance/chisel/blob/main/circtpanamabinding/includeStructs.txt

Describes the configuration options available for the 'firtool' utility within the CIRCT project, which processes FIRRTL code.

```APIDOC
CirctFirtoolFirtoolOptions
```

--------------------------------

### `circt.stage.ChiselStage` Emission Methods

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/testing.md

`circt.stage.ChiselStage` provides methods to emit Chisel circuits as FIRRTL or SystemVerilog. Both methods accept optional elaboration arguments, and `emitSystemVerilog` also takes `firtool` options for fine-grained control over the generated output.

```APIDOC
circt.stage.ChiselStage:
  emitCHIRRTL(
    circuit: chisel3.Module,
    args: Seq[String] = Seq.empty
  ): String

  emitSystemVerilog(
    circuit: chisel3.Module,
    args: Seq[String] = Seq.empty,
    firtoolOpts: Seq[String] = Seq.empty
  ): String
```

--------------------------------

### Chisel 3.0 - 3.6 Project Compatibility Matrix

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/appendix/versioning.md

Table detailing compatible versions of Chisel and related projects (chiseltest, chisel-iotesters, firrtl, treadle, diagrammer, firrtl-interpreter) for Chisel versions 3.0 through 3.6. This matrix indicates which project versions were compiled against specific dependencies, along with relevant footnotes.

```APIDOC
| chisel3 | chiseltest | chisel-iotesters^3 | firrtl | treadle | diagrammer | firrtl-interpreter^2 |
| ------- | ---------- | ---------------- | ------ | ------- | ---------- | ----- |
| 3.6 | 0.6 | - | 1.6 | 1.6 | 1.6 | - |
| 3.5 | 0.5^4 | 2.5^5 | 1.5 | 1.5^4 | 1.5^4 | - |
| 3.4 | 0.3 | 1.5 | 1.4 | 1.3 | 1.3 | 1.4 |
| 3.3 | 0.2 | 1.4 | 1.3 | 1.2 | 1.2 | 1.3 |
| 3.2 | 0.1^1 | 1.3 | 1.2 | 1.1 | 1.1 | 1.2 |
| 3.1 | - | 1.2 | 1.1 | 1.0 | 1.0 | 1.1 |
| 3.0 | - | 1.1 | 1.0 | - | - | 1.0 |

^1 chiseltest 0.1 was published under artifact name [chisel-testers2](https://search.maven.org/search?q=a:chisel-testers2_2.12) (0.2 was published under both artifact names)
^2 Replaced by Treadle, in maintenance mode only since version 1.1, final version is 1.4
^3 Replaced by chiseltest, final version is 2.5
^4 chiseltest, treadle, and diagrammer skipped X.4 to have a consistent major version with Chisel
^5 chisel-iotesters skipped from 1.5 to 2.5 to have a consistent major version with Chisel
```

--------------------------------

### Annotate Chisel Memory for Binary File Loading

Source: https://github.com/chipsalliance/chisel/wiki/Chisel-Memories

This snippet demonstrates how to explicitly specify that a memory should be loaded from a file containing binary numbers. It uses the 'MemoryLoadFileType.Binary' option, corresponding to '$readmemb' in Verilog simulation.

```Scala
loadMemoryFromFile(memory, "/workspace/workdir/mem1.txt", MemoryLoadFileType.Binary)
```

--------------------------------

### Object Graph for Multiple CSR Descriptions from Top Module

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/properties.md

This JSON snippet illustrates the object graph representation when elaborating the `Top` module, showing a list of two `CSRDescription` objects. Each object contains the `identifier`, `description`, and `width` properties for the 'mcycle' and 'minstret' counters, demonstrating how multiple CSR configurations are exposed.

```APIDOC
{
  "descriptions": [
    {
      "identifier": "mcycle",
      "description": "Machine cycle counter.",
      "width": 64
    },
    {
      "identifier": "minstret",
      "description": "Machine instructions-retired counter.",
      "width": 64
    }
  ]
}
```

--------------------------------

### Run VCD Simulation and Inspect State

Source: https://github.com/chipsalliance/chisel/wiki/Debugging-with-the-Interpreter-REPL-3

The `vcd run` command advances the simulation. Appending `; show` displays the current circuit state, including inputs, outputs, and registers. Use `vcd run to N` to advance the simulation to a specific event number. The interpreter sets inputs and compares outputs/registers based on the VCD script. To disable comparison warnings, use `vcd run notest`.

```Interpreter Command
vcd run ; show
```

```Interpreter Command
vcd run to 32 ; show
```

```Interpreter Command
vcd run notest
```

--------------------------------

### Displaying Low-Level FIRRTL Circuit Representation in REPL

Source: https://github.com/chipsalliance/chisel/wiki/Debugging-with-the-Interpreter-REPL-2

This snippet shows the output of the 'show lofirrtl' command in the REPL, which displays the low-level FIRRTL representation of the loaded circuit. It includes module definitions, inputs, outputs, registers, and combinational logic, with references to original Scala source locations.

```FIRRTL
circuit GCD :
  module GCD :
    input clock : Clock
    input reset : UInt<1>
    input io_value1 : UInt<16>
    input io_value2 : UInt<16>
    input io_loadingValues : UInt<1>
    output io_outputGCD : UInt<16>
    output io_outputValid : UInt<1>

    reg x : UInt<4>, clock with :
      reset => (UInt<1>("h0"), x) @[GCD.scala 21:15]
    reg y : UInt<4>, clock with :
      reset => (UInt<1>("h0"), y) @[GCD.scala 22:15]
    node _T_9 = gt(x, y) @[GCD.scala 24:10]
    node _T_10 = sub(x, y) @[GCD.scala 24:24]
    node _T_11 = asUInt(_T_10) @[GCD.scala 24:24]
    node _T_12 = tail(_T_11, 1) @[GCD.scala 24:24]
    node _T_13 = sub(y, x) @[GCD.scala 25:25]
    node _T_14 = asUInt(_T_13) @[GCD.scala 25:25]
    node _T_15 = tail(_T_14, 1) @[GCD.scala 25:25]
    node _GEN_0 = mux(_T_9, _T_12, x) @[GCD.scala 24:15]
    node _GEN_1 = mux(_T_9, y, _T_15) @[GCD.scala 24:15]
    node _GEN_2 = mux(io_loadingValues, io_value1, _GEN_0) @[GCD.scala 27:26]
    node _GEN_3 = mux(io_loadingValues, io_value2, _GEN_1) @[GCD.scala 27:26]
    node _T_17 = eq(y, UInt<1>("h0")) @[GCD.scala 33:23]
    io_outputGCD <= x
    io_outputValid <= _T_17
    x <= bits(_GEN_2, 3, 0)
    y <= bits(_GEN_3, 3, 0)
```

--------------------------------

### Convert Chisel Bundle to UInt

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/cookbook.md

This snippet demonstrates how to convert an instance of a Chisel Bundle into a UInt. It utilizes the `asUInt` method available on Bundle instances to achieve this conversion, showing how the individual fields of the Bundle are packed into a single unsigned integer.

```Scala
import chisel3._

class MyBundle extends Bundle {
  val foo = UInt(4.W)
  val bar = UInt(4.W)
}

class Foo extends Module {
  val bundle = Wire(new MyBundle)
  bundle.foo := 0xc.U
  bundle.bar := 0x3.U
  val uint = bundle.asUInt
  printf(cf"$uint") // 195

  // Test
  assert(uint === 0xc3.U)
}
```

--------------------------------

### Test Chisel module using legacy ChiselTest

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/appendix/migrating-from-chiseltest.md

This Scala code demonstrates how to test the `MyModule` using the deprecated ChiselTest library. It utilizes `ChiselScalatestTester` to poke input values, step the clock, and expect output values, showcasing the traditional testing approach before migration.

```Scala
import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec

class MyModuleSpec extends AnyFlatSpec with ChiselScalatestTester {
  behavior of "MyModule"
  it should "do something" in {
    test(new MyModule) { c =>
      c.io.in.poke(0.U)
      c.clock.step()
      c.io.out.expect(0.U)
      c.io.in.poke(42.U)
      c.clock.step()
      c.io.out.expect(42.U)
      println("Last output value : " + c.io.out.peek().litValue)
    }
  }
}
```

--------------------------------

### Extend SimpleLink with Parity Bits (PLink)

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/interfaces-and-connections.md

Extends the `SimpleLink` interface using inheritance to create `PLink`. This new interface adds a 5-bit `parity` output signal, demonstrating how interfaces can be built upon existing ones.

```scala
class PLink extends SimpleLink {
  val parity = Output(UInt(5.W))
}
```

--------------------------------

### Instantiate Parameterized Filter with PLink

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/polymorphism-and-parameterization.md

Shows how to instantiate the generic Filter module with a specific parameterized type, PLink, demonstrating the practical application of the generic Filter definition for a concrete link type.

```Scala
val f = Module(new Filter(new PLink))
```

--------------------------------

### Instantiate Generic FIFO with DataBundle

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/polymorphism-and-parameterization.md

Shows how to instantiate the generic Fifo module with a specific DataBundle type and a depth of 8, illustrating the reusability of the parameterized FIFO design with a concrete data type.

```Scala
val fifo = Module(new Fifo(new DataBundle, 8))
```

--------------------------------

### Repl VCD Command Submenu Reference

Source: https://github.com/chipsalliance/chisel/wiki/Debugging-with-the-Interpreter-REPL-3

This section details the various subcommands available under the `vcd` command in the Repl, used for controlling VCD playback and inspection. Commands include running events, setting event pointers, and listing VCD contents with various filtering options.

```APIDOC
vcd run                    run one event
vcd run to step            run event until a step occurs
vcd run to <event-number>  run up to given event-number
vcd run <number-of-events> run this many events
vcd run set <event>        set next event to run
vcd run test               test outputs after each run command
vcd run notest             do not test outputs after each run command
vcd run verbose            run in verbose mode (the default)
vcd run noverbose          do not run in verbose mode
vcd list
vcd list all
vcd list <event-number>
vcd list <event-number> <window-size>
```

--------------------------------

### Chisel: Emitting SystemVerilog for `FooToBarSwizzled` Module

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/dataview.md

This command generates the SystemVerilog output for the `FooToBarSwizzled` module, showcasing the hardware implementation of the swizzled `DataView` transformation.

```Chisel
chisel3.docs.emitSystemVerilog(new FooToBarSwizzled)
```

--------------------------------

### Compile Chisel Module to SystemVerilog with FIRRTL Options

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/probes.md

This Scala snippet shows how to compile a Chisel module, specifically the `Foo` module, into SystemVerilog using `circt.stage.ChiselStage.emitSystemVerilog`. It includes an array of `firtoolOpts` to control the compilation process, such as stripping debug information, disabling randomization, and enabling specific verification layers (Assert, Assume, Cover).

```Scala
circt.stage.ChiselStage.emitSystemVerilog(
  new Foo,
  Array("--throw-on-first-error"),
  firtoolOpts = Array(
    "-strip-debug-info",
    "-disable-all-randomization",
    "-enable-layers=Verification",
    "-enable-layers=Verification.Assert",
    "-enable-layers=Verification.Assume",
    "-enable-layers=Verification.Cover"
  )
)
```

--------------------------------

### Chisel Mux4 Implementation without Functional Mux2 Interface

Source: https://github.com/chipsalliance/chisel/wiki/Functional-Module-Creation

This Chisel code defines a `Mux4` module by instantiating and connecting multiple `Mux2` modules explicitly. It shows a traditional way of composing larger modules from smaller ones, where each sub-module's inputs and outputs are individually wired. This serves as a comparison to the more concise approach using the `apply` method.

```scala
class Mux4 extends Module {
  val io = IO(new Bundle {
    val in0 = Input(UInt(1.W))
    val in1 = Input(UInt(1.W))
    val in2 = Input(UInt(1.W))
    val in3 = Input(UInt(1.W))
    val sel = Input(UInt(2.W))
    val out = Output(UInt(1.W))
  })
  val m0 = Module(new Mux2)
  m0.io.sel := io.sel(0) 
  m0.io.in0 := io.in0
  m0.io.in1 := io.in1

  val m1 = Module(new Mux2)
  m1.io.sel := io.sel(0) 
  m1.io.in0 := io.in2
  m1.io.in1 := io.in3

  val m3 = Module(new Mux2)
  m3.io.sel := io.sel(1) 
  m3.io.in0 := m0.io.out
  m3.io.in1 := m1.io.out

  io.out := m3.io.out
}
```

--------------------------------

### Chisel Scala-style printf Basic Usage

Source: https://github.com/chipsalliance/chisel/wiki/Printing-in-Chisel

Demonstrates basic usage of Chisel's Scala-style `printf` with string interpolation for printing a UInt value. This method provides a concise way to embed Chisel hardware values directly into a string.

```scala
val myUInt = 33.U
printf(p"myUInt = $myUInt")
```

--------------------------------

### ChiselSim ScalaTest CLI Mix-in Traits for Extended Options

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/testing.md

This API documentation describes optional command line argument traits available in `chisel3.simulator.scalatest.Cli` that can be mixed into ChiselSim ScalaTest suites. These traits extend functionality to include options for FSDB/VPD waveform generation, test scaling, and selecting simulation backends like VCS or Verilator.

```APIDOC
chisel3.simulator.scalatest.Cli object traits:
  - EmitFsdb:
      Option: -DemitFsdb=1
      Description: Causes the simulator to generate an FSDB waveform if supported.
  - EmitVpd:
      Option: -DemitFsdb=1
      Description: Causes the simulator to generate an FSDB waveform if supported. (Note: Source text indicates -DemitFsdb=1 for both EmitFsdb and EmitVpd)
  - Scale:
      Option: -Dscale=<float>
      Description: Provides a way to scale a test up or down at test-time (e.g., to make it run longer). Accessed via the 'scaled' method.
  - Simulator:
      Option: -Dsimulator=<simulator-name>
      Description: Allows test-time selection of simulation backend (VCS or Verilator).
```

--------------------------------

### Generate Chisel Test Coverage Report with sbt

Source: https://github.com/chipsalliance/chisel/wiki/Test-Coverage

Use these sbt commands to first clean the project, then run all tests while collecting coverage data, and finally generate the comprehensive coverage report. The reports are output to `target/scala-x.yy/scoverage-report/`.

```sbt
sbt clean coverage test
sbt coverageReport
```

--------------------------------

### Import Chisel3 Library

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/dataview.md

Imports the core Chisel3 library for use in Scala projects. This provides access to Chisel's hardware description constructs and types.

```scala
import chisel3._
```

--------------------------------

### Chisel Module Definition and Verilog Generation using mdoc

Source: https://github.com/chipsalliance/chisel/blob/main/docs/README.md

Defines a simple Chisel `RawModule` in Scala, demonstrating input/output ports and basic combinational logic. The `mdoc:verilog` modifier is then used to invoke `ChiselStage.emitVerilog` on this module, generating its hardware description language (HDL) representation for documentation.

```scala
class MyModule extends RawModule {
  val in = IO(Input(UInt(8.W)))
  val out = IO(Output(UInt(8.W)))
  out := in + 1.U
}
```

```scala
ChiselStage.emitVerilog(new MyModule)
```

--------------------------------

### Chisel CLI: List Clock Signals

Source: https://github.com/chipsalliance/chisel/wiki/Running-Stuff

This command-line option enables listing the signals that drive each clock within a specified module and its descendents in a Chisel circuit. It requires the circuit, the target module, and an output filename to store the results. This helps in analyzing and debugging clocking schemes within complex designs.

```Shell
-clks -c:<circuit>:-m:<module>:-o:<filename>
```

```Shell
--list-clocks -c:<circuit>:-m:<module>:-o:<filename>
```

--------------------------------

### Chisel/Firrtl Annotation and Transform Imports

Source: https://github.com/chipsalliance/chisel/wiki/Annotations-Extending-Chisel-and-Firrtl

Essential Scala imports required for defining custom Chisel annotations, Firrtl transforms, and related internal components like InstanceId, CircuitForm, and Named.

```Scala
import chisel3._
import chisel3.internal.InstanceId
import firrtl.{CircuitForm, CircuitState, LowForm, Transform}
import firrtl.annotations.{Annotation, ModuleName, Named}
```

--------------------------------

### Configure SBT Project with Local Chisel Version

Source: https://github.com/chipsalliance/chisel/blob/main/README.md

Scala SBT configuration snippet to update `libraryDependencies` and `addCompilerPlugin` in a project's `build.sbt` file. This allows a project to use a locally published Chisel development version instead of a released one.

```scala
val chiselVersion = "7.0.0-M2+431-4798bea7-SNAPSHOT"
addCompilerPlugin("org.chipsalliance" % "chisel-plugin" % chiselVersion cross CrossVersion.full)
libraryDependencies += "org.chipsalliance" %% "chisel" % chiselVersion
```

--------------------------------

### Chisel Plugin Rewriting for Nested Hardware in Options

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/naming.md

Demonstrates the compiler plugin's ability to apply naming and prefixing to hardware types nested within Scala constructs like `Option`. Signals within the `Option` are correctly prefixed based on the `val` name holding the `Option`.

```Scala
class Example3 extends Module {
  val in = IO(Input(UInt(2.W)))
  // val in = withName("in")(prefix("in")(IO(Input(UInt(2.W)))))

  val out = IO(Output(UInt(4.W)))
  // val out = withName("out")(prefix("out")(IO(Output(UInt(4.W)))))

  def func() = {
    val delay = RegNext(in)
    delay + 1.U
  }

  val opt = Some(func())
  // Note that the register in func() is prefixed with `opt`:
  // val opt = withName("opt")(prefix("opt")(Some(func()))

  out := opt.get + 1.U
}
```

```Scala
emitSystemVerilog(new Example3)
```

--------------------------------

### Implement 3-point Moving Sum FIR Filter in Chisel

Source: https://github.com/chipsalliance/chisel/blob/main/README.md

Demonstrates a simple 3-point moving sum filter in Chisel, illustrating basic register usage and arithmetic operations similar to traditional Verilog.

```Scala
// 3-point moving sum implemented in the style of a FIR filter
class MovingSum3(bitWidth: Int) extends Module {
  val io = IO(new Bundle {
    val in = Input(UInt(bitWidth.W))
    val out = Output(UInt(bitWidth.W))
  })

  val z1 = RegNext(io.in)
  val z2 = RegNext(z1)

  io.out := (io.in * 1.U) + (z1 * 1.U) + (z2 * 1.U)
}
```

--------------------------------

### Initialize a Chisel register with a Vec literal

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/appendix/experimental-features.md

Demonstrates how to initialize a Chisel register (`RegInit`) using a `Vec` literal. This allows for direct assignment of initial values to all elements of a `Vec` register upon reset or power-up.

```scala
import chisel3._
import chisel3.experimental.VecLiterals._

class VecExample3 extends Module {
  val out = IO(Output(Vec(4, UInt(8.W))))
  val y = RegInit(
    Vec(4, UInt(8.W)).Lit(0 -> 0xAB.U(8.W), 1 -> 0xCD.U(8.W), 2 -> 0xEF.U(8.W), 3 -> 0xFF.U(8.W))
  )
  out := y
}
```

```verilog
// Verilog output for the above Chisel code (generated by mdoc:verilog)
// Actual Verilog content not provided in source text.
```

--------------------------------

### Chisel CLI: Replace Sequential Memories

Source: https://github.com/chipsalliance/chisel/wiki/Running-Stuff

This command-line option allows users to replace sequential memories within a Chisel circuit with blackboxes. It requires specifying the input circuit, an input filename for configuration, and an output filename for the modified circuit. This is useful for abstracting memory implementations for simulation or synthesis.

```Shell
-frsq -c:<circuit>:-i:<filename>:-o:<filename>
```

```Shell
--repl-seq-mem -c:<circuit>:-i:<filename>:-o:<filename>
```

--------------------------------

### Load VCD File from Repl Prompt

Source: https://github.com/chipsalliance/chisel/wiki/Debugging-with-the-Interpreter-REPL-3

This Repl command loads a specified VCD file from within the Repl prompt, making its contents available as a driving input for simulation. This provides an alternative to loading via command line flags at startup.

```Repl
vcd load test_run_dir/gcd.GCDMain2061991994/GCD.vcd
```

--------------------------------

### Chisel: Generate SRAM with Configurable Ports

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/memories.md

This snippet demonstrates the use of the `SRAM` API to generate a memory with a specified number of read, write, and read-write ports. It shows how to instantiate an `SRAMInterface` and connect it to an `SRAM` instance.

```Scala
import chisel3.util._

class ModuleWithSRAM(numReadPorts: Int, numWritePorts: Int, numReadwritePorts: Int) extends Module {
  val width: Int = 8

  val io = IO(new SRAMInterface(1024, UInt(width.W), numReadPorts, numWritePorts, numReadwritePorts))

  // Generate a SyncReadMem representing an SRAM with an explicit number of read, write, and read-write ports
  io :<>= SRAM(1024, UInt(width.W), numReadPorts, numWritePorts, numReadwritePorts)
}
```

--------------------------------

### Chisel Bundle with Input/Output for Non-Aggregate Types

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/connectable.md

This snippet demonstrates the use of `Input` and `Output` with non-aggregate Chisel types (`UInt`). It shows how `Output(UInt)` is equivalent to `UInt` and `Input(UInt)` is equivalent to `Flipped(UInt)` for non-aggregate types, within a `Bundle` and a `Module` context.

```scala
import chisel3._
class ParentWithOutputInput extends Bundle {
  val alignedCoerced = Output(UInt(32.W)) // Equivalent to just UInt(32.W)
  val flippedCoerced = Input(UInt(32.W))  // Equivalent to Flipped(UInt(32.W))
}
class MyModule2 extends Module {
  val p = Wire(new ParentWithOutputInput)
}
```

--------------------------------

### Generate Verilog from Chisel DataView Connection

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/dataview.md

Shows the resulting Verilog from a Chisel design that uses `DataView` to connect different `Bundle` types. This confirms that `DataView` correctly maps and connects corresponding fields in the generated hardware description, ensuring proper signal routing.

```Scala
chisel3.docs.emitSystemVerilog
```

--------------------------------

### Connect Chisel Records with Defaults and Waived Members

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/connectable.md

Demonstrates how to connect two Chisel `Record`s using the `:<>=` operator. It shows how to initialize all members to default values and then selectively waive connections for non-matching members using `.waive`, ensuring only common members are connected while others retain their defaults.

```Scala
import scala.collection.immutable.SeqMap

class Example10 extends RawModule {
  val abType = new Record { val elements = SeqMap("a" -> Bool(), "b" -> Flipped(Bool())) }
  val bcType = new Record { val elements = SeqMap("b" -> Flipped(Bool()), "c" -> Bool()) }

  val p = Wire(abType)
  val c = Wire(bcType)

  dontTouch(p) // So it doesn't get constant-propped away for the example
  dontTouch(c) // So it doesn't get constant-propped away for the example

  p :#= abType.Lit(_.elements("a") -> true.B, _.elements("b") -> true.B)
  c :#= bcType.Lit(_.elements("b") -> true.B, _.elements("c") -> true.B)

  c.waive(_.elements("c")) :<>= p.waive(_.elements("a"))
}
```

```Scala
chisel3.docs.emitSystemVerilog(new Example10)
```

--------------------------------

### Launch Firrtl Interpreter REPL in Scala

Source: https://github.com/chipsalliance/chisel/wiki/Debugging-with-the-Interpreter-REPL-1

This Scala object, `GCDRepl`, uses `iotesters.Driver.executeFirrtlRepl` to launch the firrtl-interpreter REPL. It provides an interactive shell for debugging lowered FIRRTL generated by a Chisel circuit, useful for inspecting circuit state and behavior. The `GCD` class is used as the circuit to be elaborated.

```Scala
/**
  * This provides a way to ruin the firrtl-interpreter REPL (or shell)
  * on the lowered firrtl generated by your circuit. You will be placed
  * in an interactive shell. This can be very helpful as a debugging
  * technique. Type help to see a list of commands.
  */
object GCDRepl extends App {
  iotesters.Driver.executeFirrtlRepl(args, () => new GCD)
}
```

--------------------------------

### Verilog Implementation for Chisel BlackBoxRealAdd

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/blackboxes.md

Provides the Verilog module implementation for the `BlackBoxRealAdd` defined in Chisel. It demonstrates the use of Verilog system functions `$realtobits` and `$bitstoreal` for performing real number arithmetic on 64-bit unsigned integer inputs.

```verilog
module BlackBoxRealAdd(
    input  [63:0] in1,
    input  [63:0] in2,
    output reg [63:0] out
);
  always @* begin
    out <= $realtobits($bitstoreal(in1) + $bitstoreal(in2));
  end
endmodule
```

--------------------------------

### Chisel Object for SystemVerilog File Emission

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/resources/faqs.md

This Scala object utilizes `circt.stage.ChiselStage` to emit SystemVerilog for the `HelloWorld` module, providing a main entry point for file generation.

```scala
import circt.stage.ChiselStage
object VerilogMain extends App {
  ChiselStage.emitSystemVerilog(new HelloWorld)
}
```

--------------------------------

### FIRRTL Attribute API Functions

Source: https://github.com/chipsalliance/chisel/blob/main/circtpanamabinding/includeFunctions.txt

Lists API functions for handling FIRRTL-specific attributes such as port directions, parameter declarations, conventions, and memory initialization. These attributes provide metadata and configuration for FIRRTL constructs.

```APIDOC
firrtlAttrGetPortDirs()
firrtlAttrGetParamDecl()
firrtlAttrGetConvention()
firrtlAttrGetNameKind()
firrtlAttrGetRUW()
firrtlAttrGetMemoryInit()
firrtlAttrGetMemDir()
firrtlAttrGetIntegerFromString()
```

--------------------------------

### Object Graph for Single CSR Description from Specific Module

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/properties.md

This JSON snippet shows the object graph when elaborating a single `CSRModule` (e.g., 'minstret'). It presents a single `CSRDescription` object with its `identifier`, `description`, and `width` properties, demonstrating the view of the object graph from a specific module's output.

```APIDOC
{
  "description": {
    "identifier": "minstret",
    "description": "Machine instructions-retired counter.",
    "width": 64
  }
}
```

--------------------------------

### Define SyncReadMem with Separate Read and Write Ports in Chisel

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/memories.md

This Chisel module `ReadWriteSmem` demonstrates the creation of a `SyncReadMem` (synchronous-read, synchronous-write memory) with distinct read and write ports. It shows how to instantiate a memory, define its I/O bundle, and use `mem.write` and `mem.read` for separate operations.

```Scala
import chisel3._
class ReadWriteSmem extends Module {
  val width: Int = 32
  val io = IO(new Bundle {
    val enable = Input(Bool())
    val write = Input(Bool())
    val addr = Input(UInt(10.W))
    val dataIn = Input(UInt(width.W))
    val dataOut = Output(UInt(width.W))
  })

  val mem = SyncReadMem(1024, UInt(width.W))
  // Create one write port and one read port
  mem.write(io.addr, io.dataIn)
  io.dataOut := mem.read(io.addr, io.enable)
}
```

--------------------------------

### Emit SystemVerilog for `PartialDataViewModule`

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/dataview.md

Confirms the successful generation of SystemVerilog for the `PartialDataViewModule`, demonstrating that `PartialDataView` correctly handles partial mappings.

```scala
chisel3.docs.emitSystemVerilog(new PartialDataViewModule)
```

--------------------------------

### Generate Firtool Release Version Table (Scala)

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/appendix/versioning.md

Scala code snippet used by `mdoc` to dynamically generate the Firtool release version compatibility table for Chisel documentation. It calls `FirtoolVersionsTable.releaseTable`.

```Scala
// This table is generated by SBT
println(FirtoolVersionsTable.releaseTable)
```

--------------------------------

### Chisel Register Instantiation for Specific Width

Source: https://github.com/chipsalliance/chisel/wiki/Scala-land-vs.-Chisel-land

This Chisel snippet demonstrates the correct way to create a register with a specific width, derived from a value (e.g., 42) but without initializing it to that value. `UInt(log2Up(42).W)` explicitly defines the width based on the number of bits required for 42, ensuring the register has the correct size.

```Scala
  val accumulator = Reg(UInt(log2Up(42).W))
```

--------------------------------

### Generate Verilog from Chisel Design using DataView

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/dataview.md

Shows the Verilog output generated from a Chisel module that utilizes `DataView`. This confirms that `DataView` enables structured Chisel code to produce Verilog with standard naming conventions, bridging the gap between Chisel's type system and Verilog's flat signals.

```Scala
chisel3.docs.emitSystemVerilog(new AXIStub)
```

--------------------------------

### Defining a Generic Scala Procedure

Source: https://github.com/chipsalliance/chisel/wiki/CS250-Chisel+Scala-Primer

Shows the syntax for defining a procedure in Scala, which is a function that does not return a value (i.e., its return type is Unit). The procedure body is enclosed in curly braces.

```Scala
def procedureName(a: Type, b: AnotherType) {procedure body …}
```

--------------------------------

### Generated Verilog for Chisel LED Blinker

Source: https://github.com/chipsalliance/chisel/blob/main/README.md

This SystemVerilog code is automatically generated from the Chisel `Blinky` module. It describes the hardware implementation of the LED blinker, including the `led` register for the LED state and `counterWrap_c_value` for the frequency division logic. This output demonstrates the synthesis result of the Chisel design.

```verilog
// Generated by CIRCT firtool-1.37.0
module Blinky(
  input  clock,
         reset,
  output io_led0
);

  reg       led;
  reg [8:0] counterWrap_c_value;
  always @(posedge clock) begin
    if (reset) begin
      led <= 1'h0;
      counterWrap_c_value <= 9'h0;
    end
    else begin
      automatic logic counterWrap = counterWrap_c_value == 9'h1F3;
      led <= counterWrap ^ led;
      if (counterWrap)
        counterWrap_c_value <= 9'h0;
      else
        counterWrap_c_value <= counterWrap_c_value + 9'h1;
    end
  end // always @(posedge)
  assign io_led0 = led;
endmodule
```

--------------------------------

### Chisel Plugin Rewriting for Internal Signals and Functions

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/naming.md

Illustrates the compiler plugin's behavior for general `val` declarations and signals created within functions. It shows how `withName` and `prefix` are applied to ensure proper naming and hierarchical prefixing of intermediate values and function returns.

```Scala
class Example2 extends Module {
  val in = IO(Input(UInt(2.W)))
  // val in = withName("in")(prefix("in")(IO(Input(UInt(2.W)))))

  val out1 = IO(Output(UInt(4.W)))
  // val out1 = withName("out1")(prefix("out1")(IO(Output(UInt(4.W)))))
  val out2 = IO(Output(UInt(4.W)))
  // val out2 = withName("out2")(prefix("out2")(IO(Output(UInt(4.W)))))
  val out3 = IO(Output(UInt(4.W)))
  // val out3 = withName("out3")(prefix("out3")(IO(Output(UInt(4.W)))))

  def func() = {
    val squared = in * in
    // val squared = withName("squared")(prefix("squared")(in * in))
    out1 := squared
    val delay = RegNext(squared)
    // val delay = withName("delay")(prefix("delay")(RegNext(squared)))
    delay
  }

  val masked = 0xa.U & func()
  // val masked = withName("masked")(prefix("masked")(0xa.U & func()))
  // Note that values created inside of `func()`` are prefixed with `masked`

  out2 := masked + 1.U
  out3 := masked - 1.U
}
```

```Scala
emitSystemVerilog(new Example2)
```

--------------------------------

### Initialize Chisel Memory Inline from External File

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/appendix/experimental-features.md

Demonstrates how to initialize a Chisel SyncReadMem using loadMemoryFromFileInline. This function generates inline readmemh or readmemb statements in the output Verilog, allowing synthesis tools to load memory contents from a specified external file. Chisel does not validate the file content or location.

```scala
import chisel3._
import chisel3.util.experimental.loadMemoryFromFileInline

class InitMemInline(memoryFile: String = "") extends Module {
  val width: Int = 32
  val io = IO(new Bundle {
    val enable = Input(Bool())
    val write = Input(Bool())
    val addr = Input(UInt(10.W))
    val dataIn = Input(UInt(width.W))
    val dataOut = Output(UInt(width.W))
  })

  val mem = SyncReadMem(1024, UInt(width.W))
  // Initialize memory
  if (memoryFile.trim().nonEmpty) {
    loadMemoryFromFileInline(mem, memoryFile)
  }
  io.dataOut := DontCare
  when(io.enable) {
    val rdwrPort = mem(io.addr)
    when (io.write) { rdwrPort := io.dataIn }
      .otherwise    { io.dataOut := rdwrPort }
  }
}
```

--------------------------------

### Chisel Repl: Poke Internal Register and Show

Source: https://github.com/chipsalliance/chisel/wiki/Debugging-with-the-Interpreter-REPL-2

Demonstrates attempting to directly set an internal register (`y`) in the Chisel Repl and immediately showing the state, as a way to further probe a suspected issue with an internal signal.

```Chisel Repl
poke y 29 ; show
```

--------------------------------

### Chisel `Bundle` Using 0-arity Function Parameters to Prevent Aliasing

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/cookbook.md

Introduces the first solution: defining `UsingAFunctionBundle` where `gen` is a 0-arity function `() => T`. By calling `gen()` for each field, `foo` and `bar` are guaranteed to be fresh, distinct instances, resolving the aliasing problem.

```scala
class UsingAFunctionBundle[T <: Data](gen: () => T) extends Bundle {
  val foo = gen()
  val bar = gen()
}
```

--------------------------------

### Manual sbt Commands for Chisel Code Coverage

Source: https://github.com/chipsalliance/chisel/wiki/Chisel-Developer-Stuff

If the automated `make coverage` command encounters issues or for more granular control, use this sequence of sbt commands. This workflow allows you to manually trigger coverage collection, run tests, and generate aggregated reports within the sbt shell.

```sbt
sbt
coverage
test
coverageReport
coverageAggregate
```

--------------------------------

### Configure build.sbt for ChiselFrontend Coverage

Source: https://github.com/chipsalliance/chisel/wiki/Chisel-Developer-Stuff

To ensure `chiselFrontend` is included in the scoverage report, modify the `aggregate` setting in your local `build.sbt` file to `true`. This enables aggregation of coverage data across sub-projects.

```Scala
aggregate := true,
```

--------------------------------

### Chisel BlackBox with External Verilog Resource File

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/blackboxes.md

Shows how to link a Chisel `BlackBox` to an external Verilog file using the `HasBlackBoxResource` trait and `addResource` method. The Verilog implementation is expected to be located in a specified resource path, typically `src/main/resources/real_math.v`.

```scala
import chisel3._
import chisel3.util.HasBlackBoxResource

class BlackBoxRealAdd extends BlackBox with HasBlackBoxResource {
  val io = IO(new Bundle {
    val in1 = Input(UInt(64.W))
    val in2 = Input(UInt(64.W))
    val out = Output(UInt(64.W))
  })
  addResource("/real_math.v")
}
```

--------------------------------

### Incorrect Chisel Vector Register Instantiation for Initialization

Source: https://github.com/chipsalliance/chisel/wiki/Scala-land-vs.-Chisel-land

This Chisel snippet illustrates an incorrect approach to initializing a vector of registers. `Reg(Vec(100, true.B))` creates a vector of 100 Boolean registers, but `true.B` is only used to infer the type (Bool), not to initialize each element to true. The elements remain uninitialized.

```Scala
  val found = Reg(Vec(100, true.B))
```

--------------------------------

### Run Lit Tests with Mill

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/developers/lit-test.md

Command to execute all Lit test cases using the Mill build tool. This requires the `JAVA_HOME` environment variable to be set to a Java 21 runtime environment.

```Shell
mill -i lit[_].run
```

--------------------------------

### MLIR Core API Functions

Source: https://github.com/chipsalliance/chisel/blob/main/circtpanamabinding/includeFunctions.txt

Provides a comprehensive list of core MLIR (Multi-Level Intermediate Representation) API functions for context management, module creation, operation manipulation, attribute handling, type creation, and pass manager operations. These functions are fundamental for interacting with MLIR's internal structures.

```APIDOC
mlirContextCreate()
mlirContextDestroy()
mlirGetDialectHandle__firrtl__()
mlirGetDialectHandle__chirrtl__()
mlirGetDialectHandle__sv__()
mlirGetDialectHandle__seq__()
mlirGetDialectHandle__emit__()
mlirDialectHandleLoadDialect()
mlirStringRefCreateFromCString()
mlirLocationGetAttribute()
mlirLocationUnknownGet()
mlirLocationFileLineColGet()
mlirModuleCreateEmpty()
mlirModuleCreateParse()
mlirModuleFromOperation()
mlirModuleDestroy()
mlirModuleGetBody()
mlirModuleGetOperation()
mlirOperationStateGet()
mlirNamedAttributeGet()
mlirAttributeIsAInteger()
mlirAttributeIsAFloat()
mlirAttributeIsABool()
mlirAttributeIsAString()
mlirIntegerAttrGet()
mlirIntegerAttrGetValueInt()
mlirIntegerAttrGetValueSInt()
mlirIntegerAttrGetValueUInt()
mlirFloatAttrDoubleGet()
mlirFloatAttrGetValueDouble()
mlirBoolAttrGet()
mlirBoolAttrGetValue()
mlirStringAttrGet()
mlirStringAttrGetValue()
mlirArrayAttrGet()
mlirTypeAttrGet()
mlirArrayAttrGetNumElements()
mlirArrayAttrGetElement()
mlirUnitAttrGet()
mlirIntegerTypeGet()
mlirIntegerTypeUnsignedGet()
mlirIntegerTypeSignedGet()
mlirF64TypeGet()
mlirNoneTypeGet()
mlirIdentifierGet()
mlirFlatSymbolRefAttrGet()
mlirValueGetType()
mlirAttributeDump()
mlirOperationStateAddOperands()
mlirOperationStateAddResults()
mlirOperationStateAddAttributes()
mlirOperationStateEnableResultTypeInference()
mlirOperationGetResult()
mlirOperationGetAttributeByName()
mlirOperationSetInherentAttributeByName()
mlirRegionCreate()
mlirOperationCreate()
mlirBlockCreate()
mlirBlockGetArgument()
mlirBlockGetFirstOperation()
mlirBlockAppendOwnedOperation()
mlirBlockInsertOwnedOperationAfter()
mlirBlockInsertOwnedOperationBefore()
mlirRegionAppendOwnedBlock()
mlirOperationStateAddOwnedRegions()
mlirOperationPrint()
mlirOperationWriteBytecode()
mlirExportFIRRTL()
mlirPassManagerCreate()
mlirPassManagerCreateOnOperation()
mlirPassManagerDestroy()
mlirPassManagerGetNestedUnder()
mlirPassManagerRunOnOp()
mlirPassManagerAddOwnedPass()
mlirOpPassManagerGetNestedUnder()
mlirOpPassManagerAddOwnedPass()
```

--------------------------------

### Scala Package Declaration

Source: https://github.com/chipsalliance/chisel/wiki/Scala-Things-You-Should-Know

Illustrates how to declare a package in a Scala source file, which is crucial for organizing code hierarchically. It also notes the convention of matching the directory structure and using lowercase names without separators.

```Scala
package mytools
class Tool1 { ... }
```

--------------------------------

### Chisel Plugin Rewriting for Unapply Patterns

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/naming.md

Illustrates how the Chisel compiler plugin handles `val` declarations using unapply patterns for multiple assignments. `withName` is applied to each element of the tuple, allowing individual naming of signals extracted via pattern matching.

```Scala
class UnapplyExample extends Module {
  val foo = IO(Input(UInt(2.W)))
  def mkIO() = (IO(Input(UInt(2.W))), foo, IO(Output(UInt(2.W))))
  val (in, _, out) = mkIO()
  // val (in, _, out) = withName("in", "", "out")(mkIO())

  out := in & foo
}
```

```Scala
emitSystemVerilog(new UnapplyExample)
```

--------------------------------

### Generate Error for Chisel ':=' Operator Test

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/connection-operators.md

Command to attempt emitting SystemVerilog for the `Wrapper` module using the `:=` operator, which is expected to result in a compilation error due to incorrect signal directions, demonstrating the strict assignment behavior of `:='.

```Scala
circt.stage.ChiselStage.emitSystemVerilog(new Wrapper)
```

--------------------------------

### svsim Makefile Targets for Simulation Rebuild and Replay

Source: https://github.com/chipsalliance/chisel/blob/main/svsim/README.md

Explains the utility of `Makefile` targets generated by `svsim` for development workflow. `make simulation` allows recompiling the simulation without re-running the Scala driver, picking up changes in source or arguments. `make replay` rebuilds and re-executes captured simulation commands from `execution-script.txt`.

```APIDOC
make simulation:
  Purpose: Rebuilds the simulation executable.
  Behavior: Recompiles based on modifications to `generated-sources`, `primary-sources`, or `workdir-$tag/Makefile` without needing to re-run the Scala driver.

make replay:
  Purpose: Rebuilds the simulation and re-executes previously captured commands.
  Behavior: Recompiles the simulation and then replays commands from `execution-script.txt` (emitted by default during `Simulation` runs). Useful for replaying tests with source modifications.
```

--------------------------------

### Create nested Bundle literals in Chisel

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/appendix/experimental-features.md

Shows how to construct arbitrarily nested Bundle literals. It defines `ChildBundle` and `ParentBundle` and initializes a `ParentBundle` instance with a nested `ChildBundle` literal, demonstrating complex data structure initialization.

```scala
import chisel3._
import chisel3.experimental.BundleLiterals._

class ChildBundle extends Bundle {
  val foo = UInt(8.W)
}

class ParentBundle extends Bundle {
  val a = UInt(8.W)
  val b = new ChildBundle
}

class Example3 extends RawModule {
  val out = IO(Output(new ParentBundle))
  out := (new ParentBundle).Lit(_.a -> 123.U, _.b -> (new ChildBundle).Lit(_.foo -> 42.U))
}
```

```verilog
// Verilog output for the above Chisel code (generated by mdoc:verilog)
// Actual Verilog content not provided in source text.
```

--------------------------------

### Demonstrate Scala Pattern Matching with Component Display Logic

Source: https://github.com/chipsalliance/chisel/wiki/Scala-Things-You-Should-Know

This code defines a `System` class that processes a list of `Component` objects. The `displayComponents` method utilizes Scala's `match` statement to perform type-safe pattern matching. It showcases various matching patterns, including specific value matching, variable extraction, and wildcard usage, to display information about different component types.

```scala
class System(val components: List[Component]) {
  def displayComponents(): Unit = {
    components.foreach {
      case Monitor("BrandX", size, _) =>
        // brandx is square, lists horizontal size, all are 60Hz
        val diag = size * 1.414
        println(s"monitor BrandX of diagonal size $diag scan rate is 60")
      case Monitor(name, size, scan) =>
        println(s"monitor $name of diagonal size $size scan rate $scan")
      case Keyboard(name, keys) =>
        println(s"keyboard $name with $keys keys")
      case _: Mouse =>
        println("There is a mouse")
      case x: Component =>
        println(s"unknown component ${x.name}")
    }
  }
}
```

--------------------------------

### Scala If-Else Conditional Statement

Source: https://github.com/chipsalliance/chisel/wiki/CS250-Chisel+Scala-Primer

Illustrates the basic if-else if-else conditional structure in Scala, which is similar to Java's syntax.

```Scala
if(n < len) {
  //do something}
} else if(n == len) {
  //do something
} else {
  //do something
}
```

--------------------------------

### Chisel Repl: Current State Output

Source: https://github.com/chipsalliance/chisel/wiki/Debugging-with-the-Interpreter-REPL-2

Displays the output from the `show` command in the Chisel Repl, revealing the current values of inputs, outputs, and internal registers, which helps in diagnosing unexpected behavior.

```console
Inputs: clock= 0, io_loadingValues= 1, io_value1= 13, io_value2= 29, reset= 0
Outputs: io_outputGCD= 13, io_outputValid= 0
Registers      : x= 13, y= 13
```

--------------------------------

### Chisel Warning Configuration Filters

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/warnings.md

Defines the available filters for Chisel warning configuration. Filters determine which warnings a specific action applies to, including `any`, `id=<integer>`, and `src=<glob>`. Filters can be combined using `&`.

```APIDOC
Filters:
  - any:
      Description: Matches all warnings.
  - id=<integer>:
      Description: Matches warnings with the integer ID.
  - src=<glob>:
      Description: Matches warnings when <glob> matches the source locator filename where the warning occurs.
Combinations:
  - id & src: Can be combined. At most one 'id' and one 'src' allowed.
  - any: Cannot be combined with any other filters.
```

--------------------------------

### Chisel `Top` Module Definition for Testing Bundles

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/cookbook.md

Defines a generic `Top` module in Chisel that takes a `Data` type `T` as input and output. This module is used throughout the document to test various `Bundle` implementations and demonstrate their behavior regarding aliasing.

```scala
import chisel3._

class Top[T <: Data](gen: T) extends Module {
  val in = IO(Input(gen))
  val out = IO(Output(gen))
  out := in
}
```

--------------------------------

### Chisel Scala-style printf with Format Specifiers

Source: https://github.com/chipsalliance/chisel/wiki/Printing-in-Chisel

Shows how to use `Hexadecimal`, `Binary`, and `Character` format specifiers with Chisel's Scala-style `printf` for different output representations. These functions allow explicit control over how hardware values are displayed.

```scala
// Hexadecimal
printf(p"myUInt = 0x${Hexadecimal(myUInt)}")
// Binary
printf(p"myUInt = ${Binary(myUInt)}")
// Character
printf(p"myUInt = ${Character(myUInt)}")
```

--------------------------------

### Hardware Instance Graph Types

Source: https://github.com/chipsalliance/chisel/blob/main/circtpanamabinding/includeStructs.txt

Defines the types used to represent and navigate hardware instance graphs, which model the hierarchical structure of a hardware design.

```APIDOC
HWInstanceGraph
HWInstanceGraphNode
```

--------------------------------

### Define Scala Trait and Case Classes for Component Hierarchy

Source: https://github.com/chipsalliance/chisel/wiki/Scala-Things-You-Should-Know

This snippet establishes a `Component` trait as a base interface. It then defines several case classes (`Monitor`, `Keyboard`, `Mouse`) that extend `Component`, each encapsulating specific properties. These classes serve as the data structure for demonstrating Scala's powerful pattern matching capabilities.

```scala
trait Component { def name: String }
case class Monitor(name: String, diagonal: Double, scanRate: Int) extends Component
case class Keyboard(name: String, numberOfKeys: Int) extends Component
case class Mouse(name: String) extends Component
```

--------------------------------

### Scala Anonymous Function with Underscore Syntax

Source: https://github.com/chipsalliance/chisel/wiki/CS250-Chisel+Scala-Primer

Illustrates the syntactic sugar for anonymous functions in Scala using the underscore (_) as a positional argument placeholder. This concise syntax is applied within a higher-order function call, yielding the same result as an explicit lambda.

```scala
def highOrder(a: Int, b: Int, c:Int, fun:(Int,Int) => Int) = {
	val tmp1 = fun(a, b)
	val tmp2 = fun(b, c)
	fun(tmp1, tmp2)
}

val result = highOrder(2, 5, 7, _+_)
// result: Int = 19
```

--------------------------------

### Chisel Scala-style printf with Custom Bundle Printing

Source: https://github.com/chipsalliance/chisel/wiki/Printing-in-Chisel

Defines a custom `Message` Bundle with an overridden `toPrintable` method to provide custom formatting for `printf` output. This demonstrates how users can control the string representation of their custom hardware structures.

```scala
class Message extends Bundle {
  val valid = Bool()
  val addr = UInt(32.W)
  val length = UInt(4.W)
  val data = UInt(64.W)
  override def toPrintable: Printable = {
    val char = Mux(valid, 'v'.U, '-'.U)
    p"Message:\n" +
    p"  valid  : ${Character(char)}\n" +
    p"  addr   : 0x${Hexadecimal(addr)}\n" +
    p"  length : $length\n" +
    p"  data   : 0x${Hexadecimal(data)}\n"
  }
}

val myMessage = Wire(new Message)
myMessage.valid := true.B
myMessage.addr := "h1234".U
myMessage.length := 10.U
myMessage.data := "hdeadbeef".U

printf(p"$myMessage")
```

--------------------------------

### Define Synchronous Read/Write Memory (SyncReadMem) in Chisel

Source: https://github.com/chipsalliance/chisel/wiki/Memories

Illustrates how to create a 1024-entry register file with one write port and one synchronous read port using `SyncReadMem`. This construct is suitable for memories that will likely be synthesized to technology SRAMs, common in FPGAs.

```Scala
val width:Int = 32
val addr = Wire(UInt(width.W))
val dataIn = Wire(UInt(width.W))
val dataOut = Wire(UInt(width.W))
val enable = Wire(Bool())

// assign data...

// Create a synchronous-read, synchronous-write memory (like in FPGAs).
val mem = SyncReadMem(1024, UInt(width.W))
// Create one write port and one read port.
mem.write(addr, dataIn)
dataOut := mem.read(addr, enable)
```

--------------------------------

### Chisel Workaround for Dynamic Indexing Signal Naming Loss using WireInit

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/cookbook.md

This Scala code demonstrates a workaround to preserve signal names when using dynamic indexing in Chisel. By wrapping the dynamically indexed expression with `WireInit`, the `x` signal retains its name in the generated hardware, preventing generic names like `_GEN_3`. The full module `Foo2` illustrates the application of this workaround.

```Scala
val x = WireInit(io.in(io.idx))
```

```Scala
class Foo2 extends Module {
  val io = IO(new Bundle {
    val in = Input(Vec(4, Bool()))
    val idx = Input(UInt(2.W))
    val en = Input(Bool())
    val out = Output(Bool())
  })

  val x = WireInit(io.in(io.idx))
  val y = x && io.en
  io.out := y
}
```

```Scala
chisel3.docs.emitSystemVerilog(new Foo2)
```

--------------------------------

### Verilog Output for viewAsSupertype Connection

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/connectable.md

Shows the SystemVerilog generated from Example12, confirming that the bits fields are not connected when .viewAsSupertype is used, as the view omits them.

```Verilog
chisel3.docs.emitSystemVerilog(new Example12)
```

--------------------------------

### Define a Chisel Module with FilterIO Interface

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/interfaces-and-connections.md

Defines a `Filter` module, instantiating its I/O bundle using the previously defined `FilterIO` interface. This shows how a module's external connections are defined by an interface bundle.

```scala
class Filter extends Module {
  val io = IO(new FilterIO)
  // ...
}
```

--------------------------------

### Create a Scala Annotation Factory for IdentityTransform

Source: https://github.com/chipsalliance/chisel/wiki/Annotations-Extending-Chisel-and-Firrtl

Defines a Scala object `IdentityAnnotation` that acts as a factory for creating `Annotation` instances linked to the `IdentityTransform`. It includes an `apply` method for easy annotation creation and an `unapply` method for pattern matching and extracting information from existing annotations.

```Scala
object IdentityAnnotation {
  def apply(target: Named, value: String): Annotation = Annotation(target, classOf[IdentityTransform], value)

  def unapply(a: Annotation): Option[(Named, String)] = a match {
    case Annotation(named, t, value) if t == classOf[IdentityTransform] => Some((named, value))
    case _ => None
  }
}
```

--------------------------------

### Chisel Connection Operators Reference

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/connectable.md

Reference for the standard `Connectable` operators in Chisel, detailing their syntax, behavior, and the meaning of their constituent symbols for connecting hardware components with varying structural and directional properties.

```APIDOC
Chisel Connectable Operators:

c := p (mono-direction)
  - Connects all 'p' members to 'c'.
  - Requires 'c' and 'p' to not have any flipped members.

c :#= p (coercing mono-direction)
  - Connects all 'p' members to 'c'.
  - Ignores alignment.

c :<= p (aligned-direction)
  - Connects all aligned (non-flipped) 'c' members from 'p'.
  - Drives members producer-to-consumer (right-to-left).

c :>= p (flipped-direction)
  - Connects all flipped 'p' members from 'c'.
  - Drives members consumer-to-producer (left-to-right).

c :<>= p (bi-direction operator)
  - Connects all aligned 'c' members from 'p'.
  - Connects all flipped 'p' members from 'c'.
  - Drives members both producer-to-consumer and consumer-to-producer.

Symbol Semantics:
  :   - Indicates the consumer (left-hand-side) of the operator.
  =   - Indicates the producer (right-hand-side) of the operator.
  <   - Indicates members driven producer-to-consumer (right-to-left).
  >   - Indicates members driven consumer-to-producer (left-to-right).
  #   - Indicates ignoring member alignment and driving producer-to-consumer.
```

--------------------------------

### Implement Generic FIFO Module

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/polymorphism-and-parameterization.md

Provides a complete implementation of a generic First-In, First-Out (FIFO) buffer in Chisel. The FIFO is parameterized by a data type T and its depth n, demonstrating how to manage read/write pointers, full/empty conditions, and memory access for a generic data type.

```Scala
import chisel3.util.log2Up

class Fifo[T <: Data](gen: T, n: Int) extends Module {
  val io = IO(new Bundle {
    val enqVal = Input(Bool())
    val enqRdy = Output(Bool())
    val deqVal = Output(Bool())
    val deqRdy = Input(Bool())
    val enqDat = Input(gen)
    val deqDat = Output(gen)
  })
  val enqPtr     = RegInit(0.U((log2Up(n)).W))
  val deqPtr     = RegInit(0.U((log2Up(n)).W))
  val isFull     = RegInit(false.B)
  val doEnq      = io.enqRdy && io.enqVal
  val doDeq      = io.deqRdy && io.deqVal
  val isEmpty    = !isFull && (enqPtr === deqPtr)
  val deqPtrInc  = deqPtr + 1.U
  val enqPtrInc  = enqPtr + 1.U
  val isFullNext = Mux(doEnq && ~doDeq && (enqPtrInc === deqPtr),
                         true.B, Mux(doDeq && isFull, false.B,
                         isFull))
  enqPtr := Mux(doEnq, enqPtrInc, enqPtr)
  deqPtr := Mux(doDeq, deqPtrInc, deqPtr)
  isFull := isFullNext
  val ram = Mem(n, gen)
  when (doEnq) {
    ram(enqPtr) := io.enqDat
  }
  io.enqRdy := !isFull
  io.deqVal := !isEmpty
  ram(deqPtr) <> io.deqDat
}
```

--------------------------------

### Chisel3 I/O Without Prefix using Multiple IO Calls

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/cookbook.md

By calling IO multiple times for individual input and output signals, Chisel automatically creates top-level ports without an io_ prefix. This is the simplest way to define module ports directly.

```Scala
import chisel3._

class MyModule extends Module {
  val in = IO(Input(UInt(8.W)))
  val out = IO(Output(UInt(8.W)))

  out := in +% 1.U
}
```

```Verilog
module MyModule(
  input  [7:0] in,
  output [7:0] out
);
  assign out = in + 8'h1;
endmodule
```

--------------------------------

### Define a Simple Handshaking Interface (SimpleLink)

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/interfaces-and-connections.md

Defines a `SimpleLink` interface by subclassing `Bundle`. This interface includes `data` (a 16-bit unsigned integer output) and `valid` (a Boolean output) signals, commonly used for basic handshaking protocols.

```scala
class SimpleLink extends Bundle {
  val data = Output(UInt(16.W))
  val valid = Output(Bool())
}
```

--------------------------------

### Chisel3 API: Type Cloning and Hardware Object Immutability

Source: https://github.com/chipsalliance/chisel/wiki/release-notes-17-10-06

Documents significant changes to Chisel's internal and external APIs for type handling. It clarifies the deprecation of `chiselCloneType`, the internal marking of `cloneType`, and introduces `chiselTypeOf(data)` as the new external API. The section emphasizes the immutable nature of Chisel types and hardware objects, explaining how operations like `Input`, `Output`, and `Reg` return copies.

```APIDOC
API Changes for Type Handling:

- cloneType:
    Status: Internal API (marked through comments only).
    Purpose: Internal mechanism for type cloning.

- chiselCloneType:
    Status: Deprecated.
    Replacement: Internally changed to cloneTypeFull (analogous to cloneTypeWidth).

- chiselTypeOf(data):
    Purpose: External API to obtain a Chisel type from a hardware object.
    Parameters:
      data: A hardware object.
    Returns: A Chisel type.

General Principles for Hardware Objects:
- Immutability: Chisel types and hardware objects should act as immutable types.
- Operations: Operations like Input(...), Reg(...), etc., return a copy and leave the original unchanged.
- Cloning: Explicit clone operations are deprecated.
- Unbound Requirement: Input(...), Output(...), Flipped(...) require the object to be unbound.
```

--------------------------------

### Configure SBT Dependencies for Chisel 6.0.0

Source: https://github.com/chipsalliance/chisel/blob/main/README.md

Specifies the build.sbt configuration for including Chisel 6.0.0 and its compiler plugin as project dependencies.

```Scala
// build.sbt
scalaVersion := "2.13.12"
val chiselVersion = "6.0.0"
addCompilerPlugin("org.chipsalliance" % "chisel-plugin" % chiselVersion cross CrossVersion.full)
libraryDependencies += "org.chipsalliance" %% "chisel" % chiselVersion
```

--------------------------------

### Connect Chisel Property Ports

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/properties.md

Illustrates connecting an input `Property[Int]` port to an output `Property[Int]` port using the `:=` operator in Chisel, enforcing type compatibility for property connections.

```Scala
class ConnectExample extends RawModule {
  val inPort = IO(Input(Property[Int]()))
  val outPort = IO(Output(Property[Int]()))
  outPort := inPort
}
```

--------------------------------

### Representing Basic Boolean Expressions in Chisel

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/combinational-circuits.md

Demonstrates how simple boolean expressions using bitwise operators (`&`, `|`, `~`) in Chisel directly translate into combinational circuit trees. This syntax allows for concise definition of logic gates.

```Scala
(a & b) | (~c & d)
```

--------------------------------

### Chisel-idiomatic AXI4 Bundle with Decoupled Interface

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/dataview.md

Presents a more 'Chisel-y' approach to defining an AXI4 interface using composition and `Decoupled` utilities. This structure is preferred for internal Chisel designs, promoting modularity and abstracting away low-level `ready`/`valid` signals.

```Scala
class AXIAddressChannel(val addrWidth: Int) extends Bundle {
  val id = UInt(4.W)
  val addr = UInt(addrWidth.W)
  val len = UInt(2.W)
  val size = UInt(2.W)
  // ...
}
import chisel3.util.Decoupled
// We can compose the various AXI channels together
class AXIBundle(val addrWidth: Int) extends Bundle {
  val aw = Decoupled(new AXIAddressChannel(addrWidth))
  // val ar = new AXIAddressChannel
  // ... Other channels here ...
}
// Instantiated as
class MyModule extends RawModule {
  val axi = IO(new AXIBundle(20))
}
```

--------------------------------

### Write simulation logs to standard error using SimLog

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/printing.md

Shows how to direct SimLog output to standard error using SimLog.StdErr, similar to standard printf behavior.

```Scala
class MyModule extends Module {
  val log = SimLog.StdErr
  val in = IO(Input(UInt(8.W)))
  log.printf(cf"in = $in%d\n")
}
```

--------------------------------

### Pattern Match with Scala Case Classes

Source: https://github.com/chipsalliance/chisel/wiki/Scala-Things-You-Should-Know

Illustrates how to use pattern matching with a case class instance. The automatically generated 'unapply' method allows destructuring the case class into local variables within the match case, simplifying access to its parameters.

```Scala
  someVarThatMightHaveADrill match {
    case Drill(hasVarSpeed, amps, rpm) =>
       // here we have access to local variables hasVarSpeed, amps, and rpm, that come
       // someVarThatMightHaveADrill's parameters.
         ???
  }
```

--------------------------------

### Manipulate Verilog-style AXI Interface using DataView

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/dataview.md

Illustrates how to use a `DataView` to manipulate a `VerilogAXIBundle` as if it were an `AXIBundle`. This allows Chisel developers to work with structured, idiomatic Chisel types while maintaining compatibility with external Verilog interfaces and their flat signal naming conventions.

```Scala
class AXIStub extends RawModule {
  val AXI = IO(new VerilogAXIBundle(20))
  val view = AXI.viewAs[AXIBundle]

  // We can now manipulate `AXI` via `view`
  view.aw.bits := 0.U.asTypeOf(new AXIAddressChannel(20)) // zero everything out by default
  view.aw.valid := true.B
  when (view.aw.ready) {
    view.aw.bits.id := 5.U
    view.aw.bits.addr := 1234.U
    // We can still manipulate AXI as well
    AXI.AWLEN := 1.U
  }
}
```

--------------------------------

### Instantiating a Child Module in a Different Clock Domain

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/multi-clock.md

This snippet illustrates how to instantiate an entire child module within a different clock domain using `withClockAndReset`. The `ChildModule` instance (`clockB_child`) will have its internal synchronous elements clocked by `io.clockB` and reset by `io.resetB`, effectively placing the child module in a separate clock domain.

```scala
import chisel3._

class ChildModule extends Module {
  val io = IO(new Bundle{
    val in = Input(Bool())
  })
}
class MultiClockModule extends Module {
  val io = IO(new Bundle {
    val clockB = Input(Clock())
    val resetB = Input(Bool())
    val stuff = Input(Bool())
  })
  val clockB_child = withClockAndReset(io.clockB, io.resetB) { Module(new ChildModule) }
  clockB_child.io.in := io.stuff
}
```

--------------------------------

### Chisel Compiler Plugin: Enable Reflection-Free Bundle Elements Accessor

Source: https://github.com/chipsalliance/chisel/blob/main/plugin/README.md

This `scalac` option enables the Chisel compiler plugin to rewrite the `Bundle#elements` method, replacing reflection-based access with a more efficient, direct approach. This feature is expected to become default in the future, but can be enabled manually by advanced users.

```CLI
-P:chiselplugin:buildElementAccessor
```

--------------------------------

### Scala: Basic Match Statement for Value Comparison

Source: https://github.com/chipsalliance/chisel/wiki/Scala-Things-You-Should-Know

This snippet demonstrates a simple "match" statement in Scala, similar to a C switch statement. It compares an integer variable "y" against predefined cases (0, 1, 2) and uses a wildcard "_" for any other value, returning a corresponding string. The matching process stops after the first successful case.

```Scala
// y is an integer variable defined somewhere else in the code
val x = y match {
  case 0 => "zero"
  case 1 => "one"
  case 2 => "two"
  case _ => "many"
}
println("y is " + x)
```

--------------------------------

### Perform Subword Assignment in Chisel using Vec and asUInt

Source: https://github.com/chipsalliance/chisel/wiki/Cookbook

Provides the recommended Chisel idiom for subword assignment. It involves converting a UInt to a Vec of Bools, modifying the desired bit, and then converting the Vec back to a UInt.

```scala
class TestModule extends Module {
  val io = IO(new Bundle {
    val in = Input(UInt(10.W))
    val bit = Input(Bool())
    val out = Output(UInt(10.W))
  })
  val bools = VecInit(io.in.toBools)
  bools(0) := io.bit
  io.out := bools.asUInt
}
```

--------------------------------

### Verilog Output with Named Signals (With `chiselName`)

Source: https://github.com/chipsalliance/chisel/wiki/Cookbook

Shows the generated Verilog code when the `chiselName` annotation *is* used. Notice that the internal register `innerReg` now retains its original, descriptive name from the Chisel source, significantly improving the readability and debuggability of the generated hardware description.

```Verilog
module TestMod(
  input        clock,
  input        reset,
  input        io_a,
  output [3:0] io_b
);
  reg [3:0] innerReg;
  wire [3:0] _T_1;
  assign _T_1 = innerReg + 4'h1;
  assign io_b = io_a ? innerReg : 4'ha;
  always @(posedge clock) begin
    if (reset) begin
      innerReg <= 4'h5;
    end else begin
      innerReg <= _T_1;
    end
  end
endmodule
```

--------------------------------

### Instantiate Chisel Combinational Logic Block Function

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/functional-abstraction.md

Demonstrates how to use the previously defined `clb` function within a Chisel circuit. It instantiates the `clb` with existing `UInt` signals (`a`, `b`, `c`, `d`) and assigns its computed output to a new `val` named `out`, showcasing the reusability of the abstracted logic.

```Scala
val out = clb(a,b,c,d)
```

--------------------------------

### Create Read-Only Memory (ROM) with VecInit and Counter in Chisel

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/memories.md

This Chisel snippet demonstrates how to define a small read-only memory (ROM) using `VecInit` and access its values sequentially with a `Counter`. The ROM is initialized with specific `UInt` literals.

```Scala
import chisel3._
import chisel3.util.Counter
val m = VecInit(1.U, 2.U, 4.U, 8.U)
val c = Counter(m.length)
c.inc()
val r = m(c.value)
```

--------------------------------

### Apply custom prefix to Chisel signals using `prefix`

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/naming.md

Demonstrates how to use the `prefix` function in Chisel to add a custom prefix to signals within a block. Prefixes are cumulative, including those generated by the compiler plugin.

```Scala
class Example6 extends Module {
  val in = IO(Input(UInt(2.W)))
  val out = IO(Output(UInt(4.W)))

  val add = prefix("foo") {
    val sum = RegNext(in + 1.U)
    sum + 1.U
  }

  out := add
}
```

```Verilog
emitSystemVerilog(new Example6)
```

--------------------------------

### Create Sine Lookup Table ROM in Chisel

Source: https://github.com/chipsalliance/chisel/wiki/Memories

Provides Chisel functions to generate an N-value sine lookup table using a ROM initialized with `VecInit`. It shows how to calculate and store scaled fixpoint sine values, and how to access them to generate a sine wave.

```Scala
def sinTable(amp: Double, n: Int) = {
      val times = 
        (0 until n).map(i => (i*2*Pi)/(n.toDouble-1) - Pi)
      val inits = 
        times.map(t => round(amp * sin(t)).asSInt(32.W))
      VecInit(inits)
    }
def sinWave(amp: Double, n: Int) = 
      sinTable(amp, n)(counter(n.U))
```

--------------------------------

### Chisel Warning Configuration Actions

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/warnings.md

Defines the available actions for Chisel warning configuration. Actions specify how matching warnings should be handled, including suppressing, reporting as warnings, or elevating to errors.

```APIDOC
Actions:
  - :s:
      Description: Suppress matching warnings.
  - :w:
      Description: Report matching warnings as warnings (default behavior).
  - :e:
      Description: Error on matching warnings.
```

--------------------------------

### Define Chisel BlackBox for Real Number Addition

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/blackboxes.md

Illustrates the basic Chisel definition of a `BlackBox` named `BlackBoxRealAdd`. This BlackBox specifies its input and output ports for 64-bit unsigned integers, which are intended to represent real numbers for an external Verilog implementation.

```scala
import chisel3._
class BlackBoxRealAdd extends BlackBox {
  val io = IO(new Bundle {
    val in1 = Input(UInt(64.W))
    val in2 = Input(UInt(64.W))
    val out = Output(UInt(64.W))
  })
}
```

--------------------------------

### Generated FIRRTL for Chisel CSR Modules

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/properties.md

This FIRRTL code represents the hardware description generated from the Chisel `Top` module. It details the `CSRDescription` class, the `mcycle` and `minstret` CSR modules with their inputs, outputs, and property assignments, and the `Top` module connecting these instances and exposing the CSR descriptions.

```FIRRTL
FIRRTL version 4.0.0
circuit Top :
  class CSRDescription :
    output identifier : String
    output description : String
    output width : Integer
    input identifierIn : String
    input descriptionIn : String
    input widthIn : Integer

    propassign identifier, identifierIn
    propassign description, descriptionIn
    propassign width, widthIn

  module mcycle :
    input clock : Clock
    input reset : Reset
    output value : UInt<64>
    output description : Inst<CSRDescription>

    object csrDescription of CSRDescription
    propassign csrDescription.identifierIn, String("mcycle")
    propassign csrDescription.descriptionIn, String("Machine cycle counter.")
    propassign csrDescription.widthIn, Integer(64)
    regreset csr : UInt<64>, clock, reset, UInt<64>(0h0)
    connect value, csr
    propassign description, csrDescription

  module minstret :
    input clock : Clock
    input reset : Reset
    output value : UInt<64>
    output description : Inst<CSRDescription>

    object csrDescription of CSRDescription
    propassign csrDescription.identifierIn, String("minstret")
    propassign csrDescription.descriptionIn, String("Machine instructions-retired counter.")
    propassign csrDescription.widthIn, Integer(64)
    regreset csr : UInt<64>, clock, reset, UInt<64>(0h0)
    connect value, csr
    propassign description, csrDescription

  public module Top :
    input clock : Clock
    input reset : UInt<1>
    output descriptions : List<Inst<CSRDescription>>

    inst mcycle of mcycle
    connect mcycle.clock, clock
    connect mcycle.reset, reset
    inst minstret of minstret
    connect minstret.clock, clock
    connect minstret.reset, reset
    propassign descriptions, List<Inst<CSRDescription>>(mcycle.description, minstret.description)
```

--------------------------------

### Import Scala Class from Package

Source: https://github.com/chipsalliance/chisel/wiki/Scala-Things-You-Should-Know

Shows the syntax for importing a specific class from a declared package, making it accessible for use within another Scala file. This is a fundamental step for reusing code across different modules.

```Scala
import mytools.Tool1
```

--------------------------------

### Import loadMemoryFromFile Utility in Chisel

Source: https://github.com/chipsalliance/chisel/wiki/Chisel-Memories

This import statement brings the 'loadMemoryFromFile' utility into scope, which is necessary to annotate Chisel memories for loading data from external text files during simulation.

```Scala
import chisel3.util.experimental.loadMemoryFromFile
```

--------------------------------

### Initialize Chisel Hardware with *Init Functions

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/chisel-type-vs-scala-type.md

Shows that Chisel initialization functions like WireInit expect a hardware instance as an argument for initialization, not a Chisel data type. Attempting to initialize with a Chisel type will result in a compilation error.

```Scala
// Do this...
elaborate(new Module {
  val hardware = Wire(new MyBundle(3))
  hardware := DontCare
  val moarHardware = WireInit(hardware)
})
```

```Scala
// Not this...
elaborate(new Module {
  val crash = WireInit(new MyBundle(3))
})
```

--------------------------------

### Chisel N-way Mux using MuxCase

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/muxes-and-input-selection.md

`MuxCase` simplifies the creation of n-way multiplexers, avoiding deeply nested `Mux` calls. It takes a default value and an array of `condition -> selected_input_port` tuples, where each condition is a boolean signal.

```scala
MuxCase(default, Array(c1 -> a, c2 -> b, ...))
```

--------------------------------

### Simplify FIFO Interface using DecoupledIO

Source: https://github.com/chipsalliance/chisel/wiki/Polymorphism-and-Parameterization

Shows how the `Fifo` module's I/O can be simplified by using the `DecoupledIO` bundle for its enqueue (`enq`) and dequeue (`deq`) ports. This makes the interface more concise, standard, and easier to integrate with other decoupled components.

```Scala
class Fifo[T <: Data](data: T, n: Int) extends Module {
  val io = IO(new Bundle {
    val enq = Flipped(new DecoupledIO(data))
    val deq = new DecoupledIO(data)
  })
  ...
}
```

--------------------------------

### Generate SystemVerilog from Chisel with Layers

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/layers.md

This Scala snippet shows how to use circt.stage.ChiselStage to compile a Chisel module (Foo) into SystemVerilog. It's specifically used to ensure that the layer-specific outputs, such as bind files and preprocessor macros, are correctly generated and included in the final Verilog output, with options to strip debug information.

```scala
// Use ChiselStage instead of chisel3.docs.emitSystemVerilog because we want layers printed here (obviously)
import circt.stage.ChiselStage
ChiselStage.emitSystemVerilog(new Foo, firtoolOpts=Array("-strip-debug-info", "-disable-all-randomization"))
```

--------------------------------

### Elevating Unmatched Chisel Warnings to Errors

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/warnings.md

Illustrates how to treat all unmatched warnings as errors by ending the warning configuration with `any:e` using `--warn-conf`. This promotes good software practice by ensuring all warnings are addressed.

```scala
compile(new TooWideIndexModule, args = Array("--warn-conf", "id=4&src=**warnings.md:s,any:e"))
// Or
compile(new TooWideIndexModule, args = Array("--warn-conf", "id=4&src=**warnings.md:s", "--warn-conf", "any:e"))
// Or
compile(new TooWideIndexModule, args = Array("--warn-conf", "id=4&src=**warnings.md:s", "--warnings-as-errors"))
```

--------------------------------

### ChiselSim ScalaTest Custom CLI Option Definition and Access

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/testing.md

This API documentation details how to define and access custom command line options within ChiselSim ScalaTest using `chisel3.simulator.scalatest.HasCliOptions`. It covers the flexible `addOption` method, simpler type-specific factories (`CliOption.int`, `string`, etc.), and the `getOption` method for retrieving values within a test, noting its usage constraint.

```APIDOC
chisel3.simulator.scalatest.HasCliOptions:
  Methods for adding custom options:
    - addOption(name: String, description: String, ...):
        Description: Most flexible method to add a custom option. Can influence Chisel elaboration, FIRRTL compilation, or generic/backend settings.
    - CliOption.simple(name: String, description: String):
        Description: Factory for adding a simple flag-like option.
    - CliOption.double(name: String, description: String):
        Description: Factory for adding a double-type option.
    - CliOption.int(name: String, description: String):
        Description: Factory for adding an integer-type option.
    - CliOption.string(name: String, description: String):
        Description: Factory for adding a string-type option.
    - CliOption.flag(name: String, description: String):
        Description: Factory for adding a boolean flag option.

  Methods for accessing options:
    - getOption[T](name: String): Option[T]
        Description: Retrieves the value of a declared command line option.
        Usage Constraint: Must only be used _inside_ a test; otherwise, it causes a runtime exception.
```

--------------------------------

### Define a 2-input Multiplexer Module in Chisel

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/modules.md

This snippet defines a `Mux2` module in Chisel, demonstrating how to create a custom module. It includes the `Mux2IO` bundle for defining the module's input/output interface and the `Mux2` class which inherits from `Module` and implements the multiplexer logic using the `:=` wiring operator.

```Scala
import chisel3._
class Mux2IO extends Bundle {
  val sel = Input(UInt(1.W))
  val in0 = Input(UInt(1.W))
  val in1 = Input(UInt(1.W))
  val out = Output(UInt(1.W))
}

class Mux2 extends Module {
  val io = IO(new Mux2IO)
  io.out := (io.sel & io.in1) | (~io.sel & io.in0)
}
```

--------------------------------

### Annotate Chisel Memory for Hex File Loading

Source: https://github.com/chipsalliance/chisel/wiki/Chisel-Memories

This code annotates a Chisel memory instance to be loaded from a specified text file. By default, it assumes the file contains hexadecimal numbers, using '$readmemh' in Verilog simulation.

```Scala
loadMemoryFromFile(memory, "/workspace/workdir/mem1.txt")
```

--------------------------------

### Attempt to Generate Verilog with Missing Field (Expected Error)

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/connection-operators.md

This Scala code attempts to emit SystemVerilog for the `Wrapper` module where `MockDecoupledIO` is missing a required field (`bits`). This snippet is specifically designed to trigger and demonstrate a Chisel elaboration error, illustrating the strictness of signal connection by field name when using `<>`.

```scala
circt.stage.ChiselStage.emitSystemVerilog(new Wrapper)
```

--------------------------------

### Unpacking Values (Reverse Concatenation) in Chisel

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/cookbook.md

Explains how to achieve 'reverse concatenation' or value unpacking in Chisel, similar to Verilog. It demonstrates using asTypeOf to reinterpret a UInt as a structured Bundle and provides a Verilog equivalent for comparison.

```Verilog
wire [1:0] a;
wire [3:0] b;
wire [2:0] c;
wire [8:0] z = [...];
assign {a,b,c} = z;
```

```Scala
import chisel3._

class MyBundle extends Bundle {
  val a = UInt(2.W)
  val b = UInt(4.W)
  val c = UInt(3.W)
}
```

```Scala
class Foo extends Module {
  val z = Wire(UInt(9.W))
  z := DontCare // This is a dummy connection
  val unpacked = z.asTypeOf(new MyBundle)
  printf("%d", unpacked.a)
  printf("%d", unpacked.b)
  printf("%d", unpacked.c)
}
```

--------------------------------

### circtFirtoolOptions Configuration API

Source: https://github.com/chipsalliance/chisel/blob/main/circtpanamabinding/includeFunctions.txt

Lists API functions for configuring `firtool` options within CIRCT (Circuit IR Compilers and Tools). These functions allow setting various compilation and optimization flags for FIRRTL processing, including output formats, annotation handling, memory lowering, and debug information stripping.

```APIDOC
circtFirtoolOptionsCreateDefault()
circtFirtoolOptionsDestroy()
circtFirtoolOptionsSetOutputFilename()
circtFirtoolOptionsSetDisableUnknownAnnotations()
circtFirtoolOptionsSetDisableAnnotationsClassless()
circtFirtoolOptionsSetLowerAnnotationsNoRefTypePorts()
circtFirtoolOptionsSetPreserveAggregate()
circtFirtoolOptionsSetPreserveValues()
circtFirtoolOptionsSetBuildMode()
circtFirtoolOptionsSetDisableOptimization()
circtFirtoolOptionsSetExportChiselInterface()
circtFirtoolOptionsSetChiselInterfaceOutDirectory()
circtFirtoolOptionsSetVbToBv()
circtFirtoolOptionsSetNoDedup()
circtFirtoolOptionsSetCompanionMode()
circtFirtoolOptionsSetDisableAggressiveMergeConnections()
circtFirtoolOptionsSetEmitOmir()
circtFirtoolOptionsSetOmirOutFile()
circtFirtoolOptionsSetLowerMemories()
circtFirtoolOptionsSetBlackBoxRootPath()
circtFirtoolOptionsSetReplSeqMem()
circtFirtoolOptionsSetReplSeqMemFile()
circtFirtoolOptionsSetExtractTestCode()
circtFirtoolOptionsSetIgnoreReadEnableMem()
circtFirtoolOptionsSetDisableRandom()
circtFirtoolOptionsSetOutputAnnotationFilename()
circtFirtoolOptionsSetEnableAnnotationWarning()
circtFirtoolOptionsSetAddMuxPragmas()
circtFirtoolOptionsSetVerificationFlavor()
circtFirtoolOptionsSetEmitSeparateAlwaysBlocks()
circtFirtoolOptionsSetEtcDisableInstanceExtraction()
circtFirtoolOptionsSetEtcDisableRegisterExtraction()
circtFirtoolOptionsSetEtcDisableModuleInlining()
circtFirtoolOptionsSetAddVivadoRAMAddressConflictSynthesisBugWorkaround()
circtFirtoolOptionsSetCkgModuleName()
circtFirtoolOptionsSetCkgInputName()
circtFirtoolOptionsSetCkgOutputName()
circtFirtoolOptionsSetCkgEnableName()
circtFirtoolOptionsSetCkgTestEnableName()
circtFirtoolOptionsSetExportModuleHierarchy()
circtFirtoolOptionsSetStripFirDebugInfo()
circtFirtoolOptionsSetStripDebugInfo()
```

--------------------------------

### ChiselSim Integration Traits

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/testing.md

To enable ChiselSim functionality, users must mix in one of two traits: `chisel3.simulator.ChiselSim` for general use, or `chisel3.simulator.scalatest.ChiselSim` for tighter integration with ScalaTest, into their test classes.

```APIDOC
chisel3.simulator.ChiselSim
chisel3.simulator.scalatest.ChiselSim
```

--------------------------------

### Compile Chisel Extract Layer to SystemVerilog

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/layers.md

This Scala code compiles the `Foo` module, which includes an extract layer, into SystemVerilog. It uses `circt.stage.ChiselStage.emitSystemVerilog` with `firtoolOpts` to enable specific verification layers and strip debug information, resulting in a `layers-Foo-A.sv` bind file.

```Scala
circt.stage.ChiselStage.emitSystemVerilog(
  new Foo,
  firtoolOpts = Array(
    "-strip-debug-info",
    "-disable-all-randomization",
    "-enable-layers=Verification",
    "-enable-layers=Verification.Assert",
    "-enable-layers=Verification.Assume",
    "-enable-layers=Verification.Cover"
  )
)
```

--------------------------------

### Imperative Chisel I/O Assignment (Anti-Pattern)

Source: https://github.com/chipsalliance/chisel/wiki/Scala-land-vs.-Chisel-land

This Chisel snippet demonstrates an anti-pattern where I/O assignments (`module.io.in.a := ...`, `module.io.in.valid := ...`) are placed inside `when` clauses, mimicking imperative programming. This approach can lead to unintended behavior in hardware synthesis, as Chisel describes concurrent hardware, not sequential execution.

```Scala
  val index = RegInit(0.U(log2Up(max_index).W))
  when(condition) {
    module.io.in.a := vector(index)
    module.io.in.valid := true.B
  } elsewhen {
    module.io.in.valid := false.B
  }
  when(module.io.in.ready) {
    index := index + 1.U
  }
```

--------------------------------

### Migrating UInt/SInt width specification from Chisel2 to Chisel3

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/troubleshooting.md

This section addresses the `type mismatch` error when specifying `UInt` or `SInt` width in Chisel3. It contrasts the old Chisel2 syntax, which allowed direct `Int` for width, with the new Chisel3 requirement of a `Width` type, demonstrating the correct usage with the `.W` method.

```Scala
class TestBlock extends Module {
	val io = IO(new Bundle {
		val output = Output(UInt(width=3))
	})
}
```

```bash
type mismatch;
[error]  found   : Int(3)
[error]  required: chisel3.internal.firrtl.Width
[error] 		val output = Output(UInt(width=3))
```

```Scala
import chisel3._

class TestBlock extends Module {
	val io = IO(new Bundle {
		val output = Output(UInt(3.W))
	})
}
```

--------------------------------

### Chisel Output Initialization (Corrected)

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/unconnected-wires.md

The corrected Chisel code demonstrates proper initialization of an output queue. It ensures that both the `valid` bit and the actual data bits (`out.bits`) are explicitly initialized, preventing 'not fully initialized' errors from Firrtl and ensuring a well-defined hardware state.

```Scala
io.outs.foreach { out =>
    out.bits := 0.U.asTypeOf(out.bits)
    out.noenq()
  }
```

--------------------------------

### Chisel3 Entire Optional I/O Port

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/cookbook.md

This snippet demonstrates making an entire IO port optional for a Chisel module. The port is defined using an Option type, and its value can be safely accessed using getOrElse to provide a default if the port is not present.

```Scala
import chisel3._

class ModuleWithOptionalIO(flag: Boolean) extends Module {
  val in = if (flag) Some(IO(Input(Bool()))) else None
  val out = IO(Output(Bool()))

  out := in.getOrElse(false.B)
}
```

--------------------------------

### Nested Chisel Bundle Aliasing in FIRRTL with `HasTypeAlias`

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/naming.md

This snippet extends the use of `HasTypeAlias` to demonstrate how it supports aliasing for nested Chisel bundles. It shows how parent and child bundles can both define aliases, resulting in structured type definitions in the generated FIRRTL output.

```Scala
import chisel3._
import chisel3.experimental.{HasTypeAlias, RecordAlias}

class Child extends Bundle with HasTypeAlias {
  override def aliasName = RecordAlias("ChildBundle")
  val x = UInt(8.W)
}

class Parent extends Bundle with HasTypeAlias {
  override def aliasName = RecordAlias("ParentBundle")
  val child = new Child
}
```

```Scala
import chisel3._
import circt.stage.ChiselStage.{emitCHIRRTL => emitFIRRTL}
emitFIRRTL(new Module {
  val wire = Wire(new Parent)
})
```

--------------------------------

### FIRRTL Utility API Functions

Source: https://github.com/chipsalliance/chisel/blob/main/circtpanamabinding/includeFunctions.txt

Provides utility functions for FIRRTL, including value folding and importing annotations from JSON. These functions assist in common FIRRTL processing tasks.

```APIDOC
firrtlValueFoldFlow()
firrtlImportAnnotationsFromJSONRaw()
```

--------------------------------

### CIRCT Firtool IR Population Functions

Source: https://github.com/chipsalliance/chisel/blob/main/circtpanamabinding/includeFunctions.txt

This section lists functions used in the CIRCT firtool pipeline for populating FIRRTL Intermediate Representation (IR). It covers stages from preprocessing to final Verilog export.

```APIDOC
circtFirtoolPopulatePreprocessTransforms
circtFirtoolPopulateCHIRRTLToLowFIRRTL
circtFirtoolPopulateLowFIRRTLToHW
circtFirtoolPopulateHWToSV
circtFirtoolPopulateExportVerilog
circtFirtoolPopulateExportSplitVerilog
circtFirtoolPopulateFinalizeIR
```

--------------------------------

### Unpack a Value using asTypeOf in Chisel

Source: https://github.com/chipsalliance/chisel/wiki/Cookbook

Demonstrates the recommended Chisel approach to unpack a UInt into a structured Bundle using the `asTypeOf` method, providing a type-safe way to access sub-elements.

```scala
val z = Wire(UInt(9.W))
// z := ...
val unpacked = z.asTypeOf(new MyBundle)
unpacked.a
unpacked.b
unpacked.c
```

--------------------------------

### Chisel Compiler Plugin Debugging: Conditional `println` Wrapper

Source: https://github.com/chipsalliance/chisel/blob/main/plugin/README.md

Scala function `show` intended for debugging within the Chisel compiler plugin. It wraps `println` statements, executing them only if the current `Bundle`'s name matches a predefined debug regex, reducing verbose output during development.

```Scala
def show(string: => String): Unit = {
  if (bundle.symbol.name.toString.matches(bundleNameDebugRegex)) {
    println(string)
  }
}
```

--------------------------------

### Multi-Condition Wire Assignment with `when`, `elsewhen`, `otherwise` in Chisel

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/combinational-circuits.md

Expands on conditional assignments, demonstrating the use of `when`, `elsewhen`, and `otherwise` for handling multiple conditions when assigning a value to a `Wire`, creating a priority encoder-like structure in hardware.

```Scala
val myNode = Wire(UInt(8.W))
when (input > 128.U) {
  myNode := 255.U
} .elsewhen (input > 64.U) {
  myNode := 1.U
} .otherwise {
  myNode := 0.U
}
```

--------------------------------

### Chisel Bundle Stripping with Flipped Elements and FIRRTL Aliasing

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/naming.md

Demonstrates how 'Flipped' elements within a 'Bundle', when used with 'Input' or 'Output', cause the bundle's type to be fundamentally changed in FIRRTL, resulting in a '_stripped' suffix on its alias. This highlights the distinction between the Chisel and FIRRTL representations.

```Scala
class StrippedBundle extends Bundle with HasTypeAlias {
  override def aliasName = RecordAlias("StrippedBundle")
  val flipped = Flipped(UInt(8.W))
  val normal = UInt(8.W)
}
```

```Scala
emitFIRRTL(new Module {
  val in = IO(Input(new StrippedBundle))
})
```

--------------------------------

### Capture ScalaTest output programmatically

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/appendix/migrating-from-chiseltest.md

This Scala code demonstrates how to programmatically capture the standard output of a ScalaTest run. It uses `java.io.ByteArrayOutputStream` and `Console.withOut` to redirect and store the console output, allowing for inspection and assertion on test results.

```Scala
val stdout = new java.io.ByteArrayOutputStream()
Console.withOut(stdout) {
  org.scalatest.nocolor.run(new MyModuleSpec)
}
val result = stdout.toString
```

--------------------------------

### BibTeX Citations for FIRRTL Intermediate Representation

Source: https://github.com/chipsalliance/chisel/blob/main/website/src/pages/community.md

These BibTeX entries provide recommended citations for FIRRTL, covering its compiler framework and language specification. Use these when citing FIRRTL in academic research.

```bib
@INPROCEEDINGS{8203780,
  author={A. Izraelevitz and J. Koenig and P. Li and R. Lin and A. Wang and A. Magyar and D. Kim and C. Schmidt and C. Markley and J. Lawson and J. Bachrach},
  booktitle={2017 IEEE/ACM International Conference on Computer-Aided Design (ICCAD)},
  title={Reusability is FIRRTL ground: Hardware construction languages, compiler frameworks,
  and transformations},
  year={2017},
  volume={},
  number={},
  pages={209-216},
  keywords={field programmable gate arrays;hardware description languages;program compilers;software reusability;hardware development practices;hardware libraries;open-source hardware intermediate representation;hardware compiler transformations;Hardware construction languages;retargetable compilers;software development;virtual Cambrian explosion;hardware compiler frameworks;parameterized libraries;FIRRTL;FPGA mappings;Chisel;Flexible Intermediate Representation for RTL;Reusability;Hardware;Libraries;Hardware design languages;Field programmable gate arrays;Tools;Open source software;RTL;Design;FPGA;ASIC;Hardware;Modeling;Reusability;Hardware Design Language;Hardware Construction Language;Intermediate Representation;Compiler;Transformations;Chisel;FIRRTL},
  doi={10.1109/ICCAD.2017.8203780},
  ISSN={1558-2434},
  month={Nov},}
```

```bib
@techreport{Li:EECS-2016-9,
    Author = {Li, Patrick S. and Izraelevitz, Adam M. and Bachrach, Jonathan},
    Title = {Specification for the FIRRTL Language},
    Institution = {EECS Department, University of California, Berkeley},
    Year = {2016},
    Month = {Feb},
    URL = {http://www2.eecs.berkeley.edu/Pubs/TechRpts/2016/EECS-2016-9.html},
    Number = {UCB/EECS-2016-9}
}
```

--------------------------------

### Accessing Data from Chisel ObjectModel Class

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/objectmodel.md

This Scala code snippet illustrates the process of defining a Chisel module with a property, converting it to the ObjectModel (OM) using the PanamaCIRCTConverter, and subsequently accessing and evaluating the property's value from the generated OM instance. It showcases the full workflow from Chisel definition to OM evaluation.

```Scala
import chisel3._
import chisel3.properties._
import chisel3.panamaom._

class IntPropTest extends RawModule {
  val intProp = IO(Output(Property[Int]()))
  intProp := Property(123)
}

val converter = Seq(
  new chisel3.stage.phases.Elaborate,
  chisel3.panamaconverter.stage.Convert
).foldLeft(
  firrtl.AnnotationSeq(Seq(chisel3.stage.ChiselGeneratorAnnotation(() => new IntPropTest)))
) { case (annos, phase) => phase.transform(annos) }
  .collectFirst {
    case chisel3.panamaconverter.stage.PanamaCIRCTConverterAnnotation(converter) => converter
  }
  .get

val pm = converter.passManager()
assert(pm.populatePreprocessTransforms())
assert(pm.populateCHIRRTLToLowFIRRTL())
assert(pm.populateLowFIRRTLToHW())
assert(pm.populateFinalizeIR())
assert(pm.run())

val om = converter.om()
val evaluator = om.evaluator()
val obj = evaluator.instantiate("PropertyTest_Class", Seq(om.newBasePathEmpty)).get

val value = obj.field("intProp").asInstanceOf[PanamaCIRCTOMEvaluatorValuePrimitiveInteger].integer
assert(value === 123)
```

--------------------------------

### Chisel Register Instantiation with RegNext

Source: https://github.com/chipsalliance/chisel/wiki/State-Elements

Demonstrates the simplest form of a positive edge-triggered register in Chisel. The output of this circuit is a copy of the input signal 'in' delayed by one clock cycle. The type of the register is automatically inferred from its input, and global clock/reset signals are implicitly included.

```Scala
val reg = RegNext(in)
```

--------------------------------

### Define a Scala Case Class

Source: https://github.com/chipsalliance/chisel/wiki/Scala-Things-You-Should-Know

Demonstrates the basic syntax for defining a case class in Scala. Case classes automatically provide useful features like public parameter access, a factory method (eliminating 'new'), and an 'unapply' method for pattern matching.

```Scala
case class Drill(variableSpeed: Boolean, amps: Int, rpm: Int)
```

--------------------------------

### Defining `HWTuple2` Bundle and Implicit `DataView`

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/dataview.md

Shows how to define a Chisel `Bundle` (`HWTuple2`) to represent a hardware tuple and provide an implicit `DataView` that maps Scala Tuples to this `HWTuple2` type. This enables viewing Scala Tuples as Chisel `Data`.

```scala
class HWTuple2[A <: Data, B <: Data](val _1: A, val _2: B) extends Bundle
```

```scala
implicit def view[A <: Data, B <: Data]: DataView[(A, B), HWTuple2[A, B]] =
  DataView(tup => new HWTuple2(tup._1.cloneType, tup._2.cloneType),
           _._1 -> _._1, _._2 -> _._2)
```

--------------------------------

### Multiple `withModulePrefix` Instances for Distinct Module Copies in Chisel

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/moduleprefix.md

Explains that running a generator within multiple `withModulePrefix` blocks results in distinct, identical copies of the module definition in the Verilog output, each with its own unique prefix (e.g., `Foo_Sub` and `Bar_Sub`).

```scala
import chisel3._

class Top extends Module {
  val foo_sub = withModulePrefix("Foo") {
    Module(new Sub)
  }

  val bar_sub = withModulePrefix("Bar") {
    Module(new Sub)
  }
}

class Sub extends Module {
  // ..
}
```

--------------------------------

### Implement DataProduct for MyCounter and Succeed DataView Creation

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/dataview.md

Provides the necessary DataProduct implementation for MyCounter, enabling Chisel to correctly access its internal Data elements. This allows the DataView to be successfully created, resolving the previous compilation error.

```scala
import chisel3.util.Valid
implicit val counterProduct: DataProduct[MyCounter] = new DataProduct[MyCounter] {
  // The String part of the tuple is a String path to the object to help in debugging
  def dataIterator(a: MyCounter, path: String): Iterator[(Data, String)] =
    List(a.value -> s"$path.value", a.active -> s"$path.active").iterator
}
// Now this works
implicit val counterView: DataView[MyCounter, Valid[UInt]] = DataView(c => Valid(UInt(c.width.W)), _.value -> _.bits, _.active -> _.valid)
```

--------------------------------

### Triggering Chisel Compilation Error for Mismatched BiConnect

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/interfaces-and-connections.md

This snippet shows the `emitSystemVerilog` command, which, when executed with the `Block2` module, will trigger the compilation error caused by the mismatched `BiConnect` operation. It demonstrates how Chisel's strict type and field matching for `BiConnect` are enforced during hardware generation.

```Scala
emitSystemVerilog(new Block2)
```

--------------------------------

### Verify Chisel Module Constant Propagation using ScalaTest FileCheck

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/testing.md

This Scala code defines a `chisel3` module `Baz` that performs a simple constant addition (`1.U + 3.U`). It then uses `chisel3.testing.scalatest.FileCheck` within an `AnyFunSpec` test to assert that the `ChiselStage.emitSystemVerilog` output for `Baz` contains the simplified constant `4` in the `assign` statement. The `CHECK` and `CHECK-NEXT` directives are used to validate the module structure and the constant assignment.

```scala
import chisel3._
import chisel3.testing.scalatest.FileCheck
import circt.stage.ChiselStage
import org.scalatest.funspec.AnyFunSpec

class FileCheckExample extends AnyFunSpec with FileCheck {

  class Baz extends RawModule {

    val out = IO(Output(UInt(32.W)))

    out :<= 1.U(32.W) + 3.U(32.W)

  }

  describe("Foo") {

    it("should simplify the constant computation in its body") {

      ChiselStage.emitSystemVerilog(new Baz).fileCheck()(
        """|CHECK:      module Baz(
           |CHECK-NEXT:   output [31:0] out
           |CHECK:        assign out = 32'h4;
           |CHECK:      endmodule
           |""".stripMargin
        )

    }

  }

}
```

--------------------------------

### Import Chisel Properties

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/properties.md

Imports necessary Chisel libraries, including the `Property` type, to enable property functionality in a Scala design.

```Scala
import chisel3._
import chisel3.properties.Property
```

--------------------------------

### MLIR Core API Types and Handles

Source: https://github.com/chipsalliance/chisel/blob/main/circtpanamabinding/includeStructs.txt

Defines the fundamental types, contexts, operations, and handles used within the MLIR (Multi-Level Intermediate Representation) framework, essential for compiler infrastructure development.

```APIDOC
MlirContext
MlirDialectHandle
MlirStringRef
MlirType
MlirValue
MlirLocation
MlirAttribute
MlirIdentifier
MlirModule
MlirBlock
MlirRegion
MlirOperation
MlirOperationState
MlirNamedAttribute
MlirPassManager
MlirOpPassManager
MlirPass
MlirLogicalResult
```

--------------------------------

### Define a Chisel Module with a Custom IO Bundle

Source: https://github.com/chipsalliance/chisel/wiki/Interfaces-Bulk-Connections

Illustrates how to define a Chisel module (`Filter`) and assign a custom `FilterIO` Bundle to its `io` port. This is the standard way to define the external interface of a Chisel hardware module, making its inputs and outputs accessible.

```scala
class Filter extends Module {
  val io = IO(new FilterIO)
  ...
}
```

--------------------------------

### Instantiate New Chisel Hardware (Wire, Reg, IO)

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/chisel-type-vs-scala-type.md

Explains that Wire, Reg, and IO are used to define *new* hardware components, and therefore cannot be instantiated with an existing hardware instance as an argument. They require a Chisel type to define the new hardware's structure.

```Scala
// Do this...
elaborate(new Module {
  val hardware = Wire(new MyBundle(3))
  hardware := DontCare
})
```

```Scala
// Not this...
elaborate(new Module {
  val hardware = Wire(new MyBundle(3))
  val crash = Wire(hardware)
})
```

--------------------------------

### Scala For-Each Loop over Collections

Source: https://github.com/chipsalliance/chisel/wiki/CS250-Chisel+Scala-Primer

Shows how to iterate over elements in a collection using a for-each style loop in Scala, similar to Java's enhanced for loop, where i takes the value of each element.

```Scala
val a = Seq(1, 2, 3, 4, 5)
for (i <- a){
	//i takes the value of each
	//element in the sequence a	
	println(i)
}
```

--------------------------------

### Define Chisel Execution Options Case Class

Source: https://github.com/chipsalliance/chisel/wiki/Running-Stuff

The `ChiselExecutionOptions` case class defines the configurable parameters for Chisel execution. It extends `ComposableOptions` and is typically immutable, requiring `copy` for modifications.

```Scala
case class ChiselExecutionOptions(
                                   runFirrtlCompiler: Boolean = true
                                   // var runFirrtlAsProcess: Boolean = false
                                 ) extends ComposableOptions
```

--------------------------------

### Chisel RawModule with Explicit Clock and Reset

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/reset.md

Illustrates a `RawModule` that takes explicit `Clock` and `Reset` inputs. This allows for fine-grained control over the clock and reset domains for internal registers, making the module reset-agnostic by explicitly passing the `rst` signal to `RegInit` via `withClockAndReset`.

```Scala
class ResetAgnosticRawModule extends RawModule {
  val clk = IO(Input(Clock()))
  val rst = IO(Input(Reset()))
  val out = IO(Output(UInt(8.W)))

  val resetAgnosticReg = withClockAndReset(clk, rst)(RegInit(0.U(8.W)))
  resetAgnosticReg := resetAgnosticReg + 1.U
  out := resetAgnosticReg
}
```

--------------------------------

### Chisel: Multi-level Conditional Assignment with `elsewhen`

Source: https://github.com/chipsalliance/chisel/wiki/Combinational-Circuits

Demonstrates advanced conditional assignment to a Chisel wire using `when`, `elsewhen`, and `otherwise`. This allows for multiple conditions to determine the assigned value, such as setting `myNode` to `255.U`, `1.U`, or `0.U` based on the `input` value.

```scala
val myNode = Wire(UInt(8.W))
when (input > 128.U) {
  myNode := 255.U
} .elsewhen (input > 64.U) {
  myNode := 1.U
} .otherwise {
  myNode := 0.U
}
```

--------------------------------

### Demonstrating Chisel Signal Naming Loss with Dynamic Vector Indexing

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/cookbook.md

This Scala code defines a Chisel module `Foo` that demonstrates how dynamic indexing into a `Vec` can lead to loss of signal naming information, resulting in generic names like `_GEN_3` in the generated Verilog. The `x` signal, which is the result of `io.in(io.idx)`, loses its original name.

```Scala
import chisel3._

class Foo extends Module {
  val io = IO(new Bundle {
    val in = Input(Vec(4, Bool()))
    val idx = Input(UInt(2.W))
    val en = Input(Bool())
    val out = Output(Bool())
  })

  val x = io.in(io.idx)
  val y = x && io.en
  io.out := y
}
```

```Scala
chisel3.docs.emitSystemVerilog(new Foo)
```

--------------------------------

### Defining `BundleA` and `BundleB` for `PartialDataView`

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/dataview.md

Defines two simple Chisel `Bundle` types, `BundleA` and `BundleB`, which are used to illustrate the concepts of `DataView` totality and `PartialDataView`.

```scala
import chisel3._
import chisel3.experimental.dataview._
class BundleA extends Bundle {
  val foo = UInt(8.W)
  val bar = UInt(8.W)
}
class BundleB extends Bundle {
  val fizz = UInt(8.W)
}
```

--------------------------------

### Hardware Signal Assignment in Chisel/Verilog

Source: https://github.com/chipsalliance/chisel/wiki/ChiselSheet

This snippet demonstrates hardware signal assignment in Chisel using `:=`, as in `myWire := [...]`. This directly translates to a continuous `assign` statement in Verilog, `assign myWire = [...];`, which describes the combinational logic for a hardware signal.

```Chisel
myWire := [...]
```

```Verilog
assign myWire = [...];
```

--------------------------------

### Assign Chisel Property Literal Value

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/properties.md

Shows how to assign a literal integer value wrapped in `Property()` to an output `Property[Int]` port, demonstrating the creation of property values from Scala primitives.

```Scala
class LiteralExample extends RawModule {
  val outPort = IO(Output(Property[Int]()))
  outPort := Property(123)
}
```

--------------------------------

### Manually run ScalaTest Spec

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/appendix/migrating-from-chiseltest.md

This Scala snippet shows how to manually execute a ScalaTest specification, such as the `MyModuleSpec`, from within a Scala environment. While typically run via `sbt test`, this provides an alternative for direct execution and debugging.

```Scala
org.scalatest.nocolor.run(new MyModuleSpec)
```

--------------------------------

### Define DataView for Chisel AXI4 Bundle Conversion

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/dataview.md

Introduces `DataView` as a mechanism to map between different Chisel `Bundle` structures, specifically from a flat Verilog-style AXI bundle to a compositional Chisel-idiomatic one. It shows how to define an implicit `DataView` within a companion object, specifying field mappings for conversion.

```Scala
import chisel3.experimental.dataview._

// We recommend putting DataViews in a companion object of one of the involved types
object AXIBundle {
  // Don't be afraid of the use of implicits, we will discuss this pattern in more detail later
  implicit val axiView: DataView[VerilogAXIBundle, AXIBundle] = DataView(
    // The first argument is a function constructing an object of View type (AXIBundle)
    // from an object of the Target type (VerilogAXIBundle)
    vab => new AXIBundle(vab.addrWidth),
    // The remaining arguments are a mapping of the corresponding fields of the two types
    _.AWVALID -> _.aw.valid,
    _.AWREADY -> _.aw.ready,
    _.AWID -> _.aw.bits.id,
    _.AWADDR -> _.aw.bits.addr,
    _.AWLEN -> _.aw.bits.len,
    _.AWSIZE -> _.aw.bits.size,
    // ...
  )
}
```

--------------------------------

### Incorrect Chisel Register Instantiation for Initialization

Source: https://github.com/chipsalliance/chisel/wiki/Scala-land-vs.-Chisel-land

This Chisel snippet shows an incorrect way to initialize a register. While `Reg(42.U)` correctly infers the width needed to hold the value 42, it does not initialize the register to 42. It only uses `42.U` to determine the register's type and width, not its initial value.

```Scala
  val accumulator = Reg(42.U)
```

--------------------------------

### Use RawModule for Custom Clock and Reset in Chisel

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/modules.md

This snippet illustrates the use of `RawModule` in Chisel to define a module without implicit clock and reset signals. It demonstrates how to wrap a standard `Module` (`Foo`) within a `RawModule` (`FooWrapper`) and explicitly manage clock and reset signals, including changing reset polarity using `withClockAndReset`.

```Scala
import chisel3.{RawModule, withClockAndReset}

class Foo extends Module {
  val io = IO(new Bundle{
    val a = Input(Bool())
    val b = Output(Bool())
  })
  io.b := !io.a
}

class FooWrapper extends RawModule {
  val a_i  = IO(Input(Bool()))
  val b_o  = IO(Output(Bool()))
  val clk  = IO(Input(Clock()))
  val rstn = IO(Input(Bool()))

  val foo = withClockAndReset(clk, !rstn){ Module(new Foo) }

  foo.io.a := a_i
  b_o := foo.io.b
}
```

--------------------------------

### Chisel: Defining a Case Class with Data and Instance Members

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/hierarchy.md

Defines a `UserDefinedType` case class that includes Chisel `Data` (UInt) and an `Instance` of another module. This illustrates a more complex type that requires special handling (the `Lookupable` typeclass) for instance accessibility.

```scala
import chisel3._
import chisel3.experimental.hierarchy.{Definition, Instance, instantiable, public}

@instantiable
class MyModule extends Module {
  @public val wire = Wire(UInt(8.W))
}
case class UserDefinedType(name: String, data: UInt, inst: Instance[MyModule])
```

--------------------------------

### Chisel `Bundle` Using `.cloneType` for Explicit Field Instantiation

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/cookbook.md

Explains the direct use of `.cloneType` on the `gen` argument within `UsingCloneTypeBundle`. This method explicitly invokes Chisel's internal mechanism for creating fresh `Data` objects, providing a clear and direct solution to the aliasing problem.

```scala
class UsingCloneTypeBundle[T <: Data](gen: T) extends Bundle {
  val foo = gen.cloneType
  val bar = gen.cloneType
}
```

--------------------------------

### Chisel: Module Using Overridden `DataView` for Swizzled Conversion

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/dataview.md

This Chisel module imports the `Swizzle` object, making its implicit `DataView` available in the current scope. This demonstrates how explicit imports can override default implicit resolutions, leading to a different data transformation (swizzling) for `Foo` to `Bar`.

```Chisel
// Current scope always wins over implicit scope
import Swizzle._
class FooToBarSwizzled extends Module {
  val foo = IO(Input(new Foo))
  val bar = IO(Output(new Bar))
  bar := foo.viewAs[Bar]
}
```

--------------------------------

### Attempted Subword Assignment in Chisel (Not Supported)

Source: https://github.com/chipsalliance/chisel/wiki/Cookbook

Illustrates a direct attempt at subword assignment in Chisel, which is not natively supported. This snippet highlights the limitation and the need for alternative approaches.

```scala
class TestModule extends Module {
  val io = IO(new Bundle {
    val in = Input(UInt(10.W))
    val bit = Input(Bool())
    val out = Output(UInt(10.W))
  })
  io.out(0) := io.bit
}
```

--------------------------------

### Deserialize and Elaborate GCD Module from JSON in Scala

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/serialization.md

This Scala code shows how to deserialize a JSON string back into a `SerializableModuleGenerator` object using `upickle.default.read` and `ujson.read`. Once deserialized, the module can be elaborated into SystemVerilog using `circt.stage.ChiselStage.emitSystemVerilog`, enabling recreation of the hardware design from its serialized form.

```Scala
circt.stage.ChiselStage.emitSystemVerilog(
  upickle.default.read[SerializableModuleGenerator[GCDSerializableModule, GCDSerializableModuleParameter]](
    ujson.read(j)
  ).module()
)
```

--------------------------------

### Chisel Runtime Prefixing on Connection Assignments

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/naming.md

Explains how Chisel's runtime handles prefixing for signals created within a connection assignment block, even without explicit compiler plugin intervention. The name of the left-hand side signal is used as a prefix for internal signals.

```Scala
class ConnectPrefixing extends Module {
  val in = IO(Input(UInt(2.W)))
  // val in = withName("in")(prefix("in")(IO(Input(UInt(2.W)))))

  val out1 = IO(Output(UInt(4.W)))
  // val out1 = withName("out1")(prefix("out1")(IO(Output(UInt(4.W)))))
  val out2 = IO(Output(UInt(4.W)))
  // val out2 = withName("out2")(prefix("out2")(IO(Output(UInt(4.W)))))

  out1 := { // technically this is not wrapped in withName nor prefix
    // But the Chisel runtime will still use the name of `out1` as a prefix
    val squared = in * in
    out2 := squared
    val delayed = RegNext(squared)
    // val delayed = withName("delayed")(prefix("delayed")(RegNext(squared)))
    delayed + 1.U
  }
}
```

```Scala
emitSystemVerilog(new ConnectPrefixing)
```

--------------------------------

### Define Chisel Module with Output Probe for Internal Register

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/probes.md

This Chisel code defines a module named `Foo` that demonstrates how to expose an internal register's value as an external read probe. It declares an input `d`, an output `q`, and an output `r_probe` of type `Probe(UInt(32.W))`. The internal register `r` is assigned to `q`, and its value is made available via `r_probe` using `ProbeValue(r)`.

```Scala
import chisel3._
import chisel3.probe.{Probe, ProbeValue}

class Foo extends Module {

  val d = IO(Input(UInt(32.W)))
  val q = IO(Output(UInt(32.W)))
  val r_probe = IO(Output(Probe(UInt(32.W))))

  private val r = Reg(UInt(32.W))

  q :<= r

  r_probe :<= ProbeValue(r)
}
```

--------------------------------

### Define a Filter Interface with Nested Bundles (FilterIO)

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/interfaces-and-connections.md

Defines `FilterIO` by nesting two `PLink` instances: `x` (with its direction flipped) and `y` (with its normal direction). This demonstrates how to organize interfaces hierarchically and use `Flipped` to recursively change signal directions within a bundle.

```scala
class FilterIO extends Bundle {
  val x = Flipped(new PLink)
  val y = new PLink
}
```

--------------------------------

### Behavior of temporary signals (`_`) when generating Chisel prefixes

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/naming.md

Illustrates how a leading underscore in a temporary signal's name is handled when that signal is used to generate a prefix for nested signals. The leading underscore is ignored to prevent double underscores in the resulting names.

```Scala
class TemporaryPrefixExample extends Module {
  val in0 = IO(Input(UInt(2.W)))
  val in1 = IO(Input(UInt(2.W)))
  val out0 = IO(Output(UInt(3.W)))
  val out1 = IO(Output(UInt(4.W)))

  val _sum = {
    val x = in0 + in1
    out0 := x
    x + 1.U
  }
  out1 := _sum & 0x2.U
}
```

```Verilog
emitSystemVerilog(new TemporaryPrefixExample)
```

--------------------------------

### Create Literals with .Lit on Chisel Types

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/chisel-type-vs-scala-type.md

Demonstrates that the .Lit method for creating hardware literals must be called on a Chisel data type, not on an already defined hardware instance. This method is used to define the initial value of a type.

```Scala
// Do this...
elaborate(new Module {
  val hardwareLit = (new MyBundle(3)).Lit(
    _.foo -> 0.U,
    _.bar -> 0.U
  )
})
```

```Scala
//Not this...
elaborate(new Module {
  val hardware = Wire(new MyBundle(3))
  val crash = hardware.Lit(
    _.foo -> 0.U,
    _.bar -> 0.U
  )
})
```

--------------------------------

### Apply Scalafix for Code Cleanup in FIRRTL

Source: https://github.com/chipsalliance/chisel/blob/main/firrtl/README.md

Commands to use Scalafix, a Scala code refactoring tool, to automatically remove unused imports and update deprecated procedure syntax within the FIRRTL codebase.

```sbt
sbt "firrtl/scalafix RemoveUnused"
sbt "firrtl/scalafix ProcedureSyntax"
```

--------------------------------

### Chisel Repl: Register Type Output

Source: https://github.com/chipsalliance/chisel/wiki/Debugging-with-the-Interpreter-REPL-2

Displays the output from the `type` command in the Chisel Repl, confirming the current value and the bit width of a register, which directly points to the cause of the `bad width` error.

```console
type y 13.U<4>
```

--------------------------------

### Assigning CSRDescription Property Reference in Chisel

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/properties.md

This line demonstrates how a property reference from a `CSRDescription` object is assigned to an output port named `description` within a Chisel module, making it externally accessible.

```Scala
description := csrDescription.getPropertyReference
```

--------------------------------

### Chisel Analog Type Usage

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/data-types.md

Illustrates the usage of the experimental `Analog` type (Chisel 3.1+) for undirectioned nets, similar to Verilog's `inout`. It demonstrates how to connect multiple `Analog` nets using the `attach` operator and explains the limitation that the `<>` operator can only connect an `Analog` once.

```scala
val a = IO(Analog(1.W))
val b = IO(Analog(1.W))
val c = IO(Analog(1.W))

// Legal
attach(a, b)
attach(a, c)

// Legal
a <> b

// Illegal - connects 'a' multiple times
a <> b
a <> c
```

--------------------------------

### Chisel: Naming Wires for Fan-Out with `val`

Source: https://github.com/chipsalliance/chisel/wiki/Combinational-Circuits

Illustrates how to create circuits with arbitrary directed acyclic graphs (DAGs) by naming intermediate wires. The Scala keyword `val` is used to declare a wire `sel` that holds a subexpression, allowing its output to be referenced multiple times in subsequent expressions, such as in a multiplexer description.

```scala
val sel = a | b
val out = (sel & in1) | (~sel & in0)
```

--------------------------------

### Chisel: Implementing Lookupable Typeclass for Complex Case Class

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/hierarchy.md

Provides the implicit `Lookupable` typeclass implementation for `UserDefinedType` in its companion object. It uses `Lookupable.product3` to define how the case class can be converted to and from a tuple of its fields, which is necessary to enable instance accessibility for types containing `Data` or `Instance`.

```scala
import chisel3.experimental.hierarchy.Lookupable
object UserDefinedType {
  implicit val lookupable: Lookupable.Simple[UserDefinedType] =
    Lookupable.product3[UserDefinedType, String, UInt, Instance[MyModule]](
      x => (x.name, x.data, x.inst),
      UserDefinedType.apply
    )
}
```

--------------------------------

### Configure Chisel Compiler Plugin in SBT Build

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/naming.md

Instructions for integrating the Chisel compiler plugin into an SBT project. This configuration is necessary for the plugin to automatically apply naming and prefixing transformations to Chisel code during compilation.

```Scala
// For chisel versions 5.0.0+
addCompilerPlugin("org.chipsalliance" % "chisel-plugin" % "5.0.0" cross CrossVersion.full)
// For older chisel3 versions, eg. 3.6.0
addCompilerPlugin("edu.berkeley.cs" % "chisel3-plugin" % "3.6.0" cross CrossVersion.full)
```

--------------------------------

### Define a Chisel Bundle for a Floating-Point Structure

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/bundles-and-vecs.md

This snippet defines a `MyFloat` Bundle, which aggregates a boolean sign, an 8-bit exponent, and a 23-bit significand. It demonstrates how to declare a custom Bundle by extending `Bundle` and how to access its fields within a `RawModule`.

```scala
import chisel3._
class MyFloat extends Bundle {
  val sign        = Bool()
  val exponent    = UInt(8.W)
  val significand = UInt(23.W)
}

class ModuleWithFloatWire extends RawModule {
  val x  = Wire(new MyFloat)
  val xs = x.sign
}
```

--------------------------------

### Unpack a Value (Reverse Concatenation) in Verilog

Source: https://github.com/chipsalliance/chisel/wiki/Cookbook

Illustrates the concept of unpacking a concatenated value into multiple wires in Verilog, which is analogous to reverse concatenation.

```verilog
wire [1:0] a;
wire [3:0] b;
wire [2:0] c;
wire [8:0] z = [...];
assign {a,b,c} = z;
```

--------------------------------

### Compile Chisel Inline Layer to SystemVerilog

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/layers.md

This Scala code compiles the `Foo` module, which incorporates an inline layer, into SystemVerilog. It utilizes `circt.stage.ChiselStage.emitSystemVerilog` with `firtoolOpts` to control the output, demonstrating compilation for inline layer configurations.

```Scala
circt.stage.ChiselStage.emitSystemVerilog(
  new Foo,
  firtoolOpts = Array(
    "-strip-debug-info",
    "-disable-all-randomization",
    "-enable-layers=Verification,Verification.Assert,Verification.Assume,Verification.Cover"
  )
)
```

--------------------------------

### Connect Chisel Bundles by Viewing as Supertype

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/dataview.md

Learn how to connect a Bundle to its parent type using viewAsSupertype. This mechanism allows a Bundle to be treated as a simpler supertype for connection purposes, effectively connecting only the common fields. Remember that all fields of the target Bundle must still be connected, even if not through the supertype view.

```Scala
import chisel3._
import chisel3.experimental.dataview._

class Foo extends Bundle {
  val foo = UInt(8.W)
}
class Bar extends Foo {
  val bar = UInt(8.W)
}
class MyModule extends Module {
  val foo = IO(Input(new Foo))
  val bar = IO(Output(new Bar))
  bar.viewAsSupertype(new Foo) := foo // bar.foo := foo.foo
  bar.bar := 123.U           // all fields need to be connected
}
```

--------------------------------

### Define Chisel Execution Options Trait

Source: https://github.com/chipsalliance/chisel/wiki/Running-Stuff

This Scala trait, `HasChiselExecutionOptions`, extends `ExecutionOptionsManager` and adds configuration for Chisel execution. It includes a `chiselOptions` variable and uses `scopt` for command-line parsing to modify `runFirrtlCompiler`.

```Scala
trait HasChiselExecutionOptions {
  self: ExecutionOptionsManager =>

  var chiselOptions = ChiselExecutionOptions()

  parser.note("chisel3 options")

  parser.opt[Unit]("no-run-firrtl")
    .abbr("chnrf")
    .foreach { _ =>
      chiselOptions = chiselOptions.copy(runFirrtlCompiler = false)
    }
    .text("Stop after chisel emits chirrtl file")
}
```

--------------------------------

### Flush VCD Recording to Disk in Repl

Source: https://github.com/chipsalliance/chisel/wiki/Debugging-with-the-Interpreter-REPL-3

This Repl command flushes the currently recorded VCD log to disk, saving the file to the local directory. It is crucial to run this command to finalize and save the VCD file after recording.

```Repl
record-vcd done
```

--------------------------------

### Comparing Manual and Automatic Chisel Bundle Type Name Generation

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/naming.md

This snippet compares manual `typeName` overriding with automatic generation using the `HasAutoTypename` trait. It demonstrates how `HasAutoTypename` simplifies the process by deriving tuple-like names from constructor parameters, providing a more concise approach than explicit overrides.

```Scala
import chisel3._
class MyBundle[T <: Data](gen: T, intParam: Int) extends Bundle {
  override def typeName = s"MyBundle_${gen.typeName}_${intParam}"
  // ...
}
```

```Scala
import chisel3._
new MyBundle(UInt(8.W), 3).typeName
```

```Scala
import chisel3._
import chisel3.experimental.HasAutoTypename
class MyBundle[T <: Data](gen: T, intParam: Int) extends Bundle with HasAutoTypename {
  // ...
  // Note: No `override def typeName` statement here
}
```

```Scala
import chisel3._
new MyBundle(UInt(8.W), 3).typeName
```

--------------------------------

### Chisel Repl: Check Register Type and Width

Source: https://github.com/chipsalliance/chisel/wiki/Debugging-with-the-Interpreter-REPL-2

Illustrates using the `type` command in the Chisel Repl to inspect the data type and bit width of a specific register (`y`), providing crucial information for debugging width-related design errors.

```Chisel Repl
type y
```

--------------------------------

### Emit SystemVerilog String from sbt Console

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/resources/faqs.md

This Scala snippet demonstrates how to directly emit SystemVerilog as a string from within the sbt console, useful for interactive debugging or processing the output directly.

```scala
(new circt.stage.ChiselStage).emitSystemVerilog(new HelloWorld())
```

--------------------------------

### Define an Identity Firrtl Transform in Scala

Source: https://github.com/chipsalliance/chisel/wiki/Annotations-Extending-Chisel-and-Firrtl

Illustrates the basic structure of a Firrtl Transform in Scala. This `IdentityTransform` extends the `Transform` class, specifying input and output forms as `LowForm` and providing an `execute` method that currently performs no modifications, serving as a template for custom transformations.

```Scala
class IdentityTransform extends Transform {
  override def inputForm: CircuitForm = LowForm
  override def outputForm: CircuitForm = LowForm

  override def execute(state: CircuitState): CircuitState = {
    getMyAnnotations(state) match {
      case Nil => state
      case myAnnotations =>
        // Use annotations contained in the myAnnotations list to modify state
        // and return that modified state.
        state
    }
  }
}
```

--------------------------------

### Define Chisel Property Input Port

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/properties.md

Demonstrates how to declare an input port of type `Property[Int]` within a Chisel `RawModule`, allowing non-hardware integer properties to be passed into a module.

```Scala
class PortsExample extends RawModule {
  // An Int Property type port.
  val myPort = IO(Input(Property[Int]()))
}
```

--------------------------------

### Attempt DataView Creation Without DataProduct (Fails)

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/dataview.md

Demonstrates an attempt to create a DataView for MyCounter without an explicit DataProduct implementation. This code snippet is designed to fail compilation, highlighting the requirement for DataProduct.

```scala
import chisel3.util.Valid
implicit val counterView = DataView[MyCounter, Valid[UInt]](c => Valid(UInt(c.width.W)), _.value -> _.bits, _.active -> _.valid)
```

--------------------------------

### Declare a Memory in Chisel

Source: https://github.com/chipsalliance/chisel/wiki/Chisel-Memories

This snippet shows how to declare a memory instance within a Chisel module, specifying its depth and type. This memory can then be annotated for loading from an external file.

```Scala
val memory = Mem(memoryDepth, memoryType)
```

--------------------------------

### Minimize Output Vector Bit Width in Chisel using Scala Seqs

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/cookbook.md

This snippet demonstrates how to use Scala `Seq` instead of Chisel `Vec` to create output vectors with inferred and potentially varying bit widths for each element, thereby minimizing overall bit usage. It defines a `CountBits` module that counts set bits and a `Top` module for compilation.

```Scala
import chisel3._

// Count the number of set bits up to and including each bit position
class CountBits(width: Int) extends Module {
  val bits = IO(Input(UInt(width.W)))
  val countVector = IO(Output(Vec(width, UInt())))

  private val countSequence = Seq.tabulate(width)(i => Wire(UInt()))
  countSequence.zipWithIndex.foreach { case (port, i) =>
    port := util.PopCount(bits(i, 0))
  }
  countVector := countSequence
}

class Top(width: Int) extends Module {
  val countBits = Module(new CountBits(width))
  countBits.bits :<>= DontCare
  dontTouch(countBits.bits)
  dontTouch(countBits.countVector)
}
```

```Scala
chisel3.docs.emitSystemVerilog(new Top(4))
  // remove the body of the module by removing everything after ');'
  .split("\\);")
  .head + ");\n"
```

--------------------------------

### Apply Module Prefix with `withModulePrefix` in Chisel

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/moduleprefix.md

Demonstrates the basic usage of `withModulePrefix` to apply a prefix to all modules defined within its block, including immediate submodules and their descendents. The prefix is separated by an underscore by default.

```scala
import chisel3._

class Top extends Module {
  withModulePrefix("Foo") {
    // ...
  }
}
```

--------------------------------

### Emit FIRRTL String from sbt Console

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/resources/faqs.md

This Scala snippet demonstrates how to directly emit FIRRTL as a string from within the sbt console, providing an interactive way to generate intermediate hardware descriptions.

```scala
circt.stage.ChiselStage.emitCHIRRTL(new MyFirrtlModule)
```

--------------------------------

### Resolving Chisel Dynamic Index Width Errors

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/cookbook.md

This section provides solutions for 'Dynamic index is too wide/narrow' errors in Chisel, which occur when the width of an index does not match the required log2 width of the indexed element. It demonstrates using `.pad` for narrow indices, bit extraction for wide indices, and a combined approach for variable width scenarios.

```Scala
import chisel3._
// Helper to throw away return value so it doesn't show up in mdoc
def compile(gen: => chisel3.RawModule): Unit = {
  circt.stage.ChiselStage.emitCHIRRTL(gen)
}
```

```Scala
class TooNarrow extends RawModule {
  val extractee = Wire(UInt(7.W))
  val index = Wire(UInt(2.W))
  extractee(index)
}
compile(new TooNarrow)
```

```Scala
class TooNarrowFixed extends RawModule {
  val extractee = Wire(UInt(7.W))
  val index = Wire(UInt(2.W))
  extractee(index.pad(3))
}
compile(new TooNarrowFixed)
```

```Scala
class TooWide extends RawModule {
  val extractee = Wire(Vec(8, UInt(32.W)))
  val index = Wire(UInt(4.W))
  extractee(index)
}
compile(new TooWide)
```

```Scala
class TooWideFixed extends RawModule {
  val extractee = Wire(Vec(8, UInt(32.W)))
  val index = Wire(UInt(4.W))
  extractee(index(2, 0))
}
compile(new TooWideFixed)
```

```Scala
class SizeOneVec extends RawModule {
  val extractee = Wire(Vec(1, UInt(32.W)))
  val index = Wire(UInt(0.W))
  extractee(index)
}
compile(new SizeOneVec)
```

```Scala
import chisel3.util.log2Ceil
class TooWideOrNarrow(extracteeSize: Int, indexWidth: Int) extends Module {
  val extractee = Wire(Vec(extracteeSize, UInt(8.W)))
  val index = Wire(UInt(indexWidth.W))
  val correctWidth = log2Ceil(extracteeSize)
  extractee(index.pad(correctWidth)(correctWidth - 1, 0))
}
compile(new TooWideOrNarrow(8, 2))
compile(new TooWideOrNarrow(8, 4))
```

```Scala
class TooWideOrNarrowUInt(extracteeSize: Int, indexWidth: Int) extends Module {
  val extractee = Wire(UInt(extracteeSize.W))
  val index = Wire(UInt(indexWidth.W))
  (extractee >> index)(0)
}
compile(new TooWideOrNarrowUInt(8, 2))
compile(new TooWideOrNarrowUInt(8, 4))
```

--------------------------------

### Apply `chiselName` Annotation to Chisel Module for Signal Naming

Source: https://github.com/chipsalliance/chisel/wiki/Cookbook

Demonstrates how to apply the `@chiselName` annotation to a Chisel `Module` to ensure that internal signals, such as `innerReg` declared within a `when` block, are given meaningful names in the generated hardware description language. This snippet shows a basic Chisel module with an input, output, and a register updated conditionally.

```Scala
import chisel3._
import chisel3.experimental.chiselName

@chiselName
class TestMod extends Module {
  val io = IO(new Bundle {
    val a = Input(Bool())
    val b = Output(UInt(4.W))
  })
  when (io.a) {
    val innerReg = RegInit(5.U(4.W))
    innerReg := innerReg + 1.U
    io.b := innerReg
  } .otherwise {
    io.b := 10.U
  }
}
```

--------------------------------

### Scala Anonymous Function with Explicit Lambda

Source: https://github.com/chipsalliance/chisel/wiki/CS250-Chisel+Scala-Primer

Demonstrates the use of an anonymous function (lambda) as an argument to a higher-order function in Scala. It shows how the Scala inference engine can infer the types of the lambda's parameters, resulting in a calculated integer value.

```scala
def highOrder(a: Int, b: Int, c:Int, fun:(Int,Int) => Int) = {
	val tmp1 = fun(a, b)
	val tmp2 = fun(b, c)
	fun(tmp1, tmp2)
}

val result = highOrder(2, 5, 7, (a, b) => a+b)
// result: Int = 19
```

--------------------------------

### Omitting Prefixes in Chisel Generated Hardware

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/naming.md

Demonstrates the use of 'chisel3.experimental.noPrefix { ... }' to prevent signal names generated within a specific scope from inheriting the module's prefix. This allows for fine-grained control over naming in the generated hardware description language (HDL).

```Scala
import chisel3.experimental.noPrefix

class ExampleNoPrefix extends Module {
  val in = IO(Input(UInt(2.W)))
  val out = IO(Output(UInt(5.W)))

  val add = noPrefix {
    // foo will not get a prefix
    val foo = RegNext(in + 1.U)
    foo + in
  }

  out := add
}
```

```SystemVerilog
emitSystemVerilog(new ExampleNoPrefix)
```

--------------------------------

### Chisel `Bundle` Using By-Name Parameters to Prevent Aliasing

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/cookbook.md

Presents an alternative solution using Scala's by-name parameters (`gen: => T`) in `UsingByNameParameters`. This syntax is functionally equivalent to a 0-arity function, ensuring that `foo` and `bar` are distinct instances upon access.

```scala
class UsingByNameParameters[T <: Data](gen: => T) extends Bundle {
  val foo = gen
  val bar = gen
}
```

--------------------------------

### Original Chisel GCD Module Definition

Source: https://github.com/chipsalliance/chisel/wiki/Debugging-with-the-Interpreter-REPL-1

This Scala code defines the GCD (Greatest Common Divisor) module in Chisel. It specifies the input/output bundle, declares internal registers `x` and `y` with inferred widths, and implements the Euclidean algorithm for GCD calculation. This is the correct, working version of the module.

```Scala
class GCD extends Module {
  val io = IO(new Bundle {
    val value1        = Input(UInt(16.W))
    val value2        = Input(UInt(16.W))
    val loadingValues = Input(Bool())
    val outputGCD     = Output(UInt(16.W))
    val outputValid   = Output(Bool())
  })

  val x  = Reg(UInt())
  val y  = Reg(UInt())

  when(x > y) { x := x - y }
    .otherwise { y := y - x }

  when(io.loadingValues) {
    x := io.value1
    y := io.value2
  }

  io.outputGCD := x
  io.outputValid := y === 0.U
}
```

--------------------------------

### Declare Chisel Probes with Layer Coloring

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/probes.md

This Chisel code demonstrates the concept of layer-colored probes, where a probe's existence is conditional on a specific layer being enabled. It defines two distinct layers, `A` and `B`, and then declares two output probes, `a` and `b`, within the `Foo` module. Each probe is associated with a different layer, illustrating how to specify layer-coloring for `Probe` types.

```Scala
import chisel3._
import chisel3.layer.{Layer, LayerConfig}
import chisel3.probe.{Probe, ProbeValue}

object A extends Layer(LayerConfig.Extract())
object B extends Layer(LayerConfig.Extract())

class Foo extends Module {
  val a = IO(Output(Probe(Bool(), A)))
  val b = IO(Output(Probe(UInt(8.W), B)))
}
```

--------------------------------

### Implementing Verilog Case Equality in Chisel with `IsX`

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/cookbook.md

This snippet demonstrates how to achieve Verilog-like 'case equality' behavior in Chisel, particularly for assertions, by using `chisel3.util.circt.IsX`. This utility allows checking for unknown (`X`) values, preventing assertions from triggering when inputs are undefined.

```Scala
import chisel3._
import chisel3.util.circt.IsX

class AssertButAllowX extends Module {
  val in = IO(Input(UInt(8.W)))

  // Assert that in is never zero; also do not trigger assert in the presence of X.
  assert(IsX(in) || in =/= 0.U, "in should never equal 0")
}
```

```Scala
// Hidden but will make sure this actually compiles
chisel3.docs.emitSystemVerilog(new AssertButAllowX)
```

--------------------------------

### Create a Bundle literal with partial specification in Chisel

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/appendix/experimental-features.md

Illustrates creating a partially specified Bundle literal. Only the `b` field is initialized, leaving `a` invalidated, which is useful for partial resets or specific assignments as described in 'Unconnected Wires'.

```scala
import chisel3._
import chisel3.experimental.BundleLiterals._

class MyBundle extends Bundle {
  val a = UInt(8.W)
  val b = Bool()
}

class Example2 extends RawModule {
  val out = IO(Output(new MyBundle))
  out := (new MyBundle).Lit(_.b -> true.B)
}
```

```verilog
// Verilog output for the above Chisel code (generated by mdoc:verilog)
// Actual Verilog content not provided in source text.
```

--------------------------------

### Chisel cf-interpolator: Custom printing for Bundles

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/printing.md

Demonstrates how to define custom printing behavior for user-defined `Bundle` types by overriding the `toPrintable` method, allowing for structured and readable output of complex data structures.

```Scala
class Message extends Bundle {
  val valid = Bool()
  val addr = UInt(32.W)
  val length = UInt(4.W)
  val data = UInt(64.W)
  override def toPrintable: Printable = {
    val char = Mux(valid, 'v'.U, '-'.U)
    cf"Message:\n" +
    cf"  valid  : $char%c\n" +
    cf"  addr   : $addr%x\n" +
    cf"  length : $length\n" +
    cf"  data   : $data%x\n"
  }
}

val myMessage = Wire(new Message)
myMessage.valid := true.B
myMessage.addr := "h1234".U
myMessage.length := 10.U
myMessage.data := "hdeadbeef".U

printf(cf"$myMessage")
```

--------------------------------

### Chisel BlackBox with Inline Verilog Definition

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/blackboxes.md

Demonstrates how to embed Verilog code directly within a Chisel `BlackBox` definition using the `HasBlackBoxInline` trait and `setInline` method. This technique is suitable for smaller, self-contained Verilog snippets, copying the code into the target directory.

```scala
import chisel3._
import chisel3.util.HasBlackBoxInline
class BlackBoxRealAdd extends BlackBox with HasBlackBoxInline {
  val io = IO(new Bundle {
    val in1 = Input(UInt(64.W))
    val in2 = Input(UInt(64.W))
    val out = Output(UInt(64.W))
  })
  setInline("BlackBoxRealAdd.v",
    """module BlackBoxRealAdd(
      |    input  [63:0] in1,
      |    input  [63:0] in2,
      |    output reg [63:0] out
      |);
      |always @* begin
      |  out <= $realtobits($bitstoreal(in1) + $bitstoreal(in2));
      |end
      |endmodule
    """.stripMargin)
}
```

--------------------------------

### Forcing Synchronous Reset in Chisel

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/reset.md

Demonstrates how to explicitly force a synchronous reset for Chisel registers and modules using `withReset(reset.asBool)`. It shows how to apply this to standard modules and how to manually connect resets for `RawModules` which lack implicit resets.

```Scala
class ForcedSyncReset extends Module {
  // withReset's argument becomes the implicit reset in its scope
  withReset (reset.asBool) {
    val myReg = RegInit(0.U)
    val myModule = Module(new ResetAgnosticModule)

    // RawModules do not have implicit resets so withReset has no effect
    val myRawModule = Module(new ResetAgnosticRawModule)
    // We must drive the reset port manually
    myRawModule.rst := Module.reset // Module.reset grabs the current implicit reset
  }
}
```

--------------------------------

### Create nested Vec literals in Chisel

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/appendix/experimental-features.md

Shows how to construct arbitrarily nested `Vec` literals, where elements of the `Vec` are themselves `Bundle` literals. This enables complex data structure initialization and hierarchical design.

```scala
import chisel3._
import chisel3.experimental.VecLiterals._

class ChildBundle extends Bundle {
  val foo = UInt(8.W)
}

class VecExample5 extends RawModule {
  val out = IO(Output(Vec(2, new ChildBundle)))
  out := Vec(2, new ChildBundle).Lit(
    0 -> (new ChildBundle).Lit(_.foo -> 42.U),
    1 -> (new ChildBundle).Lit(_.foo -> 7.U)
  )
}
```

```verilog
// Verilog output for the above Chisel code (generated by mdoc:verilog)
// Actual Verilog content not provided in source text.
```

--------------------------------

### Define unnamed temporary signals in Chisel using leading underscore

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/naming.md

Demonstrates the convention of using a leading underscore (`_`) in a `val` name to signify an 'unnamed' or temporary signal in Chisel. Chisel preserves this convention across prefixes, and it can help `firtool` maintain common subexpressions.

```Scala
class TemporaryExample extends Module {
  val in0 = IO(Input(UInt(2.W)))
  val in1 = IO(Input(UInt(2.W)))

  val out = {
    // We need 2 ports so firtool will maintain the common subexpression
    val port0 = IO(Output(UInt(4.W)))
    // out_port1
    val port1 = IO(Output(UInt(4.W)))
    val _sum = in0 + in1
    port0 := _sum + 1.U
    port1 := _sum - 1.U
    // port0 is returned so will get the name "out"
    port0
  }
}
```

```Verilog
emitSystemVerilog(new TemporaryExample)
```

--------------------------------

### Define a Bundle for Unpacking in Chisel

Source: https://github.com/chipsalliance/chisel/wiki/Cookbook

Shows how to define a Chisel Bundle that represents a structured data type. This is often used as a target for unpacking unstructured data, providing a more organized approach.

```scala
class MyBundle extends Bundle {
  val a = UInt(2.W)
  val b = UInt(4.W)
  val c = UInt(3.W)
}
```

--------------------------------

### Define a CSR Description Class (CSRDescription) in Chisel

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/properties.md

This Scala code defines `CSRDescription`, a Chisel `Class` that serves as an abstract description for a Control/Status Register (CSR). It uses `@instantiable` and `@public` annotations to enable integration with Chisel's `Definition` and `Instance` APIs. The class declares output `Property` ports for `identifier`, `description`, and `width`, and corresponding input `Property` ports (`identifierIn`, `descriptionIn`, `widthIn`) which are directly connected to the outputs to capture concrete values upon instantiation.

```scala
import chisel3.properties.Class
import chisel3.experimental.hierarchy.{instantiable, public, Definition, Instance}

// An abstract description of a CSR, represented as a Class.
@instantiable
class CSRDescription extends Class {
  // An output Property indicating the CSR name.
  val identifier = IO(Output(Property[String]()))
  // An output Property describing the CSR.
  val description = IO(Output(Property[String]()))
  // An output Property indicating the CSR width.
  val width = IO(Output(Property[Int]()))

  // Input Properties to be passed to Objects representing instances of the Class.
  @public val identifierIn = IO(Input(Property[String]()))
  @public val descriptionIn = IO(Input(Property[String]()))
  @public val widthIn = IO(Input(Property[Int]()))

  // Simply connect the inputs to the outputs to expose the values.
  identifier := identifierIn
  description := descriptionIn
  width := widthIn
}
```

--------------------------------

### Chisel Module Instantiation with Trait-Based Common Interface

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/appendix/upgrading-from-chisel-3-4.md

Demonstrates the correct and idiomatic way to instantiate Chisel modules with a common interface using a Scala trait. The `inst` variable is now correctly inferred as `HasCommonInterface`, resolving the type error and allowing flexible module selection.

```scala
class Example(useBar: Boolean) extends Module {
  val io = IO(new Bundle {
    val in = IO(Input(UInt(8.W)))
    val out = IO(Output(UInt(8.W)))
  })

  // Now, inst is inferred to be of type "HasCommonInterface"
  val inst = if (useBar) {
    Module(new Bar)
  } else {
    Module(new Foo)
  }

  inst.io.in := io.in
  io.out := inst.io.out
}
```

--------------------------------

### Define a 2-input multiplexer module in Chisel (Scala)

Source: https://github.com/chipsalliance/chisel/wiki/Modules

This snippet demonstrates the basic structure of a Chisel module. It shows how to define a class inheriting from Module, declare its input/output interface using IO(new Bundle{...}) for the 'io' field, and implement the combinational logic using the ':= ' assignment operator.

```Scala
class Mux2 extends Module {
  val io = IO(new Bundle{
    val sel = Input(UInt(1.W))
    val in0 = Input(UInt(1.W))
    val in1 = Input(UInt(1.W))
    val out = Output(UInt(1.W))
  })
  io.out := (io.sel & io.in1) | (~io.sel & io.in0)
}
```

--------------------------------

### Verilog Output for Static Cast and waive Connection

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/connectable.md

Displays the SystemVerilog generated from Example13, demonstrating that the bits fields are connected when a static cast and waive are used, as waive does not prevent connection if the members are structurally equivalent.

```Verilog
chisel3.docs.emitSystemVerilog(new Example13)
```

--------------------------------

### Triggering Chisel Compilation Error for Wire BiConnect

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/interfaces-and-connections.md

This snippet shows the `emitSystemVerilog` command, which, when executed with the `BlockWithTemporaryWires` module, will trigger the compilation error caused by the unsupported `BiConnect` operation on temporary wires. It demonstrates that `BiConnect` is strictly for directioned ports and not for arbitrary internal wire connections.

```Scala
emitSystemVerilog(new BlockWithTemporaryWires)
```

--------------------------------

### Create Nested Chisel Bundles and Vecs

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/bundles-and-vecs.md

This snippet illustrates how to create complex data structures by nesting `Vec` and `Bundle` types. The `BigBundle` contains a `Vec` of signed integers, a boolean flag, and an instance of the previously defined `MyFloat` Bundle.

```scala
class BigBundle extends Bundle {
 // Vector of 5 23-bit signed integers.
 val myVec = Vec(5, SInt(23.W))
 val flag  = Bool()
 // Previously defined bundle.
 val f     = new MyFloat
}
```

--------------------------------

### Partial Connection in Chisel Ignoring Extra Members with waiveAll

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/connectable.md

Shows how to perform a partial connection between Chisel `Bundle`s using `.waiveAll` and static casting to `Data`. This method connects only members present in both the consumer and producer, effectively ignoring any extra members without generating errors, making it a flexible but less safe connection.

```Scala
class OnlyA extends Bundle {
  val a = UInt(32.W)
}
class OnlyB extends Bundle {
  val b = UInt(32.W)
}
class Example11 extends RawModule {
  val in  = IO(Flipped(new OnlyA))
  val out = IO(new OnlyB)

  out := DontCare

  (out: Data).waiveAll :<>= (in: Data).waiveAll
}
```

```Scala
chisel3.docs.emitSystemVerilog(new Example11)
```

--------------------------------

### Chisel Intrinsics: Required Imports for Scala 3

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/intrinsics.md

This snippet provides the necessary `chisel3` imports, including `fromStringToStringParam` which is specifically required for Scala 3 compatibility when working with Chisel Intrinsics.

```Scala
import chisel3._
import chisel3.experimental.fromStringToStringParam
```

--------------------------------

### Chisel Register (RegInit) to Verilog Synchronous Register

Source: https://github.com/chipsalliance/chisel/wiki/ChiselSheet

Illustrates the definition of a hardware register in Chisel using `RegInit` for initialization and its corresponding synchronous Verilog implementation. The Verilog code includes a clock edge trigger and an asynchronous reset for proper sequential logic behavior.

```Chisel
val r = RegInit([init]); r := [next]
```

```Verilog
reg r;
always @ (posedge clk) begin
  if (reset) r <= [init];
  else r <= [next];
end
```

--------------------------------

### Programmatically Create Chisel MixedVec Types

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/bundles-and-vecs.md

This snippet demonstrates how to programmatically define the types within a `MixedVec` using a range. It creates a `MixedVec` where each `UInt` element has a width corresponding to a value in the specified range, showcasing dynamic type generation.

```scala
class ModuleProgrammaticMixedVec(x: Int, y: Int) extends Module {
  val io = IO(new Bundle {
    val vec = Input(MixedVec((x to y) map { i => UInt(i.W) }))
    // ...
  })
  // ...rest of the module goes here...
}
```

--------------------------------

### Chisel: Masked Read/Write Memory (SyncReadMem)

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/memories.md

This snippet demonstrates how to create a `SyncReadMem` that supports byte-masked subword writes. It shows the definition of a module with inputs for address, data, enable, and a mask vector, and how to use the `write` function with the `mask` argument.

```Scala
import chisel3._
class MaskedReadWriteSmem extends Module {
  val width: Int = 8
  val io = IO(new Bundle {
    val enable = Input(Bool())
    val write = Input(Bool())
    val addr = Input(UInt(10.W))
    val mask = Input(Vec(4, Bool()))
    val dataIn = Input(Vec(4, UInt(width.W)))
    val dataOut = Output(Vec(4, UInt(width.W)))
  })

  // Create a 32-bit wide memory that is byte-masked
  val mem = SyncReadMem(1024, Vec(4, UInt(width.W)))
  // Write with mask
  mem.write(io.addr, io.dataIn, io.mask)
  io.dataOut := mem.read(io.addr, io.enable)
}
```

--------------------------------

### Chisel Module with Missing Field in MockDecoupledIO

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/connection-operators.md

This Scala code defines a modified `MockDecoupledIO` where the `bits` field is intentionally removed. It then attempts to use this modified bundle within the `Wrapper` and `PipelineStage` modules, demonstrating how a missing field will lead to a Chisel elaboration error during signal connection.

```scala
import chisel3._
import chisel3.util.DecoupledIO

class MockDecoupledIO extends Bundle {
  val valid = Output(Bool())
  val ready = Input(Bool())
  //val bits = Output(UInt(8.W))
}
class Wrapper extends Module{
  val io = IO(new Bundle {
  val in = Flipped(new MockDecoupledIO())
  val out = new MockDecoupledIO()
  })
  val p = Module(new PipelineStage)
  val c = Module(new PipelineStage)
  // connect producer to I/O
  p.io.a <> io.in
  // connect producer  to consumer
  c.io.a <> p.io.b
  // connect consumer to I/O
  io.out <> c.io.b
}
class PipelineStage extends Module{
  val io = IO(new Bundle{
    val a = Flipped(DecoupledIO(UInt(8.W)))
    val b = DecoupledIO(UInt(8.W))
  })
  io.a <> io.b
}
```

--------------------------------

### Define Serializable GCD Module and Parameter in Scala

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/serialization.md

This Scala code defines a `GCDSerializableModuleParameter` case class to hold the width parameter for a GCD module. It then defines `GCDSerializableModule`, a Chisel module that extends `Module` and `SerializableModule`, taking the parameter as input. An implicit `ReadWriter` for the parameter is provided using `upickle` to enable serialization.

```Scala
import chisel3._
import chisel3.experimental.{SerializableModule, SerializableModuleGenerator, SerializableModuleParameter}
import upickle.default._

// provide serialization functions to GCDSerializableModuleParameter
object GCDSerializableModuleParameter {
  implicit def rwP: ReadWriter[GCDSerializableModuleParameter] = macroRW
}

// Parameter
case class GCDSerializableModuleParameter(width: Int) extends SerializableModuleParameter

// Module
class GCDSerializableModule(val parameter: GCDSerializableModuleParameter)
    extends Module
    with SerializableModule[GCDSerializableModuleParameter] {
  val io = IO(new Bundle {
    val a = Input(UInt(parameter.width.W))
    val b = Input(UInt(parameter.width.W))
    val e = Input(Bool())
    val z = Output(UInt(parameter.width.W))
  })
  val x = Reg(UInt(parameter.width.W))
  val y = Reg(UInt(parameter.width.W))
  val z = Reg(UInt(parameter.width.W))
  val e = Reg(Bool())
  when(e) {
    x := io.a
    y := io.b
    z := 0.U
  }
  when(x =/= y) {
    when(x > y) {
      x := x - y
    }.otherwise {
      y := y - x
    }
  }.otherwise {
    z := x
  }
  io.z := z
}
```

--------------------------------

### Chisel Compiler Plugin Debugging: Indented Conditional `println` Wrapper

Source: https://github.com/chipsalliance/chisel/blob/main/plugin/README.md

Scala function `indentShow` for debugging recursive operations within the Chisel compiler plugin. It indents debug messages based on a `depth` variable and uses the `show` wrapper to conditionally print, providing clearer output for hierarchical processing like `getAllBundleFields`.

```Scala
def indentShow(s: => String): Unit = {
  val indentString = ("-" * depth) * 2 + ">  "
  s.split("\n").foreach { line =>
    show(indentString + line)
  }
}
```

--------------------------------

### Chisel Driver execute Method with Options Manager Signature

Source: https://github.com/chipsalliance/chisel/wiki/Running-Stuff

This Scala snippet shows the signature of an execute method that accepts an ExecutionOptionsManager as a parameter. This manager is a crucial component for holding and passing configuration classes and data between different parts of the Chisel toolchain during execution.

```scala
def execute(
      optionsManager: ExecutionOptionsManager with HasChiselExecutionOptions with HasFirrtlOptions,
      dut: () => Module): ChiselExecutionResult = {
          ???
      }
```

--------------------------------

### Chisel C-style printf Format Specifiers

Source: https://github.com/chipsalliance/chisel/wiki/Printing-in-Chisel

Lists the supported format specifiers for Chisel's C-style `printf` function, including their meaning. These specifiers control the interpretation and display of arguments.

```APIDOC
Format Specifier | Meaning
:-----: | :-----
%d | decimal number
%x | hexadecimal number
%b | binary number
%c | 8-bit ASCII character
%% | literal percent
```

--------------------------------

### Chisel `fileCheck` API Method

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/testing.md

The `fileCheck` method is an extension on `String` in Chisel, used for running FileCheck tests. It takes arguments for the FileCheck tool and an inline test string, preserving input and check strings on failure for manual debugging.

```APIDOC
chisel3.testing.FileCheck:
  fileCheck(
    fileCheckArgs: Seq[String],
    inlineCheckString: String
  ): Unit
```

--------------------------------

### Explore various Scala map method syntaxes

Source: https://github.com/chipsalliance/chisel/wiki/Scala-Things-You-Should-Know

This snippet showcases different syntactic variations for calling the `map` method on a Scala `List` with an anonymous function. It highlights Scala's flexibility in expressing functional transformations, including infix notation and explicit type annotations.

```Scala
intList map ( s => s.toString )
intList.map( s => s.toString )
intList.map { s: Int => s.toString }
intList.map { (s: Int) => s.toString }
```

--------------------------------

### Chisel Repl: Register Width Mismatch Error

Source: https://github.com/chipsalliance/chisel/wiki/Debugging-with-the-Interpreter-REPL-2

Shows an error message from the Chisel Repl indicating a `bad width` exception when attempting to `poke` a value into a register that is too small to hold it, confirming a design issue related to bit width.

```console
Error: exception error: ConcreteUInt(29, 4) bad width 4 needs 5 firrtl_interpreter.InterpreterException: error: ConcreteUInt(29, 4) bad width 4 needs 5
```

--------------------------------

### Connect Unrelated Chisel Bundles using DataView

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/dataview.md

Illustrates another powerful use case of `DataView`: connecting two seemingly unrelated Chisel `Bundle` types. It shows how `viewAs` combined with the `connect` operator (`<>`) can map and connect corresponding fields between different interface structures, simplifying complex wiring.

```Scala
class ConnectionExample extends RawModule {
  val in = IO(new AXIBundle(20))
  val out = IO(Flipped(new VerilogAXIBundle(20)))
  out.viewAs[AXIBundle] <> in
}
```

--------------------------------

### Chisel Indexed N-way Mux using MuxLookup

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/muxes-and-input-selection.md

`MuxLookup` provides an n-way indexed multiplexer, useful when selection is based on an index value. It takes an index, a default value, and a sequence of `index_value -> selected_input_port` pairs. This is functionally equivalent to a `MuxCase` where conditions are index comparisons.

```scala
MuxLookup(idx, default)(Seq(0.U -> a, 1.U -> b, ...))
```

```scala
MuxCase(default,
        Array((idx === 0.U) -> a,
              (idx === 1.U) -> b, ...))
```

--------------------------------

### Chisel: Module Using Default `DataView` for Type Conversion

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/dataview.md

This Chisel module demonstrates how to use the default `DataView` implicit to convert a `Foo` bundle to a `Bar` bundle using the `viewAs` method. The Scala compiler automatically resolves the implicit `DataView` defined in the `Foo` companion object.

```Chisel
class FooToBar extends Module {
  val foo = IO(Input(new Foo))
  val bar = IO(Output(new Bar))
  bar := foo.viewAs[Bar]
}
```

--------------------------------

### Define Chisel Module and Object for FIRRTL Emission

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/resources/faqs.md

This Scala snippet defines a 'MyFirrtlModule' and an accompanying `FirrtlMain` object, which uses `circt.stage.ChiselStage` to emit CHIRRTL (FIRRTL) for the module.

```scala
package intro

import chisel3._
import circt.stage.ChiselStage

class MyFirrtlModule extends Module {
  val io = IO(new Bundle{})
}

object FirrtlMain extends App {
  ChiselStage.emitCHIRRTL(new MyFirrtlModule)
}
```

--------------------------------

### Chisel One-Hot Mux using Mux1H

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/muxes-and-input-selection.md

`Mux1H` is a one-hot multiplexer designed for scenarios where exactly one selector is active. It takes a sequence of `selector_signal -> value` pairs. If zero or multiple selectors are active, the behavior is undefined. This utility generates optimized Firrtl.

```scala
val hotValue = chisel3.util.Mux1H(Seq(
    io.selector(0) -> 2.U,
    io.selector(1) -> 4.U,
    io.selector(2) -> 8.U,
    io.selector(4) -> 11.U,
  ))
```

--------------------------------

### Chisel Scala Module Definition and Initial Compilation

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/warnings.md

Defines a Chisel `RawModule` named `TooWideIndexModule` with an input `idx` that is wider than necessary, leading to a `W004` warning. Compiles the module without any warning configurations to demonstrate the default warning behavior.

```scala
import chisel3._
class TooWideIndexModule extends RawModule {
  val in = IO(Input(Vec(4, UInt(8.W))))
  val idx = IO(Input(UInt(8.W))) // This index is wider than necessary
  val out = IO(Output(UInt(8.W)))

  out := in(idx)
}
compile(new TooWideIndexModule)
```

--------------------------------

### Call Scala Method Using Named Parameters

Source: https://github.com/chipsalliance/chisel/wiki/Scala-Things-You-Should-Know

Demonstrates calling a Scala method by explicitly naming parameters. This improves code readability, especially for methods with many arguments or boolean flags, and allows flexible argument ordering, particularly when combined with default parameters.

```Scala
myMethod(count = 10, wrap = false, wrapValue = 23)
```

--------------------------------

### Chisel BiConnect Operator for Module Composition

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/interfaces-and-connections.md

This Scala code demonstrates the use of Chisel's `BiConnect` (`<>`) operator to compose two `Filter` modules into a larger `Block`. It shows how `BiConnect` facilitates element-wise, bidirectional connections between `FilterIO` instances, effectively chaining the filters.

```Scala
class Block extends Module {
  val io = IO(new FilterIO)
  val f1 = Module(new Filter)
  val f2 = Module(new Filter)
  f1.io.x <> io.x
  f1.io.y <> f2.io.x
  f2.io.y <> io.y
}
```

--------------------------------

### Chisel cf-interpolator: Format modifiers for padding

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/printing.md

Illustrates the use of Verilog-style format modifiers for padding (`%d`, `%x`, `%b`) with `cf` interpolator, including zero-padding and space-padding, and overriding default widths.

```Scala
val foo = WireInit(UInt(32.W), 33.U)
printf(cf"foo = $foo%d!\n")  // foo =         33!
printf(cf"foo = $foo%0d!\n") // foo = 33!
printf(cf"foo = $foo%4d!\n") // foo =   33!
printf(cf"foo = $foo%x!\n")  // foo = 00000021!
printf(cf"foo = $foo%0x!\n") // foo = 21!
printf(cf"foo = $foo%4x!\n") // foo = 0021!
val bar = WireInit(UInt(8.W), 5.U)
printf(cf"bar = $bar%b!\n")  // foo = 00000101!
printf(cf"bar = $bar%0b!\n") // foo = 101!
printf(cf"bar = $bar%4b!\n") // foo = 0101!
```

--------------------------------

### Modify Scala-CLI for Detailed Lit Output

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/developers/lit-test.md

A diff showing how to temporarily modify the `panama.sc` file to enable more detailed output from `lit` for debugging purposes. This change adds the `-a` flag to the `lit` command, which provides all output.

```Diff
diff --git a/panama.sc b/panama.sc
--- a/panama.sc
+++ b/panama.sc
@@ -243,7 +243,7 @@ trait LitModule extends Module {
     PathRef(T.dest)
   }
   def run(args: String*) = T.command(
-    os.proc("lit", litConfig().path)
+    os.proc("lit", litConfig().path, "-a")
       .call(T.dest, stdout = os.ProcessOutput.Readlines(line => T.ctx().log.info("[lit] " + line)))
   )
 }
```

--------------------------------

### Add Scala Compiler Plugin for `chiselName` Annotation in `build.sbt`

Source: https://github.com/chipsalliance/chisel/wiki/Cookbook

Provides the necessary `build.sbt` configuration to enable the `chiselName` annotation. This involves adding the `paradise` compiler plugin, which is required for macro annotations like `@chiselName` to function correctly in Scala projects.

```Scala
addCompilerPlugin("org.scalamacros" % "paradise" % "2.1.0" cross CrossVersion.full)
```

--------------------------------

### Create DataView for Type-Parameterized Bundles in Chisel

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/dataview.md

Learn how to define an implicit DataView for Bundle classes that incorporate type parameters. This approach uses a def instead of a val to correctly handle the generic type, ensuring proper DataView generation for each specific type instantiation. Remember to use .cloneType when creating the target Bundle.

```Scala
import chisel3._
import chisel3.experimental.dataview._

class Foo[T <: Data](val foo: T) extends Bundle
class Bar[T <: Data](val bar: T) extends Bundle

object Foo {
  implicit def view[T <: Data]: DataView[Foo[T], Bar[T]] = {
    DataView(f => new Bar(f.foo.cloneType), _.foo -> _.bar)
    // .cloneType is necessary because the f passed to this function will be bound hardware
  }
}
```

--------------------------------

### Verilog Output with Dynamically Set Module Name

Source: https://github.com/chipsalliance/chisel/wiki/Cookbook

Displays the resulting Verilog output after elaborating a Chisel module where `desiredName` was overridden. This demonstrates how the custom names are reflected in the generated HDL.

```verilog
module SodiumMonochloride(
  input   clock,
  input   reset
);
  wire [31:0] drink_O;
  wire [31:0] drink_I;
  Tea drink (
    .O(drink_O),
    .I(drink_I)
  );
  assign drink_I = 32'h0;
endmodule
```

--------------------------------

### Flush buffered SimLog output to standard error

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/printing.md

Demonstrates flushing the standard error SimLog object, which flushes all standard printf outputs.

```Scala
SimLog.StdErr.flush() // This will flush all standard printfs.
```

--------------------------------

### Failing `DataView` Due to Non-Totality

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/dataview.md

Demonstrates a `DataView` definition that fails because it does not map all fields of the source `BundleA` to the target `BundleB`. This highlights Chisel's strict totality requirement for standard `DataView`s.

```scala
// We forgot BundleA.foo in the mapping!
implicit val myView: DataView[BundleA, BundleB] = DataView(_ => new BundleB, _.bar -> _.fizz)
class BadMapping extends Module {
   val in = IO(Input(new BundleA))
   val out = IO(Output(new BundleB))
   out := in.viewAs[BundleB]
}
// We must run Chisel to see the error
getVerilogString(new BadMapping)
```

--------------------------------

### Chisel `AliasedBundle` Definition Demonstrating Field Aliasing

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/cookbook.md

Illustrates a problematic `AliasedBundle` definition where `foo` and `bar` fields directly reference the same `gen` object. This direct assignment leads to aliasing, which Chisel cannot distinguish, resulting in errors during hardware generation.

```scala
class AliasedBundle[T <: Data](gen: T) extends Bundle {
  val foo = gen
  val bar = gen
}
```

--------------------------------

### Casting Chisel Data Types

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/data-types.md

Demonstrates how to cast between `SInt` and `UInt` types in Chisel using `asUInt` and `asSInt` methods. It's important to note that explicit width parameters are not accepted for these casting methods, as Chisel handles padding or truncation automatically.

```scala
val sint = 3.S(4.W)             // 4-bit SInt

val uint = sint.asUInt          // cast SInt to UInt
uint.asSInt                     // cast UInt to SInt
```

--------------------------------

### Conditional Wire Assignment with `when` and `otherwise` in Chisel

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/combinational-circuits.md

Shows how to declare a `Wire` and assign values conditionally using Chisel's `when` and `otherwise` constructs, which synthesize into hardware logic similar to an if-else statement based on a control signal.

```Scala
val myNode = Wire(UInt(8.W))
when (isReady) {
  myNode := 255.U
} .otherwise {
  myNode := 0.U
}
```

--------------------------------

### Chisel Module with Verification and Debug Layers

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/layers.md

This Scala code defines a Chisel module Foo that incorporates built-in Verification and Assert layers, alongside a user-defined Debug layer. It demonstrates how to declare custom layers and use block constructs to encapsulate conditional logic, such as assertions and printf statements, which are selectively included during Verilog elaboration.

```scala
import chisel3._
import chisel3.layer.{Layer, LayerConfig, block}
import chisel3.layers.Verification

// User-defined layers are declared here.  Built-in layers do not need to be declared.
object UserDefined {
  implicit val root: Layer = Verification
  object Debug extends Layer(LayerConfig.Inline)
}

class Foo extends Module {
  val a = IO(Input(UInt(32.W)))
  val b = IO(Output(UInt(32.W)))

  b := a +% 1.U

  // This adds a `Verification` layer block inside Foo.
  block(Verification) {

    // Some common logic added here.  The input port `a` is "captured" and
    // used here.
    val a_d0 = RegNext(a)

    // This adds an `Assert` layer block.
    block(Verification.Assert) {
      chisel3.assert(a >= a_d0, "a must always increment")
    }

    // This adds a `Debug` layer block.
    block(UserDefined.Debug) {
      printf("a: %x, a_d0: %x", a, a_d0)
    }

  }

}
```

--------------------------------

### Represent Hardware-level Unsigned/Signed Integer in Chisel/Verilog

Source: https://github.com/chipsalliance/chisel/wiki/ChiselSheet

This snippet shows the representation of a hardware-level unsigned or signed integer in Chisel using `[x].U([w].W)`, where `[x]` is the value and `[w]` is the bit width. This directly translates to a fixed-width decimal literal in Verilog, formatted as `[w]'d[x]`, representing an actual hardware signal.

```Chisel
[x].U([w].W)
```

```Verilog
[w]'d[x]
```

--------------------------------

### Failed SBT Test Output for Broken Chisel GCD

Source: https://github.com/chipsalliance/chisel/wiki/Debugging-with-the-Interpreter-REPL-1

This output displays the test failures encountered after the GCD module was modified to introduce a width truncation bug. Both Firrtl and Verilator backends report failures, indicating that the circuit no longer behaves as expected. This confirms the breakage and highlights the need for debugging.

```Shell
[info] GCD
[info] - should calculate proper greatest common denominator (with firrtl) *** FAILED ***
[info]   false was not true (GCDUnitTest.scala:71)
[info] GCD
[info] - should calculate proper greatest common denominator (with verilator) *** FAILED ***
[info]   false was not true (GCDUnitTest.scala:71)
[info] Basic test using Driver.execute
```

--------------------------------

### Chisel: Representing Combinational Logic with Textual Expressions

Source: https://github.com/chipsalliance/chisel/wiki/Combinational-Circuits

Demonstrates how to express a simple combinational logic circuit in Chisel using Scala-like textual expressions. Bitwise operators `&` (AND), `|` (OR), and `~` (NOT) are used with named wires `a` through `d` to form a circuit tree.

```scala
(a & b) | (~c & d)
```

--------------------------------

### Correct Chisel Queue Initialization (Fixed Code)

Source: https://github.com/chipsalliance/chisel/wiki/Unconnected-Wires

Corrected Chisel code snippet for queue initialization that properly initializes both the `valid` bit and the actual output values of the queue.

```Scala
io.outs.foreach { out =>
    out.bits := 0.U.asTypeOf(out.bits)
    out.noenq()
  }
```

--------------------------------

### SystemVerilog File Naming for Extract Layers

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/layers.md

When Chisel designs with extract layers are compiled to SystemVerilog, specific `.sv` files are generated to represent each layer. Including these files in the build enables the corresponding layers. Child layer files automatically include parent layer files.

```SystemVerilog
layers-Foo-A.sv
layers-Foo-C.sv
layers-Foo-C-D.sv
```

--------------------------------

### Define a Combinational Logic Block Function in Chisel/Scala

Source: https://github.com/chipsalliance/chisel/wiki/Functional-Abstraction

This snippet defines a reusable combinational logic block function named `clb` in Scala, which takes four `UInt` inputs and returns a single `UInt` output. It demonstrates how to encapsulate a boolean circuit using Scala's `def` keyword for hardware design, making the logic reusable.

```Scala
def clb(a: UInt, b: UInt, c: UInt, d: UInt): UInt = 
  (a & b) | (~c & d)
```

--------------------------------

### Apply DecoupledIO Template to DataBundle

Source: https://github.com/chipsalliance/chisel/wiki/Polymorphism-and-Parameterization

Demonstrates how to use the `DecoupledIO` template to create a decoupled interface for a `DataBundle`. This simplifies the definition of handshaking protocols for custom data types, promoting consistency and reusability.

```Scala
class DecoupledDemo extends DecoupledIO(new DataBundle)
```

--------------------------------

### Connect Chisel Components with Different Widths Using Squeeze

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/connectable.md

Explains how to connect Chisel components with differing bit widths using the `squeeze` mechanism with `Connectable` operators. This allows for implicit truncation of the source component's width to match the destination, providing flexibility where truncation is desired.

```Scala
import scala.collection.immutable.SeqMap

class Example14 extends RawModule {
  val p = IO(Flipped(UInt(4.W)))
  val c = IO(UInt(3.W))

  c :<>= p.squeeze
}
```

```Scala
chisel3.docs.emitSystemVerilog(new Example14)
```

--------------------------------

### Define Parameterized FilterIO Bundle

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/polymorphism-and-parameterization.md

Illustrates how to define a parameterized Bundle in Chisel, FilterIO, which takes a generic type T (constrained to Data) to define its input and output signals. This enables the creation of reusable I/O interfaces for various data types.

```Scala
class FilterIO[T <: Data](gen: T) extends Bundle {
  val x = Input(gen)
  val y = Output(gen)
}
```

--------------------------------

### Chisel MuxCase (n-way selector)

Source: https://github.com/chipsalliance/chisel/wiki/Muxes-and-Input-Selection

`MuxCase` provides an n-way multiplexer functionality, allowing selection from multiple inputs based on an array of condition-value pairs. Each pair is represented as a tuple `condition -> selected_input_port`.

```scala
MuxCase(default, Array(c1 -> a, c2 -> b, ...))
```

--------------------------------

### Define Scala functions and classes with parameters

Source: https://github.com/chipsalliance/chisel/wiki/Scala-Things-You-Should-Know

This snippet illustrates how to define functions and classes with parameters in Scala. It includes a function `add1` that increments an integer and a class `RepeatString` that concatenates an input string with itself.

```Scala
def add1(c: Int): Int = {
  c + 1
}
class RepeatString(s: String) {
  val repeatedString = s + s
}
```

--------------------------------

### Create a Chisel MixedVec with Programmatic Types

Source: https://github.com/chipsalliance/chisel/wiki/Bundles-and-Vecs

Demonstrates a more advanced use of `MixedVec` in Chisel, where the types of the elements are generated programmatically. This allows for flexible creation of heterogeneous vectors based on input parameters.

```Scala
class MyModule(x: Int, y: Int) extends Module {
  val io = IO(new Bundle {
    val vec = Input(MixedVec((x to y) map { i => UInt(i.W) }))
    // ...
  })
  // ...rest of the module goes here...
}
```

--------------------------------

### Dynamically Setting Chisel Module Names using desiredName Override

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/cookbook.md

This Scala code demonstrates how to override the `desiredName` function in Chisel modules and `BlackBox`es to explicitly control their names in the generated Verilog. The `Coffee` BlackBox is named 'Tea' and the `Salt` module is named 'SodiumMonochloride', showcasing custom naming for hierarchical modules.

```Scala
import chisel3._

class Coffee extends BlackBox {
    val io = IO(new Bundle {
        val I = Input(UInt(32.W))
        val O = Output(UInt(32.W))
    })
    override def desiredName = "Tea"
}

class Salt extends Module {
    val io = IO(new Bundle {})
    val drink = Module(new Coffee)
    override def desiredName = "SodiumMonochloride"

    drink.io.I := 42.U
}
```

```Scala
chisel3.docs.emitSystemVerilog(new Salt)
```

--------------------------------

### Instantiate Edge-Triggered Register

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/sequential-circuits.md

Instantiates a positive edge-triggered register using `RegNext`, which delays the input signal 'in' by one clock cycle. The type of the register is automatically inferred from its input.

```scala
val reg = RegNext(in)
```

--------------------------------

### Transform list elements using Scala map with a code block

Source: https://github.com/chipsalliance/chisel/wiki/Scala-Things-You-Should-Know

This snippet demonstrates using the `map` method on a Scala `List` with a parameterized code block. It transforms a list of integers into a list of their string representations, showcasing a common functional programming pattern.

```Scala
val intList = List(1, 2, 3)
val stringList = intList.map { i =>
  i.toString
}
```

--------------------------------

### Chisel Built-in Layers Hierarchy

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/layers.md

Chisel includes several predefined layers, all of which are extract layers. These layers, such as `Verification`, `Assert`, `Assume`, and `Cover`, are designed to sequester verification code and are used by the Chisel standard library APIs for automatic placement of prints, assertions, assumptions, and covers.

```Scala
chisel3.layers.Verification
├── chisel3.layers.Verification.Assert
├── chisel3.layers.Verification.Assume
└── chisel3.layers.Verification.Cover
```

--------------------------------

### Explicitly Define Single-Ported SyncReadMem using readWrite in Chisel

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/memories.md

This Chisel module `RDWR_Smem` shows how to explicitly create a single-ported `SyncReadMem` using the `readWrite` method. This method provides a unified accessor for both read and write operations based on control signals.

```Scala
class RDWR_Smem extends Module {
  val width: Int = 32
  val io = IO(new Bundle {
    val enable = Input(Bool())
    val write = Input(Bool())
    val addr = Input(UInt(10.W))
    val dataIn = Input(UInt(width.W))
    val dataOut = Output(UInt(width.W))
  })

  val mem = SyncReadMem(1024, UInt(width.W))
  io.dataOut := mem.readWrite(io.addr, io.dataIn, io.enable, io.write)
}
```

--------------------------------

### Chisel `Bundle` Misuse of 0-arity Function Parameters Leading to Aliasing

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/cookbooks/cookbook.md

Provides a crucial warning by demonstrating `MisusedFunctionArguments`, where an already constructed `Data` value (`fizz`) is captured by the 0-arity function. This incorrect usage reintroduces the aliasing problem, as `foo` and `bar` will still point to the same `fizz` object.

```scala
class MisusedFunctionArguments extends Module {
  // This usage is correct
  val in = IO(Input(new UsingAFunctionBundle(() => UInt(8.W))))

  // This usage is incorrect
  val fizz = UInt(8.W)
  val out = IO(Output(new UsingAFunctionBundle(() => fizz)))
}
getVerilogString(new MisusedFunctionArguments)
```

--------------------------------

### Instantiate Child Module in Explicit Clock and Reset Domain in Chisel

Source: https://github.com/chipsalliance/chisel/wiki/Multiple-Clock-Domains

This Chisel Scala code demonstrates how to instantiate a child module (`ChildModule`) within a specific clock and reset domain. By wrapping the `Module(new ChildModule)` instantiation with `withClockAndReset(io.clockB, io.resetB)`, the child module's internal synchronous elements will operate under `io.clockB` and `io.resetB`.

```Scala
class MultiClockModule extends Module {
  val io = IO(new Bundle {
    val clockB = Input(Clock())
    val resetB = Input(Bool())
    val stuff = Input(Bool())
  })
  val clockB_child = withClockAndReset(io.clockB, io.resetB) { Module(new ChildModule) }
  clockB_child.io.in := io.stuff
}
```

--------------------------------

### FIRRTL Type API Functions

Source: https://github.com/chipsalliance/chisel/blob/main/circtpanamabinding/includeFunctions.txt

Defines API functions for creating and querying various FIRRTL (Flexible Intermediate Representation for RTL) types, including integer, clock, reset, analog, vector, and bundle types. These functions are used to construct the type system within FIRRTL.

```APIDOC
firrtlTypeGetUInt()
firrtlTypeGetSInt()
firrtlTypeGetClock()
firrtlTypeGetReset()
firrtlTypeGetAsyncReset()
firrtlTypeGetAnalog()
firrtlTypeGetVector()
firrtlTypeGetBundle()
firrtlTypeIsAOpenBundle()
firrtlTypeGetBundleFieldIndex()
firrtlTypeGetRef()
firrtlTypeGetAnyRef()
firrtlTypeGetInteger()
firrtlTypeGetDouble()
firrtlTypeGetString()
firrtlTypeGetBoolean()
firrtlTypeGetPath()
firrtlTypeGetList()
firrtlTypeGetClass()
firrtlTypeGetMaskType()
```

--------------------------------

### Connect Chisel Bundles with Optional Members Using Waive

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/explanations/connectable.md

Illustrates connecting Chisel `Bundle`s that may have optional members. The `:<>=` operator combined with `.waive` is used to connect common fields while gracefully ignoring optional members that are not present in both the source and destination bundles.

```Scala
class MyDecoupledOpt(hasBits: Boolean) extends Bundle {
  val valid = Bool()
  val ready = Flipped(Bool())
  val bits = if (hasBits) Some(UInt(32.W)) else None
}
class Example6 extends RawModule {
  val in  = IO(Flipped(new MyDecoupledOpt(true)))
  val out = IO(new MyDecoupledOpt(false))
  out :<>= in.waive(_.bits.get) // We can know to call .get because we can inspect in.bits.isEmpty
}
```

```Scala
chisel3.docs.emitSystemVerilog(new Example6)
```

--------------------------------

### Create a Vec literal with inferred type and length in Chisel

Source: https://github.com/chipsalliance/chisel/blob/main/docs/src/appendix/experimental-features.md

Demonstrates creating a `Vec` literal where the type and length are inferred from the provided elements. This is a concise way to initialize a `Vec` without explicitly specifying its dimensions.

```scala
import chisel3._
import chisel3.experimental.VecLiterals._

class VecExample1 extends Module {
  val out = IO(Output(Vec(2, UInt(4.W))))
  out := Vec.Lit(0xa.U, 0xbb.U)
}
```

```verilog
// Verilog output for the above Chisel code (generated by mdoc:verilog)
// Actual Verilog content not provided in source text.
```