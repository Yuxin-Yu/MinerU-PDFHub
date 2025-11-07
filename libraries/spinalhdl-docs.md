================
CODE SNIPPETS
================
### SpinalHDL Standard and In-place Assignments

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Semantic/assignments.rst

Demonstrates standard assignment (:=) and in-place update assignment (\=) for combinational signals in SpinalHDL. The standard assignment is similar to VHDL/Verilog, while \= updates instantly and is restricted to combinational signals. Automatic connection using <> is also shown.

```scala
val a, b, c = UInt(4 bits)
a := 0
b := a
// a := 1 // this would cause an `assignment overlap` error,
          // if manually overridden the assignment would take assignment priority
c := a

var x = UInt(4 bits)
val y, z = UInt(4 bits)
x := 0
y := x      // y read x with the value 0
x \= x + 1
z := x      // z read x with the value 1

// Automatic connection between two UART interfaces.
// uartCtrl.io.uart <> io.uart
```

--------------------------------

### SpinalHDL Fixed-Point Assignments and Truncation

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/Fix.rst

Illustrates valid and invalid assignments between fixed-point signals in SpinalHDL, emphasizing the prevention of bit loss. It demonstrates the use of the `truncated` function to resize source numbers to match destination sizes.

```scala
   val i16_m2 = SFix(16 exp, -2 exp)
   val i16_0  = SFix(16 exp,  0 exp)
   val i8_m2  = SFix( 8 exp, -2 exp)
   val o16_m2 = SFix(16 exp, -2 exp)
   val o16_m0 = SFix(16 exp,  0 exp)
   val o14_m2 = SFix(14 exp, -2 exp)

   o16_m2 := i16_m2            // OK
   o16_m0 := i16_m2            // Not OK, Bit loss
   o14_m2 := i16_m2            // Not OK, Bit loss
   o16_m0 := i16_m2.truncated  // OK, as it is resized to match assignment target
   o14_m2 := i16_m2.truncated  // OK, as it is resized to match assignment target
   val o18_m2 = i16_m2.truncated(18 exp, -2 exp)
   val o18_22b = i16_m2.truncated(18 exp, 22 bit)
```

--------------------------------

### SpinalHDL Automatic Resizing of Literals

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Semantic/assignments.rst

Illustrates SpinalHDL's automatic widening of literal values when assigning to signals of a different bit width. This behavior is similar to using `.resized` but applied implicitly to literals.

```scala
// U(3) creates an UInt of 2 bits, which doesn't match the left side (8 bits)
// myUIntOf_8bits := U(3)
```

--------------------------------

### AFix Truncated Assignment in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/AFix.rst

Demonstrates the .truncated function for controlling AFix assignment to smaller types in Scala. It allows configuration of saturation, overflow, and rounding behavior. The .saturated() helper provides a common saturation pattern.

```scala
def truncated(saturation: Boolean = false,
                overflow  : Boolean = true,
                rounding  : RoundType = RoundType.FLOOR)

def saturated(): AFix = this.truncated(saturation = true, overflow = false)
```

--------------------------------

### Automatic Naming of Data Instances in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Structuring/naming.rst

Demonstrates how SpinalHDL automatically names `Data` instances (like `UInt` or `Bits`) when they are declared as `val` within a `Component`. Unnamed, temporary signals created within functions might be optimized away if not stored in a component's `val`.

```scala
class MyComponent extends Component {
  val a,b = in UInt(8 bits) // Will be properly named
  val toto = out UInt(8 bits)   // same

  def doStuff(): Unit = {
    val tmp = UInt(8 bits) // This will not be named, as it isn't stored anywhere in a
                           // component val (but there is a solution explained later)
    tmp := 0x20
    toto := tmp
  }
  doStuff()
}

```

--------------------------------

### AFix Saturation Examples in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/AFix.rst

Provides examples of using the saturation functionality on AFix instances in Scala. Demonstrates how to saturate to a specific range or to another AFix instance, considering different exponents.

```scala
val a = new AFix(63, 0, -2 exp) // [0 to 63, 2^-2]
a.sat(63, 0)                    // [0 to 63, 2^-2]
a.sat(63, 0, -3 exp)            // [0 to 31, 2^-2]
a.sat(new AFix(31, 0, -1 exp))  // [0 to 31, 2^-2]
```

--------------------------------

### Scala: Example of Internal Clock Domain Usage

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Structuring/clock_domain.rst

An example demonstrating the creation and usage of an internal clock domain, including instantiating a PLL and assigning signals within a ClockingArea.

```scala
class InternalClockWithPllExample extends Component {
  val io = new Bundle {
    val clk100M = in Bool()
    val aReset  = in Bool()
    val result  = out UInt (4 bits)
  }
  // myClockDomain.clock will be named myClockName_clk
  // myClockDomain.reset will be named myClockName_reset
  val myClockDomain = ClockDomain.internal("myClockName")

  // Instantiate a PLL (probably a BlackBox)
  val pll = new Pll()
  pll.io.clkIn := io.clk100M

  // Assign myClockDomain signals with something
  myClockDomain.clock := pll.io.clockOut
  myClockDomain.reset := io.aReset || !pll.io..

  // Do whatever you want with myClockDomain
  val myArea = new ClockingArea(myClockDomain) {
    val myReg = Reg(UInt(4 bits)) init(7)
    myReg := myReg + 1

    io.result := myReg
  }
}
```

--------------------------------

### SpinalHDL Latch Detection: Using muxListDc for Default Handling

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Design errors/latch_detected.rst

Presents the use of `muxListDc` in SpinalHDL as a more robust alternative to `mux` for handling cases where a default value is not explicitly needed, preventing potential latch detection errors. The example shows its usage with a sequence of mappings.

```scala
val u1 = UInt(1 bit)
// automatically adds default if needed
u1.muxListDc(Seq(0 -> True))
```

--------------------------------

### SpinalHDL Signal Width Inference and Resizing

Source: https://context7.com/spinalhdl/spinaldoc-rtd/llms.txt

Demonstrates automatic width inference for literals and explicit resize operations in SpinalHDL. It covers how signals can infer their width from assignments and the use of CombInit for copy-by-value semantics to ensure predictable behavior, especially within helper functions.

```Scala
// Automatic width inference for literals
val myUIntOf_8bits = UInt(8 bits)
myUIntOf_8bits := U(3)          // U(3) is "weak" 2-bit, auto-widened to 8 bits

// Explicit resize operations
val source = UInt(16 bits)
val dest = UInt(8 bits)

dest := source.resized           // Auto-resize to dest width (8 bits), keeps LSB
dest := source.resize(8)         // Explicit resize to 8 bits, keeps LSB
dest := source.resizeLeft(8)     // Resize keeping MSB side

// Width-inferred signal with assignments
val myBits = Bits()              // Width inferred from assignments
myBits := B("1010").resized      // Marked for auto-resize
when(condMaybe) {
  myBits := B("110000")          // Widest assignment: 6 bits, determines myBits width
}

// CombInit for copy-by-value semantics
val a = UInt(8 bits)
a := 1

val b = a                        // b references same signal as a
when(sel) {
  b := 2                         // Also changes a to 2
}

val c = UInt(8 bits)
c := 1

val d = CombInit(c)             // d is a copy with current assignments
when(sel) {
  d := 2                        // Only changes d, c remains 1
}

// CombInit in helper functions for predictable behavior
def invertedIf(b: Bits, condition: Boolean): Bits =
  if(condition) { ~b } else { CombInit(b) }

val a2 = invertedIf(a1, false)
when(sel) {
  a2 := 0                       // Without CombInit, would also assign to a1
}
```

--------------------------------

### SpinalHDL Register Assignment via Function

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Semantic/rules.rst

Demonstrates assigning a value to a SpinalHDL register using a helper function, showcasing the object-oriented manipulation of hardware elements.

```scala
val inc, clear = Bool()
val counter = Reg(UInt(8 bits))

def setCounter(value : UInt): Unit = {
  counter := value
}

when(inc) {
  setCounter(counter + 1)  // Set counter with counter + 1
}
when(clear) {
  counter := 0
}
```

--------------------------------

### SpinalHDL Assignments and Concurrency

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/miscelenea/core/core_components.rst

Demonstrates standard assignments (:=), instant updates (/=), automatic signal connections (<>), and how hardware concurrency affects signal reads in SpinalHDL.

```scala
   // Because of hardware concurrency is always read with the value '1' by b and c
   val a,b,c = UInt(4 bits)
   a := 0
   b := a
   a := 1  // a := 1 win
   c := a  

   var x = UInt(4 bits)
   val y,z = UInt(4 bits)
   x := 0
   y := x      // y read x with the value 0
   x \= x + 1
   z := x      // z read x with the value 1
```

--------------------------------

### SpinalHDL Comparison Operations

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/Int.rst

Demonstrates comparison operations in SpinalHDL, including equality, inequality, greater than, greater than or equal to, less than, and less than or equal to. The example shows how these comparisons can be used within 'when-elsewhen-otherwise' constructs to control logic flow.

```scala
val a = U(5, 8 bits)
val b = U(10, 8 bits)
val c = UInt(2 bits)

when (a > b) {
  c := U"10"
} elsewhen (a =/= b) {
  c := U"01"
} elsewhen (a === U(0)) {
  c.setAll()
} otherwise {
  c.clearAll()
}
```

--------------------------------

### SpinalHDL Conditional Register Assignment Function

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Semantic/rules.rst

Presents a SpinalHDL function that conditionally assigns a value to a register, further illustrating the integration of Scala functions with hardware elements.

```scala
val inc, clear = Bool()
val counter = Reg(UInt(8 bits))

def setCounterWhen(cond : Bool,value : UInt): Unit = {
  when(cond) {
    counter := value
  }
}

setCounterWhen(cond = inc,   value = counter + 1)
```

--------------------------------

### SpinalHDL Bit and Range Extraction

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/Int.rst

Demonstrates static and dynamic access to individual bits, bit ranges, and assigning values to parts of signals in SpinalHDL. Supports fixed and variable offsets and various range specifications.

```scala
// get the element at the index 4
val myBool = myUInt(4)
// assign element 1
myUInt(1) := True

// index dynamically
val index = UInt(2 bit)
val indexed = myUInt(index, 2 bit)

// range index
val myUInt_8bit = myUInt_16bit(7 downto 0)
val myUInt_7bit = myUInt_16bit(0 to 6)
val myUInt_6bit = myUInt_16bit(0 until 6)
// assign to myUInt_16bit(3 downto 0)
myUInt_8bit(3 downto 0) := myUInt_4bit

// equivalent slices, no reversing occurs
val a = myUInt_16bit(8 downto 4)
val b = myUInt_16bit(4 to 8)

// read / assign the msb / leftmost bit / x.high bit
val isNegative = mySInt_16bit.sign
myUInt_16bit.msb := False
```

--------------------------------

### Publish SpinalHDL Locally with Mill

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Developers area/mill support.rst

Publishes the SpinalHDL library to the local ivy2 repository as a development version using Mill. This allows other projects to depend on the locally built version. The Sbt equivalent is also shown.

```sh
mill __.publishLocal
```

```sh
sbt publishLocal
```

--------------------------------

### SpinalHDL: Configuring Global Allowance for Out-of-Range Literals

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Design errors/out_of_range_constant.rst

Illustrates how to configure SpinalHDL globally to allow all comparisons with out-of-range literals. This is achieved by setting the 'allowOutOfRangeLiterals' parameter to 'true' within the SpinalConfig.

```scala
SpinalConfig(allowOutOfRangeLiterals = true)
```

--------------------------------

### Verilog: Arithmetic Expression Splitting (Scala Example)

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Structuring/naming.rst

Demonstrates how SpinalHDL transforms a Scala expression involving multiple additions into smaller Verilog assignments. This ensures compatibility with the Scala API by breaking down complex operations into intermediate signals.

```scala
class MyComponent extends Component {
    val a,b,c,d = in UInt(8 bits)
    val result = a + b + c + d
  }
```

```verilog
module MyComponent (
  input      [7:0]    a,
  input      [7:0]    b,
  input      [7:0]    c,
  input      [7:0]    d
);
  wire       [7:0]    _zz_result;
  wire       [7:0]    _zz_result_1;
  wire       [7:0]    result;

  assign _zz_result = (_zz_result_1 + c);
  assign _zz_result_1 = (a + b);
  assign result = (_zz_result + d);

endmodule
```

--------------------------------

### SpinalHDL Peripheral Instantiation and APB3 Decoder

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Foreword/index.rst

This snippet demonstrates how to instantiate an AXI4 to APB3 bridge, several APB3 peripherals, and an APB3 decoder that maps these peripherals into specific memory regions. It showcases SpinalHDL's object-oriented approach to hardware design, reducing the verbosity typically found in VHDL or Verilog.

```scala
   // Instantiate an AXI4 to APB3 bridge
   val apbBridge = Axi4ToApb3Bridge(
     addressWidth = 20,
     dataWidth    = 32,
     idWidth      = 4
   )

   // Instantiate some APB3 peripherals
   val gpioACtrl = Apb3Gpio(gpioWidth = 32)
   val gpioBCtrl = Apb3Gpio(gpioWidth = 32)
   val timerCtrl = PinsecTimerCtrl()
   val uartCtrl = Apb3UartCtrl(uartCtrlConfig)
   val vgaCtrl = Axi4VgaCtrl(vgaCtrlConfig)

   // Instantiate an APB3 decoder
   // - Driven by the apbBridge
   // - Map each peripheral in a memory region
   val apbDecoder = Apb3Decoder(
     master = apbBridge.io.apb,
     slaves = List(
       gpioACtrl.io.apb -> (0x00000, 4 KiB),
       gpioBCtrl.io.apb -> (0x01000, 4 KiB),
       uartCtrl.io.apb  -> (0x10000, 4 KiB),
       timerCtrl.io.apb -> (0x20000, 4 KiB),
       vgaCtrl.io.apb   -> (0x30000, 4 KiB)
     )
   )
```

--------------------------------

### SpinalHDL Signal Resizing Techniques

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Semantic/assignments.rst

Demonstrates various techniques for resizing signals in SpinalHDL assignments, including inferred resizing (`.resized`), explicit width resizing (`.resize(newWidth)`), and left-aligned resizing (`.resizeLeft(newWidth)`).

```scala
// x := y.resized
// x := y.resize(newWidth)
// x := y.resizeLeft(newWidth)
```

--------------------------------

### SpinalHDL muxListDc for Configurable Width Selection

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Semantic/when_switch.rst

Demonstrates the use of `muxListDc` for selecting bits from a vector with a configurable width. This method allows for unassigned cases, which will result in 'X' during simulation, making it suitable for generic code where not all cases need explicit handling.

```scala
case class Example(width: Int = 3) extends Component {
  // 2 bit wide for default width
  val sel = UInt(log2Up(count) bit)
  val data = Bits(width*8 bit)
  // no need to cover missing case 3 for default width
  val dataByte = sel.muxListDc(for(i <- 0 until count) yield (i, data(index*8, 8 bit)))
}
```

--------------------------------

### SpinalHDL Scope Violation Fix

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Design errors/scope_violation.rst

This Scala code snippet shows the corrected version of the previous example. By initializing the 'tmp' signal with a default value of 'UInt(8 bits)' outside the 'when' block, the scope violation is resolved. The assignment 'tmp := U"x42"' is now valid as 'tmp' is properly declared and initialized.

```scala
class TopLevel extends Component {
  val cond = Bool()

  var tmp : UInt = UInt(8 bits)
  when(cond) {

  }
  tmp := U"x42"
}
```

--------------------------------

### Buffer Component I/O Signals with Shift Register

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Developers area/spinalhdl_datamodel.rst

This Scala function buffers each input and output of a SpinalHDL component with a three-stage shift register. It ensures that internal signals are properly handled and allows for disabling bundle linting. This is useful for synthesis testing.

```scala
def ffIo[T <: Component](c : T): T = {
    def buf1[T <: Data](that : T) = KeepAttribute(RegNext(that)).addAttribute("DONT_TOUCH")
    def buf[T <: Data](that : T) = buf1(buf1(buf1(that)))
    c.rework {
      val ios = c.getAllIo.toList
      ios.foreach{
io =>
        if(io.getName() == "clk") {
          // Do nothing
        } else if(io.isInput) {
          io.setAsDirectionLess().allowDirectionLessIo  // allowDirectionLessIo is to disable the io Bundle linting
          io := buf(in(cloneOf(io).setName(io.getName() + "_wrap")))
        } else if(io.isOutput) {
          io.setAsDirectionLess().allowDirectionLessIo
          out(cloneOf(io).setName(io.getName() + "_wrap")) := buf(io)
        } else ???
      }
    }
    c
  }
  
  // Example usage:
  // SpinalVerilog(ffIo(new MyToplevel))
  
```

--------------------------------

### SpinalHDL: Implement Saturation Arithmetic with fixTo

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/Int.rst

Demonstrates the use of the `fixTo` method in SpinalHDL to implement saturation arithmetic. This method allows for configurable bit widths, rounding types, and saturation behavior.

```scala
val b  = a.fixTo( 9 downto 3, RoundType.CEIL,       sym = false)
   val b  = a.fixTo(16 downto 1, RoundType.ROUNDTOINF, sym = true )
   val b  = a.fixTo(10 downto 3, RoundType.FLOOR) // floor 3 bit, sat 5 bit @ highest
   val b  = a.fixTo(20 downto 3, RoundType.FLOOR) // floor 3 bit, expand 2 bit @ highest
```

--------------------------------

### Instantiate and Clone Rgb Signals in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Getting Started/Scala Guide/interaction.rst

Shows how to instantiate an Rgb signal with specific bit widths and how to create a clone of an existing Rgb signal using the 'cloneOf' function. This highlights signal instantiation and type replication in SpinalHDL.

```scala
// Define an Rgb signal
val myRgbSignal = Rgb(5, 6, 5)               

// Define another Rgb signal of the same data type as the preceding one
val myRgbCloned = cloneOf(myRgbSignal)
```

--------------------------------

### Concatenating Signals with Cat in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Other language features/utils.rst

Demonstrates the usage of the Cat function to concatenate hardware signals. Two versions are shown: one accepting arbitrary arguments and another accepting an iterable collection. The order of concatenation differs between the two versions.

```scala
val bit0, bit1, bit2 = Bool()

val first = Cat(bit2, bit1, bit0)

// is equivalent to

val signals = List(bit0, bit1, bit2)
val second = Cat(signals)
```

--------------------------------

### Instantiate and Assign Bundles in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Developers area/types.rst

Provides examples of instantiating Bundle objects (VGA) and assigning values between them, including direct assignment of the whole bundle and modification of individual elements.

```scala
val vgaIn  = VGA(8)        // Create a RGB instance
val vgaOut = VGA(8)
vgaOut := vgaIn            // Assign the whole bundle
vgaOut.color.green := 0    // Fix the green to zero
val vgaInRgbIsBlack = vgaIn.rgb.isBlack   // Get if the vgaIn rgb is black
```

--------------------------------

### SpinalHDL Latch Detection: Incomplete Assignment Example

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Design errors/latch_detected.rst

Demonstrates a common scenario in SpinalHDL where a latch is detected due to an incomplete assignment to a signal within a conditional block. The example shows the problematic code and a corrected version that ensures the signal is always assigned.

```scala
class TopLevel extends Component {
  val cond = in(Bool())
  val a = UInt(8 bits)

  when(cond) {
    a := 42
  }
}
```

```scala
class TopLevel extends Component {
  val cond = in(Bool())
  val a = UInt(8 bits)

  a := 0
  when(cond) {
    a := 42
  }
}
```

--------------------------------

### Conditional Signal Assignment in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Developers area/types.rst

Demonstrates conditional assignment of 'valid' and 'value' signals based on the 'cond' input. When 'cond' is true, 'valid' becomes true and 'value' takes the value of 'red'. Otherwise, default values are maintained.

```scala
val cond = in Bool()
val red = in UInt(4 bits)
...
val valid = False          // Bool signal which is by default assigned with False
val value = U"0100"        // UInt signal of 4 bits which is by default assigned with 4
when(cond) {
  valid := True
  value := red
}
```

--------------------------------

### SpinalHDL muxList for Divided Data Selection

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Semantic/when_switch.rst

Shows how to use `muxList` to select specific chunks (e.g., 32-bit words) from a wider data bus based on a selector. It demonstrates both a loop-based generation and a more concise `subdivideIn` method.

```scala
val sel  = UInt(2 bits)
val data = Bits(128 bits)

// Dividing a wide Bits type into smaller chunks, using a mux:
val dataWord = sel.muxList(for (index <- 0 until 4)
                           yield (index, data(index*32+32-1 downto index*32)))

// A shorter way to do the same thing:
val dataWord = data.subdivideIn(32 bits)(sel)
```

--------------------------------

### SpinalHDL Bit Rotation and Conditional Logic

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/Int.rst

Demonstrates bit rotation and conditional logic in SpinalHDL. The 'rotateLeft' operation shifts bits to the left, and the 'when' statement executes code blocks based on conditions like 'a.andR' (all bits of 'a' are true).

```scala
val rotated = UInt(8 bits) rotateLeft 3 // left bit rotation
assert(rotated.getWidth == 8)

// Set all bits of b to True when all bits of a are True
when(a.andR) { b.setAll() }
```

--------------------------------

### Scala: Example of External Clock Domain Usage

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Structuring/clock_domain.rst

An example demonstrating the creation and usage of an external clock domain, where the clock and reset signals are expected to be provided from the top level.

```scala
class ExternalClockExample extends Component {
  val io = new Bundle {
    val result = out UInt (4 bits)
  }

  // On the top level you have two signals  :
  //     myClockName_clk and myClockName_reset
  val myClockDomain = ClockDomain.external("myClockName")

  val myArea = new ClockingArea(myClockDomain) {
    val myReg = Reg(UInt(4 bits)) init(7)
    myReg := myReg + 1

    io.result := myReg
  }
}
```

--------------------------------

### SpinalHDL Name Extraction via Scala Compiler Plugin

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Structuring/naming.rst

Illustrates how SpinalHDL uses a Scala compiler plugin (`ValCallback`) to capture the names of values defined during class construction. This mechanism automatically assigns names to signals based on their Scala variable names, simplifying hardware generation.

```scala
// spinal.idslplugin.ValCallback is the Scala compiler plugin feature which will provide the callbacks
class Component extends spinal.idslplugin.ValCallback {
  override def valCallback[T](ref: T, name: String) : T = {
    println(s"Got $ref named $name") // Here we just print what we got as a demo.
    ref
  }
}

class UInt
class Bits
class MyComponent extends Component {
  val two = 2
  val wuff = "miaou"
  val toto = new UInt
  val rawrr = new Bits
}

object Debug3 extends App {
  new MyComponent()
  // ^ This will print :
  // Got 2 named two
  // Got miaou named wuff
  // Got spinal.tester.code.sandbox.UInt@691a7f8f named toto
  // Got spinal.tester.code.sandbox.Bits@161b062a named rawrr
}

```

--------------------------------

### SpinalHDL Scope Violation Example

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Design errors/scope_violation.rst

This Scala code snippet demonstrates a scope violation in SpinalHDL. A signal 'tmp' is assigned a value outside the 'when' block where it was conditionally declared, leading to a SCOPE VIOLATION error. The error message indicates the signal and its location of the invalid assignment.

```scala
class TopLevel extends Component {
  val cond = Bool()

  var tmp : UInt = null
  when(cond) {
    tmp = UInt(8 bits)
  }
  tmp := U"x42"
}
```

--------------------------------

### Publish Local SpinalHDL Version

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Introduction/faq.rst

This snippet shows how to publish a locally cloned SpinalHDL version using sbt. It cleans the project, then publishes it for Scala version 2.12.13. This allows a local version to be used in other projects by setting the `spinalVersion` to 'dev'.

```sh
sbt clean '++ 2.12.13' publishLocal
```

--------------------------------

### SpinalHDL Bit Manipulation Utilities

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/Int.rst

Provides examples of utility functions for bit manipulation in SpinalHDL, including getting signal width, MSB index, value range, concatenation, repetition, and resizing signals.

```scala
// Concatenate
val concatenated = x ## y
// Repeat
val repeated = x #* n
// Concatenate with Bool/SInt/UInt
val concatWithBit = x @@ y
// Resize
val resized = x.resize(y)
// Get zero instance
val zeroInstance = x.getZero
// Get all ones instance
val allOnesInstance = x.getAllTrue
```

--------------------------------

### Implement Filtered Sine Wave in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Examples/Simple ones/sinus_rom.rst

Generates a filtered version of the sine wave using a first-order low-pass filter. The filtered output is assigned to the 'sinFiltered' port. This demonstrates basic signal processing within the hardware component.

```scala
io.sinFiltered := io.sinFiltered + (io.sin - io.sinFiltered) / sampleCount
```

--------------------------------

### Handle[T] Produce and Derivate Usage in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/fiber.rst

Illustrates advanced usage of Handle[T] with the 'produce' and 'derivate' methods. 'produce' generates a new Handle based on the value of an existing Handle once it's loaded. 'derivate' is similar but also passes the loaded value as an argument to the lambda function.

```scala
val x,y = Handle[Int]

// x.produce can be used to generate a new Handle when x is loaded
val xPlus2 : Handle[Int] = x.produce(x.get + 2)

// x.derivate is as x.produce, but also provide the x.get as argument of the lambda function
val xPlus3 : Handle[Int] = x.derivate(_ + 3)    

x.load(3) // x will now contain the value 3
```

--------------------------------

### SpinalHDL: Assertions within Reset Scope

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Formal verification/index.rst

This SpinalHDL code shows how to specify assumptions that should hold true during the reset phase of a component. The `duringReset` block ensures that the enclosed `assume` statements are evaluated only when the reset signal is active.

```scala
ClockDomain.current.duringReset {
  assume(rawrrr === 0)
  assume(wuff === 3)
}
```

--------------------------------

### SpinalHDL Parameterized Data Structures

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Getting Started/Help for VHDL people/vhdl_comp.rst

Illustrates how SpinalHDL enables parameterization of data structures like streams and FIFOs with custom types, such as `Color`. This allows for reusable and configurable components.

```scala
val colorStream = Stream(Color(5, 6, 5)))
val colorFifo   = StreamFifo(Color(5, 6, 5), depth = 128)
colorFifo.io.push <> colorStream
```

--------------------------------

### Assign Scala Constants to SpinalHDL Fixed-Point

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/Fix.rst

Shows how to assign values from Scala's `BigInt` or `Double` types to SpinalHDL's `UFix` or `SFix` signals. It explains how these assignments are converted to the fixed-point signal's raw integer representation.

```scala
   val i4_m2 = SFix(4 exp, -2 exp)
   i4_m2 := 1.25    // Will load 5 in i4_m2.raw
   i4_m2 := 4       // Will load 16 in i4_m2.raw
```

--------------------------------

### SpinalHDL Enumeration Signal Assignment

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Developers area/types.rst

Shows how to instantiate a signal to store an enumerated value and assign it a specific state from the defined enumeration. It also illustrates importing enumeration elements for easier access.

```scala
val stateNext = UartCtrlTxState() // Or UartCtrlTxState(encoding=encodingOfYouChoice)
   stateNext := UartCtrlTxState.sIdle

   // You can also import the enumeration to have the visibility on its elements
   import UartCtrlTxState._
   stateNext := sIdle
```

--------------------------------

### SpinalHDL Bit Extraction and Assignment

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/bits.rst

Illustrates static and dynamic bit access, fixed and variable part selection, and range selection for reading and writing bits within a signal. Examples cover single bit access, dynamic indexing, and range assignments.

```scala
   // get the element at the index 4
   val myBool = myBits(4)
   // assign element 1
   myBits(1) := True

   // index dynamically
   val index = UInt(2 bit)
   val indexed = myBits(index, 2 bit)

   // range index
   val myBits_8bit = myBits_16bit(7 downto 0)
   val myBits_7bit = myBits_16bit(0 to 6)
   val myBits_6bit = myBits_16bit(0 until 6)
   // assign to myBits_16bit(3 downto 0)
   myBits_8bit(3 downto 0) := myBits_4bit

   // equivalent slices, no reversing occurs
   val a = myBits_16bit(8 downto 4)
   val b = myBits_16bit(4 to 8)

   // read / assign the msb / leftmost bit / x.high bit
   val isNegative = myBits_16bit.msb
   myBits_16bit.msb := False
```

--------------------------------

### Force and Propagate Names in SpinalHDL Components

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Structuring/naming.rst

Demonstrates how to manually set names for signals within a SpinalHDL Component using `setName` and `setCompositeName`. This allows for explicit control over generated hardware signal names, especially for debugging or specific netlist requirements.

```scala
class MyComponent extends Component {
  val a, b, c, d = Bool()
  b.setName("rawrr") // Force name
  c.setName("rawrr", weak = true) // Propose a name, will not be applied if a stronger name is already applied
  d.setCompositeName(b, postfix = "wuff") // Force toto to be named as b.getName() + "_wuff"
}

```

--------------------------------

### Create and Manipulate Vectors in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Developers area/types.rst

Demonstrates the creation of vectors with fixed or mixed element widths and how to perform read, write, and assignment operations. It also shows iterating over vector elements for assignment.

```scala
val myVecOfSInt = Vec(SInt(8 bits),2)
myVecOfSInt(0) := 2
myVecOfSInt(1) := myVecOfSInt(0) + 3

val myVecOfMixedUInt = Vec(UInt(3 bits), UInt(5 bits), UInt(8 bits))

val x,y,z = UInt(8 bits)
val myVecOf_xyz_ref = Vec(x,y,z)
for(element <- myVecOf_xyz_ref) {
  element := 0   // Assign x,y,z with the value 0
}
myVecOf_xyz_ref(1) := 3    // Assign y with the value 3
```

--------------------------------

### Conditionally Generate Signals in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Structuring/parametrization.rst

Shows how to conditionally generate a signal based on a boolean flag using the 'generate' method in SpinalHDL. If the flag is true, a Bool() signal is generated; otherwise, it results in null. This allows for optional signal generation in hardware designs.

```scala
case class MyComponent(flag : Boolean) extends Component {
  val mySignal = flag generate (Bool())
  // equivalent to "val mySignal = if (flag) Bool() else null"
}
```

--------------------------------

### Scala: Assignment Operators, Width Handling, and Signal Types

Source: https://context7.com/spinalhdl/spinaldoc-rtd/llms.txt

Explains SpinalHDL's three assignment operators (:= for standard, \= for immediate, <> for automatic connection). It details tuple assignment for bundle signals and demonstrates how signal nature (combinational vs. sequential) is determined at declaration.

```scala
// Three assignment operators
val a, b, c = UInt(4 bits)

a := 0                          // := Standard assignment (like VHDL <=)
b := a                          // b gets value 0

val x = UInt(4 bits)
val y, z = UInt(4 bits)
x := 0
y := x                          // y reads 0
x \= x + 1                      // \= Immediate assignment (like Verilog =)
z := x                          // z reads 1

// Automatic connection operator
uartCtrl.io.uart <> io.uart     // <> connects matching Bundle signals

// Tuple assignment (bundle multiple signals)
val a, b, c = UInt(4 bits)
val d = UInt(12 bits)
(a, b, c) := B(0, 12 bits)      // Assign 12-bit value to three 4-bit signals
(a, b, c) := d.asBits           // Convert d to Bits and split

val e = Bits(10 bits)
val f = SInt(2 bits)
val g = Bits()
(a, b, c) := (e, f).asBits      // Both sides use tuples
g := (a, b, c, e, f).asBits     // Right side only

// Signal nature defined at declaration, not assignment
val combSignal = UInt(4 bits)              // Always combinational
val regSignal = Reg(UInt(4 bits))          // Always sequential (register)
val resetReg = Reg(UInt(4 bits)) init(0)   // Register with reset value

```

--------------------------------

### Advanced Register Initialization and Assignment in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Sequential logic/registers.rst

Illustrates more advanced register configurations in SpinalHDL, including initialization with `init()`, named parameters for RegNext, and combined features for RegNextWhen with conditional assignments and explicit enables.

```scala
// UInt register of 6 bits (initialized with 42 when the reset occurs)
val reg1 = Reg(UInt(6 bits)) init(42)

// Register that samples reg1 each cycle (initialized with 0 when the reset occurs)
// using Scala named parameter argument format
val reg2 = RegNext(reg1, init=0)

// Register that has multiple features combined

// My register enable signal
val reg3Enable = Bool()
// UInt register of 6 bits (inferred from reg1 type)
//   assignment preconfigured to update from reg1
//   only updated when reg3Enable is set
//   initialized with 99 when the reset occurs
val reg3 = RegNextWhen(reg1, reg3Enable, U(99))
// when(reg3Enable) {
//   reg3 := reg1; // this expression is implied in the constructor use case
// }

when(cond2) {      // this is a valid assignment, will take priority when executed
   reg3 := U(0)    //  (due to last assignment wins rule), assignment does not require
}                  //  reg3Enable condition, you would use `when(cond2 & reg3Enable)` for that

// UInt register of 8 bits, initialized with 99 when the reset occurs
val reg4 = Reg(UInt(8 bits), U(99))
// My register enable signal
val reg4Enable = Bool()
// no implied assignments exist, you must use enable explicitly as necessary
when(reg4Enable) {
   reg4 := newValue
}
```

--------------------------------

### Bitwise and Shift Operations for SInt/UInt in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/Int.rst

Illustrates the use of bitwise logical operators (NOT, AND, OR, XOR) and shift operations (arithmetic and logical left/right shifts) for SInt and UInt types in SpinalHDL. It also covers rotation operations and methods to clear or set all bits. The example highlights the difference in behavior between shifts with Int and UInt operands.

```scala
val a, b, c = SInt(32 bits)
a := S(5)
b := S(10)

// Bitwise operators
c := ~(a & b)     // Inverse(a AND b)
assert(c.getWidth == 32)

// Shift
val arithShift = UInt(8 bits) << 2      // shift left (resulting in 10 bits)
val logicShift = UInt(8 bits) |<< 2     // shift left (resulting in 8 bits)
assert(arithShift.getWidth == 10)
assert(logicShift.getWidth == 8)

// Rotation
// val rotatedLeft = myUInt.rotateLeft(2)
// val rotatedRight = myUInt.rotateRight(2)
```

--------------------------------

### SpinalHDL: Using SpinalEnum for Register Field Reset Values

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/regIf.rst

Illustrates how to use `SpinalEnum` to define enumerated types for register fields. The `resetValue` in this context specifies the index of the enum element to which the field should be initialized.

```scala
object UartCtrlTxState extends SpinalEnum(defaultEncoding = binaryOneHot) {
   val sIdle, sStart, sData, sParity, sStop = newElement()
}

val raw = M_REG2.field(UartCtrlTxState(), AccessType.RW, resetValue = 2, doc="state")
// raw will be init to sData
```

--------------------------------

### Handle Cross Clock Domain Signals in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/miscelenea/core/core_components.rst

This snippet demonstrates how to safely handle signals that cross between different clock domains in SpinalHDL. It shows the use of the `crossClockDomain` tag to explicitly mark signals that originate from a different clock domain, which is crucial for preventing metastability issues. The example includes a two-stage buffering approach using `Reg` and `RegNext`.

```scala
val asynchronousSignal = UInt(8 bits)
...
val buffer0 = Reg(UInt(8 bits)).addTag(crossClockDomain)
val buffer1 = Reg(UInt(8 bits))
buffer0 := asynchronousSignal
buffer1 := buffer0   // Second register stage to be avoid metastability issues
```

```scala
// Or in less lines:
val buffer0 = RegNext(asynchronousSignal).addTag(crossClockDomain)
val buffer1 = RegNext(buffer0)
```

--------------------------------

### Declare Signed Fixed-Point (SFix) in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/Fix.rst

Shows how to declare signed fixed-point numbers (SFix) in SpinalHDL. It covers declarations using `peak` with `resolution` or `width`, illustrating the bit width calculation for signed types.

```scala
   // Signed Fixed-Point
   val Q_8_2 = SFix(peak = 8 exp, resolution = -2 exp) // bit width = 8 - (-2) + 1 = 11 bits
   val Q_8_2 = SFix(8 exp, -2 exp)

   val Q_8_2 = SFix(peak = 8 exp, width = 11 bits)
   val Q_8_2 = SFix(8 exp, 11 bits)
```

--------------------------------

### Create Custom Range AFix in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/AFix.rst

Illustrates how to create custom range AFix instances in Scala by directly instantiating the class with specific maximum value, minimum value, and exponent. This allows for fine-grained control over the fixed-point representation.

```scala
class AFix(val maxValue: BigInt, val minValue: BigInt, val exp: ExpNumber)

new AFix(4096, 0, 0 exp)     // [0 to 4096, 2^0]
new AFix(256, -256, -2 exp)  // [-256 to 256, 2^-2]
new AFix(16, 8, 2 exp)       // [8 to 16, 2^2]
```

--------------------------------

### SpinalHDL: Batch Register Creation with APB3 Bus Interface

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/regIf.rst

Shows a typical example of batch creating registers and fields within an APB3 bus interface. This snippet demonstrates setting up multiple registers with different field types and accessing them via the bus.

```scala
import spinal.lib.bus.regif._

class RegBank extends Component {
  val io = new Bundle {
    val apb = slave(Apb3(Apb3Config(16, 32)))
    val stats = in Vec(Bits(16 bit), 10)
    val IQ  = out Vec(Bits(16 bit), 10)
  }
  val busif = Apb3BusInterface(io.apb, (0x000, 100 Byte), regPre = "AP")

  (0 to 9).map { i =>
    // here use setName give REG uniq name for Docs usage
    val REG = busif.newReg(doc = s"Register${i}").setName(s"REG${i}")
    val real = REG.field(SInt(8 bit), AccessType.RW, 0, "Complex real")
    val imag = REG.field(SInt(8 bit), AccessType.RW, 0, "Complex imag")
    val stat = REG.field(Bits(16 bit), AccessType.RO, 0, "Accelerator status")
    io.IQ(i)( 7 downto 0) := real.asBits
    io.IQ(i)(15 downto 8) := imag.asBits
    stat := io.stats(i)
  }

  def genDocs() = {
    busif.accept(CHeaderGenerator("regbank", "AP"))
    busif.accept(HtmlGenerator("regbank", "Interupt Example"))
    busif.accept(JsonGenerator("regbank"))
    busif.accept(RalfGenerator("regbank"))
    busif.accept(SystemRdlGenerator("regbank", "AP"))
  }

  this.genDocs()
}

SpinalVerilog(new RegBank())
```

--------------------------------

### Instantiate Axi4SharedOnChipRam

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Legacy/pinsec/hardware_toplevel.rst

Instantiates an AXI4 Shared on-chip RAM component. This component utilizes a unified read/write channel for reduced area usage while maintaining AXI4 compatibility. Configuration includes data width, byte count, and AXI ID width.

```scala
val ram = Axi4SharedOnChipRam(
  dataWidth = 32,
  byteCount = 4 KiB,
  idWidth = 4     // Specify the AXI4 ID width.
)
```

--------------------------------

### SpinalHDL Latch Detection: Non-Exhaustive Mux Example

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Design errors/latch_detected.rst

Illustrates how a latch can be inferred from a non-exhaustive mux or muxList statement in SpinalHDL. The provided code shows an example with a missing case and its resolution by including all cases or a default.

```scala
val u1 = UInt(1 bit)
u1.mux(
  0 -> False,
  // case for 1 is missing
)
```

```scala
val u1 = UInt(1 bit)
u1.mux(
  0 -> False,
  default -> True
)
```

--------------------------------

### SpinalHDL Hierarchy Violation Fix

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Design errors/hierarchy_violation.rst

This Scala code shows the corrected version of the hierarchy violation example. By changing the 'in' signal 'a' to an 'out' signal, the assignment 'io.a := tmp' becomes valid, as outputs can be driven from within the component. This resolves the 'HIERARCHY VIOLATION' error.

```scala
class TopLevel extends Component {
  val io = new Bundle {
    val a = out UInt(8 bits) // changed from in to out
  }
  val tmp = U"x42"
  io.a := tmp  // now we are assigning to an output
}
```

--------------------------------

### SpinalHDL Conditional Assignments using when/elsewhen/otherwise

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Getting Started/Help for VHDL people/vhdl_perspective.rst

Demonstrates conditional signal assignments in SpinalHDL using `when`, `elsewhen`, and `otherwise`, which are analogous to VHDL's `if-then-elsif-else` statements. It includes a counter register that is cleared, updated, or toggles a bit based on conditions.

```scala
val clear   = Bool()
val counter = Reg(UInt(8 bits))

when(clear) {
  counter := 0
}.elsewhen(counter === 76) {
  counter := 79
}.otherwise {
  counter(7) := ! counter(7)
}
```

--------------------------------

### Cloning Hardware Data Types with cloneOf in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Other language features/utils.rst

Illustrates how to use the cloneOf function to create a new instance of a hardware data type with the same width and parameters. This is useful for creating temporary variables or dynamically sized signals within functions. It also highlights requirements for cloning Bundles.

```scala
def plusOne(value : UInt) : UInt {
  // Will provide new instance of a UInt with the same width as ``value``
  val temp = cloneOf(value)
  temp := value + 1
  return temp
}

// treePlusOne will become a 8 bits value
val treePlusOne = plusOne(U(3, 8 bits))
```

```scala
// An example of a regular 'class' with 'override def clone()' function
class MyBundle(ppp : Int) extends Bundle {
   val a = UInt(ppp bits)
   override def clone = new MyBundle(ppp)
 }
 val x = new MyBundle(3)
 val typeDef = HardType(new MyBundle(3))
 val y = typeDef()

 cloneOf(x) // Need clone method, else it errors
 cloneOf(y) // Is ok
```

--------------------------------

### Verilog Output with Automatic Naming and Optimization

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Structuring/naming.rst

Shows the Verilog output generated from a SpinalHDL component where signals are automatically named. It also highlights how SpinalHDL can optimize away unnamed temporary signals if they are not essential for the final logic.

```verilog
module MyComponent (
  input      [7:0]    a,
  input      [7:0]    b,
  output     [7:0]    toto
);
  // Note that the tmp signal defined in scala was "shortcuted" by SpinalHDL,
  //  as it was unnamed and technically "shortcutable"
  assign toto = 8'h20;
endmodule

```

--------------------------------

### Capture Waveforms Window in SpinalHDL Simulation (Scala)

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Simulation/bootstraps.rst

This example shows two methods for capturing waveforms within a specific time window during long simulations to manage file size and performance. It involves disabling and enabling waveform capture using `disableSimWave` and `enableSimWave`, or using a `DualSimTracer` for advanced dual lock-step simulation with delayed wave tracing.

```scala
disableSimWave()
delayed(timeFromWhichIWantToCapture)(enableSimWave())
```

--------------------------------

### Make Sub-Signals Accessible in Simulation (In-Component)

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Simulation/signal.rst

This code demonstrates how to make internal signals of a SpinalHDL component accessible during simulation by marking them with the 'simPublic()' tag directly within the component's hardware description. This allows simulation code to directly read and write these internal signals.

```scala
object SimAccessSubSignal {
  import spinal.core.sim._

  class TopLevel extends Component {
    val counter = Reg(UInt(8 bits)) init(0) simPublic() // Here we add the simPublic tag on the counter register to make it visible
    counter := counter + 1
  }

  def main(args: Array[String]) {
    SimConfig.compile(new TopLevel).doSim{
      dut =>
        dut.clockDomain.forkStimulus(10)

        for(i <- 0 to 3) {
          dut.clockDomain.waitSampling()
          println(dut.counter.toInt)
        }
    }
  }
}
```

--------------------------------

### Conflict Detection in SpinalHDL Register Fields

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/regIf.rst

This example demonstrates conflict detection when defining fields within a SpinalHDL register. It shows two scenarios where defining fields can lead to exceptions due to overlapping positions or exceeding register bounds. The first case shows a potential conflict, while the second explicitly demonstrates a conflict caused by `fieldAt`.

```scala
val M_REG1  = busif.newReg(doc="REG1")
  val r1fd0 = M_REG1.field(Bits(16 bits), RW, doc="fields 1")
  val r1fd2 = M_REG1.field(Bits(18 bits), RW, doc="fields 1")
    ...
  cause Exception
  val M_REG1  = busif.newReg(doc="REG1")
  val r1fd0 = M_REG1.field(Bits(16 bits), RW, doc="fields 1")
  val r1fd2 = M_REG1.fieldAt(pos=10, Bits(2 bits), RW, doc="fields 1")
    ...
  cause Exception
```

--------------------------------

### SpinalHDL High Bit Operations (Saturation and Trimming)

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/Int.rst

Illustrates high bit operations in SpinalHDL, specifically saturation (sat) and trimming (trim), which are used to manage the bit width of fixed-point numbers. It also shows the 'symmetry' property for signed integers.

```scala
val a  = SInt(8 bits)
val b  = a.sat(3 bits)      // return 5 bits with saturated highest 3 bits
val b  = a.sat(3)           // equal to sat(3 bits)
val b  = a.trim(3 bits)     // return 5 bits with the highest 3 bits discarded
val b  = a.trim(3 bits)     // return 5 bits with the highest 3 bits discarded
val c  = a.symmetry         // return 8 bits and symmetry as (-128~127 to -127~127)
val c  = a.sat(3).symmetry  // return 5 bits and symmetry as (-16~15 to -15~15)
```

--------------------------------

### Instantiate and Use Axi4 Bus in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/Bus/amba4/axi4.rst

Demonstrates how to instantiate an AXI4 bus with a specific configuration and how to access its signals for transaction handling. It requires an Axi4Config object to define bus widths.

```scala
val axiConfig = Axi4Config(
  addressWidth = 32,
  dataWidth    = 32,
  idWidth      = 4
)
val axiX = Axi4(axiConfig)
val axiY = Axi4(axiConfig)

when(axiY.aw.valid) {
  // ...
}
```

--------------------------------

### Instantiate and Use APB3 Bus in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/Bus/amba3/apb3.rst

Demonstrates how to configure and instantiate APB3 buses in SpinalHDL. It shows the creation of an Apb3Config object and then using it to declare APB3 bus instances, with a basic example of checking the PENABLE signal.

```scala
val apbConfig = Apb3Config(
  addressWidth = 12,
  dataWidth    = 32
)
val apbX = Apb3(apbConfig)
val apbY = Apb3(apbConfig)

when(apbY.PENABLE) {
  // ...
}
```

--------------------------------

### Advanced String Interpolation for Reporting in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Other language features/report.rst

Introduces the enhanced string interpolation syntax (`L"..."`) in SpinalHDL (since version 1.4.4) for cleaner reporting. This allows direct embedding of variables within strings and also supports reporting the current simulation time using `REPORT_TIME`.

```scala
report(L"miaou $a $b $c $d")
```

```scala
report(L"miaou $REPORT_TIME")
```

```verilog
$display("NOTE miaou %t", $time);
```

--------------------------------

### SpinalHDL Hierarchy Violation Example (Error)

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Design errors/hierarchy_violation.rst

This Scala code demonstrates a hierarchy violation in SpinalHDL. It attempts to assign a value to an 'in' signal of the current component, which is not allowed. The violation occurs because 'io.a' is declared as an input signal, and inputs cannot be driven from within the same component.

```scala
class TopLevel extends Component {
  val io = new Bundle {
    // This is an 'in' signal of the current component 'Toplevel'
    val a = in UInt(8 bits)
  }
  val tmp = U"x42"
  io.a := tmp  // ERROR: attempting to assign to an input of current component
}
```

--------------------------------

### Configure mill for Local SpinalHDL Dependency

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Developers area/howotuselocalspinalclone.rst

This Scala code snippet is for `build.sc` using mill. It imports necessary modules from the local SpinalHDL clone and defines the project's dependencies, including `spinalCore`, `spinalLib`, and `idslplugin`. It also configures `scalacOptions` with `pluginOptions` from `idslplugin` to ensure correct compilation.

```scala
import mill._
import scalalib._

import $file.^.SpinalHDL.build
import ^.SpinalHDL.build.{core => spinalCore}
import ^.SpinalHDL.build.{lib => spinalLib}
import ^.SpinalHDL.build.{idslplugin => spinalIdslplugin}

val spinalVers = "1.10.2a"
val scalaVers = "2.12.18"

object projectname extends RootModule with SbtModule {
   def scalaVersion = scalaVers
   def sources = T.sources(
      this.millSourcePath / "hw" / "spinal"
   )

   def idslplugin = spinalIdslplugin(scalaVers)
   def moduleDeps = Seq(
      spinalCore(scalaVers),
      spinalLib(scalaVers),
      idslplugin
   )
   def scalacOptions = super.scalacOptions() ++ idslplugin.pluginOptions()
}
```

--------------------------------

### Custom State Encoding - Key-Value Pairs

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/fsm.rst

Shows how to define a custom encoding for states in a SpinalHDL state machine by providing explicit key-value pairs, mapping each state to a specific 'BigInt' value. This offers granular control over state representation.

```scala
val fsm = new StateMachine {
  val stateA = new State with EntryPoint
  val stateB = new State
  ...
  setEncoding((stateA -> 0x23), (stateB -> 0x22))
}
```

--------------------------------

### Instantiate Dual-Port RAM with Read/Write Ports in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Sequential logic/memory.rst

This example demonstrates how to instantiate a dual-port RAM with specified bit width and word count in SpinalHDL. It shows how to configure synchronous write operations using `mem.write` and synchronous read operations using `mem.readSync`, including enabling signals and addresses for both operations.

```scala
val mem = Mem(Bits(32 bits), wordCount = 256)
mem.write(
  enable  = io.writeValid,
  address = io.writeAddress,
  data    = io.writeData
)

io.readData := mem.readSync(
  enable  = io.readValid,
  address = io.readAddress
)
```

--------------------------------

### Declare and Initialize UInt/SInt Integers in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/Int.rst

Demonstrates various ways to declare and initialize UInt (unsigned) and SInt (signed) integers in SpinalHDL. This includes specifying bit widths, assigning literal values, and using hexadecimal, decimal, octal, and binary string formats. It also shows how to assign values using ranges and default values, and how to compare integers with booleans.

```scala
val myUInt = UInt(8 bit)
myUInt := U(2, 8 bit)
myUInt := U(2)
myUInt := U"0000_0101"  // Base per default is binary => 5
myUInt := U"h1A"        // Base could be x (base 16)
                           //               h (base 16)
                           //               d (base 10)
                           //               o (base 8)
                           //               b (base 2)                       
myUInt := U"8'h1A"       
myUInt := 2             // You can use a Scala Int as a literal value

val myBool = Bool()
myBool := myUInt === U(7 -> true, (6 downto 0) -> false)
myBool := myUInt === U(8 bit, 7 -> true, default -> false)
myBool := myUInt === U(myUInt.range -> true)

// For assignment purposes, you can omit the U/S
// which also allows the use of "default -> ??"
myUInt := (default -> true)                        // Assign myUInt with "11111111"
myUInt := (myUInt.range -> true)                   // Assign myUInt with "11111111"
myUInt := (7 -> true, default -> false)            // Assign myUInt with "10000000"
myUInt := ((4 downto 1) -> true, default -> false) // Assign myUInt with "00011110"
```

--------------------------------

### Compare Bits Vectors in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/bits.rst

Shows how to perform equality and inequality comparisons between Bits vectors using the `===` and `=!=` operators. The result of these comparisons is a Bool.

```scala
when(myBits === 3) {
  // ...
}

val notMySpecialValue = myBits_32 =/= B"32'x44332211"
```

--------------------------------

### Automatic Handling of Scala Primitive Types in SpinalHDL Reporting

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Other language features/report.rst

Explains the automatic handling of Scala primitive types (Int, Boolean, Float, BigInt, etc.) within `L"..."` interpolated strings in SpinalHDL (since version 1.12.2). This feature eliminates the need for explicit `.toString()` calls when embedding these types in reports.

```scala
val myInt = 123
val myBool = True
val myFloat = 3.14f
val myBigInt = BigInt(0xABCD)
report(L"My values: int=$myInt, bool=$myBool, float=$myFloat, bigInt=$myBigInt")
```

```scala
for (i <- 0 until cacheConfig.fetchWordsPerFetchGroup) {
  report(L"AdvICache: sCompareTags - Instruction ${i}: ${io.cpu.rsp.payload.instructions(i)}")
}
```

--------------------------------

### Define APB Configuration Class for Parameterization in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Developers area/types.rst

Introduces a case class `APBConfig` to encapsulate the parameters for an APB interface, promoting reusability and easier management of configurations across multiple instances.

```scala
case class APBConfig(addressWidth: Int,
                       dataWidth: Int,
                       selWidth : Int,
                       useSlaveError : Boolean)

class APB(val config: APBConfig) extends Bundle {   // [val] config, make the configuration public
  val PADDR      = UInt(config.addressWidth bits)
  val PSEL       = Bits(config.selWidth bits)
  val PENABLE    = Bool()
  val PREADY     = Bool()
  val PWRITE     = Bool()
  val PWDATA     = Bits(config.dataWidth bits)
  val PRDATA     = Bits(config.dataWidth bits)
  val PSLVERROR  = if(config.useSlaveError) Bool() else null
}

// Example of usage
val apbConfig = APBConfig(addressWidth = 8,dataWidth = 32,selWidth = 4,useSlaveError = false)
val busA = APB(apbConfig)
val busB = APB(apbConfig)
```

--------------------------------

### Conditionally Generate Hardware Areas in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Structuring/parametrization.rst

Illustrates how to conditionally generate an Area of hardware based on a boolean flag using the 'generate' method in SpinalHDL. If the flag is true, the Area and its contents are generated; otherwise, it is omitted. This enables optional hardware chunk generation.

```scala
case class MyComponent(flag : Boolean) extends Component {
  val myHardware = flag generate new Area {
    // optional hardware here
  }
}
```

--------------------------------

### Make Sub-Signals Accessible in Simulation (Post-Instantiation)

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Simulation/signal.rst

This code illustrates how to make internal signals of a SpinalHDL component accessible during simulation by calling the 'simPublic()' method after the component has been instantiated. This approach is useful when the 'simPublic()' tag cannot be added directly in the hardware description.

```scala
object SimAccessSubSignal {
  import spinal.core.sim._
  class TopLevel extends Component {
    val counter = Reg(UInt(8 bits)) init(0)
    counter := counter + 1
  }

  def main(args: Array[String]) {
    SimConfig.compile {
      val dut = new TopLevel
      dut.counter.simPublic()     // Call simPublic() here
      dut
    }.doSim{
      dut =>
        dut.clockDomain.forkStimulus(10)

        for(i <- 0 to 3) {
          dut.clockDomain.waitSampling()
          println(dut.counter.toInt)
        }
    }
  }
}
```

--------------------------------

### SpinalHDL System Integration Example

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/Bus/tilelink/tilelink_fabric.rst

An example demonstrating the integration of CpuFiber and RamFiber components within a system. It shows how to connect components using memory mapping and define intermediate access nodes for peripherals.

```scala
val cpu = new CpuFiber()

val ram = new RamFiber()
ram.up at(0x10000, 0x200) of cpu.down
  
// Create a peripherals namespace to keep things clean
val peripherals = new Area {
  // Create a intermediate node in the interconnect
  val access = tilelink.fabric.Node()
  access at 0x20000 of cpu.down

  val gpioA = new GpioFiber()
  gpioA.up at 0x0000 of access

  val gpioB = new GpioFiber()
  gpioB.up at 0x1000 of access
}
```

--------------------------------

### SpinalHDL Boolean and Unsigned Integer Literals

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Getting Started/Help for VHDL people/vhdl_perspective.rst

Illustrates various ways to assign literal values to SpinalHDL signals, including boolean (`True`, `False`), binary string, hexadecimal string, decimal integer, and bit-range assignments for unsigned integers. It also shows a conditional bit assignment within a literal context.

```scala
val myBool = Bool()
myBool := False
myBool := True
myBool := Bool(4 > 7)

val myUInt = UInt(8 bits)
myUInt := "0001_1100"
myUInt := "xEE"
myUInt := 42
myUInt := U(54,8 bits)
myUInt := ((3 downto 0) -> myBool, default -> true)
when(myUInt === U(myUInt.range -> true)) {
  myUInt(3) := False
}
```

--------------------------------

### SpinalHDL Bits Resizing Examples

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/bits.rst

Demonstrates various ways to resize Bits in SpinalHDL. Includes automatic resizing with `.resized`, explicit resizing with `.resize(width)`, and left-aligned resizing with `.resizeLeft(width)`. Note that `.resize` pads with zeros at the MSB if widening, and truncates from the MSB if narrowing. `.resizeLeft` retains the MSB at the same position when widening or truncating.

```scala
println(myBits_32bits.getWidth) // 32

// Concatenation
myBits_24bits := bits_8bits_1 ## bits_8bits_2 ## bits_8bits_3
// or
myBits_24bits := Cat(bits_8bits_1, bits_8bits_2, bits_8bits_3)

// Resize
myBits_32bits := B"32'x112233344"
myBits_8bits  := myBits_32bits.resized       // automatic resize (myBits_8bits = 0x44)
myBits_8bits  := myBits_32bits.resize(8)     // resize to 8 bits (myBits_8bits = 0x44)
myBits_8bits  := myBits_32bits.resizeLeft(8) // resize to 8 bits (myBits_8bits = 0x11)
```

--------------------------------

### Functional Programming with SpinalHDL Vec

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Getting Started/Scala Guide/interaction.rst

Illustrates the use of functional programming techniques with SpinalHDL 'Vec' types. It shows how to map a comparison operation across a vector, reduce the resulting boolean vector to a single boolean, and how to zip a vector with its indices for element-wise comparison.

```scala
val values = Vec(Bits(8 bits), 4)

val valuesAre42    = values.map(_ === 42)
val valuesAreAll42 = valuesAre42.reduce(_ && _)

val valuesAreEqualToTheirIndex = values.zipWithIndex.map{ case (value, i) => value === i }
```

--------------------------------

### Fix SpinalHDL Class Clone Error with Case Class in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Design errors/spinal_cant_clone.rst

Demonstrates how to resolve the 'Spinal can't clone class' error by converting a class-based Bundle to a case class. This allows SpinalHDL's cloneOf function to correctly infer construction parameters. No external dependencies are required.

```scala
class RGB(width : Int) extends Bundle {
  val r, g, b = UInt(width bits)
}

class TopLevel extends Component {
  val tmp = Stream(new RGB(8)) // Stream requires the capability to cloneOf(new RGB(8))
}
```

```scala
case class RGB(width : Int) extends Bundle {
  val r, g, b = UInt(width bits)
}

class TopLevel extends Component {
  val tmp = Stream(RGB(8))
}
```

--------------------------------

### SpinalHDL Register Increment and Clear Example

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Semantic/rules.rst

Shows a basic SpinalHDL register that increments on an 'inc' signal and clears on a 'clear' signal, demonstrating the 'last assignment wins' rule where 'clear' has priority.

```scala
val inc, clear = Bool()          // Define two combinational signals/wires
val counter = Reg(UInt(8 bits))  // Define an 8 bit register

when(inc) {
  counter := counter + 1
}
when(clear) {
  counter := 0    // If inc and clear are True, then this  assignment wins
}                 //  (last value assignment wins rule)
```

--------------------------------

### SpinalHDL Switch Statement for Case-Based Assignments

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Getting Started/Help for VHDL people/vhdl_perspective.rst

Shows how to implement case-based assignments in SpinalHDL using the `switch` statement, similar to VHDL's `case` statements. The example assigns specific values to a counter based on its current value or uses a default assignment.

```scala
switch(counter) {
  is(42) {
    counter := 65
  }
  default {
    counter := counter + 1
  }
}
```

--------------------------------

### Clock Domain Crossing using BufferCC Utility

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Structuring/clock_domain.rst

This snippet showcases the use of the `BufferCC` utility function for clock domain crossing. `BufferCC` automatically instantiates the required number of flip-flops (determined by `bufferDepth`) to mitigate metastability. This is a more concise and recommended approach compared to manual staging. Dependencies include `Component`, `Bundle`, `in`, `out`, `Bool`, `ClockDomain`, `ClockingArea`, and `BufferCC`.

```scala
class CrossingExample(clkA : ClockDomain,clkB : ClockDomain) extends Component {
  val io = new Bundle {
    val dataIn  = in Bool()
    val dataOut = out Bool()
  }

  // sample dataIn with clkA
  val area_clkA = new ClockingArea(clkA) {
    val reg = RegNext(io.dataIn) init(False)
  }

  // BufferCC to avoid metastability issues
  val area_clkB = new ClockingArea(clkB) {
    val buf1   = BufferCC(area_clkA.reg, False)
  }

  io.dataOut := area_clkB.buf1
}
```

--------------------------------

### Generate Sine Wave using ROM in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Examples/Simple ones/sinus_rom.rst

Generates the sine wave output by reading from a ROM. The ROM stores pre-calculated sine wave samples. A phase counter is used to read these samples, effectively playing the sine wave on the 'sin' output.

```scala
// Calculate
val sinSamples = Vec(
    for (i <- 0 until sampleCount)
        yield U(round(sin(2 * math.Pi * i / sampleCount) * ((1 << resolutionWidth) - 1)).toInt)
).asSInt

val phase = Reg(UInt(log2(sampleCount bits) + 1 bits)) init (0)
phase := phase + 1

io.sin := sinSamples(phase(phase.maxValue.asInt-1 downto 0))
```

--------------------------------

### Scala: Signal Copying with CombInit

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Semantic/assignments.rst

Demonstrates how CombInit creates an independent copy of a signal, allowing modifications to the copy without affecting the original. Contrasts with direct assignment where modifications impact both.

```scala
val a = UInt(8 bits)
a := 1

val b = a
when(sel) {
    b := 2
    // At this point, a and b are evaluated to 2: they reference the same signal
}

val c = UInt(8 bits)
c := 1

val d = CombInit(c)
// Here c and d are evaluated to 1
when(sel) {
    d := 2
    // At this point c === 1 and d === 2.
}
```

--------------------------------

### SpinalHDL Bitwise Mux Selection

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Semantic/when_switch.rst

Illustrates how to perform bitwise selection using the `mux` method on a UInt signal. This method checks for complete coverage of all possible values to prevent latch generation. A `default` case can be provided if not all values are explicitly handled.

```scala
val bitwiseSelect = UInt(2 bits)
val bitwiseResult = bitwiseSelect.mux(
  0 -> (io.src0 & io.src1),
  1 -> (io.src0 | io.src1),
  2 -> (io.src0 ^ io.src1),
  default -> (io.src0)
)
```

```scala
val bitwiseSelect = UInt(2 bits)
val bitwiseResult = bitwiseSelect.mux(
  0 -> (io.src0 & io.src1),
  1 -> (io.src0 | io.src1),
  2 -> (io.src0 ^ io.src1),
  3 -> (io.src0)
)
```

--------------------------------

### Create Rgb Type Factory in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Getting Started/Scala Guide/interaction.rst

Demonstrates the creation of a type factory function 'myRgbTypeDef' in SpinalHDL, which simplifies the instantiation of Rgb signals with predefined configurations. This showcases functional programming for hardware type definitions.

```scala
// Define a type factory function
def myRgbTypeDef = Rgb(5, 6, 5)

// Use that type factory to create an Rgb signal
val myRgbFromTypeDef = myRgbTypeDef
```

--------------------------------

### Declare AFix Fixed-Point Values in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/AFix.rst

Demonstrates various ways to declare AFix fixed-point types in Scala, using bit sizes or exponents to define unsigned and signed fixed-point formats. These declarations ensure the full representable range of values is tracked.

```scala
AFix.U(12 bits)             // U12.0
AFix(QFormat(12, 0, false)) // U12.0
AFix.UQ(8 bits, 4 bits)     // U8.4
AFix.U(8 exp, 12 bits)      // U8.4
AFix.U(8 exp, -4 exp)       // U8.4
AFix.U(8 exp, 4 exp)        // U8.-4
AFix(QFormat(12, 4, false)) // U8.4

AFix.S(12 bits)             // S11.0 + sign
AFix(QFormat(12, 0, true))  // S11.0 + sign
AFix.SQ(8 bits, 4 bits)     // S8.4  + sign
AFix.S(8 exp, 12 bits)      // S8.3  + sign
AFix.S(8 exp, -4 exp)       // S8.4  + sign
AFix(QFormat(12, 4, true))  // S7.4  + sign
```

--------------------------------

### Analyze Signal Latency with LatencyAnalysis

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Developers area/spinalhdl_datamodel.rst

This example demonstrates how to use the LatencyAnalysis utility in SpinalHDL to determine the shortest logical path (in clock cycles) between two signals. This is particularly useful for analyzing complex designs like the VexRiscv FPU.

```scala
// Assuming 'vex' and 'logic' are instances of Component or related structures
// println("cpuDecode to fpuDispatch " + LatencyAnalysis(vex.decode.arbitration.isValid, logic.decode.input.valid))

```

--------------------------------

### SpinalHDL: Allowing Directionless Signals in IO Bundles

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Design errors/iobundle.rst

Shows how to permit directionless signals within an IO bundle in SpinalHDL when necessary for meta hardware description reasons. This bypasses the default directionality checks.

```scala
class TopLevel extends Component {
  val io = new Bundle {
    val a = UInt(8 bits)
  }
  a.allowDirectionLessIo
}
```

--------------------------------

### AFix Mathematical Operations in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/AFix.rst

Shows examples of performing addition, subtraction, and multiplication with AFix types in Scala. The operations handle integer and fractional expansion, demonstrating how ranges and bit widths adapt.

```scala
// Integer and fractional expansion
val a = AFix.U(4 bits)          // [   0 (  0.)     to  15 (15.  )]  4 bits, 2^0
val b = AFix.UQ(2 bits, 2 bits) // [   0 (  0.)     to  15 ( 3.75)]  4 bits, 2^-2
val c = a + b                   // [   0 (  0.)     to  77 (19.25)]  7 bits, 2^-2
val d = new AFix(-4, 8, -2 exp) // [-  4 (- 1.25)   to   8 ( 2.00)]  5 bits, 2^-2
val e = c * d                   // [-308 (-19.3125) to 616 (38.50)] 11 bits, 2^-4

// Integer without expansion
val aa = new AFix(8, 16, -4 exp) // [8 to 16] 5 bits, 2^-4
val bb = new AFix(1, 15, -4 exp) // [1 to 15] 4 bits, 2^-4
val cc = aa + bb                 // [9 to 31] 5 bits, 2^-4
```

--------------------------------

### Automatic Address Allocation in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/regIf.rst

This snippet demonstrates how to automatically allocate addresses for registers within an APB bus interface using SpinalHDL. It shows the creation of a `RegBankExample` component with an APB slave interface and the definition of several registers, including one placed at a specific address. The snippet also shows how to accept different generators like HtmlGenerator.

```scala
class RegBankExample extends Component {
    val io = new Bundle {
      apb = slave(Apb3(Apb3Config(16,32)))
    }
    val busif = Apb3BusInterface(io.apb,(0x0000, 100 Byte))
    val M_REG0  = busif.newReg(doc="REG0")
    val M_REG1  = busif.newReg(doc="REG1")
    val M_REG2  = busif.newReg(doc="REG2")

    val M_REGn  = busif.newRegAt(address=0x40, doc="REGn")
    val M_REGn1 = busif.newReg(doc="REGn1")

    busif.accept(HtmlGenerator("regif", "AP"))
    // busif.accept(CHeaderGenerator("header", "AP")),
    // busif.accept(JsonGenerator("regif")),
    // busif.accept(RalfGenerator("regbank")),
    // busif.accept(SystemRdlGenerator("regif", "AP"))
  }
```

--------------------------------

### Signal Naming Preservation with Area in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Getting Started/Scala Guide/interaction.rst

Shows how to use SpinalHDL's 'Area' construct to preserve the names of internal signals in the generated RTL. The 'temp' signal within 'myFunction' when wrapped in an 'Area' will be named 'myFunctionCall_temp'.

```scala
def myFunction(arg: UInt) new Area {
  val temp = arg + 1  // You will not retrieve the temp signal in the generated RTL
}

val myFunctionCall = myFunction(U"000001")  // Will generate `temp` with `myFunctionCall_temp` as the name
val value = myFunctionCall.temp  + 42
```

--------------------------------

### SpinalHDL: Arithmetic Operations for UInt and SInt

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Developers area/types.rst

Covers standard arithmetic operations for UInt and SInt types in SpinalHDL, including addition, subtraction, multiplication, and comparison operators. Also details arithmetic shift and resize operations.

```Scala
// Arithmetic Operations
x + y
x - y
x * y

// Comparison Operators
x > y
x >= y
x < y
x <= y

// Arithmetic Shift Right
x >> y (y : Int)
x >> y (y : UInt)

// Arithmetic Shift Left
x << y (y : Int)
x << y (y : UInt)

// Arithmetic Resize
x.resize(y)
```

--------------------------------

### Formal Verification with External Stimulus (anyseq)

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Formal verification/index.rst

Demonstrates how to drive DUT inputs during formal verification using SpinalHDL's `anyseq` statement. This example verifies a counter that increments only when an 'inc' input is high, ensuring the value remains within the [2:10] range by randomly driving the 'inc' signal.

```scala
class LimitedCounterInc extends Component {
  // Only increment the value when the inc input is set
  val inc = in Bool()
  val value = Reg(UInt(4 bits)) init(2)
  when(inc && value < 10) {
    value := value + 1
  }
}

object LimitedCounterIncFormal extends App {
  import spinal.core.formal._

  FormalConfig.withBMC(15).doVerify(new Component {
    val dut = FormalDut(new LimitedCounterInc())
    assumeInitial(ClockDomain.current.isResetActive)
    assert(dut.value >= 2)
    assert(dut.value <= 10)

    // Drive dut.inc with random values
    anyseq(dut.inc)
  })
}
```

--------------------------------

### Define Sine ROM Component in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Examples/Simple ones/sinus_rom.rst

Defines the SpinalHDL component 'SineRom' which takes resolutionWidth and sampleCount as parameters. It includes input/output ports for the sine wave and its filtered version. This forms the basic structure of the component.

```scala
case class SineRom(
    resolutionWidth: Int,
    sampleCount: Int
) extends Component {

    val io = new Bundle {
        val sin = out SInt (resolutionWidth bits)
        val sinFiltered = out SInt (resolutionWidth bits)
    }

    // ... ROM generation and filtering logic will follow ...
}
```

--------------------------------

### SpinalEnum Type Casting from Bits

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/enum.rst

This example demonstrates how to assign a value from a Bits signal back to an enumeration signal using the `assignFromBits` method.

```scala
import UartCtrlTxState._

val stateNext = UartCtrlTxState()
val myBits = UInt(stateNext.asBits.getWidth bits)
// Assume myBits is assigned some value

stateNext.assignFromBits(myBits)
```

--------------------------------

### Define Rgb Bundle Class in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Getting Started/Scala Guide/interaction.rst

Defines a case class 'Rgb' that extends SpinalHDL's 'Bundle' to represent an RGB color with configurable bit widths for red, green, and blue components. This demonstrates how to create custom hardware data structures in SpinalHDL.

```scala
case class Rgb(rWidth: Int, gWidth: Int, bWidth: Int) extends Bundle {
  val r = UInt(rWidth bits)
  val g = UInt(gWidth bits)
  val b = UInt(bWidth bits)
}
```

--------------------------------

### Verilog: Logical OR Reduction Splitting (Scala Example)

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Structuring/naming.rst

Illustrates how SpinalHDL handles the reduction of a vector of boolean conditions using a logical OR operation. The complex expression is split into multiple Verilog signals for better manageability.

```scala
class MyComponent extends Component {
    val conditions = in Vec(Bool(), 64)
    // Perform a logical OR between all the condition elements
    val result = conditions.reduce(_ || _)

    // For Bits/UInt/SInt signals the 'orR' methods implements this reduction operation
  }
```

```verilog
module MyComponent (
  input               conditions_0,
  input               conditions_1,
  input               conditions_2,
  input               conditions_3,
  ...
  input               conditions_58,
  input               conditions_59,
  input               conditions_60,
  input               conditions_61,
  input               conditions_62,
  input               conditions_63
);
  wire                _zz_result;
  wire                _zz_result_1;
  wire                _zz_result_2;
  wire                result;

  assign _zz_result = ((((((((((((((((_zz_result_1 || conditions_32) || conditions_33) || conditions_34) || conditions_35) || conditions_36) || conditions_37) || conditions_38) || conditions_39) || conditions_40) || conditions_41) || conditions_42) || conditions_43) || conditions_44) || conditions_45) || conditions_46) || conditions_47);
  assign _zz_result_1 = ((((((((((((((((_zz_result_2 || conditions_16) || conditions_17) || conditions_18) || conditions_19) || conditions_20) || conditions_21) || conditions_22) || conditions_23) || conditions_24) || conditions_25) || conditions_26) || conditions_27) || conditions_28) || conditions_29) || conditions_30) || conditions_31);
  assign _zz_result_2 = (((((((((((((((conditions_0 || conditions_1) || conditions_2) || conditions_3) || conditions_4) || conditions_5) || conditions_6) || conditions_7) || conditions_8) || conditions_9) || conditions_10) || conditions_11) || conditions_12) || conditions_13) || conditions_14) || conditions_15);
  assign result = ((((((((((((((((_zz_result || conditions_48) || conditions_49) || conditions_50) || conditions_51) || conditions_52) || conditions_53) || conditions_54) || conditions_55) || conditions_56) || conditions_57) || conditions_58) || conditions_59) || conditions_60) || conditions_61) || conditions_62) || conditions_63);

endmodule
```

--------------------------------

### Scala Function for RGB to Grayscale Conversion

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Structuring/function.rst

Demonstrates a Scala function that converts an 8-bit RGB color input to a grayscale value using floating-point coefficients. The function `coef` multiplies a `UInt` by a `Float` value, scales it, and shifts it to maintain 8-bit precision. This snippet highlights function reusability for signal processing in hardware generation.

```scala
// Input RGB color
   val r, g, b = UInt(8 bits)

   // Define a function to multiply a UInt by a Scala Float value.
   def coef(value: UInt, by: Float): UInt = (value * U((255 * by).toInt, 8 bits) >> 8)

   // Calculate the gray level
   val gray = coef(r, 0.3f) + coef(g, 0.4f) + coef(b, 0.3f)
```

--------------------------------

### SpinalHDL Last Assignment Wins Rule Example

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Semantic/rules.rst

Illustrates the 'last assignment wins' rule in SpinalHDL for combinational signals. Assignments within conditional blocks are evaluated based on the conditions at elaboration time. Assignments within an `if(false)` block are not elaborated.

```scala
// Every clock cycle  evaluation starts here
val paramIsFalse = false
val x, y = Bool()           // Define two combinational signals
val result = UInt(8 bits)   // Define a combinational signal

result := 1
when(x) {
  result := 2
  when(y) {
    result := 3
  }
}
if(paramIsFalse) {          // This assignment should win as it is last, but it was never elaborated
  result := 4               //  into hardware due to the use of if() and it evaluating to false at the time
}                           //  of elaboration.  The three := assignments above are elaborated into hardware.
```

--------------------------------

### SpinalHDL MaskedLiteral Comparisons

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/bits.rst

Illustrates how to use MaskedLiterals (M"...") for pattern matching and comparison with Bits values in SpinalHDL. The '-' character in a MaskedLiteral represents a 'don't care' bit, allowing for flexible comparisons.

```scala
val myBits = B"1101"

val test1 = myBits === M"1-01" // True
val test2 = myBits === M"0---" // False
val test3 = myBits === M"1--1" // True
```

--------------------------------

### Create and Assign SpinalHDL Bool Signals

Source: https://context7.com/spinalhdl/spinaldoc-rtd/llms.txt

Demonstrates the creation and assignment of Bool signals in SpinalHDL, including uninitialized signals, direct assignments, conversion from Scala Booleans, and basic logic operations. It also shows conditional assignments and register behavior with set/fall logic.

```scala
// Bool represents a single bit/boolean hardware signal
val myBool_1 = Bool()        // Create uninitialized Bool
myBool_1 := False            // := is assignment operator (like VHDL <=)

val myBool_2 = False         // Create Bool assigned to False

val myBool_3 = Bool(5 > 12)  // Convert Scala Boolean to SpinalHDL Bool

// Logic operations
val a, b, c = Bool()
val res = (!a & b) ^ c       // ((NOT a) AND b) XOR c

// Conditional assignment
val d = False
d.setWhen(cond)              // Set to True when cond is True
d.clearWhen(cond)            // Set to False when cond is True

// Register with set/fall behavior
val f = RegInit(False) fallWhen(ack) setWhen(req)
// Equivalent to: f := req || (f && !ack)
```

--------------------------------

### SpinalHDL Signal Resizing

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/miscelenea/core/core_components.rst

Explains how SpinalHDL handles automatic resizing of signals during assignments, including explicit resizing with .resized and .resize(newWidth), and automatic resizing for weak bit-inferred signals.

```scala
   x := y.resized
   x := y.resize(newWidth)
```

--------------------------------

### Scala Signal Assignment with External Function

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Getting Started/Help for VHDL people/vhdl_comp.rst

Shows an example of assigning a signal defined outside a function's scope in SpinalHDL. The `clear` function resets the `counter` signal, which is then conditionally called within a `when` block.

```scala
val counter = Reg(UInt(8 bits)) init(0)
counter := counter + 1

def clear() : Unit = {
  counter := 0
}

when(counter > 42) {
  clear()
}
```

--------------------------------

### Scala Flexible Signal Declaration and Assignment

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Getting Started/Help for VHDL people/vhdl_comp.rst

Demonstrates SpinalHDL's flexibility in declaring and assigning signals. Signals can be declared separately and then assigned, or defined and assigned in a single line, offering more concise code.

```scala
val a = Bool()
a := x & y
```

```scala
val a = x & y
```

--------------------------------

### Instantiate and Assign SpinalEnum Value

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/enum.rst

This example shows how to create an instance of an enumeration signal and assign a specific enum value to it. It also demonstrates importing enum elements for direct use.

```scala
object UartCtrlTxState extends SpinalEnum {
  val sIdle, sStart, sData, sParity, sStop = newElement()
}

val stateNext = UartCtrlTxState()
stateNext := UartCtrlTxState.sIdle

// You can also import the enumeration to have visibility of its elements
import UartCtrlTxState._
stateNext := sIdle
```

--------------------------------

### SpinalHDL: Basic Out of Range Constant Error

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Design errors/out_of_range_constant.rst

Demonstrates a typical SpinalHDL comparison that results in an 'OUT OF RANGE CONSTANT' error because the literal (42) is wider than the compared value (UInt with 2 bits). This error highlights that the literal 42 (binary 101010) is 6 bits wide, exceeding the 2 bits of the 'value' signal.

```scala
val value = in UInt(2 bits)
val result = out(value < 42)
```

--------------------------------

### Fix Hierarchy Violation: Input signal X cannot be assigned by Y in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/miscelenea/frequent_errors.rst

Details the 'Hierarchy violation: Input signal X can't be assigned by Y' error in SpinalHDL, which arises from attempting to assign an input signal from within the same component. It highlights the necessity of assigning input signals from the parent component.

```scala
class ComponentXY extends Component {
  val io = new Bundle {
    val X = in Bool()
  }
  ...
  val Y = Bool()
  io.X := Y // This assignment is not legal
  ...
}
```

--------------------------------

### SpinalHDL Concurrent Signal Assignment Example

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Semantic/rules.rst

Demonstrates that the order of combinational signal assignments does not affect the final hardware behavior in SpinalHDL. Both code blocks achieve the same result due to the concurrent nature of signal updates.

```scala
val a, b, c = UInt(8 bits) // Define 3 combinational signals
c := a + b  // c will be set to 7
b := 2      // b will be set to 2
a := b + 3  // a will be set to 5
```

```scala
val a, b, c = UInt(8 bits) // Define 3 combinational signals
b := 2      // b will be set to 2
a := b + 3  // a will be set to 5
c := a + b  // c will be set to 7
```

--------------------------------

### SpinalHDL: Allowing Out-of-Range Literals for a Specific Comparison

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Design errors/out_of_range_constant.rst

Shows how to explicitly allow a comparison with an out-of-range literal in SpinalHDL by using the '.allowOutOfRangeLiterals' method. This is useful when, due to design parametrization, a comparison with a larger constant is intended and should result in a statically known True/False value.

```scala
val value = in UInt(2 bits)
val result = out((value < 42).allowOutOfRangeLiterals)
```

--------------------------------

### SpinalHDL: Shift and Rotate Operations for Bits

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Developers area/types.rst

Explains shift and rotate operations available for the Bits type in SpinalHDL. Covers logical right and left shifts with both Int and UInt shift amounts, as well as left rotation.

```Scala
// Logical Shift Right
x >> y (y : Int)
x >> y (y : UInt)

// Logical Shift Left
x << y (y : Int)
x << y (y : UInt)

// Left Rotation
x.rotateLeft(y)
```

--------------------------------

### Declare Unsigned Fixed-Point (UFix) in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/Fix.rst

Demonstrates the declaration of unsigned fixed-point numbers (UFix) in SpinalHDL using different syntaxes. It highlights the use of `peak` and `resolution` or `width` parameters, along with the `exp` and `bits` combiners.

```scala
   // Unsigned Fixed-Point
   val UQ_8_2 = UFix(peak = 8 exp, resolution = -2 exp) // bit width = 8 - (-2) = 10 bits
   val UQ_8_2 = UFix(8 exp, -2 exp)

   val UQ_8_2 = UFix(peak = 8 exp, width = 10 bits)
   val UQ_8_2 = UFix(8 exp, 10 bits)
```

--------------------------------

### Parametrized Components with Configuration in SpinalHDL

Source: https://context7.com/spinalhdl/spinaldoc-rtd/llms.txt

Illustrates creating parametrized SpinalHDL components using configuration objects. Two examples are provided: `MySocConfig` using a case class for parameters, and `MyBusConfig` which includes methods and a `require` statement for validation. Components are instantiated with their respective configurations.

```Scala
// Configuration case class for complex parameters
case class MySocConfig(
  axiFrequency  : HertzNumber,
  onChipRamSize : BigInt,
  cpuCacheSize  : Int
)

class MySoc(config: MySocConfig) extends Component {
  val io = new Bundle {
    val axiPort = master(Axi4(Axi4Config(32, 32, 4)))
  }
  // Use config.axiFrequency, config.onChipRamSize, etc.
}

// Configuration with methods and validation
case class MyBusConfig(addressWidth: Int, dataWidth: Int) {
  def bytePerWord = dataWidth / 8
  def addressType = UInt(addressWidth bits)
  def dataType = Bits(dataWidth bits)

  require(dataWidth == 32 || dataWidth == 64, "Data width must be 32 or 64")
}

class MyBus(config: MyBusConfig) extends Component {
  val io = new Bundle {
    val addr = in(config.addressType)      // Use config methods
    val data = out(config.dataType)
  }
}

// Instantiate with configuration
val socConfig = MySocConfig(
  axiFrequency = 100 MHz,
  onChipRamSize = 32 KiB,
  cpuCacheSize = 4096
)
val mySoc = new MySoc(socConfig)
```

--------------------------------

### Basic Reporting with String Interpolation in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Other language features/report.rst

Demonstrates basic reporting in SpinalHDL using string interpolation for debugging simulation. It shows how to include enum values, unsigned integers, and output signals within the report string, which is then translated to Verilog's `$display` statement.

```scala
object Enum extends SpinalEnum {
    val MIAOU, RAWRR = newElement()
}

class TopLevel extends Component {
    val a = Enum.RAWRR()
    val b = U(0x42)
    val c = out(Enum.RAWRR())
    val d = out (U(0x42))
    report(Seq("miaou ", a, b, c, d))
}
```

```verilog
$display("NOTE miaou %s%x%s%x", a_string, b, c_string, d);
```

--------------------------------

### SpinalHDL: Formal Memory Content Checking

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Formal verification/index.rst

These Scala snippets demonstrate various ways to check the content of a RAM (Mem) within a formal verification context in SpinalHDL. They include checking for the absence of a specific word, and checking the count of a specific word.

```scala
// Manual access
for(i <- 0 until dut.ram.wordCount) {
  assumeInitial(dut.ram(i) =/= X) // No occurrence of the word X
}
```

```scala
assumeInitial(!dut.ram.formalContains(X)) // No occurrence of the word X
```

```scala
assumeInitial(dut.ram.formalCount(X) === 1) // only one occurrence of the word X
```

--------------------------------

### SpinalHDL Conditional Logic (when/switch)

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/miscelenea/core/core_components.rst

Provides examples of conditional execution using 'when' and 'switch' statements, similar to VHDL and Verilog, including nested conditions and the ability to define new signals within these blocks.

```scala
   when(cond1) { 
     // execute when      cond1 is true
   }.elsewhen(cond2) { 
     // execute when (not cond1) and cond2
   }.otherwise { 
     // execute when (not cond1) and (not cond2)
   }

   switch(x) { 
     is(value1) { 
       // execute when x === value1
     }
     is(value2) { 
       // execute when x === value2
     }
     default { 
       // execute if none of precedent condition meet
     }
   }

   val toto,titi = UInt(4 bits)
   val a,b = UInt(4 bits)

   when(cond) { 
     val tmp = a + b
     toto := tmp
     titi := tmp + 1
   } otherwise { 
     toto := 0
     titi := 0
   }
```

--------------------------------

### SpinalHDL: Manual Interrupt Controller Implementation with APB3

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/regIf.rst

Provides an example of manually writing an interrupt controller using SpinalHDL. It defines raw, force, mask, and status registers for interrupts, allowing for control and monitoring of interrupt sources.

```scala
class cpInterruptExample extends Component {
   val io = new Bundle {
     val tx_done, rx_done, frame_end = in Bool()
     val interrupt = out Bool()
     val apb = slave(Apb3(Apb3Config(16, 32)))
   }
   val busif = Apb3BusInterface(io.apb, (0x000, 100 Byte), regPre = "AP")
   val M_CP_INT_RAW   = busif.newReg(doc="cp int raw register")
   val tx_int_raw      = M_CP_INT_RAW.field(Bool(), W1C, doc="tx interrupt enable register")
   val rx_int_raw      = M_CP_INT_RAW.field(Bool(), W1C, doc="rx interrupt enable register")
   val frame_int_raw   = M_CP_INT_RAW.field(Bool(), W1C, doc="frame interrupt enable register")

   val M_CP_INT_FORCE = busif.newReg(doc="cp int force register\n for debug use")
   val tx_int_force     = M_CP_INT_FORCE.field(Bool(), RW, doc="tx interrupt enable register")
   val rx_int_force     = M_CP_INT_FORCE.field(Bool(), RW, doc="rx interrupt enable register")
   val frame_int_force  = M_CP_INT_FORCE.field(Bool(), RW, doc="frame interrupt enable register")

   val M_CP_INT_MASK    = busif.newReg(doc="cp int mask register")
   val tx_int_mask      = M_CP_INT_MASK.field(Bool(), RW, doc="tx interrupt mask register")
   val rx_int_mask      = M_CP_INT_MASK.field(Bool(), RW, doc="rx interrupt mask register")
   val frame_int_mask   = M_CP_INT_MASK.field(Bool(), RW, doc="frame interrupt mask register")

   val M_CP_INT_STATUS   = busif.newReg(doc="cp int state register")
   val tx_int_status      = M_CP_INT_STATUS.field(Bool(), RO, doc="tx interrupt state register")
   val rx_int_status      = M_CP_INT_STATUS.field(Bool(), RO, doc="rx interrupt state register")
   val frame_int_status   = M_CP_INT_STATUS.field(Bool(), RO, doc="frame interrupt state register")

   rx_int_raw.setWhen(io.rx_done)
   tx_int_raw.setWhen(io.tx_done)
}
```

--------------------------------

### SpinalEnum Comparison Operators

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/enum.rst

This code demonstrates the usage of equality (`===`) and inequality (`=/=`) operators for comparing enumeration values, returning a Boolean result.

```scala
import UartCtrlTxState._

val stateNext = UartCtrlTxState()
stateNext := sIdle

when(stateNext === sStart) {
  ...
}

switch(stateNext) {
  is(sIdle) {
    ...
  }
  is(sStart) {
    ...
  }
  ...
}
```

--------------------------------

### Configure and Instantiate Axi4VgaCtrl

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Legacy/pinsec/hardware_toplevel.rst

Configures and instantiates an AXI4 VGA controller. The configuration includes AXI interface widths, burst length, maximum frame size, FIFO size, RGB color format, and the VGA clock domain.

```scala
val vgaCtrlConfig = Axi4VgaCtrlGenerics(
  axiAddressWidth = 32,
  axiDataWidth    = 32,
  burstLength     = 8,           // In Axi words
  frameSizeMax    = 2048*1512*2, // In byte
  fifoSize        = 512,         // In axi words
  rgbConfig       = RgbConfig(5,6,5),
  vgaClock        = vgaClockDomain
)

val vgaCtrl = Axi4VgaCtrl(vgaCtrlConfig)
```

--------------------------------

### Sphinx WaveDrom Timing Diagram Example

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Developers area/howtodocument.rst

This code snippet demonstrates how to create a timing diagram using the sphinxcontrib-wavedrom plugin. It utilizes the WaveJSON syntax to define signals and their waveforms. Ensure to use non-relaxed JSON for PDF export.

```javascript
.. wavedrom::

   { "signal": [
      { "name": "pclk", "wave": "p......." },
      { "name": "Pclk", "wave": "P......." },
      { "name": "nclk", "wave": "n......." },
      { "name": "Nclk", "wave": "N......." },
      {},
      { "name": "clk0", "wave": "phnlPHNL" },
      { "name": "clk1", "wave": "xhlhLHl." },
      { "name": "clk2", "wave": "hpHplnLn" },
      { "name": "clk3", "wave": "nhNhplPl" },
      { "name": "clk4", "wave": "xlh.L.Hx" }
   ]}
```

--------------------------------

### Automatic Field Allocation in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/regIf.rst

This code snippet illustrates automatic field allocation within a SpinalHDL register. It shows how to define fields within a register, specifying their type and access permissions. The example highlights how the system automatically handles reserved bits between fields, simplifying the definition process.

```scala
val M_REG0  = busif.newReg(doc="REG1")
  val fd0 = M_REG0.field(Bits(2 bit), RW, doc= "fields 0")
  M_REG0.reserved(5 bits)
  val fd1 = M_REG0.field(Bits(3 bit), RW, doc= "fields 0")
  val fd2 = M_REG0.field(Bits(3 bit), RW, doc= "fields 0")
  // auto reserved 2 bits
  val fd3 = M_REG0.fieldAt(pos=16, Bits(4 bit), doc= "fields 3")
  // auto reserved 12 bits
```

--------------------------------

### Configure and Instantiate Non-Coherent Tilelink Bus in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/Bus/tilelink/tilelink.rst

This snippet shows how to define basic Tilelink bus parameters for a non-coherent setup and instantiate two buses, connecting them using the '<<' operator. It uses `tilelink.BusParameter.simple` for straightforward configuration.

```scala
import spinal.lib.bus.tilelink
val param = tilelink.BusParameter.simple(
  addressWidth = 32,
  dataWidth    = 64,
  sizeBytes    = 64,
  sourceWidth  = 4
)
val busA, busB = tilelink.Bus(param)
busA << busB
```

--------------------------------

### Chaining Composites in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Structuring/naming.rst

Illustrates how to chain multiple `Composite` instances in SpinalHDL. This allows for sequential application of namespaced functionalities. The example defines `isZero` and `inverted` methods, each using a `Composite` to encapsulate logic, and then chains these methods to process an input value.

```scala
class MyComponent extends Component {
    def isZero(value: UInt) = new Composite(value) {
      val comparator = value === 0
    }.comparator


    def inverted(value: Bool) = new Composite(value) {
      val inverter = !value
    }.inverter

    val value = in UInt(8 bits)
    val result = out Bool()
    result := inverted(isZero(value))
  }
```

--------------------------------

### SpinalEnum Type Declarations

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/enum.rst

This snippet provides the type declarations for individual enumeration elements (`SpinalEnumElement` or `.E`) and for the enumeration signal itself (`SpinalEnumCraft` or `.C`).

```scala
// Type of an enum element (e.g., sIdle)
spinal.core.SpinalEnumElement[UartCtrlTxState.type]
or equivalently
UartCtrlTxState.E

// Type of an enum signal (e.g., stateNext)
spinal.core.SpinalEnumCraft[UartCtrlTxState.type]
or equivalently
UartCtrlTxState.C
```

--------------------------------

### Configure sbt for Local SpinalHDL Dependency

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Developers area/howotuselocalspinalclone.rst

This Scala code snippet is for `build.sbt`. It sets up project references to a local SpinalHDL clone, defining `spinalRoot` and linking `spinalIdslPlugin`, `spinalSim`, `spinalCore`, and `spinalLib` as dependencies. It also configures `scalacOptions` to include the `idslplugin` artifact path, which is crucial for preventing compilation errors.

```scala
ThisBuild / version := "1.0"              // change as needed
ThisBuild / scalaVersion := "2.12.18"     // change as needed
ThisBuild / organization := "org.example" // change as needed

val spinalRoot = file("/somewhere/SpinalHDL")
lazy val spinalIdslPlugin = ProjectRef(spinalRoot, "idslplugin")
lazy val spinalSim = ProjectRef(spinalRoot, "sim")
lazy val spinalCore = ProjectRef(spinalRoot, "core")
lazy val spinalLib = ProjectRef(spinalRoot, "lib")

lazy val projectname = (project in file("."))
.settings(
   Compile / scalaSource := baseDirectory.value / "hw" / "spinal",
).dependsOn(spinalIdslPlugin, spinalSim, spinalCore, spinalLib)

scalacOptions += (spinalIdslPlugin / Compile / packageBin / artifactPath).map {
   file =>
     s"-Xplugin:${file.getAbsolutePath}"
}.value

fork := true
```

--------------------------------

### Combinational Logic in SpinalHDL and VHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Other language features/vhdl_generation.rst

Illustrates the implementation of combinational logic using 'when' and 'switch' statements in SpinalHDL and its equivalent VHDL representation.

```scala
class TopLevel extends Component {
  val io = new Bundle {
    val cond           = in  Bool()
    val value          = in  UInt(4 bits)
    val withoutProcess = out UInt(4 bits)
    val withProcess    = out UInt(4 bits)
  }
  io.withoutProcess := io.value
  io.withProcess := 0
  when(io.cond) {
    switch(io.value) {
      is(U"0000") {
        io.withProcess := 8
      }
      is(U"0001") {
        io.withProcess := 9
      }
      default {
        io.withProcess := io.value+1
      }
    }
  }
}
```

```vhdl
entity TopLevel is
  port(
    io_cond : in std_logic;
    io_value : in unsigned(3 downto 0);
    io_withoutProcess : out unsigned(3 downto 0);
    io_withProcess : out unsigned(3 downto 0)
  );
end TopLevel;

architecture arch of TopLevel is
begin
  io_withoutProcess <= io_value;
  process(io_cond,io_value)
  begin
    io_withProcess <= pkg_unsigned("0000");
    if io_cond = '1' then
      case io_value is
        when pkg_unsigned("0000") =>
          io_withProcess <= pkg_unsigned("1000");
        when pkg_unsigned("0001") =>
          io_withProcess <= pkg_unsigned("1001");
        when others =>
          io_withProcess <= (io_value + pkg_unsigned("0001"));
      end case;
    end if;
  end process;
end arch;
```

--------------------------------

### Resolve Hierarchy Violation: Signal X cannot be assigned by Y in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/miscelenea/frequent_errors.rst

Explains and provides solutions for 'Hierarchy violation: Signal X can't be assigned by Y' errors in SpinalHDL. This violation occurs when attempting to assign signals to subcomponents inappropriately, often due to incorrect direction declarations.

```scala
class ComponentX extends Component {
  ...
  val X = Bool()
  ...
}

class ComponentY extends Component {
  ...
  val componentX = new ComponentX
  val Y = Bool()
  componentX.X := Y // This assignment is not legal
  ...
}
```

```scala
class ComponentX extends Component {
  val io = new Bundle {
    val X = Bool() // Forgot to specify an in/out direction
  }
  ...
}

class ComponentY extends Component {
  ...
  val componentX = new ComponentX
  val Y = Bool()
  componentX.io.X := Y // This assignment will be detected as not legal
  ...
}
```

--------------------------------

### Implement WidthAdapterFiber for Data Width Adaptation in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/Bus/tilelink/tilelink_fabric.rst

Provides an implementation of a WidthAdapterFiber using SpinalHDL's Area and Fiber constructs. This adapter negotiates data widths between master and slave interfaces, handling mismatches and generating the necessary hardware bridge.

```Scala
class WidthAdapterFiber() extends Area {
  val up = Node.up()
  val down = Node.down()

  // Populate the MemoryConnection graph.
  new MemoryConnection {
    override def up = up
    override def down = down
    override def transformers = Nil
    override def mapping = SizeMapping(0, BigInt(1) << WidthAdapterFiber.this.up.m2s.parameters.addressWidth)
    populate()
  }

  // Fiber in which we will negotiate the data width parameters and generate the hardware.
  val logic = Fiber build new Area {
    // First, we propagate downward the parameter proposal, hopping that the downward side will agree.
    down.m2s.proposed.load(up.m2s.proposed)

    // Second, we will propagate upward what is actually supported, but will take care of any
    // dataWidth mismatch.
    up.m2s.supported load down.m2s.supported.copy(
      dataWidth = up.m2s.proposed.dataWidth
    )

    // Third, we propagate downward the final bus parameter, but will take care of any dataWidth mismatch.
    down.m2s.parameters load up.m2s.parameters.copy(
      dataWidth = down.m2s.supported.dataWidth
    )

    // No alteration on s2m parameters.
    up.s2m.from(down.s2m)

    // Finally, we generate the hardware.
    val bridge = new tilelink.WidthAdapter(up.bus.p, down.bus.p)
    bridge.io.up << up.bus
    bridge.io.down >> down.bus
  }
}
```

--------------------------------

### Simulate Single Clock FIFO using Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Simulation/examples/single_clock_fifo.rst

This Scala code sets up and runs a simulation for a single-clock FIFO component. It compiles the FIFO, configures the simulation with waveform dumping, and then forks stimulus threads for pushing and popping data. The push thread randomizes inputs and updates a reference queue, while the pop thread checks the FIFO's output against the reference queue. Dependencies include SpinalHDL core libraries and Scala's mutable collections.

```scala
import spinal.core._
import spinal.core.sim._

import scala.collection.mutable.Queue


object SimStreamFifoExample {
  def main(args: Array[String]): Unit = {
    // Compile the Component for the simulator.
    val compiled = SimConfig.withWave.allOptimisation.compile(
      rtl = new StreamFifo(
        dataType = Bits(32 bits),
        depth = 32
      )
    )

    // Run the simulation.
    compiled.doSimUntilVoid{dut =>
      val queueModel = mutable.Queue[Long]()

      dut.clockDomain.forkStimulus(period = 10)
      SimTimeout(1000000*10)

      // Push data randomly, and fill the queueModel with pushed transactions.
      val pushThread = fork {
        dut.io.push.valid #= false
        while(true) {
          dut.io.push.valid.randomize()
          dut.io.push.payload.randomize()
          dut.clockDomain.waitSampling()
          if(dut.io.push.valid.toBoolean && dut.io.push.ready.toBoolean) {
            queueModel.enqueue(dut.io.push.payload.toLong)
          }
        }
      }

      // Pop data randomly, and check that it match with the queueModel.
      val popThread = fork {
        dut.io.pop.ready #= true
        for(i <- 0 until 100000) {
          dut.io.pop.ready.randomize()
          dut.clockDomain.waitSampling()
          if(dut.io.pop.valid.toBoolean && dut.io.pop.ready.toBoolean) {
            assert(dut.io.pop.payload.toLong == queueModel.dequeue())
          }
        }
        simSuccess()
      }
    }
  }
}
```

--------------------------------

### Instantiate RgbToSomething Component with Custom Stages (Scala)

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/Pipeline/introduction.rst

This snippet demonstrates how to customize the RgbToSomething component's processing stages. By adjusting the `addAt`, `invAt`, and `mulAt` parameters, users can control where inversion and addition occur within the pipeline, optimizing for specific hardware requirements.

```scala
SpinalVerilog(
        new RgbToSomething(
          addAt    = 0,
          invAt    = 0,
          mulAt    = 1,
          resultAt = 2
        )
      )
```

--------------------------------

### Workaround for intermediate val in SpinalHDL NodeArea

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/Pipeline/introduction.rst

Demonstrates a workaround in SpinalHDL for cases where intermediate vals like 'addNode' are necessary, by defining a NodeArea class to avoid direct replacement of 'new addNode.Area' with 'new nodes(at).Area'.

```scala
class NodeArea(at : Int) extends NodeMirror(nodes(at))
val adder = new NodeArea(addAt) {
    ...
}
```

--------------------------------

### Transform TriState to inout(Analog) with InOutWrapper - SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Other language features/analog_inout.rst

Demonstrates the use of InOutWrapper to transform 'master' TriState/TriStateArray/ReadableOpenDrain bundles within a component into native 'inout(Analog(...))' signals. This allows for cleaner hardware descriptions by abstracting away analog specifics until synthesis.

```scala
case class Apb3Gpio(gpioWidth : Int) extends Component {
  val io = new Bundle {
    val gpio = master(TriStateArray(gpioWidth bits))
    val apb  = slave(Apb3(Apb3Gpio.getApb3Config()))
  }
  ...
}

SpinalVhdl(InOutWrapper(Apb3Gpio(32)))
```

--------------------------------

### Instantiate Apb3Gpio Controller

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Legacy/pinsec/hardware_toplevel.rst

Instantiates an APB3 General Purpose Input/Output (GPIO) controller. The configuration specifies the width of the GPIO interface, allowing for different numbers of I/O pins.

```scala
val gpioACtrl = Apb3Gpio(
  gpioWidth = 32
)

val gpioBCtrl = Apb3Gpio(
  gpioWidth = 32
)
```

--------------------------------

### Scala: Register Vectors, Bundles, and Deferred Initialization

Source: https://context7.com/spinalhdl/spinaldoc-rtd/llms.txt

Explains how to create vectors of registers, initialize specific fields within bundles, convert existing signals to registers with optional reset values, and implement reusable components with deferred initialization using a `ShiftRegister` example.

```scala
// Vector of registers
val vecReg1 = Vec(Reg(UInt(8 bits)) init(0), 4)
val vecReg2 = Vec.fill(8)(Reg(Bool()))
vecReg2.foreach(_ init(False))                  // Initialize all elements

// Bundle with selective initialization
case class ValidRGB() extends Bundle {
  val valid   = Bool()
  val r, g, b = UInt(8 bits)
}

val reg = Reg(ValidRGB())
reg.valid init(False)                           // Only valid field has reset value
// r, g, b have no reset value

// Transform existing signal into register
val io = new Bundle {
  val apb = master(Apb3(apb3Config))
}

io.apb.PADDR.setAsReg()                        // Convert signal to register
io.apb.PWRITE.setAsReg() init(False)           // With reset value

when(someCondition) {
  io.apb.PWRITE := True                        // Assign directly to register
}

// Deferred initialization for reusable components
case class ShiftRegister[T <: Data]( 
  dataType: HardType[T],
  depth: Int,
  initFunc: T => Unit
) extends Component {
  val io = new Bundle {
    val input  = in (dataType())
    val output = out(dataType())
  }

  val regs = Vec.fill(depth)(Reg(dataType()))
  regs.foreach(initFunc)                       // Apply init function to all regs

  for (i <- 1 to (depth-1)) {
    regs(i) := regs(i-1)
  }

  regs(0) := io.input
  io.output := regs(depth-1)
}

```

--------------------------------

### Perform Logic Operations on Bits Vectors in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/bits.rst

Illustrates the use of bitwise and logical shift/rotation operators on Bits vectors. It covers bitwise NOT, AND, reduction operations, logical shifts (left and right with different width behaviors), and bit rotations.

```scala
// Bitwise operator
val a, b, c = Bits(32 bits)
c := ~(a & b) // Inverse(a AND b)

val all_1 = a.andR // Check that all bits are equal to 1

// Logical shift
val bits_10bits = bits_8bits << 2  // shift left (results in 10 bits)
val shift_8bits = bits_8bits |<< 2 // shift left (results in 8 bits)

// Logical rotation
val myBits = bits_8bits.rotateLeft(3) // left bit rotation

// Set/clear
val a = B"8'x42"
when(cond) {
  a.setAll() // set all bits to True when cond is True
}
```

--------------------------------

### SpinalHDL: Using parasiteField for Shared Register Fields

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/regIf.rst

Demonstrates how to use `parasiteField` to allow software to share the same register on multiple addresses. This is useful for implementing features like clock gating enables and interrupt raw status registers with force interfaces.

```scala
val M_CG_ENS_SET = busif.newReg(doc="Clock Gate Enables")  // x00000
val M_CG_ENS_CLR = busif.newReg(doc="Clock Gate Enables")  // 0x0004
val M_CG_ENS_RO  = busif.newReg(doc="Clock Gate Enables")  // 0x0008

val xx_sys_cg_en = M_CG_ENS_SET.field(Bits(4 bit), W1S, 0, "clock gate enables, write 1 set" )
M_CG_ENS_CLR.parasiteField(xx_sys_cg_en, W1C, 0, "clock gate enables, write 1 clear" )
M_CG_ENS_RO.parasiteField(xx_sys_cg_en, RO, 0, "clock gate enables, read only")
```

```scala
val RAW    = this.newRegAt(offset,"Interrupt Raw status Register\n set when event \n clear raw when write 1")
val FORCE  = this.newReg("Interrupt Force  Register\n for SW debug use \n write 1 set raw")

val raw    = RAW.field(Bool(), AccessType.W1C,    resetValue = 0, doc = s"raw, default 0" )
FORCE.parasiteField(raw, AccessType.W1S,   resetValue = 0, doc = s"force, write 1 set, debug use" )
```

--------------------------------

### Declare a SpinalHDL Bundle with conditional signals

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/bundle.rst

This snippet illustrates how to declare signals within a SpinalHDL Bundle conditionally. The `data` signal is only generated if `dataWidth` is greater than 0, showcasing the use of the `generate` method.

```scala
case class myBundle(dataWidth: Int) extends Bundle {
  val data = (dataWidth > 0) generate (UInt(dataWidth bits))
}
```

--------------------------------

### SpinalHDL Assignment Width Mismatch Fix

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Design errors/width_mismatch.rst

Demonstrates fixing a width mismatch in a SpinalHDL assignment by resizing the source signal. This ensures that the assigned signal's width is compatible with the target signal's width.

```scala
class TopLevel extends Component {
  val a = UInt(8 bits)
  val b = UInt(4 bits)
  b := a.resized
}
```

--------------------------------

### Define and Use a Clock Domain in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/miscelenea/core/core_components.rst

This example demonstrates how to define a custom clock domain using specific clock and reset signals, and then apply it to a particular area of the design, ensuring that synchronous elements within that area utilize the defined clock domain. It also shows how to instantiate a register within this ClockingArea.

```scala
val coreClock = Bool()
val coreReset = Bool()

// Define a new clock domain
val coreClockDomain = ClockDomain(coreClock,coreReset)

... // Other design elements

// Use this domain in an area of the design
val coreArea = new ClockingArea(coreClockDomain) {
  val coreClockedRegister = Reg(UInt(4 bits))
}
```

--------------------------------

### SpinalHDL: BitVector Initialization and Assignment

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Developers area/types.rst

Demonstrates how to initialize and assign values to BitVector types in SpinalHDL, including masked comparisons and default value assignments. Supports comparisons with bitmasks and default assignments for entire ranges or specific bits.

```Scala
val myBool := myUInt === U(7 -> true,(6 downto 0) -> false)
val myBool := myUInt === U(myUInt.range -> true)

// For assignment purposes, you can omit the B/U/S, which also alow the use of the [default -> ???] feature
myUInt := (default -> true)                       // Assign myUInt with "11111111"
myUInt := (myUInt.range -> true)                  // Assign myUInt with "11111111"
myUInt := (7 -> true,default -> false)            // Assign myUInt with "10000000"
myUInt := ((4 downto 1) -> true,default -> false) // Assign myUInt with "00011110"
```

```Scala
val myBits = Bits(8 bits)
val itMatch = myBits === M"00--10--"
```

--------------------------------

### Access Raw Integer Value of SpinalHDL Fixed-Point

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/Fix.rst

Demonstrates how to read from or write to the underlying integer representation of a fixed-point number in SpinalHDL using the `.raw` property. This allows direct manipulation of the bits representing the fixed-point value.

```scala
   val UQ_8_2 = UFix(8 exp, 10 bits)
   UQ_8_2.raw := 4        // Assign the value corresponding to 1.0
   UQ_8_2.raw := U(17)    // Assign the value corresponding to 4.25
```

--------------------------------

### SpinalHDL Timer Component Implementation

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Examples/Advanced ones/timer.rst

Defines the SpinalHDL Timer component with its construction parameter (width) and input/output signals (tick, clear, limit, full, value). It specifies the behavior of the timer, including counting up on 'tick', clearing on 'clear', inhibiting tick when 'limit' is reached, and outputting the current 'value'.

```scala
case class Timer(width : Int) extends Component {
  val tick = in Bool()
  val clear = in Bool()
  val limit = in UInt (width bits)

  val full = out Bool ()
  val value = out UInt (width bits)

  val reg = Reg (UInt (width bits)) init (0)

  when(!clear) {
    when(tick && reg =/= limit) {
      reg <<= reg + 1
    }
  }.otherwise {
    reg <<= 0
  }

  full := tick && reg === limit
  value := reg
}
```

--------------------------------

### Declare and Instantiate Registers in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Sequential logic/registers.rst

Demonstrates the declaration of various types of registers including UInt, RegNext, RegInit, and RegNextWhen. It shows how to assign values and handle conditional updates.

```scala
// UInt register of 4 bits
val reg1 = Reg(UInt(4 bits))

// Register that updates itself every cycle with a sample of reg1 incremented by 1
val reg2 = RegNext(reg1 + 1)

// UInt register of 4 bits initialized with 0 when the reset occurs
val reg3 = RegInit(U"0000")
reg3 := reg2
when(reg2 === 5) {
  reg3 := 0xF
}

// Register that samples reg3 when cond is True
val reg4 = RegNextWhen(reg3, cond)
```

--------------------------------

### Enumerate ClockDomains in SpinalHDL Component

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Developers area/spinalhdl_datamodel.rst

This snippet demonstrates how to elaborate a SpinalHDL component and then traverse its hierarchy to collect all ClockDomains in use. It differentiates between general ClockDomains and externally defined ones.

```scala
object MyTopLevelVerilog extends App {
  class MyTopLevel extends Component {
    val cdA = ClockDomain.external("rawrr")
    val regA = cdA(RegNext(False))

    val sub = new Component {
      val cdB = ClockDomain.external("miaou")
      val regB = cdB(RegNext(False))

      val clkC = CombInit(regB)
      val cdC = ClockDomain(clkC)
      val regC = cdC(RegNext(False))
    }
  }

  val report = SpinalVerilog(new MyTopLevel)

  val clockDomains = mutable.LinkedHashSet[ClockDomain]()
  report.toplevel.walkComponents(c =>
    c.dslBody.walkStatements(s =>
      s.foreachClockDomain(cd =>
        clockDomains += cd
      )
    )
  )

  println("ClockDomains : " + clockDomains.mkString(", "))
  val externals = clockDomains.filter(_.clock.component == null)
  println("Externals : " + externals.mkString(", "))
}
```

--------------------------------

### RALF (UVM) Document Generation Example

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/regIf.rst

Example of generating a RALF (Register Abstraction Layer File) for UVM using `RalfGenerator`. This function takes the output name as an argument.

```scala
busif.accept(RalfGenerator("header"))
```

--------------------------------

### SpinalHDL Vec Helper Functions: Finding and Reducing

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/Vec.rst

Illustrates sFindFirst for locating the first element matching a condition and returning its index, and reduceBalancedTree for performing an operation (like summation) across all elements using a balanced tree structure to optimize circuit depth. Requires importing spinal.lib._.

```scala
    import spinal.lib._

    // Create a vector with 4 unsigned integers
    val vec1 = Vec.fill(4)(UInt(8 bits))

    // ... the vector is actually assigned somewhere

    val (u1Found, u1): (Bool, UInt) = vec1.sFindFirst(_ < 10) // get the index of the first element lower than 10
    val u2: UInt = vec1.reduceBalancedTree(_ + _) // sum all elements together
```

--------------------------------

### SpinalHDL: Specifying an Initial Assumption

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Formal verification/index.rst

This code snippet illustrates how to specify an initial assumption in SpinalHDL's formal verification. It assumes that the current clock domain's reset signal is active at the initial state.

```scala
assumeInitial(clockDomain.isResetActive)
```

--------------------------------

### Verilog: Resulting Logic for Signal Copying

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Semantic/assignments.rst

Shows the Verilog output generated from the Scala code, illustrating how CombInit results in separate logic for the copied signal, unlike direct assignment which leads to aliasing.

```verilog
always @(*)
begin
  a = 8'h01;
  if(sel)
    a = 8'h02;
end

assign c = 8'h01;
always @(*)
begin
  d = c;
  if(sel)
    d = 8'h02;
end
```

--------------------------------

### AvalonMM Configuration and Instantiation in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/Bus/avalon/avalonmm.rst

Demonstrates how to create a custom AvalonMM configuration for a write-only bus with burst capabilities and byte enables, and then instantiates the AvalonMM bus using this configuration. It utilizes utility functions like `bursted` and `copy` for configuration, followed by calling `getWriteOnlyConfig` to disable read features.

```scala
// Create a write only AvalonMM configuration with burst capabilities and byte enable
val myAvalonConfig =  AvalonMMConfig.bursted(
  addressWidth = addressWidth,
  dataWidth = memDataWidth,
  burstCountWidth = log2Up(burstSize + 1)
).copy(
  useByteEnable = true,
  constantBurstBehavior = true,
  burstOnBurstBoundariesOnly = true
).getWriteOnlyConfig

// Create an instance of the AvalonMM bus by using this configuration
val bus = AvalonMM(myAvalonConfig)
```

--------------------------------

### Override Bundle Clone Function for Implicit Parameters in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Design errors/spinal_cant_clone.rst

Illustrates how to fix the 'Spinal can't clone class' error when Bundles have implicit parameters. By overriding the clone function, the implicit parameter is correctly propagated, enabling successful cloning. This solution is specific to SpinalHDL.

```scala
case class Xlen(val xlen: Int) {}

case class MemoryAddress()(implicit xlenConfig: Xlen) extends Bundle {
    val address = UInt(xlenConfig.xlen bits)
}

class DebugMemory(implicit config: Xlen) extends Component {
    val io = new Bundle {
        val inputAddress = in(MemoryAddress())
    }   

    val someAddress = RegNext(io.inputAddress) // -> ERROR *****************************
}
```

```scala
case class MemoryAddress()(implicit xlenConfig: Xlen) extends Bundle {
  val address = UInt(xlenConfig.xlen bits)

  override def clone = MemoryAddress()
}
```

--------------------------------

### Verilog: FIFO Pop Logic

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Structuring/naming.rst

This Verilog code implements the control logic for popping an element from a FIFO. It handles ready and valid signals, synchronizes data, and manages internal state registers.

```verilog
assign source_fifo_io_pop_ready = ((1'b1 && (! source_fifo_io_pop_m2sPipe_valid)) || source_fifo_io_pop_m2sPipe_ready);
      assign source_fifo_io_pop_m2sPipe_valid = source_fifo_io_pop_rValid;
      assign source_fifo_io_pop_m2sPipe_payload = source_fifo_io_pop_rData;
      assign sink_valid = source_fifo_io_pop_m2sPipe_valid;
      assign source_fifo_io_pop_m2sPipe_ready = sink_ready;
      assign sink_payload = source_fifo_io_pop_m2sPipe_payload;
      always @ (posedge clk or posedge reset) begin
        if (reset) begin
          source_fifo_io_pop_rValid <= 1'b0;
        end else begin
          if(source_fifo_io_pop_ready)begin
            source_fifo_io_pop_rValid <= source_fifo_io_pop_valid;
          end
        end
      end

      always @ (posedge clk) begin
        if(source_fifo_io_pop_ready)begin
          source_fifo_io_pop_rData <= source_fifo_io_pop_payload;
        end
      end
    endmodule
```

--------------------------------

### Scala: Conditional Assignment in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Design errors/assignment_overlap.rst

Presents a corrected approach in SpinalHDL to handle signal assignments that avoids the 'ASSIGNMENT OVERLAP' error by using conditional logic. This ensures that assignments are made only when certain conditions are met.

```scala
class TopLevel extends Component {
  val a = UInt(8 bits)
  a := 42
  when(something) {
    a := 66
  }
}
```

--------------------------------

### SpinalHDL Signal Type Declaration

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Semantic/assignments.rst

Shows the declaration of combinational and registered signals in SpinalHDL. Signals are inherently combinational unless explicitly declared as registered using `Reg(...)`.

```scala
val a = UInt(4 bits)              // Define a combinational signal
val b = Reg(UInt(4 bits))         // Define a registered signal
val c = Reg(UInt(4 bits)) init(0) // Define a registered signal which is
                                  //  set to 0 when a reset occurs
```

--------------------------------

### Namespacing with Areas in SpinalHDL Components

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Structuring/naming.rst

Explains how to use the `Area` construct in SpinalHDL to define new namespaces within a `Component`. Signals declared inside an `Area` will have their names prefixed with the area's name, improving organization and preventing name collisions.

```scala
class MyComponent extends Component {
  val logicA = new Area {    // This define a new namespace named "logicA
    val toggle = Reg(Bool()) // This register will be named "logicA_toggle"
    toggle := !toggle
  }
}

```

--------------------------------

### Local Signal Declaration within Conditional Blocks in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Semantic/when_switch.rst

Demonstrates the ability to declare new signals locally within 'when' or 'switch' conditional blocks. These local signals are scoped to the block they are defined in. This allows for temporary variables used only within specific conditional paths.

```scala
val x, y = UInt(4 bits)
val a, b = UInt(4 bits)

when(cond) {
  val tmp = a + b
  x := tmp
  y := tmp + 1
} otherwise {
  x := 0
  y := 0
}
```

--------------------------------

### SpinalHDL Arithmetic Operations (Addition, Subtraction, Multiplication, Division, Modulo)

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/Int.rst

Illustrates various arithmetic operations in SpinalHDL, including standard addition, addition with carry, saturated addition, subtraction, subtraction with carry, saturated subtraction, multiplication, division, and modulo. It also covers unary bitwise NOT and two's complement negation for signed integers.

```scala
val a, b, c = UInt(8 bits)
a := U"xf0"
b := U"x0f"

c := a + b
assert(c === U"8'xff")

val d = a +^ b
assert(d === U"9'x0ff")

// 0xf0 + 0x20 would overflow, the result therefore saturates
val e = a +| U"8'x20"
assert(e === U"8'xff")
```

--------------------------------

### Continuous Assignment for Wire and Equality in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Developers area/types.rst

Shows how continuous assignment can define a wire, maintain the result of an equality operation in hardware, and infer the type to be Bool due to the use of the '===' operator. The 'done' signal is set to true when 'value' is true.

```scala
val done = Bool(False)
val blue = in UInt(4 bits)
...
val value = blue === U"0001"  // inferred type is Bool due to use of === operator
when(value) {
  done := True
}
```

--------------------------------

### Formal Verification of Value Incrementing

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Formal verification/index.rst

Illustrates checking for sequential behavior during formal verification. This example asserts that the counter's value increments correctly when not at its maximum, using `pastValid()` and `past()` to reference previous states and ensuring the increment logic is sound.

```scala
FormalConfig.withBMC(15).doVerify(new Component {
  val dut = FormalDut(new LimitedCounter())
  assumeInitial(ClockDomain.current.isResetActive)

  // Check that the value is incrementing.
  // hasPast is used to ensure that the past(dut.value) had at least one sampling out of reset
  when(pastValid() && past(dut.value) =/= 10) {
    assert(dut.value === past(dut.value) + 1)
  }
})
```

--------------------------------

### SpinalHDL Bitwise Operations: Concatenation and Resizing

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/Int.rst

Demonstrates basic bitwise operations in SpinalHDL, including accessing the least significant bit, concatenating signals, and resizing signals to different bit widths. The `lsb` method extracts the least significant bit, `@@` and `##` are used for concatenation, and `resized` or `resize()` methods handle bit width adjustments.

```scala
myBool := mySInt.lsb  // equivalent to mySInt(0)

// Concatenation
val mySInt = mySInt_1 @@ mySInt_1 @@ myBool   
val myBits = mySInt_1 ## mySInt_1 ## myBool

// Resize
myUInt_32bits := U"32'x112233344"
myUInt_8bits  := myUInt_32bits.resized      // automatic resize (myUInt_8bits = 0x44)
val lowest_8bits = myUInt_32bits.resize(8)  // resize to 8 bits (myUInt_8bits = 0x44)
```

--------------------------------

### Equivalent Reg and RegNext Syntax in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Sequential logic/registers.rst

Shows the equivalence between the standard Reg syntax with explicit assignment and the shorthand RegNext syntax for register updates in SpinalHDL.

```scala
// Standard way
val something = Bool()
val value = Reg(Bool())
value := something

// Short way
val something = Bool()
val value = RegNext(something)
```

--------------------------------

### Verilog Generation for Chained Composites in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Structuring/naming.rst

Presents the Verilog code generated from the SpinalHDL example that chains `Composite` functionalities. The generated Verilog module `MyComponent` reflects the sequential application of the `isZero` and `inverted` operations, creating intermediate wires for each step.

```verilog
module MyComponent (
  input      [7:0]    value,
  output              result
);
  wire                value_comparator;
  wire                value_comparator_inverter;

  assign value_comparator = (value == 8'h0);
  assign value_comparator_inverter = (! value_comparator);
  assign result = value_comparator_inverter;

endmodule
```

--------------------------------

### Define Hardware Component with Scala Case Class and Collections in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Structuring/parametrization.rst

Demonstrates defining a hardware component using a Scala case class and generating hardware areas dynamically based on an integer parameter. This showcases the integration of Scala's object-oriented features and collections for hardware description.

```scala
case class MyComponent(amount : Int) extends Component {
  val myHardware = for(i <- 0 until amount) yield new Area {
    // hardware here
  }
}
```

--------------------------------

### SpinalHDL Bool Logic Operators

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/bool.rst

Illustrates the usage of various logical operators for the SpinalHDL Bool type, including NOT, AND, OR, XOR, and methods for setting, clearing, rising, and falling states. It also shows conditional assignments using `when`, `setWhen`, `clearWhen`, `riseWhen`, and `fallWhen`.

```scala
val a, b, c = Bool()
val res = (!a & b) ^ c   // ((NOT a) AND b) XOR c

val d = False
when(cond) {
  d.set()                // equivalent to d := True
}

val e = False
e.setWhen(cond)          // equivalent to when(cond) { d := True }

val f = RegInit(False) fallWhen(ack) setWhen(req)
/** equivalent to
 * when(f && ack) { f := False }
 * when(req) { f := True }
 * or
 * f := req || (f && !ack)
 */

// mind the order of assignments!  last one wins
```

--------------------------------

### SpinalHDL ClockDomain Stimulus Functions

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Simulation/clock.rst

Functions to stimulate ClockDomain signals like clock, reset, and clock enable. These are used to control the simulation flow and inject specific signal states. They operate on the implicit clock domain of a component.

```Scala
dut.clockDomain.assertReset()
dut.clockDomain.fallingEdge()
sleep(10)
```

--------------------------------

### Basic SoC TopLevel with TileLink Nodes in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/Bus/tilelink/tilelink_fabric.rst

Provides a foundational example of a SpinalHDL SoC top-level design, demonstrating the instantiation and connection of CPU, RAM, and GPIO components using TileLink nodes. It showcases mapping peripherals to specific memory addresses.

```scala
val cpu = new CpuFiber()

val ram = new RamFiber()

// Map the ram at [0x10000-0x101FF], the ram will infer its own size from it.
ram.up at(0x10000, 0x200) of cpu.down 

val gpio = new GpioFiber()

// Map the gpio at [0x20000-0x20FFF], its range of 4KB being fixed internally.
gpio.up at 0x20000 of cpu.down
```

--------------------------------

### Configure and Instantiate Apb3UartCtrl

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Legacy/pinsec/hardware_toplevel.rst

Configures and instantiates an APB3 UART controller. The configuration includes generic parameters for the UART core (data width, clock divider, sampling sizes) and FIFO depths for transmit and receive.

```scala
val uartCtrlConfig = UartCtrlMemoryMappedConfig(
  uartCtrlConfig = UartCtrlGenerics(
    dataWidthMax      = 8,
    clockDividerWidth = 20,
    preSamplingSize   = 1,
    samplingSize      = 5,
    postSamplingSize  = 2
  ),
  txFifoDepth = 16,
  rxFifoDepth = 16
)

val uartCtrl = Apb3UartCtrl(uartCtrlConfig)
```

--------------------------------

### Scala: Basic Register Declaration and Initialization

Source: https://context7.com/spinalhdl/spinaldoc-rtd/llms.txt

Demonstrates fundamental ways to declare registers in Scala using SpinalHDL, including registers without reset values, those initialized to zero, and conditional assignments. It also covers `RegNext` for sampling signals and `RegNextWhen` for conditional sampling.

```scala
// Basic register declaration
val reg1 = Reg(UInt(4 bits))                    // No reset value

// Register with reset value
val reg3 = RegInit(U"0000")                     // Initialized to 0 on reset
reg3 := reg2
when(reg2 === 5) {
  reg3 := 0xF                                   // Conditional assignment
}

// RegNext - samples value every cycle
val reg2 = RegNext(reg1 + 1)                    // Samples reg1+1 each cycle
val reg2_alt = RegNext(reg1, init=0)            // With reset value

// RegNextWhen - conditional sampling
val reg4 = RegNextWhen(reg3, cond)              // Samples reg3 when cond is True
val reg5 = RegNextWhen(reg1, enableSignal, U(99))  // With reset value

// Alternative init syntax
val reg6 = Reg(UInt(6 bits)) init(42)           // Register initialized to 42

// Last assignment wins rule
val controlReg = RegInit(U(0, 8 bits))
controlReg := defaultValue
when(condition1) {
  controlReg := value1                          // Overrides default if true
}
when(condition2) {
  controlReg := value2                          // Overrides value1 if true
}
// If no assignment executes, register keeps previous value
```

--------------------------------

### SpinalHDL Operator Width Mismatch Fix

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Design errors/width_mismatch.rst

Illustrates resolving a width mismatch in a SpinalHDL bitwise OR operation by resizing the narrower operand. This allows the operation to proceed with compatible signal widths.

```scala
class TopLevel extends Component {
  val a = UInt(8 bits)
  val b = UInt(4 bits)
  val result = a | (b.resized)
}
```

--------------------------------

### Declare Bits Vectors in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/bits.rst

Demonstrates various ways to declare and initialize Bits vectors in SpinalHDL. This includes inferring width from assignments, explicitly defining width, initializing with values, and using default values.

```scala
val myBits1 = Bits(32 bits)   
val myBits2 = B(25, 8 bits)
val myBits3 = B"8'xFF"   // Base could be x,h (base 16)                         
                         //               d   (base 10)
                         //               o   (base 8)
                         //               b   (base 2)    
val myBits4 = B"1001_0011"  // _ can be used for readability

// Bits with all ones ("11111111")
val myBits5 = B(8 bits, default -> True)

// initialize with "10111000" through a few elements
val myBits6 = B(8 bits, (7 downto 5) -> B"101", 4 -> true, 3 -> True, default -> false)

// "10000000" (For assignment purposes, you can omit the B)
val myBits7 = Bits(8 bits)
myBits7 := (7 -> true, default -> false)
```

```scala
// Declaration
val myBits = Bits()     // the size is inferred from the widest assignment
// ....
// .resized needed to prevent WIDTH MISMATCH error as the constants
// width does not match size that is inferred from assignment below
myBits := B("1010").resized  // auto-widen Bits(4 bits) to Bits(6 bits)
when(condxMaybe) {
  // Bits(6 bits) is inferred for myBits, this is the widest assignment
  myBits := B("110000")
}
```

--------------------------------

### Namespacing within Functions using Areas in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Structuring/naming.rst

Demonstrates how to create namespaces within functions using `Area` in SpinalHDL. This allows for logical grouping of related signals and logic within a function, with names being prefixed accordingly in the generated hardware.

```scala
class MyComponent extends Component {
  def isZero(value: UInt) = new Area {
    val comparator = value === 0
  }

  val value = in UInt (8 bits)
  val someLogic = isZero(value)

  val result = out Bool()
  result := someLogic.comparator
}

```

--------------------------------

### Easy Interrupt Component with SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/regIf.rst

This snippet demonstrates creating a component with an APB bus interface that utilizes the interruptFactory to manage interrupts from multiple input signals. It includes the generation of various documentation formats like CHeader, HTML, JSON, Ralf, and SystemRDL.

```scala
class EasyInterrupt extends Component {
  val io = new Bundle {
    val apb = slave(Apb3(Apb3Config(16,32)))
    val a, b, c, d, e = in Bool()
  }

  val busif = BusInterface(io.apb,(0x000,1 KiB), 0, regPre = "AP")

  busif.interruptFactory("T", io.a, io.b, io.c, io.d, io.e)

  busif.accept(CHeaderGenerator("intrreg","AP"))
  busif.accept(HtmlGenerator("intrreg", "Interupt Example"))
  busif.accept(JsonGenerator("intrreg"))
  busif.accept(RalfGenerator("intrreg"))
  busif.accept(SystemRdlGenerator("intrreg", "AP"))
}
```

--------------------------------

### Handle Synchronous Enable Quirk in SpinalHDL Memory Access

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Sequential logic/memory.rst

This snippet illustrates a quirk in SpinalHDL where conditional `when` blocks are ignored when used with memory enable signals. It shows the incorrect usage with `when(cond)` and the recommended approach of combining the condition directly with the enable signal (`io.rdEna & cond`) for proper elaboration.

```scala
val rom = Mem(Bits(10 bits), 32)
when(cond) {
  io.rdata := rom.readSync(io.addr, io.rdEna)
}

// Preferred way:
io.rdata := rom.readSync(io.addr, io.rdEna & cond)
```

--------------------------------

### SpinalHDL Mux Syntax

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Semantic/when_switch.rst

Demonstrates the two equivalent syntaxes for creating a Mux with a Bool selection signal in SpinalHDL. This involves defining a condition and two potential output values.

```scala
val cond = Bool()
val whenTrue, whenFalse = UInt(8 bits)
val muxOutput  = Mux(cond, whenTrue, whenFalse)
val muxOutput2 = cond ? whenTrue | whenFalse
```

--------------------------------

### Conditional Hardware Generation with Scala if in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Getting Started/Scala Guide/interaction.rst

Illustrates how Scala's 'if' statement can be used within SpinalHDL to conditionally generate hardware. This example shows a 'counter' register whose generation might be controlled by a Scala condition.

```scala
val counter = Reg(UInt(8 bits))
```

--------------------------------

### Instant Entry State in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/fsm.rst

Explains how to bypass the default boot state and have a state machine start directly in a user-defined entry state using `makeInstantEntry()`. This bypasses the `onEntry` call during boot.

```scala
// State sequence: IDLE, STATE_A, STATE_B, ...
val fsm = new StateMachine {
  // IDLE is named BOOT in simulation
  val IDLE = makeInstantEntry()
  val STATE_A, STATE_B, STATE_C = new State
  
  IDLE.whenIsActive(goto(STATE_A))
  STATE_A.whenIsActive(goto(STATE_B))
  STATE_B.whenIsActive(goto(STATE_C))
  STATE_C.whenIsActive(goto(STATE_B))
}
```

--------------------------------

### Fix Combinatorial Loop in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Design errors/combinatorial_loop.rst

This Scala code shows a corrected version of the previous example where a combinatorial loop was present. By changing the assignment to 'd', the circular dependency is broken, resolving the loop.

```scala
class TopLevel extends Component {
  val a = UInt(8 bits)
  val b = UInt(8 bits)
  val c = UInt(8 bits)
  val d = UInt(8 bits)

  a := b
  b := c | d
  d := 42
  c := 0
}
```

--------------------------------

### Instantiate and Assign Rgb Bundle in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/Graphics/colors.rst

Demonstrates how to instantiate an Rgb bundle using a defined RgbConfig and assign values to its color channels. This example shows practical application of the Rgb bundle for hardware color representation.

```scala
val config = RgbConfig(5,6,5)
val color = Rgb(config)
color.r := 31
```

--------------------------------

### Dynamic Encoding for SpinalEnum

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/enum.rst

This snippet shows how to create a dynamic encoding strategy for an enumeration using a function to calculate the encoding values based on the element's declaration order.

```scala
val encoding = SpinalEnumEncoding("dynamicEncoding", _ * 2 + 1)

object MyEnumDynamic extends SpinalEnum(encoding) {
  val e0, e1, e2, e3 = newElement()
}
```

--------------------------------

### Configure Clock Domain with ClockDomainConfig in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/miscelenea/core/core_components.rst

This snippet illustrates how to configure a clock domain with specific parameters like clock edge, reset kind, and active levels using the `ClockDomainConfig` class. It then applies this configuration to a new clock domain and instantiates a register within a `ClockingArea` that uses this custom domain. The example defines input/output signals for the component.

```scala
class CustomClockExample extends Component {
  val io = new Bundle {
    val clk = in Bool()
    val resetn = in Bool()
    val result = out UInt (4 bits)
  }
  val myClockDomainConfig = ClockDomainConfig(
    clockEdge = RISING,
    resetKind = ASYNC,
    resetActiveLevel = LOW
  )
  val myClockDomain = ClockDomain(io.clk,io.resetn,config = myClockDomainConfig)
  val myArea = new ClockingArea(myClockDomain) {
    val myReg = Reg(UInt(4 bits)) init(7)
    myReg := myReg + 1

    io.result := myReg
  }
}
```

--------------------------------

### Define Configuration Class for SOC Parameters in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Structuring/components_hierarchy.rst

Presents a Scala case class 'MySocConfig' designed to hold various configuration parameters for a System-on-Chip (SOC). This includes parameters like clock frequency, RAM size, and CPU/cache configurations. This approach promotes modularity and makes it easier to manage complex hardware configurations.

```scala
case class MySocConfig(axiFrequency  : HertzNumber,
                          onChipRamSize : BigInt,
                          cpu           : RiscCoreConfig,
                          iCache        :	InstructionCacheConfig)

class MySoc(config: MySocConfig) extends Component {
  ...
}
```

--------------------------------

### SpinalHDL TileLink Memory Access Query

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/Bus/tilelink/tilelink_fabric.rst

Demonstrates how to use `spinal.lib.system.tag.MemoryConnection.getMemoryTransfers` to query allowed memory accesses for a given TileLink node. This is useful for understanding master capabilities and generating hardware based on memory mappings.

```scala
val mappings = spinal.lib.system.tag.MemoryConnection.getMemoryTransfers(down)
// Here we just print the values out in stdout, but instead you can generate some 
// hardware from it.
for(mapping <- mappings) {
  println(s"- ${mapping.where} -> ${mapping.transfers}")
}
```

--------------------------------

### Instantiate and Configure USB OHCI Controller in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/Com/usb_ohci.rst

This snippet demonstrates how to instantiate the `UsbOhciTop` component, configure its parameters, and generate Verilog output. It sets up the OHCI parameters, defines the number of ports, and specifies DMA data width.

```scala
import spinal.core._
import spinal.core.sim._
import spinal.lib.bus.bmb._
import spinal.lib.bus.bmb.sim._
import spinal.lib.bus.misc.SizeMapping
import spinal.lib.com.usb.ohci._
import spinal.lib.com.usb.phy.UsbHubLsFs.CtrlCc
import spinal.lib.com.usb.phy._

class UsbOhciTop(val p : UsbOhciParameter) extends Component {
  val ohci = UsbOhci(p, BmbParameter(
    addressWidth = 12,
    dataWidth = 32,
    sourceWidth = 0,
    contextWidth = 0,
    lengthWidth = 2
  ))

  val phyCd = ClockDomain.external("phyCd", frequency = FixedFrequency(48 MHz))
  val phy = phyCd(UsbLsFsPhy(p.portCount, sim=true))

  val phyCc = CtrlCc(p.portCount, ClockDomain.current, phyCd)
  phyCc.input <> ohci.io.phy
  phyCc.output <> phy.io.ctrl

  // propagate io signals
  val irq = ohci.io.interrupt.toIo
  val ctrl = ohci.io.ctrl.toIo
  val dma = ohci.io.dma.toIo
  val usb = phy.io.usb.toIo
  val management = phy.io.management.toIo
}

object UsbHostGen extends App {
  val p = UsbOhciParameter(
    noPowerSwitching = true,
    powerSwitchingMode = true,
    noOverCurrentProtection = true,
    powerOnToPowerGoodTime = 10,
    dataWidth = 64, // DMA data width, up to 128
    portsConfig = List.fill(4)(OhciPortParameter()) // 4 Ports
  )

  SpinalVerilog(new UsbOhciTop(p))
}
```

--------------------------------

### Apply Clock Domain to a Specific Area

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Structuring/clock_domain.rst

Shows how to instantiate a clock domain and apply it to a specific area of the design using `ClockingArea`. This ensures all synchronous elements within this area implicitly use the defined clock and reset.

```scala
val coreClock = Bool()
val coreReset = Bool()

// Define a new clock domain
val coreClockDomain = ClockDomain(coreClock, coreReset)

// Use this domain in an area of the design
val coreArea = new ClockingArea(coreClockDomain) {
  val coreClockedRegister = Reg(UInt(4 bits))
}
```

--------------------------------

### Scala for Loop for Hardware Elaboration in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Getting Started/Scala Guide/interaction.rst

Demonstrates how to use a Scala 'for' loop within SpinalHDL for hardware elaboration. This example initializes all bits of an 8-bit register 'value' to 'True' when a condition 'something' is met. This is evaluated during hardware synthesis.

```scala
val value = Reg(Bits(8 bits))
when(something) {
  // Set all bits of value by using a Scala for loop (evaluated during hardware elaboration)
  for(idx <- 0 to 7) {
    value(idx) := True
  }
}
```

--------------------------------

### SpinalHDL: Correct IO Bundle Signal Declaration

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Design errors/iobundle.rst

Demonstrates the correct way to declare input signals within an IO bundle in SpinalHDL. This ensures proper directionality and avoids compilation errors.

```scala
class TopLevel extends Component {
  val io = new Bundle {
    val a = in UInt(8 bits)  // provide 'in' direction declaration
  }
}
```

--------------------------------

### Component Using Chained Stream Utilities in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Structuring/naming.rst

An example component `MyComponent` that utilizes the `queue` and `m2sPipe` methods defined on the `Stream` bundle. This demonstrates how the `Composite` feature, when used in bundle utilities, allows for clean, nested calls to create complex dataflow structures like pipelines and queues.

```scala
class MyComponent extends Component {
    val source = slave(Stream(UInt(8 bits)))
    val sink = master(Stream(UInt(8 bits)))
    sink << source.queue(size = 16).m2sPipe()
  }
```

--------------------------------

### Define Frequency and Time in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Other language features/utils.rst

SpinalHDL provides a dedicated syntax for defining frequency and time values. These values infer specific types like TimeNumber and HertzNumber, which are based on BigDecimal. Calculations involving frequency and time result in BigDecimal values.

```scala
val frequency = 100 MHz	// infers type TimeNumber
val timeoutLimit = 3 ms	// infers type HertzNumber
val period = 100 us		// infers type TimeNumber

val periodCycles = frequency * period             // infers type BigDecimal
val timeoutCycles = frequency * timeoutLimit      // infers type BigDecimal
```

--------------------------------

### VGA Controller: Stream-Based RGB Pixel Data Handling (Scala)

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Examples/Intermediates ones/vga.rst

This snippet illustrates an advanced feature for the VgaCtrl component, enabling it to handle a stream of RGB pixel fragments. It includes logic for automatically managing the softReset input based on error conditions and the end of a picture frame.

```scala
  // end VgaCtrl connections
   :prepend: case class VgaCtrl(rgbConfig: RgbConfig, timingsWidth: Int = 12) extends Component {
             ...
   :append: ...
```

--------------------------------

### Correct Hierarchy Violation: Output signal X cannot be assigned by Y in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/miscelenea/frequent_errors.rst

Addresses the 'Hierarchy violation: Output signal X can't be assigned by Y' error in SpinalHDL. This common issue occurs when trying to assign an output signal of a component from outside of it, emphasizing that assignments must be made internally.

```scala
class ComponentX extends Component {
  val io = new Bundle {
    val X = out Bool()
  }
  ...
}

class ComponentY extends Component {
  ...
  val componentX = new ComponentX
  val Y = Bool()
  componentX.X := Y // This assignment is not legal
  ...
}
```

--------------------------------

### Sequential Logic in SpinalHDL and VHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Other language features/vhdl_generation.rst

Demonstrates the implementation of sequential logic, including registers with and without reset, in SpinalHDL and its equivalent VHDL representation.

```scala
class TopLevel extends Component {
  val io = new Bundle {
    val cond   = in Bool()
    val value  = in UInt (4 bits)
    val resultA = out UInt(4 bits)
    val resultB = out UInt(4 bits)
  }

  val regWithReset = Reg(UInt(4 bits)) init(0)
  val regWithoutReset = Reg(UInt(4 bits))

  regWithReset := io.value
  regWithoutReset := 0
  when(io.cond) {
    regWithoutReset := io.value
  }

  io.resultA := regWithReset
  io.resultB := regWithoutReset
}
```

```vhdl
entity TopLevel is
  port(
    io_cond : in std_logic;
    io_value : in unsigned(3 downto 0);
    io_resultA : out unsigned(3 downto 0);
    io_resultB : out unsigned(3 downto 0);
    clk : in std_logic;
    reset : in std_logic
  );
end TopLevel;

architecture arch of TopLevel is

  signal regWithReset : unsigned(3 downto 0);
  signal regWithoutReset : unsigned(3 downto 0);
begin
  io_resultA <= regWithReset;
  io_resultB <= regWithoutReset;
  process(clk,reset)
  begin
    if reset = '1' then
      regWithReset <= pkg_unsigned("0000");

```

--------------------------------

### Instantiate Cross Clock Domain StreamCCByToggle (Scala)

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/stream.rst

This code illustrates the creation of a `StreamCCByToggle` component, designed for low-bandwidth communication between different clock domains using toggling signals. It requires the data type and the input and output clock domains. This bridge is noted for its small area usage but limited throughput.

```scala
val clockA = ClockDomain(???) 
val clockB = ClockDomain(???) 
val streamA,streamB = Stream(Bits(8 bits))
// ...
val bridge = StreamCCByToggle(
  dataType    = Bits(8 bits),
  inputClock  = clockA,
  outputClock = clockB
)
bridge.io.input  << streamA
bridge.io.output >> streamB
```

--------------------------------

### Scala BlackBox for Instantiating VHDL/Verilog IP

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/miscelenea/core/core_components.rst

Defines a SpinalHDL `BlackBox` component named `Ram_1w_1r` to instantiate external VHDL or Verilog RAM IP. It specifies generics for word width and count, and defines the input/output ports for clock, write, and read operations.

```scala
class Ram_1w_1r(_wordWidth: Int, _wordCount: Int) extends BlackBox {
  val generic = new Generic {
    val wordCount = _wordCount
    val wordWidth = _wordWidth
  }

  val io = new Bundle {
    val clk = in Bool()

    val wr = new Bundle {
      val en = in Bool()
      val addr = in UInt (log2Up(_wordCount) bits)
      val data = in Bits (_wordWidth bits)
    }
    val rd = new Bundle {
      val en = in Bool()
      val addr = in UInt (log2Up(_wordCount) bits)
      val data = out Bits (_wordWidth bits)
    }
  }

  mapClockDomain(clock=io.clk)
}
```

--------------------------------

### Scala Bundle and Functions for Custom Bus Interface

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Structuring/function.rst

Defines a custom `MyBus` bundle in SpinalHDL, incorporating `valid`, `ready`, and `payload` signals. It includes utility functions like `asMaster` for defining signal directions, `<<` for stream-like connections, and `queue` for integrating a FIFO buffer. This snippet showcases how to encapsulate bus behavior and logic within a Scala bundle.

```scala
case class MyBus(payloadWidth: Int) extends Bundle with IMasterSlave {
     val valid   = Bool()
     val ready   = Bool()
     val payload = Bits(payloadWidth bits)

     // Define the direction of the data in a master mode
     override def asMaster(): Unit = {
       out(valid, payload)
       in(ready)
     }

     // Connect that to this
     def <<(that: MyBus): Unit = {
       this.valid   := that.valid
       that.ready   := this.ready
       this.payload := that.payload
     }

     // Connect this to the FIFO input, return the fifo output
     def queue(size: Int): MyBus = {
       val fifo = new MyBusFifo(payloadWidth, size)
       fifo.io.push << this
       return fifo.io.pop
     }
   }

   class MyBusFifo(payloadWidth: Int, depth:  Int) extends Component {

     val io = new Bundle {
       val push = slave(MyBus(payloadWidth))
       val pop  = master(MyBus(payloadWidth))
     }

     val mem =  Mem(Bits(payloadWidth bits), depth)

     // ...

   }
```

--------------------------------

### SpinalHDL Bool Edge Detection

Source: https://context7.com/spinalhdl/spinaldoc-rtd/llms.txt

Shows how to detect edges (any, rising, falling, and toggle) on SpinalHDL Bool signals. Edge detection requires an internal register to store the previous state for comparison.

```scala
// All edge detection creates an additional register internally
// to store previous cycle value for comparison

val signalA = Bool()

// Detect any edge
when(signalA.edge(False)) {  // False is reset value for internal register
    // Execute when signalA changes state (0->1 or 1->0)
}

// Detect rising edge (low to high transition)
when(signalA.rise(False)) {
    // Execute when signalA transitions from False to True
}

// Detect falling edge
when(signalA.fall(False)) {
    // Execute when signalA transitions from True to False
}

// Get all edges as bundle
val edgeBundle = signalA.edges(False)
when(edgeBundle.rise) {
    // Handle rising edge
}
when(edgeBundle.fall) {
    // Handle falling edge
}
when(edgeBundle.toggle) {
    // Handle any edge
}
```

--------------------------------

### Deferred Initialization of Registers in Vector (Scala)

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Sequential logic/registers.rst

Demonstrates deferred initialization of registers within a vector using a function. The `ShiftRegister` component takes an `initFunc` parameter to initialize its internal register vector, for example, initializing a flow's valid signal to False.

```scala
case class ShiftRegister[T <: Data](dataType: HardType[T], depth: Int, initFunc: T => Unit) extends Component {
      val io = new Bundle {
         val input  = in (dataType())
         val output = out(dataType())
      }

      val regs = Vec.fill(depth)(Reg(dataType()))
      regs.foreach(initFunc)

      for (i <- 1 to (depth-1)) {
            regs(i) := regs(i-1)
      }

      regs(0) := io.input
      io.output := regs(depth-1)
   }

   object SRConsumer {
      def initIdleFlow[T <: Data](flow: Flow[T]): Unit = {
         flow.valid init(False)
      }
   }

   class SRConsumer() extends Component {
      // ...
      val sr = ShiftRegister(Flow(UInt(8 bits)), 4, SRConsumer.initIdleFlow[UInt])
   }
```

--------------------------------

### Define IO Bundle directions using in/out

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/bundle.rst

This example demonstrates specifying the direction of a SpinalHDL Bundle within a component's IO definition using `in()` and `out()`. This is used when all signals within the bundle share the same direction, simplifying IO declarations.

```scala
case class Color(channelWidth: Int) extends Bundle {
  val r, g, b = UInt(channelWidth bits)
}

val io = new Bundle {
  val input  = in (Color(8))
  val output = out(Color(8))
}
```

--------------------------------

### SpinalHDL Unsigned to Integer Indexing

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Getting Started/Help for VHDL people/vhdl_comp.rst

Allows direct indexing of arrays using unsigned integers in SpinalHDL, eliminating the manual casting often needed in VHDL. This provides a more intuitive way to access array elements.

```scala
val array = Vec(UInt(4 bits),8)
val sel = UInt(3 bits)
val arraySel = array(sel) // Arrays are indexed directly by using UInt
```

--------------------------------

### Scala Case Class for Bus Configuration with Requirements

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Structuring/components_hierarchy.rst

Defines a Scala case class `MyBusConfig` for bus configuration, including address and data widths. It enforces requirements on the data width to be either 32 or 64 bits. This configuration is used during SpinalHDL code generation.

```scala
case class MyBusConfig(addressWidth: Int, dataWidth: Int) {
  def bytePerWord = dataWidth / 8
  def addressType = UInt(addressWidth bits)
  def dataType = Bits(dataWidth bits)

  require(dataWidth == 32 || dataWidth == 64, "Data width must be 32 or 64")
}
```

--------------------------------

### SpinalHDL Bundle Assignment

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Semantic/assignments.rst

Illustrates how to assign to or from bundles of signals in SpinalHDL using Scala's tuple syntax. This allows grouping multiple signals into a single assignment, automatically converting them to a unified bit-bus.

```scala
val a, b, c = UInt(4 bits)
val d       = UInt(12 bits)
val e       = Bits(10 bits)
val f       = SInt(2  bits)
val g       = Bits()

(a, b, c) := B(0, 12 bits)
(a, b, c) := d.asBits
(a, b, c) := (e, f).asBits           // both sides
g         := (a, b, c, e, f).asBits  // and on the right hand side
```

--------------------------------

### Create Apb3Decoder for Peripherals

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Legacy/pinsec/hardware_toplevel.rst

This snippet shows the creation of an Apb3Decoder to manage connections between an APB3 bridge and various slave peripherals. It maps each peripheral's APB3 interface to a specific address range.

```scala
val apbDecoder = Apb3Decoder(
  master = apbBridge.io.apb,
  slaves = List(
    gpioACtrl.io.apb -> (0x00000, 4 KiB),
    gpioBCtrl.io.apb -> (0x01000, 4 KiB),
    uartCtrl.io.apb  -> (0x10000, 4 KiB),
    timerCtrl.io.apb -> (0x20000, 4 KiB),
    vgaCtrl.io.apb   -> (0x30000, 4 KiB),
    core.io.debugBus -> (0xF0000, 4 KiB)
  )
)
```

--------------------------------

### Verilog Output for Namespaced Signals within Functions

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Structuring/naming.rst

Illustrates the Verilog generation for a SpinalHDL component where `Area` is used within a function to create a namespace. The `someLogic_comparator` signal shows how the function-defined area name is prepended to the signal name.

```verilog
module MyComponent (
  input      [7:0]    value,
  output              result
);
  wire                someLogic_comparator;

  assign someLogic_comparator = (value == 8'h0);
  assign result = someLogic_comparator;

endmodule

```

--------------------------------

### Scala Function for RGB to Gray Conversion

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/miscelenea/core/core_components.rst

Demonstrates using Scala functions to perform hardware operations. This example converts an RGB color to grayscale using predefined coefficients. It defines a helper function `coef` for multiplication and then calculates the gray level.

```scala
// Input RGB color
val r,g,b = UInt(8 bits)

// Define a function to multiply a UInt by a scala Float value.
def coef(value : UInt,by : Float) : UInt = (value * U((255*by).toInt,8 bits) >> 8)

// Calculate the gray level
val gray = coef(r,0.3f) +
           coef(g,0.4f) +
           coef(b,0.3f)
```

--------------------------------

### Declare and Manipulate Bits Vectors in SpinalHDL

Source: https://context7.com/spinalhdl/spinaldoc-rtd/llms.txt

Demonstrates the declaration of Bits vectors with various initializations (integer, hex, binary literals, default values) and covers bitwise operations (AND, OR, NOT, AND-reduce), bit shifts (logical and arithmetic), and bit extraction/indexing (static, dynamic, and range-based).

```Scala
// Bits is a bit vector without arithmetic meaning
val myBits1 = Bits(32 bits)             // 32-bit vector
val myBits2 = B(25, 8 bits)             // 8-bit vector initialized to 25
val myBits3 = B"8'xFF"                  // Hex literal (8 bits)
val myBits4 = B"1001_0011"              // Binary literal with readability separator

// Initialize with element list
val myBits5 = B(8 bits, default -> True)                          // All ones
val myBits6 = B(8 bits, (7 downto 5) -> B"101", 4 -> true, default -> false)  // "10111000"

// Bitwise operations
val a, b, c = Bits(32 bits)
c := ~(a & b)                           // Inverse of (a AND b)
val all_1 = a.andR                      // True if all bits are 1

// Bit shifts (different width semantics)
val bits_10bits = bits_8bits << 2       // Left shift with Int, increases width to 10 bits
val shift_8bits = bits_8bits |<< 2      // Left shift maintaining width (8 bits)
val myBits = bits_8bits.rotateLeft(3)   // Rotate left, same width

// Bit extraction and indexing
val myBool = myBits(4)                  // Static access to bit 4
myBits(1) := True                       // Assign to bit 1

val index = UInt(2 bit)
val indexed = myBits(index, 2 bit)      // Dynamic 2-bit extraction at index

val myBits_8bit = myBits_16bit(7 downto 0)     // Range extraction [7:0]
val myBits_7bit = myBits_16bit(0 to 6)         // Range [0:6]
```

--------------------------------

### Parameterized ShiftRegister Component (Safe Way) in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Other language features/utils.rst

Demonstrates the 'safe way' to parameterize a SpinalHDL component using HardType. This approach simplifies instantiation and reduces the risk of errors by encapsulating the type information within HardType.

```scala
case class ShiftRegister[T <: Data](dataType: HardType[T], depth: Int) extends Component {
  val io = new Bundle {
    val input  = in (dataType())
    val output = out(dataType())
  }
  // ...
}

val shiftReg = ShiftRegister(Bits(32 bits), depth = 8)
```

--------------------------------

### Parameter Grouping in SpinalHDL Components/Bundles

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Getting Started/Scala Guide/coding_conventions.rst

Shows how to group parameters for SpinalHDL Components and Bundles using case classes. This practice enhances maintainability and simplifies parameter manipulation, though it's not universally applicable.

```scala
case class RgbConfig(rWidth: Int, gWidth: Int, bWidth: Int) {
  def getWidth = rWidth + gWidth + bWidth
}

case class Rgb(c: RgbConfig) extends Bundle {
  val r = UInt(c.rWidth bits)
  val g = UInt(c.gWidth bits)
  val b = UInt(c.bWidth bits)
}

class Fifo[T <: Data](dataType: T, depth: Int) extends Component {

}
```

--------------------------------

### SpinalHDL: Formal Verification Setup for DUT with RAM

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Formal verification/index.rst

This snippet demonstrates setting up formal verification for a DUT (Design Under Test) that includes a RAM. It uses SpinalHDL's formal verification framework to assume initial states and check assertions on the RAM's read and write operations. The verification is configured with a BMC depth of 15.

```scala
import spinal.core.formal._

FormalConfig.withBMC(15).doVerify(new Component {
  val dut = FormalDut(new DutWithRam())
  assumeInitial(ClockDomain.current.isResetActive)

  // assume that no word in the ram has the value 1
  for(i <- 0 until dut.ram.wordCount) {
    assumeInitial(dut.ram(i) =/= 1)
  }

  // Allow the write anything but value 1 in the ram
  anyseq(dut.write)
  clockDomain.withoutReset() { // As the memory write can occur during reset, we need to ensure the assume apply there too
    assume(dut.write.data =/= 1)
  }

  // Check that no word in the ram is set to 1
  anyseq(dut.read.address)
  assert(dut.read.data =/= 1)
})
```

--------------------------------

### TopLevel Component with PLL and Reset Adaptation in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Examples/Simple ones/pll_resetctrl.rst

Defines a TopLevel component in SpinalHDL that instantiates a PLL BlackBox, creates a new ClockDomain from its output, and adapts an asynchronous reset to a synchronous reset for the new domain. It utilizes SpinalHDL's core and library functionalities.

```scala
import spinal.core._
import spinal.lib._

case class TopLevel() extends Component {
  val io = new Bundle {
    val clkIn = in Bool()
    val reset = in Bool()
    val led = out Bool()
  }

  val pll = PLL()
  pll.io.clkIn := io.clkIn

  val pllClkDomain = ClockDomain(pll.io.clkOut, reset = io.reset)
  val pllResetCtrl = ResetCtrl(pllClkDomain.reset)
  pllResetCtrl.asyncReset := io.reset

  val coreLogic = new ClockingArea(pllClkDomain) {
    val counter = Reg(UInt(8 bits)) init (0)
    counter := counter + 1
    io.led := counter.msb
  }
}
```

--------------------------------

### SpinalHDL Stateful Utilities Examples

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/utils.rst

Illustrates the use of stateful utility functions in SpinalHDL, which maintain internal state across clock cycles. This includes signal delay and history logging.

```Scala
val delayedSignal = Delay(mySignal, 5)
val historyVec = History(mySignal, 10)
val conditionalHistory = History(mySignal, 5, when = io.enable, init = initialValue)
val historyRange = History(mySignal, 0 until 5)
val bufferedSignal = BufferCC(inputSignal)
```

--------------------------------

### Execute Code in Component's Beginning Context

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Developers area/spinalhdl_datamodel.rst

This Scala function allows executing a block of code as if the current component's context did not exist. It manipulates the component's symbol tree to achieve this, enabling the definition of new signals without the influence of conditional scopes like 'when' or 'switch'.

```scala
def atBeginingOfCurrentComponent[T](body : => T) : T = {
    val body = Component.current.dslBody  // Get the head of the current component symbols tree (AST in other words)
    val ctx = body.push()                 // Now all access to the SpinalHDL API will be append to it (instead of the current context)
    val swapContext = body.swap()         // Empty the symbol tree (but keep a reference to the old content)
    val ret = that                        // Execute the block of code (will be added to the recently empty body)
    ctx.restore()                         // Restore the original context in which this function was called
    swapContext.appendBack()              // append the original symbols tree to the modified body
    ret                                   // return the value returned by that
  }
  
  // Example usage:
  // val database = mutable.HashMap[Any, Bool]()
  // def get(key : Any) : Bool = {
  //   database.getOrElseUpdate(key, atBeginingOfCurrentComponent(False))
  // }
  // 
  // object key
  // 
  // when(something) {
  //   if(somehow) {
  //     get(key) := True
  //   }
  // }
  // when(database(key)) { ... }
  
```

--------------------------------

### SpinalHDL Parameterized Component Example

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Getting Started/Help for VHDL people/vhdl_comp.rst

Provides an example of a parameterized SpinalHDL component, `Arbiter`, which accepts a generic payload type `T` and a `portCount`. This demonstrates SpinalHDL's native support for generics.

```scala
class Arbiter[T <: Data](payloadType: T, portCount: Int) extends Component {
  val io = new Bundle {
    val sources = Vec(slave(Stream(payloadType)), portCount)
    val sink = master(Stream(payloadType))
  }
  // ...
```

--------------------------------

### SpinalHDL Bool Type Declaration and Assignment

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Developers area/types.rst

Demonstrates how to declare and assign values to the Bool type in SpinalHDL. It shows direct assignment, assignment from Scala Boolean, and the use of the assignment operator ':='.

```scala
val myBool = Bool()
myBool := False         // := is the assignment operator
myBool := Bool(false)   // Use a Scala Boolean to create a literal
```

--------------------------------

### SpinalHDL for RTL Description

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Foreword/index.rst

This SpinalHDL code provides an equivalent description to the VHDL example, using a more concise and direct approach. It demonstrates how SpinalHDL simplifies the definition of combinatorial and sequential logic within a single block, driven by conditions.

```scala
val mySignal             = Bool()
val myRegister           = Reg(UInt(4 bits))
val myRegisterWithReset  = Reg(UInt(4 bits)) init(0)

mySignal := False
when(cond) {
    mySignal            := True
    myRegister          := myRegister + 1
    myRegisterWithReset := myRegisterWithReset + 1
}
```

--------------------------------

### Verilog Generation for Namespaced Scope in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Structuring/naming.rst

This is the Verilog output generated from the Scala code snippet that demonstrates the use of `Composite` for creating a namespaced scope. The Verilog module `MyComponent` correctly translates the Scala logic, including the comparator for checking if the input `value` is zero.

```verilog
module MyComponent (
  input      [7:0]    value,
  output              result
);
  wire                value_comparator;

  assign value_comparator = (value == 8'h0);
  assign result = value_comparator;

endmodule
```

--------------------------------

### SpinalHDL Signal Subdividing

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/Int.rst

Illustrates how to subdivide a signal into multiple slices or smaller bits in SpinalHDL using the `subdivideIn` method. It covers accessing slices in normal and reverse order, and assigning values to these slices.

```scala
// Subdivide
val sel = UInt(2 bits)
val myUIntWord = myUInt_128bits.subdivideIn(32 bits)(sel)
    // sel = 3 => myUIntWord = myUInt_128bits(127 downto 96)
    // sel = 2 => myUIntWord = myUInt_128bits( 95 downto 64)
    // sel = 1 => myUIntWord = myUInt_128bits( 63 downto 32)
    // sel = 0 => myUIntWord = myUInt_128bits( 31 downto  0)

 // If you want to access in reverse order you can do:
 val myVector   = myUInt_128bits.subdivideIn(32 bits).reverse
 val myRevUIntWord = myVector(sel)

 // We can also assign through subdivides
 val output8 = UInt(8 bit)
 val pieces = output8.subdivideIn(2 slices)
 // assign to output8
 pieces(0) := 0xf
 pieces(1) := 0x5
```

--------------------------------

### Simulate Dual Clock FIFO with Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Simulation/examples/dual_clock_fifo.rst

This Scala code simulates a Dual Clock FIFO (StreamFifoCC) using SpinalHDL. It sets up clock domains, manages asynchronous clock toggling, pushes random data, and verifies popped data against a mutable queue. It requires SpinalHDL libraries for compilation and simulation.

```scala
import spinal.core._
import spinal.core.sim._

import scala.collection.mutable.Queue


object SimStreamFifoCCExample {
  def main(args: Array[String]): Unit = {
    // Compile the Component for the simulator.
    val compiled = SimConfig.withWave.allOptimisation.compile(
      rtl = new StreamFifoCC(
        dataType = Bits(32 bits),
        depth = 32,
        pushClock = ClockDomain.external("clkA"),
        popClock = ClockDomain.external("clkB",withReset = false)
      )
    )

    // Run the simulation.
    compiled.doSimUntilVoid{dut =>
      val queueModel = mutable.Queue[Long]()

      // Fork a thread to manage the clock domains signals
      val clocksThread = fork {
        // Clear the clock domains' signals, to be sure the simulation captures their first edges.
        dut.pushClock.fallingEdge()
        dut.popClock.fallingEdge()
        dut.pushClock.deassertReset()
        sleep(0)

        // Do the resets.
        dut.pushClock.assertReset()
        sleep(10)
        dut.pushClock.deassertReset()
        sleep(1)

        // Forever, randomly toggle one of the clocks.
        // This will create asynchronous clocks without fixed frequencies.
        while(true) {
          if(Random.nextBoolean()) {
            dut.pushClock.clockToggle()
          } else {
            dut.popClock.clockToggle()
          }
          sleep(1)
        }
      }

      // Push data randomly, and fill the queueModel with pushed transactions.
      val pushThread = fork {
        while(true) {
          dut.io.push.valid.randomize()
          dut.io.push.payload.randomize()
          dut.pushClock.waitSampling()
          if(dut.io.push.valid.toBoolean && dut.io.push.ready.toBoolean) {
            queueModel.enqueue(dut.io.push.payload.toLong)
          }
        }
      }

      // Pop data randomly, and check that it match with the queueModel.
      val popThread = fork {
        for(i <- 0 until 100000) {
          dut.io.pop.ready.randomize()
          dut.popClock.waitSampling()
          if(dut.io.pop.valid.toBoolean && dut.io.pop.ready.toBoolean) {
            assert(dut.io.pop.payload.toLong == queueModel.dequeue())
          }
        }
        simSuccess()
      }
    }
  }
}

```

--------------------------------

### Define Pixel Solver Generics - Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Examples/Intermediates ones/fractal.rst

Defines generic construction parameters for the PixelSolver, including types for iteration count and fixed-point representation. This allows for flexible instantiation of the component with different data types.

```scala
case class PixelSolverGenerics(
    iterationType: HardType[UInt],
    fixType: HardType[SFix]
)
```

--------------------------------

### Using Composite in Bundle Utilities (Stream.queue) in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Structuring/naming.rst

Demonstrates the use of `Composite` within a `Bundle`'s function, specifically in the `Stream` class for implementing a `queue` utility. The `Composite` here helps manage the namespace for the internal `StreamFifo`. The `self` keyword within the `Composite` refers to the construction argument (`this` in the example), simplifying access to the parent bundle.

```scala
class Stream[T <: Data](val payloadType :  HardType[T]) extends Bundle {
  val valid   = Bool()
  val ready   = Bool()
  val payload = payloadType()

  def queue(size: Int): Stream[T] = new Composite(this) {
    val fifo = new StreamFifo(payloadType, size)
    fifo.io.push << self    // 'self' refers to the Composite construction argument ('this' in
                               //  the example). It avoids having to do a boring 'Stream.this'
  }.fifo.io.pop

  def m2sPipe(): Stream[T] = new Composite(this) {
    val m2sPipe = Stream(payloadType)

    val rValid = RegInit(False)
    val rData = Reg(payloadType)

    self.ready := (!m2sPipe.valid) || m2sPipe.ready

    when(self.ready) {
      rValid := self.valid
      rData := self.payload
    }

    m2sPipe.valid := rValid
    m2sPipe.payload := rData
  }.m2sPipe
}
```

--------------------------------

### SpinalHDL Counter Instantiation and Control

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/utils.rst

Shows how to instantiate and control a hardware counter using the SpinalHDL Counter tool. This includes various instantiation methods and control signals.

```Scala
val counter1 = Counter(2 to 9)
val counter2 = Counter(start = 0, end = 15)
val counter3 = Counter(stateCount = 10)
val counter4 = Counter(bitCount = 4)

counter1.clear()
counter1.increment()

val currentValue = counter1.value
val nextValue = counter1.valueNext
val willOverflow = counter1.willOverflow
val willOverflowIfInc = counter1.willOverflowIfInc

when(counter1 === 5) { ... }

val freeRunCounter = CounterFreeRun(stateCount = 100)
```

--------------------------------

### Create Quartus Project and Report Area/Frequency (Scala)

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/EDA/altera/quartus_flow.rst

Automates the creation of a new Quartus project from a single RTL file and reports its used area and maximum frequency. Requires Quartus installation and specifies paths, device family, and target frequency. The workspace folder will be removed.

```scala
val report = QuartusFlow(
   quartusPath="/eda/intelFPGA_lite/17.0/quartus/bin/",
   workspacePath="/home/spinalvm/tmp",
   toplevelPath="TopLevel.vhd",
   family="Cyclone V",
   device="5CSEMA5F31C6",
   frequencyTarget = 1 MHz
)
println(report)
```

--------------------------------

### SpinalHDL TileLink RamFiber Integration

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/Bus/tilelink/tilelink_fabric.rst

Integrates a regular TileLink RAM component by restricting supported transfers to get/put accesses and inferring RAM size from connected masters' memory mappings. It generates the hardware for the TileLink RAM.

```scala
import spinal.lib.bus.tilelink
import spinal.core.fiber.Fiber
class RamFiber() extends Area {
  val up = tilelink.fabric.Node.up()

  val thread = Fiber build new Area {
    // Here the supported parameters are function of what the master would like us to 
    // ideally support. The tilelink.Ram support all addressWidth / dataWidth / 
    // burst length / get / put accesses but doesn't support atomic / coherency.
    // So we take what is proposed to use and restrict it to all sorts of 
    // get / put request.
    up.m2s.supported load up.m2s.proposed.intersect(M2sTransfers.allGetPut)
    up.s2m.none()

    // Here we infer how many bytes our ram need to be, by looking at the memory
    // mapping of the connected masters.
    val bytes = up.ups.map(
      e => e.mapping.value.highestBound - e.mapping.value.lowerBound + 1).max.toInt
    
    // Then we finally generate the regular hardware
    val logic = new tilelink.Ram(up.bus.p.node, bytes)
    logic.io.up << up.bus
  }
}
```

--------------------------------

### Scala: Clock Enable Area Example

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Structuring/clock_domain.rst

An example of using ClockEnableArea to create a clocked area with a specific clock enable signal.

```scala
val clockedArea = new ClockEnableArea(clockEnable) {
  val reg = RegNext(io.input) init(False)
}
```

--------------------------------

### Instantiate Dual Clock Domain StreamFifoCC (Scala)

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/stream.rst

This snippet shows how to create a `StreamFifoCC` for bridging between two different clock domains. It requires specifying the data type, depth, and the respective clock domains for pushing and popping elements. This FIFO manages data transfer safely across asynchronous clock boundaries.

```scala
val clockA = ClockDomain(???) 
val clockB = ClockDomain(???) 
val streamA,streamB = Stream(Bits(8 bits))
// ...
val myFifo = StreamFifoCC(
  dataType  = Bits(8 bits),
  depth     = 128,
  pushClock = clockA,
  popClock  = clockB
)
myFifo.io.push << streamA
myFifo.io.pop  >> streamB
```

--------------------------------

### Static Encoding for SpinalEnum

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/enum.rst

This code illustrates how to define a static encoding for an enumeration, mapping specific enum elements to predefined numerical values.

```scala
object MyEnumStatic extends SpinalEnum {
  val e0, e1, e2, e3 = newElement()
  defaultEncoding = SpinalEnumEncoding("staticEncoding")(
    e0 -> 0,
    e1 -> 2,
    e2 -> 3,
    e3 -> 7)
}
```

--------------------------------

### Instantiate StreamFifo Buffer (Scala)

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/stream.rst

This code demonstrates the instantiation of a `StreamFifo` component, which acts as a buffered stream. It takes the data type and depth as mandatory parameters, allowing for optional configurations like asynchronous read, bypass, and optimization for maximum frequency. The FIFO connects input and output streams via `push` and `pop` ports.

```scala
val streamA,streamB = Stream(Bits(8 bits))
// ...
val myFifo = StreamFifo(
  dataType = Bits(8 bits),
  depth    = 128
)
myFifo.io.push << streamA
myFifo.io.pop  >> streamB
```

--------------------------------

### Fragment Helper Functions for Stream and Flow

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/fragment.rst

Provides utility functions for Stream and Flow bundles containing Fragments. These functions help determine the position of a fragment within a packet (first, last, or middle).

```SpinalHDL
x.first
x.tail
x.isFirst
x.isTail
x.isLast
```

--------------------------------

### Scala LatencyAnalysis Syntax

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/utils.rst

Provides the syntax for using LatencyAnalysis in Scala, a utility that calculates the shortest path in terms of clock cycles through a series of nodes. This is useful for analyzing timing critical paths in hardware designs.

```scala
// Example usage would typically involve calling LatencyAnalysis with a list of nodes
// val latency = LatencyAnalysis(Seq(node1, node2, node3))
```

--------------------------------

### SpinalHDL APB3 Bus Protocol Configuration and Instantiation

Source: https://context7.com/spinalhdl/spinaldoc-rtd/llms.txt

Details the configuration and instantiation of the APB3 bus protocol in SpinalHDL. It defines the `Apb3Config` case class for bus parameters and the `Apb3` bundle for signal definitions, showing how to create and connect APB3 bus instances.

```Scala
// APB3 (AMBA3 Advanced Peripheral Bus) for low-bandwidth peripherals
case class Apb3Config(
  addressWidth: Int,              // PADDR width (byte granularity)
  dataWidth: Int,                 // PWDATA/PRDATA width
  selWidth: Int = 1,              // PSEL width
  useSlaveError: Boolean = false  // Include PSLVERROR signal
)

// APB3 Bundle definition (simplified)
case class Apb3(config: Apb3Config) extends Bundle with IMasterSlave {
  val PADDR      = UInt(config.addressWidth bits)
  val PSEL       = Bits(config.selWidth bits)
  val PENABLE    = Bool()
  val PREADY     = Bool()
  val PWRITE     = Bool()
  val PWDATA     = Bits(config.dataWidth bits)
  val PRDATA     = Bits(config.dataWidth bits)
  val PSLVERROR  = if(config.useSlaveError) Bool() else null
}

// Create APB3 bus instances
val apbConfig = Apb3Config(
  addressWidth = 12,
  dataWidth    = 32
)
val apbX = Apb3(apbConfig)
val apbY = Apb3(apbConfig)

// Use APB3 signals in logic
when(apbY.PENABLE && apbY.PSEL(0)) {
  when(apbY.PWRITE) {
    // Write operation
    registerFile(apbY.PADDR) := apbY.PWDATA
  } otherwise {
    // Read operation
    apbY.PRDATA := registerFile(apbY.PADDR)
  }
  apbY.PREADY := True
}

// Connect APB3 buses with >> operator
apbX >> apbY                      // Connect X to Y (Y address can be smaller)
apbY << apbX                      // Reverse connection

```

--------------------------------

### Verilog: HDL Generation for ClockEnableArea

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Structuring/clock_domain.rst

Illustrates the Verilog HDL code generated for a ClockEnableArea, showing how the clock enable signal affects the register update logic.

```verilog
always @(posedge clk) begin
  if(clockedArea_newClockEnable) begin
    if(!resetn) begin
      clockedArea_reg <= 1'b0;
    end else begin
      clockedArea_reg <= io_input;
    end
  end
end
```

--------------------------------

### SpinalHDL Combinatorial Logic and Register Update with Condition

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Getting Started/Help for VHDL people/vhdl_perspective.rst

Shows how to define combinatorial logic and update registers based on conditions in SpinalHDL. It contrasts with VHDL's process blocks by allowing direct assignments. This example uses a `when` statement to conditionally update a combinatorial signal and a register.

```scala
val cond = Bool()
val myCombinatorial = Bool()
val myRegister = UInt(8 bits)

myCombinatorial := False
when(cond) {
  myCombinatorial := True
  myRegister = myRegister + 1
}
```

--------------------------------

### Wait for Condition in SpinalHDL Simulation

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/stream.rst

Demonstrates how to pause simulation execution in SpinalHDL until a specific condition is met. The `waitActiveEdgeWhere` function allows developers to synchronize simulation progress with DUT behavior, typically used in conjunction with a scoreboard or assertion.

```Scala
dut.clockDomain.waitActiveEdgeWhere(scoreboard.matches == 100)

```

--------------------------------

### Parameterized Conditionals with WhenBuilder in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Semantic/when_switch.rst

Provides a 'WhenBuilder' to generate parameters for 'when' conditions, offering more flexibility than the standard 'when'/'otherwise' structure. It allows for dynamic or parameterized conditional logic. Requires importing 'spinal.lib._'. Useful for parameterizing priority circuits.

```scala
import spinal.lib._

val conds = Bits(8 bits)
val result = UInt(8 bits)

val ctx = WhenBuilder()
ctx.when(conds(0)) {
  result := 0
}
ctx.when(conds(1)) {
  result := 1
}
if(true) {
  ctx.when(conds(2)) {
    result := 2
  }
}
ctx.when(conds(3)) {
  result := 3
}
```

```scala
for(i <- 5 to 7) ctx.when(conds(i)) {
  result := i
}

ctx.otherwise {
  result := 255
}
```

```scala
switch(addr) {
  for (i <- addressElements ) {
    is(i) {
      rdata :=  buffer(i)
    }
  }
}
```

--------------------------------

### SpinalHDL JTAG TAP Example

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Examples/Advanced ones/jtag.rst

An example demonstrating the creation of a JTAG TAP that allows reading switch/key inputs and writing LED outputs. It also shows how to assign a unique identifier (UID) for master recognition.

```scala
class SimpleJtagTap extends Component {
  // end SimpleJtagTap
```

--------------------------------

### Scala Object-Oriented Component Instantiation

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Getting Started/Help for VHDL people/vhdl_comp.rst

Shows the concise SpinalHDL way to instantiate a sub-component (`UnsignedDivider`) and access its I/O signals through object-oriented references, eliminating the need for explicit port mapping.

```scala
val divider = new UnsignedDivider()

// And then if you want to access IO signals of that divider:
```

--------------------------------

### Instantiate and Use AHB-Lite3 Bus in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/Bus/amba3/ahblite3.rst

This example demonstrates how to create an `AhbLite3Config` object and then instantiate AHB-Lite3 bus bundles (`ahbX` and `ahbY`) using that configuration. It also shows a basic conditional check on the `HSEL` signal.

```scala
val ahbConfig = AhbLite3Config(
  addressWidth = 12,
  dataWidth    = 32
)
val ahbX = AhbLite3(ahbConfig)
val ahbY = AhbLite3(ahbConfig)

when(ahbY.HSEL) {
  // ...
}
```

--------------------------------

### Define Parameterized Bundle and Component in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Structuring/parametrization.rst

Demonstrates how to define a parameterized Bundle and a Component that utilizes this Bundle in SpinalHDL. The width parameter is passed to the MyBus, which then defines a signal of that width. The MyComponent instantiates MyBus with the provided width.

```scala
case class MyBus(width : Int) extends Bundle {
  val mySignal = UInt(width bits)
}

case class MyComponent(width : Int) extends Component {
  val bus = MyBus(width)
}
```

--------------------------------

### Scala: Create Internal Clock Domain

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Structuring/clock_domain.rst

Defines an internal clock domain with a specified name, optional configuration, and reset/clock enable/frequency settings. The clock and reset signals will be named based on the provided name (e.g., 'myClockName_clk').

```scala
ClockDomain.internal(
  name: String,
  [config: ClockDomainConfig,]
  [withReset: Boolean,]
  [withSoftReset: Boolean,]
  [withClockEnable: Boolean,]
  [frequency: IClockDomainFrequency]
)
```

--------------------------------

### Accessing State Register After Build in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/fsm.rst

Provides a method to safely access the state machine's internal state register (`stateReg`) after the state machine has been elaborated. This is done using the `postBuild` method to avoid initialization issues during elaboration.

```scala
//  After or inside the fsm's definition.    
fsm.postBuild{
  io.status := fsm.stateReg.asBits //io.status is the signal user want to assigned to.
}
```

--------------------------------

### Build Chinese Translation Locally

Source: https://context7.com/spinalhdl/spinaldoc-rtd/llms.txt

Builds the Chinese translation of the SpinalHDL documentation by specifying the language in Sphinx options. The translation is managed via Weblate.

```bash
# Build Chinese version
make -e SPHINXOPTS="-D language='zh_CN'" html

# Chinese translation maintained via Weblate
# Published at spinalhdl-cn.github.io/SpinalDoc-RTD/zh_CN/index.html
```

--------------------------------

### SpinalHDL ClockDomain Wait Functions

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Simulation/clock.rst

Utilities for waiting for specific clock events within a ClockDomain. These functions allow pausing simulation until conditions like rising edges, falling edges, or sampling events occur, optionally with a condition or timeout. They must be called from within a thread.

--------------------------------

### Define External Clock Domain in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/miscelenea/core/core_components.rst

This example shows how to define an external clock domain, which is driven by signals from the top level of the design. It automatically connects the specified clock and reset signals to all synchronous elements within the component. A register is instantiated within the `ClockingArea` associated with this external clock domain.

```scala
class ExternalClockExample extends Component {
  val io = new Bundle {
    val result = out UInt (4 bits)
  }
  val myClockDomain = ClockDomain.external("myClockName")
  val myArea = new ClockingArea(myClockDomain) {
    val myReg = Reg(UInt(4 bits)) init(7)
    myReg := myReg + 1

    io.result := myReg
  }
}
```

--------------------------------

### Instantiate Axi4SharedSdramCtrl with SDRAM Parameters

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Legacy/pinsec/hardware_toplevel.rst

Instantiates an AXI4 Shared SDRAM controller using predefined layout and timing configurations. The controller is parameterized by AXI data and ID widths, SDRAM layout, timing grade, and CAS latency.

```scala
val sdramCtrl = Axi4SharedSdramCtrl(
  axiDataWidth = 32,
  axiIdWidth   = 4,
  layout       = IS42x320D.layout,
  timing       = IS42x320D.timingGrade7,
  CAS          = 3
)
```

--------------------------------

### Parameterized Component with Boolean in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Getting Started/Scala Guide/interaction.rst

Demonstrates correct parameterization of a SpinalHDL component using Scala's 'Boolean' type for construction parameters, contrasting it with an incorrect approach using a hardware 'Bool'. This ensures proper elaboration and avoids hierarchy violations.

```scala
// This is wrong, because you can't use a hardware Bool as construction parameter. (It will cause hierarchy violations.)
class SubComponent(activeHigh: Bool) extends Component { 
  // ...
}

// This is right, you can use all the Scala world to parameterize your hardware.
class SubComponent(activeHigh: Boolean) extends Component {
  // ...
}
```

--------------------------------

### SpinalHDL UFix Arithmetic Operators: Addition and Subtraction

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/Fix.rst

Details the addition (`+`) and subtraction (`-`) operators for SpinalHDL's `UFix` type. It specifies the resulting resolution and amplitude based on the operands' properties.

```scala
   * - x + y
     - Addition
     - Min(x.resolution, y.resolution)
     - Max(x.amplitude, y.amplitude)
   * - x - y
     - Subtraction
     - Min(x.resolution, y.resolution)
     - Max(x.amplitude, y.amplitude)
```

--------------------------------

### Define SpinalHDL Component with Internal Signals and Assignments

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Getting Started/Help for VHDL people/vhdl_perspective.rst

Presents a SpinalHDL component demonstrating internal signal definitions and assignments. It shows how signals can be declared and assigned values, including intermediate calculations, before being assigned to outputs.

```scala
case class MyComponent(offset: Int) extends Component {
  val io = new Bundle {
    val a, b, c = UInt(8 bits)
    val result  = UInt(8 bits)
  }
  val ab = UInt(8 bits)
  ab := a + b

  val abc = ab + c            // You can define a signal directly with its value
  io.result := abc + offset
}
```

--------------------------------

### SpinalHDL Process Equivalents

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Getting Started/Help for VHDL people/vhdl_comp.rst

Shows the equivalent SpinalHDL code for the VHDL processes, demonstrating a more concise syntax for signals, registers, and conditional logic using `when` blocks.

```scala
val mySignal = Bool()
val myRegister = Reg(UInt(4 bits))
val myRegisterWithReset = Reg(UInt(4 bits)) init(0)

mySignal := False
when(cond) {
  mySignal := True
  myRegister := myRegister + 1
  myRegisterWithReset := myRegisterWithReset + 1
}
```

--------------------------------

### Scala: CombInit in Helper Functions for Signal Isolation

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Semantic/assignments.rst

Illustrates using CombInit within a Scala helper function to ensure the returned signal is not a reference to an input signal, providing coherent behavior regardless of elaboration-time constants.

```scala
// note that condition is an elaboration time constant
def invertedIf(b: Bits, condition: Boolean): Bits = if(condition) { ~b } else { CombInit(b) }

val a2 = invertedIf(a1, c)

when(sel) {
   a2 := 0
}

Without "CombInit", if "c" == false (but not if "c" == true), "a1" and "a2" reference the same signal and the zero assignment is also applied to "a1".
With "CombInit" we have a coherent behavior whatever the "c" value.
```

--------------------------------

### Custom State Encoding - SpinalEnumEncoding

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/fsm.rst

Demonstrates how to override the default state encoding for a SpinalHDL state machine by using a predefined 'SpinalEnumEncoding', such as 'binaryOneHot'. This allows for specific encoding strategies.

```scala
val fsm = new StateMachine {
  setEncoding(binaryOneHot)

  ...
}
```

--------------------------------

### Instantiate SpinalHDL Component in Top Level

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Getting Started/Help for VHDL people/vhdl_perspective.rst

Shows how to instantiate a previously defined SpinalHDL component within a top-level component. It involves creating an instance of `MyComponent` and assigning values to its inputs, with the output connected to an undefined signal.

```scala
case class TopLevel extends Component {
  ...
  val mySubComponent = MyComponent(offset = 5)

  ...

  mySubComponent.io.a := 1
  mySubComponent.io.b := 2
  mySubComponent.io.c := 3
  ??? := mySubComponent.io.result

  ...
}
```

--------------------------------

### Name Non-Hardware Elements with AreaObjects in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Structuring/area.rst

Illustrates the use of `AreaObject` in SpinalHDL to provide names for non-hardware elements, such as pipelining keys. This feature helps in organizing and referencing specific data payloads within a system. The example shows how `AreaObject` can be used to define a payload like `PC` and how its name can be retrieved.

```scala
object Fetch extends AreaObject {
  val PC = Payload(UInt(64 bits))// PC.getName() will give Fetch_PC
}
```

--------------------------------

### Parameterized Counter Component in Scala

Source: https://context7.com/spinalhdl/spinaldoc-rtd/llms.txt

Implements a reusable counter component with a configurable width and a clear input. The component uses a register to store the count, increments it by default, and resets to zero when the clear signal is asserted. It also demonstrates how to generate Verilog for the component and how to instantiate and connect multiple counters in a larger design.

```scala
package spinaldoc.examples.simple

import spinal.core._
import scala.language.postfixOps

// Parametrized counter component
case class Counter(width: Int) extends Component {
  val io = new Bundle {
    val clear = in Bool()
    val value = out UInt(width bits)
  }

  // Create register initialized to 0
  val register = Reg(UInt(width bits)) init 0

  // Default behavior: increment each cycle
  register := register + 1

  // Override when clear is asserted
  when(io.clear) {
    register := 0
  }

  // Drive output
  io.value := register
}

// Generate Verilog for 8-bit counterobject Counter extends App {
  SpinalVerilog(Counter(8))
}

// Usage in larger design
class CounterUser extends Component {
  val io = new Bundle {
    val reset_counters = in Bool()
    val counter_vals = out Vec(UInt(16 bits), 4)
  }

  // Create array of counters
  val counters = Array.fill(4)(Counter(16))

  // Connect all counters
  for(i <- 0 until 4) {
    counters(i).io.clear := io.reset_counters
    io.counter_vals(i) := counters(i).io.value
  }
}

```

--------------------------------

### Scala: Allowing Assignment Override in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Design errors/assignment_overlap.rst

Shows how to intentionally override a previous signal assignment in SpinalHDL using the '.allowOverride' method. This is useful when explicit overwriting is desired and expected.

```scala
class TopLevel extends Component {
  val a = UInt(8 bits)
  a := 42
  a.allowOverride
  a := 66
}
```

--------------------------------

### SpinalHDL Timer Bridging Function

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Examples/Advanced ones/timer.rst

Implements a bridging function for the Timer component using BusSlaveFactory. This function allows abstract control of the Timer's IO from a parent component, mapping bus signals to timer controls like enabling ticks, clears, setting limits, and reading values. It handles register mapping for ticksEnable, clearsEnable, limit, and value, with a special case for a write to the 'clear' register.

```scala
def timerBusInterface(busCtrl : BusSlaveFactory, baseAddress : BigInt, ticks : Seq[Bool], clears : Seq[Bool]) = {
  // ticksEnable
  busCtrl.driveAndRead(ticks.toBitVector, name = "ticksEnable")

  // clearsEnable
  busCtrl.driveAndRead(clears.toBitVector, name = "clearsEnable")

  // limit
  busCtrl.doRWBittegrated( "limit",
    read= { reg },
    write= { (w: UInt) =>
      reg <<= 0
      w
    }
  )

  // value
  busCtrl.readOnly(value, name = "value")

  // clear
  busCtrl.writeOnlySignal(clear, name = "clear")
}
```

--------------------------------

### SpinalHDL Vec Helper Function: Shuffle

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/Vec.rst

Demonstrates the shuffle function for SpinalHDL Vecs, which rearranges the elements of a vector based on a provided index mapping function. Requires importing spinal.lib._.

```scala
    import spinal.lib._

    // Create a vector with 4 unsigned integers
    val vec1 = Vec.fill(4)(UInt(8 bits))

    // ... the vector is actually assigned somewhere

    val shuffledVec = vec1.shuffle(i => (vec1.size - 1 - i)) // Reverse the vector
```

--------------------------------

### Demonstrate Simple JTAG TAP Creation in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Examples/Advanced ones/jtag.rst

This Scala code demonstrates the creation of a simple application-specific JTAG TAP using SpinalHDL. It showcases how the previously defined instructions and wrappers can be combined to form a complete JTAG TAP without extensive manual logic or interconnection coding. This example highlights the ease of generating hardware with SpinalHDL.

```scala
class SimpleJtagTap extends Component {

  val io = new Bundle {
    val tap = master(JtagTap())
  }

  // create a JTAG TAP using the JtagTapAccess trait
  // and the previously defined instructions
  val tapAccess = new JtagTapAccess {
    override def tap(): JtagTap = io.tap

    // create an idcode instruction
    val idcodeInstruction = idcode(0x12345678 bits)(0x01 bits)

    // create a write instruction
    val writeInstruction = write()

    // create a read instruction
    val readInstruction = read()
  }
}
```

--------------------------------

### SBT Configuration for SpinalSim

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Simulation/install/index.rst

Enables simulation by forking SBT. This configuration is essential for running SpinalHDL simulations.

```scala
fork := true
```

--------------------------------

### Manual tristate driver implementation - SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Other language features/analog_inout.rst

Provides an example of manually implementing a tristate driver for an Analog bundle when InOutWrapper cannot be used. It demonstrates how to conditionally drive the analog signal based on a write enable signal from a TriState bundle.

```scala
case class Example extends Component {
  val io = new Bundle {
    val tri = slave(TriState(Bits(16 bits)))
    val analog = inout(Analog(Bits(16 bits)))
  }
  io.tri.read := io.analog
  when(io.tri.writeEnable) { io.analog := io.tri.write }
}
```

--------------------------------

### State Delay Implementation in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/fsm.rst

Shows how to create a state that waits for a specified number of cycles before executing its completion logic. This is useful for implementing timed actions or sequences.

```scala
val stateG : State = new StateDelay(cyclesCount=40) {
  whenCompleted {
    goto(stateH)
  }
}
```

```scala
val stateG : State = new StateDelay(40) { whenCompleted(goto(stateH)) }
```

--------------------------------

### SpinalHDL APB3 Timer Usage Example

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Examples/Advanced ones/timer.rst

Demonstrates the usage of the Timer component within a SpinalHDL design, specifically integrating it with an APB3 bus. This example instantiates a prescaler, a 32-bit timer, and three 16-bit timers, then uses an Apb3SlaveFactory to create bridging logic between the APB3 bus and these timer components.

```scala
case class ApbTimer() extends Component {
  val apb = bridgeIn(new Apb3(Apb3Config(10 bits, 32 bits)))
  val timerA = Timer(16)
  val timerB = Timer(32)
  val timerC = Timer(16)
  val timerD = Timer(16)

  val factory = new Apb3SlaveFactory(apb)

  factory.drive(timerA.limit)
  factory.drive(timerB.limit)
  factory.drive(timerC.limit)
  factory.drive(timerD.limit)

  factory.read(timerA.value, name = "timerA_value")
  factory.read(timerB.value, name = "timerB_value")
  factory.read(timerC.value, name = "timerC_value")
  factory.read(timerD.value, name = "timerD_value")

  factory.read(timerA.full, name = "timerA_full")
  factory.read(timerB.full, name = "timerB_full")
  factory.read(timerC.full, name = "timerC_full")
  factory.read(timerD.full, name = "timerD_full")

  timerA.tick := Timer.tick
  timerA.clear := Timer.clear
  timerB.tick := Timer.tick
  timerB.clear := Timer.clear
  timerC.tick := Timer.tick
  timerC.clear := Timer.clear
  timerD.tick := Timer.tick
  timerD.clear := Timer.clear

  val prescaler = Prescaler(16 bits)
  prescaler.clk := Timer.tick
  prescaler.reset := Timer.clear

  timerA.tick := prescaler.io.count(4 bits)
  timerB.tick := prescaler.io.count(8 bits)
  timerC.tick := prescaler.io.count(12 bits)
  timerD.tick := prescaler.io.count(16 bits)
}
```

--------------------------------

### Define UART Controller Generics in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Examples/Intermediates ones/uart.rst

Defines a case class to group construction parameters for the UartCtrl, simplifying its instantiation. Parameters include data width, clock divider bits, and sampling window configuration.

```scala
case class UartCtrlGenerics(
    dataWidthMax      : Int,
    clockDividerWidth : Int,
    preSamplingSize   : Int,
    samplingSize      : Int,
    postSamplingSize  : Int
) extends BaseObject
```

--------------------------------

### Set Register Value Conditionally in Scala (SpinalHDL)

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Semantic/rules.rst

Demonstrates how to conditionally assign a value to a hardware register using a Scala function within the SpinalHDL framework. This function is equivalent to inlining the logic in generated RTL.

```scala
val inc, clear = Bool()
val counter = Reg(UInt(8 bits))

def setSomethingWhen(something : UInt, cond : Bool, value : UInt): Unit = {
  when(cond) {
    something := value
  }
}

setSomethingWhen(something = counter, cond = inc,   value = counter + 1)
setSomethingWhen(something = counter, cond = clear, value = 0)
```

--------------------------------

### Formal Verification of LimitedCounter DUT

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Formal verification/index.rst

Demonstrates formal verification for a LimitedCounter component. It sets up assertions to ensure the counter's value stays within a defined range [2:10] and checks for proper reset initialization. The verification uses Bounded Model Checking (BMC) up to a depth of 15 cycles.

```scala
import spinal.core._

// Here is our DUT
class LimitedCounter extends Component {
  // The value register will always be between [2:10]
  val value = Reg(UInt(4 bits)) init(2)
  when(value < 10) {
    value := value + 1
  }
}

object LimitedCounterFormal extends App {
  // import utilities to run the formal verification, but also some utilities to describe formal stuff
  import spinal.core.formal._

  // Here we run a formal verification which will explore the state space up to 15 cycles to find an assertion failure
  FormalConfig.withBMC(15).doVerify(new Component {
    // Instantiate our LimitedCounter DUT as a FormalDut, which ensure that all the outputs of the dut are:
    // - directly and indirectly driven (no latch / no floating signal)
    // - allows the current toplevel to read every signal across the hierarchy
    val dut = FormalDut(new LimitedCounter())

    // Ensure that the state space start with a proper reset
    assumeInitial(ClockDomain.current.isResetActive)

    // Check a few things
    assert(dut.value >= 2)
    assert(dut.value <= 10)
  })
}
```

--------------------------------

### Define Hardware Logic with Areas in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Structuring/area.rst

Demonstrates how to use the `Area` construct in SpinalHDL to group related signals and logic within a Component. This helps in organizing code and avoids verbosity when defining simple logic blocks like timers or state machines. It shows how different areas can refer to signals defined in other areas.

```scala
class UartCtrl extends Component {
  ...
  val timer = new Area {
    val counter = Reg(UInt(8 bits))
    val tick = counter === 0
    counter := counter - 1
    when(tick) {
      counter := 100
    }
  }

  val tickCounter = new Area {
    val value = Reg(UInt(3 bits))
    val reset = False
    when(timer.tick) {          // Refer to the tick from timer area
      value := value + 1
    }
    when(reset) {
      value := 0
    }
  }

  val stateMachine = new Area {
    ...
  }
}
```

--------------------------------

### SpinalHDL Register Initialization and Update

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Getting Started/Help for VHDL people/vhdl_perspective.rst

Demonstrates the explicit declaration and initialization of registers in SpinalHDL using `Reg` and `init`. The example shows a counter register that increments on each clock cycle and is initialized to zero upon reset.

```scala
val counter = Reg(UInt(8 bits))  init(0)  
counter := counter + 1   // Count up each cycle

// init(0) means that the register should be initialized to zero when a reset occurs
```

--------------------------------

### Configure Clock Domain with ClockDomainConfig in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Structuring/clock_domain.rst

Demonstrates how to customize a clock domain's behavior using `ClockDomainConfig`. This includes setting the clock edge, reset kind, and active levels for reset and clock enable signals.

```scala
class CustomClockExample extends Component {
  val io = new Bundle {
    val clk    = in Bool()
    val resetn = in Bool()
    val result = out UInt (4 bits)
  }

  // Configure the clock domain
  val myClockDomain = ClockDomain(
    clock  = io.clk,
    reset  = io.resetn,
    config = ClockDomainConfig(
      clockEdge        = RISING,
      resetKind        = ASYNC,
      resetActiveLevel = LOW
    )
  )

  // Define an Area which use myClockDomain
  val myArea = new ClockingArea(myClockDomain) {
    val myReg = Reg(UInt(4 bits)) init(7)

    myReg := myReg + 1

    io.result := myReg
  }
}
```

--------------------------------

### Compare two SpinalHDL Bundles for equality

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/bundle.rst

This example shows how to compare two instances of a SpinalHDL Bundle for equality using the `===` operator. The comparison checks if all corresponding elements within the bundles are equal. This is useful for verifying state or data integrity.

```scala
case class Color(channelWidth: Int) extends Bundle {
  val r, g, b = UInt(channelWidth bits)
}

val color1 = Color(8)
color1.r := 0
color1.g := 0
color1.b := 0

val color2 = Color(8)
color2.r := 0
color2.g := 0
color2.b := 0

val myBool := color1 === color2 // Compare all elements of the bundle
// is equivalent to:
// myBool := color1.r === color2.r && color1.g === color2.g && color1.b === color2.b
```

--------------------------------

### SpinalHDL APB3 Bus Definition

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Foreword/index.rst

This SpinalHDL code defines a configurable APB3 bus interface using case classes. It demonstrates how SpinalHDL handles parameterized bundles and optional signals, overcoming limitations found in VHDL records and Verilog structs for defining interfaces.

```scala
// Class which can be instantiated to represent a given APB3 configuration
case class Apb3Config(
  addressWidth  : Int,
  dataWidth     : Int,
  selWidth      : Int     = 1,
  useSlaveError : Boolean = true
)

// Class which can be instantiated to represent a given hardware APB3 bus
case class Apb3(config: Apb3Config) extends Bundle with IMasterSlave {
  val PADDR      = UInt(config.addressWidth bits)
  val PSEL       = Bits(config.selWidth bits)
  val PENABLE    = Bool()
  val PREADY     = Bool()
  val PWRITE     = Bool()
  val PWDATA     = Bits(config.dataWidth bits)
  val PRDATA     = Bits(config.dataWidth bits)
  val PSLVERROR  = if(config.useSlaveError) Bool() else null  // Optional signal

  // Can be used to setup a given APB3 bus into a master interface of the host component
```

--------------------------------

### Declare a SpinalHDL Bundle with parameters (Color example)

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/bundle.rst

This example demonstrates declaring a SpinalHDL Bundle with parameters. The `Color` bundle takes a `channelWidth` and defines three `UInt` signals (r, g, b) with that width, suitable for representing color data.

```scala
case class Color(channelWidth: Int) extends Bundle {
  val r, g, b = UInt(channelWidth bits)
}
```

--------------------------------

### Report Pruned Signals in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Structuring/components_hierarchy.rst

Illustrates how to identify and report unused signals within a SpinalHDL component during RTL generation. This helps in optimizing the design by removing unnecessary logic. The example uses 'SpinalVhdl' to generate VHDL and then calls 'printPruned()' to display warnings about unused signals.

```scala
class TopLevel extends Component {
  val io = new Bundle {
    val a,b = in port UInt(8 bits)
    val result = out port UInt(8 bits)
  }

  io.result := io.a + io.b

  val unusedSignal = UInt(8 bits)
  val unusedSignal2 = UInt(8 bits)

  unusedSignal2 := unusedSignal
}

object Main {
  def main(args: Array[String]) {
    SpinalVhdl(new TopLevel).printPruned()
    // This will report :
    //  [Warning] Unused signal detected : toplevel/unusedSignal : UInt[8 bits]
    //  [Warning] Unused signal detected : toplevel/unusedSignal2 : UInt[8 bits]
  }
}
```

--------------------------------

### Verilog Output for Namespaced Signals using Areas

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Structuring/naming.rst

Presents the Verilog code generated from a SpinalHDL component that utilizes `Area` for namespacing. This clearly shows how the `logicA` area prefix is applied to the `toggle` register name in the resulting Verilog module.

```verilog
module MyComponent (
  input               clk,
  input               reset
);
  reg                 logicA_toggle;
  always @ (posedge clk) begin
    logicA_toggle <= (! logicA_toggle);
  end
endmodule

```

--------------------------------

### Dual Lock-step Waveform Capture Example in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Simulation/bootstraps.rst

This snippet utilizes the `DualSimTracer` utility to perform a dual lock-step simulation, capturing waveforms from a delayed simulation that starts recording once the leading simulation encounters a failure. It requires parameters for the compiled hardware, the capture window duration, and a random seed. The output includes log files and a waveform file (`.fst`).

```scala
/*
 This code is a placeholder for the actual literalinclude content.
 The actual example is located at: /../examples/src/main/scala/spinaldoc/libraries/sim/DualSimExample.scala
*/
// Example content from literalinclude directive:
// import spinal.core._
// import spinal.lib.sim._
// import java.io._
// 
// object DualSimExample extends App {
//   val compiled = SimConfig.withWave.compile(new SimTop)
//   val simTime = 100000
//   val window = 10000
//   val seed = 42
// 
//   compiled.doSim(timeout=simTime) {
//     dut =>
//       val tracer = new DualSimTracer(compiled, dut.clockDomain, window, seed)
//       // ... simulation logic ...
//       tracer.stop()
//   }
// }
```

--------------------------------

### SpinalHDL Component Internal Logic

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Introduction/A simple example.rst

This snippet demonstrates the internal logic of a SpinalHDL component, featuring a register, conditional logic, and output assignments.

```scala
val counter = Reg(UInt(8 bits)) init 0

when(io.cond0) {
  counter := counter + 1
}

io.state := counter
io.flag  := (counter === 0) | io.cond1
```

--------------------------------

### Handle NullPointerException in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/miscelenea/frequent_errors.rst

Addresses NullPointerException errors that occur when using SpinalHDL, stemming from Scala's variable instantiation rules. It emphasizes that SpinalHDL executes as a Scala program, requiring variables to be instantiated before use.

```scala
val a = b + 1         // b can't be read at that time, because b isn't instantiated yet
val b = UInt(4 bits)
```

--------------------------------

### SpinalHDL Component with Conditional Logic to Verilog

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Structuring/naming.rst

Demonstrates a SpinalHDL component that uses conditional logic (`when`) to modify an output signal and increment a counter. The generated Verilog module reflects this logic.

```spinalhdl
class MyComponent extends Component {
    val value = in UInt(8 bits)
    val isZero = out(Bool())
    val counter = out(Reg(UInt(8 bits)))

    isZero := False
    when(value === 0) { // At line 117
      isZero := True
      counter := counter + 1
    }
  }
```

```verilog
module MyComponent (
  input      [7:0]    value,
  output reg          isZero,
  output reg [7:0]    counter,
  input               clk,
  input               reset
);
  wire                when_Test_l117;

  always @ (*) begin
    isZero = 1'b0;
    if(when_Test_l117)begin
      isZero = 1'b1;
    end
  end

  assign when_Test_l117 = (value == 8'h0);
  always @ (posedge clk) begin
    if(when_Test_l117)begin
      counter <= (counter + 8'h01);
    end
  end
endmodule
```

--------------------------------

### Scala: Default ClockDomain Configuration

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Structuring/clock_domain.rst

Defines a default ClockDomain configuration with specific clock edge, reset kind, and reset active level.

```scala
val defaultCC = ClockDomainConfig(
  clockEdge        = RISING,
  resetKind        = ASYNC,
  resetActiveLevel = HIGH
)
```

--------------------------------

### Add Additional Clock Enable to Area in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Structuring/clock_domain.rst

Demonstrates how to introduce an additional clock enable signal to a specific area within the current clock domain using ClockEnableArea. This allows for finer control over when logic within that area is active, complementing the primary clock enable.

```scala
class TopLevel extends Component {

  val clockEnable = Bool()

  // Add a clock enable for this area 
  val area_1 = new ClockEnableArea(clockEnable) {
    val counter = out(CounterFreeRun(16).value)
  }
}
```

--------------------------------

### Create Color Summing Component (Scala)

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Examples/Simple ones/color_summing.rst

Defines a SpinalHDL component `ColorSumming` that takes a vector of `Color` objects as input (`sources`) and outputs their sum. The `sources` input is expected to be an array or vector of `Color` bundles. The component iterates through the `sources` and accumulates their sum into a single `Color` output named `result`. This is a common pattern for aggregating multiple input signals in hardware design.

```scala
case class ColorSumming(
    id: Int,
    sources: Vec[Color]
) extends Component {
  val result = in(Color(1 bits, 1 bits, 1 bits))

  result := sources.reduce(_ + _)
}
```

--------------------------------

### SpinalHDL: Disabling Reset for Assertions

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Formal verification/index.rst

This Scala code demonstrates how to keep an assertion enabled even during reset in SpinalHDL's formal verification. By using `ClockDomain.current.withoutReset()`, any assertions within this block will not be disabled when the reset signal is active.

```scala
ClockDomain.current.withoutReset() {
  assert(wuff === 0)
}
```

--------------------------------

### Scala: Create External Clock Domain

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Structuring/clock_domain.rst

Defines an external clock domain, which will automatically add clock and reset wires from the top level. The arguments are the same as for ClockDomain.internal.

```scala
ClockDomain.external(
  name: String,
  [config: ClockDomainConfig,]
  [withReset: Boolean,]
  [withSoftReset: Boolean,]
  [withClockEnable: Boolean,]
  [frequency: IClockDomainFrequency]
)
```

--------------------------------

### SpinalHDL Anonymous Signal Naming to Verilog

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Structuring/naming.rst

Illustrates SpinalHDL's 'last resort' naming strategy for anonymous signals. When a register is unnamed, SpinalHDL attempts to find a named signal driven by it to use as a postfix. The Verilog output shows this generated name (`_zz_value`).

```spinalhdl
class MyComponent extends Component {
    val enable = in Bool()
    val value = out UInt(8 bits)

    def count(cond : Bool): UInt = {
      val ret = Reg(UInt(8 bits)) // This register is not named (on purpose for the example)
      when(cond) {
        ret := ret + 1
      }
      return ret
    }

    value := count(enable)
  }
```

```verilog
module MyComponent (
  input               enable,
  output     [7:0]    value,
  input               clk,
  input               reset
);
  // Name given to the register in last resort by looking what was driven by it
  reg        [7:0]    _zz_value;

  assign value = _zz_value;
  always @ (posedge clk) begin
    if(enable)begin
      _zz_value <= (_zz_value + 8'h01);
    end
  end
endmodule
```

--------------------------------

### Define SDRAM Layout and Timings for IS42x320D

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Legacy/pinsec/hardware_toplevel.rst

Defines the specific layout and timing parameters for an IS42x320D SDRAM device. This includes bank, column, row, and data widths for the layout, and various timing constants like tREF, tRC, and tRAS for the timings.

```scala
object IS42x320D {
  def layout = SdramLayout(
    bankWidth   = 2,
    columnWidth = 10,
    rowWidth    = 13,
    dataWidth   = 16
  )

  def timingGrade7 = SdramTimings(
    bootRefreshCount =   8,
    tPOW             = 100 us,
    tREF             =  64 ms,
    tRC              =  60 ns,
    tRFC             =  60 ns,
    tRAS             =  37 ns,
    tRP              =  15 ns,
    tRCD             =  15 ns,
    cMRD             =   2,
    tWR              =  10 ns,
    cWR              =   1
  )
}
```

--------------------------------

### Instantiate Axi4SharedToApb3Bridge

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Legacy/pinsec/hardware_toplevel.rst

This snippet shows the instantiation of an Axi4SharedToApb3Bridge, which is used to convert AXI4 master signals to APB3 slave signals. It configures the address width, data width, and ID width for the bridge.

```scala
val apbBridge = Axi4SharedToApb3Bridge(
  addressWidth = 20,
  dataWidth    = 32,
  idWidth      = 4
)
```

--------------------------------

### Conditional Assignment with when/elsewhen/otherwise in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Semantic/when_switch.rst

Implements conditional signal assignments similar to VHDL and Verilog. The 'when' construct executes code blocks based on boolean conditions, with 'elsewhen' for additional conditions and 'otherwise' as a fallback. Dependencies include standard Scala and SpinalHDL libraries. No specific inputs/outputs are defined, as it's a control flow structure. Limitation: requires a clear condition for each block.

```scala
when(cond1) {
  // Execute when cond1 is true
} elsewhen(cond2) {
  // Execute when (not cond1) and cond2
} otherwise {
  // Execute when (not cond1) and (not cond2)
}
```

```scala
when(cond1) {
    // Execute when cond1 is true
} otherwise {
    // Execute when (not cond1) and (not cond2)
}
```

```scala
when(cond1) {
    // Execute when cond1 is true
}
.otherwise {
    // Execute when (not cond1) and (not cond2)
}
```

--------------------------------

### Clone Local SpinalHDL Repository

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Developers area/howotuselocalspinalclone.rst

This command clones the SpinalHDL repository from GitHub. It uses `--depth 1` to fetch only the latest commit and specifies the 'dev' branch. The target directory can be adjusted as needed.

```sh
cd /somewhere
git clone --depth 1 -b dev https://github.com/SpinalHDL/SpinalHDL.git
```

--------------------------------

### Define RgbConfig and Rgb Bundle in Scala for Hardware Colors

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/Graphics/colors.rst

Defines the RgbConfig case class to specify bit widths for Red, Green, and Blue channels and the Rgb bundle which utilizes this configuration to represent color components in hardware. These are essential for creating hardware color representations.

```scala
case class RgbConfig(rWidth : Int,gWidth : Int,bWidth : Int) {
  def getWidth = rWidth + gWidth + bWidth
}

case class Rgb(c: RgbConfig) extends Bundle {
  val r = UInt(c.rWidth bits)
  val g = UInt(c.gWidth bits)
  val b = UInt(c.bWidth bits)
}
```

--------------------------------

### SpinalHDL Area for Logic Definition

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/miscelenea/core/core_components.rst

Demonstrates the use of 'Area' in SpinalHDL as a lightweight alternative to Components for defining logic. It shows how to reference signals and logic from different Areas.

```scala
   class UartCtrl extends Component {
     ...
     val timer = new Area {
       val counter = Reg(UInt(8 bits))
       val tick = counter === 0
       counter := counter - 1
       when(tick) {
         counter := 100
       }
     }
     val tickCounter = new Area {
       val value = Reg(UInt(3 bits))
       val reset = False
       when(timer.tick) {          // Refer to the tick from timer area
         value := value + 1
       }
       when(reset) {
         value := 0
       }
     }
   }
```

--------------------------------

### System Level Interrupt Merge using SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/regIf.rst

This SpinalHDL code demonstrates the usage of interruptLevelFactory for merging system-level interrupts. It configures MASK and STATUS registers for level-based interrupts, suitable for consolidating interrupt signals from various sources.

```scala
busif.interruptLevelFactory("T", sys_int0, sys_int1)
```

--------------------------------

### Instantiate JtagAxi4SharedDebugger

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Legacy/pinsec/hardware_toplevel.rst

Instantiates a JTAG controller for debugging the CPU from a PC, allowing memory access and debugging operations. It requires a SystemDebuggerConfig specifying memory address/data widths and JTAG clock domain.

```scala
val jtagCtrl = JtagAxi4SharedDebugger(SystemDebuggerConfig(
  memAddressWidth = 32,
  memDataWidth    = 32,
  remoteCmdWidth  = 1,
  jtagClockDomain = jtagClockDomain
))
```

--------------------------------

### SpinalHDL Signal Resizing

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Getting Started/Help for VHDL people/vhdl_comp.rst

Shows two methods for resizing signals in SpinalHDL: the traditional `.resize()` method and the more concise `.resized` attribute. These offer flexibility in managing bit-widths.

```scala
// The traditional way
my8BitsSignal := my4BitsSignal.resize(8)

// The smart way
my8BitsSignal := my4BitsSignal.resized
```

--------------------------------

### SpinalHDL: NullPointerException due to incorrect initialization

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Design errors/nullpointerexception.rst

This Scala code snippet demonstrates a NullPointerException that occurs when assigning a value to a variable before it is declared and initialized. The fix involves declaring and initializing the variable before its first use.

```scala
class TopLevel extends Component {
  a := 42
  val a = UInt(8 bits)
}
```

```scala
class TopLevel extends Component {
  val a = UInt(8 bits)
  a := 42
}
```

--------------------------------

### SpinalHDL fixTo Function for Fixpoint Conversion

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/Int.rst

Shows how to use the fixTo function in SpinalHDL for converting fixed-point numbers. This function simplifies the process by automatically handling carry bit alignment and bit width calculations, with options for rounding type and symmetry.

```scala
val a  = SInt(16 bits)
val b  = a.fixTo(10 downto 3) // default RoundType.ROUNDTOINF, sym = false
val b  = a.fixTo( 8 downto 0, RoundType.ROUNDUP)
```

--------------------------------

### UartCtrl Initialization Configuration (Scala)

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Examples/Intermediates ones/uart.rst

Defines a case class for initializing UartCtrl with fixed settings and a companion object providing factory methods for common UART configurations. This simplifies instantiation for standard baud rates and frame formats.

```scala
case class UartCtrlInitConfig(
    val clockFrequency: HertzNumber,
    val baudRate: BaudRate,
    val frame: UartCtrlFrameConfig = UartCtrlFrameConfig(dataWidthMax = 8, parity = None, stop.two)
) {
  def txGenerics = UartCtrlGenerics(dataWidthMax = frame.dataWidthMax)
  def rxGenerics = UartCtrlGenerics(dataWidthMax = frame.dataWidthMax)
}

object UartCtrl {
  def apply(
      clockFrequency: HertzNumber,
      baudRate: BaudRate,
      frame: UartCtrlFrameConfig = UartCtrlFrameConfig(dataWidthMax = 8, parity = None, stop.two)
  ): UartCtrl = {
    new UartCtrl(UartCtrlInitConfig(clockFrequency, baudRate, frame))
  }

  def apply(
      clockFrequency: HertzNumber,
      baudRate: BaudRate,
      dataWidth: Int,
      parity: Parity = None,
      stop: Stop = stop.one
  ): UartCtrl = {
    new UartCtrl(UartCtrlInitConfig(clockFrequency, baudRate, UartCtrlFrameConfig(dataWidthMax = dataWidth, parity = parity, stop = stop)))
  }
}
```

--------------------------------

### SpinalHDL Function with Mixed Logic

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Getting Started/Help for VHDL people/vhdl_comp.rst

Presents a SpinalHDL function example that combines combinational logic and register updates within a single function definition. This showcases SpinalHDL's flexibility in handling complex logic within functions.

```scala
def simpleAluPipeline(op: Bits, a: UInt, b: UInt): UInt = {
  val result = UInt(8 bits)

  switch(op) {

```

--------------------------------

### Instantiate PinsecTimerCtrl

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Legacy/pinsec/hardware_toplevel.rst

Instantiates the Pinsec Timer Controller component. This controller integrates a prescaler, a 32-bit timer, and three 16-bit timers, providing versatile timing functionalities.

```scala
val timerCtrl = PinsecTimerCtrl()
```

--------------------------------

### SpinalHDL Type Casting Operations

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/Int.rst

Shows various type casting operations in SpinalHDL, such as converting between Bits, UInt, SInt, and Bool types. It includes examples for casting to Bits, UInt, SInt, and an array of Bools, as well as specific methods for signed integer absolute values and two's complement.

```scala
// Cast an SInt to Bits
val myBits = mySInt.asBits

// Create a Vector of Bool
val myVec = myUInt.asBools

// Cast a Bits to SInt
val mySInt = S(myBits)

// UInt to SInt conversion
val uInt_30 = U(30, 8 bit)

val sInt_30 = uint_30.intoSInt
assert(sInt_30 === S(30, 9 bit))

mySInt := uInt_30.twoComplement(booleanDoInvert)
    // if booleanDoInvert is True then we get S(-30, 9 bit)
    // otherwise we get S(30, 9 bit)

// absolute values
val sInt_n_4 = S(-3, 3 bit)
val abs_en = sInt_n_3.abs(booleanDoAbs)
    // if booleanDoAbs is True we get U(3, 3 bit)
    // otherwise we get U"3'b101" or U(5, 3 bit) (raw bit pattern of -3)

val sInt_n_128 = S(-128, 8 bit)
val abs = sInt_n_128.abs
assert(abs === U(128, 8 bit))
val sym_abs = sInt_n_128.absWithSym
assert(sym_abs === U(127, 7 bit))
```

--------------------------------

### SpinalHDL: Error - Directionless Signal in IO Bundle

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Design errors/iobundle.rst

Illustrates the compilation error generated by SpinalHDL when a directionless signal is incorrectly defined within an IO bundle.

```text
IO BUNDLE ERROR : A direction less (toplevel/io_a :  UInt[8 bits]) signal was defined into toplevel component's io bundle
  ***
  Source file location of the toplevel/io_a definition via the stack trace
  ***
```

--------------------------------

### Scala Timeout Instantiation and Usage

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/utils.rst

Demonstrates how to instantiate and use the Timeout utility in Scala, which allows for triggering actions after a specified duration or number of clock cycles. It shows checking the timeout flag and clearing it.

```scala
val timeout = Timeout(10 ms)  // Timeout who tick after 10 ms
when(timeout) {               // Check if the timeout has tick
    timeout.clear()           // Ask the timeout to clear its flag
}
```

--------------------------------

### Test Identity Component with Scala Simulation

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Simulation/bootstraps.rst

A Scala testbench for the 'Identity' component using SpinalHDL's simulation framework. It configures the simulation with wave capture enabled and iterates through all possible input values to verify the component's functionality.

```scala
import spinal.core.sim._

object TestIdentity extends App {
  // Use the component with n = 3 bits as "dut" (device under test)
  SimConfig.withWave.compile(new Identity(3)).doSim{
    dut =>
      // For each number from 3'b000 to 3'b111 included
      for (a <- 0 to 7) {
        // Apply input
        dut.io.a #= a
        // Wait for a simulation time unit
        sleep(1)
        // Read output
        val z = dut.io.z.toInt
        // Check result
        assert(z == a, s"Got $z, expected $a")
      }
  }
}
```

--------------------------------

### Verilog Generation for Component with Chained Stream Utilities

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Structuring/naming.rst

The Verilog output generated for `MyComponent`, which uses chained `Stream` utilities (`queue` and `m2sPipe`) implemented with `Composite`. This Verilog code shows the instantiated `StreamFifo` and the logic for the m2s pipeline stage, reflecting the combined functionalities.

```verilog
module MyComponent (
  input               source_valid,
  output              source_ready,
  input      [7:0]    source_payload,
  output              sink_valid,
  input               sink_ready,
  output     [7:0]    sink_payload,
  input               clk,
  input               reset
);
  wire                source_fifo_io_pop_ready;
  wire                source_fifo_io_push_ready;
  wire                source_fifo_io_pop_valid;
  wire       [7:0]    source_fifo_io_pop_payload;
  wire       [4:0]    source_fifo_io_occupancy;
  wire       [4:0]    source_fifo_io_availability;
  wire                source_fifo_io_pop_m2sPipe_valid;
  wire                source_fifo_io_pop_m2sPipe_ready;
  wire       [7:0]    source_fifo_io_pop_m2sPipe_payload;
  reg                 source_fifo_io_pop_rValid;
  reg        [7:0]    source_fifo_io_pop_rData;

  StreamFifo source_fifo (
    .io_push_valid      (source_valid                 ), //i
    .io_push_ready      (source_fifo_io_push_ready    ), //o
    .io_push_payload    (source_payload               ), //i
    .io_pop_valid       (source_fifo_io_pop_valid     ), //o
    .io_pop_ready       (source_fifo_io_pop_ready     ), //i
    .io_pop_payload     (source_fifo_io_pop_payload   ), //o
    .io_flush           (1'b0                         ), //i
    .io_occupancy       (source_fifo_io_occupancy     ), //o
    .io_availability    (source_fifo_io_availability  ), //o
    .clk                (clk                          ), //i
    .reset              (reset                        )  //i
  );
  assign source_ready = source_fifo_io_push_ready;

```

--------------------------------

### SpinalHDL Stream FIFO Component Example

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/stream.rst

Example of a Stream FIFO component in SpinalHDL. It demonstrates the basic structure of a component utilizing the Stream interface for push and pop operations.

```scala
class StreamFifo[T <: Data](dataType: T, depth: Int) extends Component {
  val io = new Bundle {
    val push = slave Stream (dataType)
    val pop = master Stream (dataType)
  }
  ...
}
```

--------------------------------

### Verilog Attribute Declaration for Synthesis

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Other language features/vhdl_generation.rst

Illustrates the Verilog code generated for a 'keep' attribute on a signal. This syntax ensures that the signal 'pcPlus4' is not optimized away during synthesis. It's a common way to preserve signals for debugging or specific design requirements.

```verilog
(* keep *) wire [31:0] pcPlus4;
```

--------------------------------

### Create Register Vectors (Scala)

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Sequential logic/registers.rst

Shows how to create vectors of registers using `Vec`. Two examples are provided: one for a fixed-size vector of UInt registers and another for a vector of Bool registers using `Vec.fill`.

```scala
   val vecReg1 = Vec(Reg(UInt(8 bits)), 4)
   val vecReg2 = Vec.fill(8)(Reg(Bool()))
```

--------------------------------

### Define Nested VGA Bundle Using RGB in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Developers area/types.rst

Illustrates how to create a nested Bundle named VGA that incorporates the previously defined RGB Bundle. This demonstrates hierarchical data structure definition.

```scala
case class VGA(channelWidth : Int) extends Bundle {
  val hsync = Bool()
  val vsync = Bool()
  val color = RGB(channelWidth)
}
```

--------------------------------

### SpinalHDL Area for Component Organization

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Getting Started/Help for VHDL people/vhdl_comp.rst

Demonstrates the use of `Area` in SpinalHDL for structuring internal logic within a component. This allows for logical grouping of signals and registers, making them accessible from other areas.

```scala
val timeout = new Area {
  val counter = Reg(UInt(8 bits)) init(0)
  val overflow = False
  when(counter =/= 100) {
    counter := counter + 1
  } otherwise {
    overflow := True
  }
}

val core = new Area {
  when(timeout.overflow) {
    timeout.counter := 0
  }
}
```

--------------------------------

### Endpoint Configuration

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/Com/usb_device.rst

This section details the configuration registers for a USB endpoint, including flags for NACK, data phase, head pointer, and maximum packet size.

```APIDOC
## Endpoint Configuration Registers

### Description
These registers control the behavior and configuration of a USB endpoint.

### Method
Not Applicable (Register Access)

### Endpoint
N/A

### Parameters
#### Register Fields
- **nack** (RW, 2 bits) - If set, the endpoint will always return NACK status.
- **dataPhase** (RW, 3 bits) - Specify the IN/OUT data PID used. '0' => DATA0. This field is also updated by the controller.
- **head** (RW, 15-4 bits) - Specify the current descriptor head (linked list). 0 => empty list, byte address = this << 4.
- **isochronous** (RW, 16 bits) - Isochronous mode flag.
- **maxPacketSize** (RW, 31-22 bits) - Maximum packet size for the endpoint.

### Request Example
(Register read/write operations)

### Response
(Register values)

#### Success Response (200)
N/A

#### Response Example
(Register values)
```

--------------------------------

### Embedded Formal Assertions in DUT

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Formal verification/index.rst

Shows how to embed formal verification assertions directly within the DUT (Device Under Test) using SpinalHDL's `GenerationFlags.formal`. These assertions are checked during formal verification but are typically excluded from the generated Verilog netlist unless specifically enabled.

```scala
class LimitedCounterEmbedded extends Component {
  val value = Reg(UInt(4 bits)) init(2)
  when(value < 10) {
    value := value + 1
  }

  // That code block will not be in the SpinalVerilog netlist by default. (would need to enable SpinalConfig().includeFormal. ...
  GenerationFlags.formal {
    assert(value >= 2)
    assert(value <= 10)
  }
}

object LimitedCounterEmbeddedFormal extends App {
  import spinal.core.formal._

  FormalConfig.withBMC(15).doVerify(new Component {
    val dut = FormalDut(new LimitedCounterEmbedded())
    assumeInitial(ClockDomain.current.isResetActive)
  })
}
```

--------------------------------

### SpinalHDL: Bitwise and Bitfield Operators

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Developers area/types.rst

Details various bitwise operators for SpinalHDL, including NOT, AND, OR, XOR, and bitfield access/assignment. Supports reading and writing single bits, ranges, and variable bitfields using different indexing methods.

```Scala
// Bitwise Operators
~x
x & y
x | y
x ^ y

// Bitfield Access
x(y)
x(hi,lo)
x(offset,width)

// Bitfield Assignment
x(y) := z
x(hi,lo) := z
x(offset,width) := z

// Bit Properties
x.msb
x.lsb
x.range
x.high

// Reduction Operators
x.xorR
x.orR
x.andR

// All Bits Manipulation
x.clearAll[()]
x.setAll[()]
x.setAllTo(value : Boolean)
x.setAllTo(value : Bool)

// Casting
x.asBools
```

--------------------------------

### Explicitly Blackbox a Memory in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Sequential logic/memory.rst

This example demonstrates how to explicitly mark a specific memory instance to be generated as a blackbox. The `generateAsBlackBox()` function is called on the `mem` object, ensuring that this particular memory will be replaced by a blackbox in the generated HDL. This is useful when a specific memory has features that require a pre-defined IP or when the automatic blackboxing policies are not granular enough.

```scala
val mem = Mem(Rgb(rgbConfig), 1 << 16)
mem.generateAsBlackBox()
```

--------------------------------

### Synthesizing UartCtrl for 115200-N-8-1 (Scala)

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Examples/Intermediates ones/uart.rst

Provides a concise example of how to instantiate and synthesize a UartCtrl component configured for a standard 115200 baud rate with No parity and 8 data bits, 1 stop bit.

```scala
// Synthesizing a UartCtrl as 115200-N-8-1:
val uartCtrl = new UartCtrl(clockFrequency = 100 MHz, baudRate = 115200 bitsPerSecond, dataWidth = 8, parity = None, stop = stop.one)
```

--------------------------------

### Scala Stream Bundle with Queue Functionality

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Getting Started/Help for VHDL people/vhdl_comp.rst

Demonstrates how to add a queueing mechanism to a generic stream bundle in SpinalHDL. This function instantiates a FIFO component to manage data flow within the stream, utilizing the IMasterSlave and DataCarrier traits.

```scala
class Stream[T <: Data](dataType:  T) extends Bundle with IMasterSlave with DataCarrier[T] {
  val valid = Bool()
  val ready = Bool()
  val payload = cloneOf(dataType)

  def queue(size: Int): Stream[T] = {
    val fifo = new StreamFifo(dataType, size)
    fifo.io.push <> this
    fifo.io.pop
  }
}
```

--------------------------------

### Fork ClockDomain Stimulus in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Simulation/clock.rst

This example demonstrates how to fork a clock stimulus for a ClockDomain directly in Scala. It utilizes the `forkStimulus` method with a specified period.

```scala
dut.clockDomain.forkStimulus(period = 10)
```

--------------------------------

### Creating a basic CtrlLink in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/Pipeline/introduction.rst

Shows how to create a CtrlLink without node arguments, which internally creates its own nodes. This is a simpler way to instantiate control links when explicit node connections are not required.

```scala
val decode = CtrlLink()
val execute = CtrlLink()

val d2e = StageLink(decode.down, execute.up)
```

--------------------------------

### SpinalHDL UFix Arithmetic Operator: Multiplication

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/Fix.rst

Describes the multiplication (`*`) operator for SpinalHDL's `UFix` type. It outlines how the resolution and amplitude of the resulting fixed-point number are determined.

```scala
   * - x * y
     - Multiplication
```

--------------------------------

### Wait for Rising Edge on Clock in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Simulation/clock.rst

This snippet shows how to pause test execution until a rising edge is detected on the ClockDomain. This is useful for synchronizing testbench actions with the clock.

```scala
dut.clockDomain.waitRisingEdge()
```

--------------------------------

### Define AvalonMM Interface with Clock Domain Tag

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/EDA/altera/qsysify.rst

This Scala code defines a SpinalHDL component with an AvalonMM interface and demonstrates how to add a `ClockDomainTag` to it. This tag is crucial for QSysify to correctly identify and configure the clock domain associated with the Avalon bus when generating the QSys IP.

```scala
io.bus addTag(ClockDomainTag(busClockDomain))
```

--------------------------------

### VHDL Attribute Declaration for Synthesis

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Other language features/vhdl_generation.rst

Shows the VHDL code generated for a 'keep' attribute on a signal. This declaration specifies that the signal 'pcPlus4' should retain its attribute, influencing the synthesis process. It produces a boolean attribute.

```vhdl
attribute keep : boolean;
signal pcPlus4 : unsigned(31 downto 0);
attribute keep of pcPlus4: signal is true;
```

--------------------------------

### Verilog Output of Named Signals

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Structuring/naming.rst

Shows the Verilog module generated from a SpinalHDL component where names have been explicitly set. This illustrates how `setName` and `setCompositeName` translate into actual hardware signal names in the Verilog output.

```verilog
module MyComponent (
);
  wire                a;
  wire                rawrr;
  wire                c;
  wire                rawrr_wuff;
endmodule

```

--------------------------------

### SpinalHDL Stream Bundle Definition and Queue Operation

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Foreword/index.rst

This code defines a generic 'Stream' Bundle in SpinalHDL, representing a data stream with valid, ready, and payload signals. It includes overloaded operators for stream connection and a 'queue' method that integrates a StreamFifo to buffer data, showcasing SpinalHDL's ability to define custom hardware constructs and operations.

```scala
// Define the concept of handshake bus
   class Stream[T <: Data](dataType:  T) extends Bundle {
     val valid   = Bool()
     val ready   = Bool()
     val payload = cloneOf(dataType)

     // Define an operator to connect the left operand (this) to the right operand (that)
     def >>(that: Stream[T]): Unit = {
       that.valid := this.valid
       this.ready := that.ready
       that.payload := this.payload
     }

     // Return a Stream connected to this via a FIFO of depth elements
     def queue(depth: Int): Stream[T] = {
       val fifo = new StreamFifo(dataType, depth)
       this >> fifo.io.push
       return fifo.io.pop
     }
   }
```

--------------------------------

### SpinalHDL Plugin Execution Phases

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/Misc/service_plugin.rst

Demonstrates the setup and build phases within a SpinalHDL FiberPlugin. The 'during setup' block executes code before hardware elaboration, while 'during build' executes during hardware elaboration. 'awaitBuild()' is used to synchronize the build phase.

```scala
class MyPlugin extends FiberPlugin {
  val logic = during setup new Area {
    // Here we are executing code in the setup phase
    awaitBuild()
    // Here we are executing code in the build phase
  }
}

class MyPlugin2 extends FiberPlugin {
  val logic = during build new Area {
    // Here we are executing code in the build phase
  }
}
```

--------------------------------

### SpinalHDL: Specifying Initial Value of Reset Wire

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Formal verification/index.rst

This SpinalHDL snippet shows how to specify the initial value of the current clock domain's reset wire. This is particularly useful at the top level of a design to ensure a known starting state for formal verification.

```scala
ClockDomain.current.readResetWire initial(False)
```

--------------------------------

### Scala Declarative Bus/Interface with Parameterization

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Getting Started/Help for VHDL people/vhdl_comp.rst

Demonstrates SpinalHDL's powerful and parameterized approach to defining slave interfaces, specifically an APB3 bus. This is significantly more concise and flexible than VHDL methods.

```scala
val P = slave(Apb3(addressWidth, dataWidth))
```

--------------------------------

### Create Reset Area with Special Reset Signal in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Structuring/clock_domain.rst

Shows how to define a new clock domain area with a special reset signal using ResetArea. This allows for custom reset logic, either replacing the current reset or combining it with a new reset signal. It's useful for scenarios requiring specific reset synchronization or handling.

```scala
class TopLevel extends Component {

  val specialReset = Bool()

  // The reset of this area is done with the specialReset signal 
  val areaRst_1 = new ResetArea(specialReset, false) {
    val counter = out(CounterFreeRun(16).value)
  }

  // The reset of this area is a combination between the current reset and the specialReset
  val areaRst_2 = new ResetArea(specialReset, true) {
    val counter = out(CounterFreeRun(16).value)
  }
}
```

--------------------------------

### Define APB3 Bus Bundle in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/Bus/amba3/apb3.rst

Defines the APB3 bus bundle structure in SpinalHDL, specifying signals like PADDR, PSEL, PENABLE, PREADY, PWRITE, PWDATA, PRDATA, and optionally PSLVERROR based on the configuration.

```scala
case class Apb3(config: Apb3Config) extends Bundle with IMasterSlave {
  val PADDR      = UInt(config.addressWidth bits)
  val PSEL       = Bits(config.selWidth bits)
  val PENABLE    = Bool()
  val PREADY     = Bool()
  val PWRITE     = Bool()
  val PWDATA     = Bits(config.dataWidth bits)
  val PRDATA     = Bits(config.dataWidth bits)
  val PSLVERROR  = if(config.useSlaveError) Bool() else null
  // ...
}
```

--------------------------------

### Define UART Configuration Enums in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Examples/Intermediates ones/uart.rst

Defines enumerations for parity and stop bit configurations within the UART controller. These enums are used to set the frame format during communication.

```scala
object Parity extends SpinalEnumDefaulting(Bool()) {
  val NONE, EVEN, ODD = newElement()
}

object StopBit extends SpinalEnumDefaulting(Bool()) {
  val ONE, TWO = newElement()
}
```

--------------------------------

### Define BlackBox RAM with Custom IO Naming (Scala)

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Structuring/blackbox.rst

This example defines a BlackBox for a RAM module and configures it to avoid the default 'io_' prefix for its input/output signals. It also maps the clock domain and demonstrates how to set up complex IO bundles for read and write ports. The `noIoPrefix()` function is used to achieve the desired naming convention.

```scala
   // Define the Ram as a BlackBox
   class Ram_1w_1r(wordWidth: Int, wordCount: Int) extends BlackBox {

     val generic = new Generic {
       val wordCount = Ram_1w_1r.this.wordCount
       val wordWidth = Ram_1w_1r.this.wordWidth
     }

     val io = new Bundle {
       val clk = in Bool()

       val wr = new Bundle {
         val en   = in Bool()
         val addr = in UInt (log2Up(_wordCount) bits)
         val data = in Bits (_wordWidth bits)
       }
       val rd = new Bundle {
         val en   = in Bool()
         val addr = in UInt (log2Up(_wordCount) bits)
         val data = out Bits (_wordWidth bits)
       }
     }

     noIoPrefix()

     mapCurrentClockDomain(clock=io.clk)
   }
```

--------------------------------

### Apply Clock Domain Directly in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Structuring/clock_domain.rst

Illustrates two alternative syntaxes for applying a clock domain directly without needing an explicit `Area` definition. This is useful for concise application within components.

```scala
class Counters extends Component {
  val io = new Bundle {
    val enable = in Bool ()
    val freeCount, gatedCount, gatedCount2 = out UInt (4 bits)
  }
  val freeCounter = CounterFreeRun(16)
  io.freeCount := freeCounter.value

  // In a real design consider using a glitch free single purpose CLKGATE primitive instead
  val gatedClk = ClockDomain.current.readClockWire && io.enable
  val gated = ClockDomain(gatedClk, ClockDomain.current.readResetWire)

  // Here the "gated" clock domain is applied on "gatedCounter" and "gatedCounter2"
  val gatedCounter = gated(CounterFreeRun(16))
  io.gatedCount := gatedCounter.value
  val gatedCounter2 = gated on CounterFreeRun(16)
  io.gatedCount2 := gatedCounter2.value

  assert(gatedCounter.value === gatedCounter2.value, "gated count mismatch")
}
```

--------------------------------

### Generated Verilog for SpinalHDL Plugins

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/Misc/service_plugin.rst

This Verilog code represents the hardware generated by the Scala SpinalHDL example. It shows the instantiation of sub-components and the resulting logic for the StatePlugin's signal, which is incremented based on the configurations applied by the SetupPlugins during elaboration. The increment value is fixed in the generated code, reflecting the final state after all plugin interactions.

```verilog
module TopLevel (
  input  wire          clk,
  input  wire          reset
);


  SubComponent sub (
    .clk   (clk  ),
    .reset (reset)
  );

endmodule

module SubComponent (
  input  wire          clk,
  input  wire          reset
);

  reg        [31:0]   StatePlugin_logic_signal;

  always @(posedge clk) begin
    StatePlugin_logic_signal <= (StatePlugin_logic_signal + 32'h00000002); // + 2 as we have two SetupPlugin
  end
endmodule
```

--------------------------------

### Define and Fork Custom ClockDomain in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Simulation/clock.rst

This example illustrates how to define a new ClockDomain using existing clock and reset signals and then fork a stimulus for it. This is helpful when the DUT's clock/reset are not directly managed by a ClockDomain.

```scala
// In the testbench
ClockDomain(dut.io.coreClk, dut.io.coreReset).forkStimulus(10)
```

--------------------------------

### Bitwise Equality with Don't Care in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/index.rst

Shows how to use a special type for checking equality between a BitVector and a bit constant pattern that includes holes (don't care values). The 'M' prefix denotes this special pattern.

```scala
val myBits  = Bits(8 bits)
val itMatch = myBits === M"00--10--" // - for don't care value
```

--------------------------------

### Define Reset Output with ResetEmitterTag

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/EDA/altera/qsysify.rst

This Scala code illustrates how to define a reset output in a SpinalHDL component and tag it with `ResetEmitterTag`. This tag, along with the specified reset output clock domain, ensures that QSysify can correctly integrate the reset signal into the QSys system.

```scala
io.resetOutput addTag(ResetEmitterTag(resetOutputClockDomain))
```

--------------------------------

### SpinalHDL BitVector (UInt) Declaration and Assignment

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Developers area/types.rst

Illustrates various ways to declare and assign values to a UInt (unsigned integer) type in SpinalHDL. It covers inferring width, specifying width, using integer literals, string literals with different bases, and Scala Int literals.

```scala
val myUInt = UInt(8 bits)
myUInt := U(2,8 bits)
myUInt := U(2)
myUInt := U"0000_0101"  // Base per default is binary => 5
myUInt := U"h1A"        // Base could be x (base 16)
                           //               h (base 16)
                           //               d (base 10)
                           //               o (base 8)
                           //               b (base 2)
myUInt := U"8'h1A"
myUInt := 2             // You can use scala Int as literal value
```

--------------------------------

### Measure Latency with LatencyAnalysis in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Developers area/spinalhdl_datamodel.rst

The LatencyAnalysis function measures the time difference between two signals, typically used for debugging and performance analysis in hardware designs. It takes signal validity or values as input and returns a string representation of the latency.

```scala
println("fpuDispatch to cpuRsp    " + LatencyAnalysis(logic.decode.input.valid, plugin.port.rsp.valid))

println("cpuWriteback to fpuAdd   " + LatencyAnalysis(vex.writeBack.input(plugin.FPU_COMMIT), logic.commitLogic(0).add.counter))

println("add                      " + LatencyAnalysis(logic.decode.add.rs1.mantissa, logic.get.merge.arbitrated.value.mantissa))
println("mul                      " + LatencyAnalysis(logic.decode.mul.rs1.mantissa, logic.get.merge.arbitrated.value.mantissa))
println("fma                      " + LatencyAnalysis(logic.decode.mul.rs1.mantissa, logic.get.decode.add.rs1.mantissa, logic.get.merge.arbitrated.value.mantissa))
println("short                    " + LatencyAnalysis(logic.decode.shortPip.rs1.mantissa, logic.get.merge.arbitrated.value.mantissa))
```

--------------------------------

### Parameterized ShiftRegister Component (Old Way) in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Other language features/utils.rst

Shows the 'old way' of parameterizing a SpinalHDL component using a raw hardware type passed as a construction parameter. This method requires careful use of cloneOf to instantiate new signals of the same type within the component.

```scala
case class ShiftRegister[T <: Data](dataType: T, depth: Int) extends Component {
  val io = new Bundle {
    val input  = in (cloneOf(dataType))
    val output = out(cloneOf(dataType))
  }
  // ...
}

val shiftReg = ShiftRegister(Bits(32 bits), depth = 8)
```

--------------------------------

### Initialize Register Vectors (Scala)

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Sequential logic/registers.rst

Illustrates initializing register vectors using the `init` method, combined with `foreach` for applying initialization to all elements. Examples include initializing a vector of UInt registers to 0 and a vector of Bool registers to False.

```scala
   val vecReg1 = Vec(Reg(UInt(8 bits)) init(0), 4)
   val vecReg2 = Vec.fill(8)(Reg(Bool()))
   vecReg2.foreach(_ init(False))
```

--------------------------------

### Define APB3 Configuration for UART Controller (Scala)

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Examples/Advanced ones/memory_mapped_uart.rst

Defines the APB3 configuration object for the UART controller. This object is intended to be accessible from various parts of the project for consistent bus configuration.

```scala
object Apb3UartCtrl {
  def getApb3Config() = Apb3Config(
    addressWidth = 32,
    dataWidth = 32,
    cmdParity = false,
    respParity = false
  )
}
// end object Apb3UartCtrl
```

--------------------------------

### Scala Generic Class: Queue with Type Parameter

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Getting Started/Scala Guide/basics.rst

Shows how to create a generic class 'Queue' that can hold elements of any type 'T'. The type parameter 'T' is specified during class instantiation. This promotes code reusability.

```scala
class  Queue[T]() {
  def push(that: T) : Unit = ...
  def pop(): T = ...
}
```

--------------------------------

### Scala Core Configuration with Plugin Extensions

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Getting Started/Help for VHDL people/vhdl_comp.rst

Shows how to define a `CoreConfig` object in SpinalHDL for a RISC-V core, including various parameters and the ability to add extensions like multiplication, division, and barrel shifters using plugins.

```scala
val coreConfig = CoreConfig(
  pcWidth = 32,
  addrWidth = 32,
  startAddress = 0x00000000,
  regFileReadyKind = sync,
  branchPrediction = dynamic,
  bypassExecute0 = true,
  bypassExecute1 = true,
  bypassWriteBack = true,
  bypassWriteBackBuffer = true,
  collapseBubble = false,
  fastFetchCmdPcCalculation = true,
  dynamicBranchPredictorCacheSizeLog2 = 7
)

// The CPU has a system of plugins which allows adding new features into the core.
// Those extensions are not directly implemented in the core, but are kind of an additive logic patch defined in a separate area.
coreConfig.add(new MulExtension)
coreConfig.add(new DivExtension)
coreConfig.add(new BarrelShifterFullExtension)
```

--------------------------------

### Generate Verilog for USB Device Controller - Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/Com/usb_device.rst

This snippet defines the top-level component for a USB device controller and generates its Verilog representation. It sets up clock domains for the controller and PHY, instantiates the UsbDeviceCtrl and UsbDevicePhyNative components, and connects their interfaces. The UsbDeviceGen object uses SpinalVerilog to synthesize the UsbDeviceTop component into Verilog.

```scala
import spinal.core._
import spinal.core.sim._
import spinal.lib.bus.bmb.BmbParameter
import spinal.lib.com.usb.phy.UsbDevicePhyNative
import spinal.lib.com.usb.sim.UsbLsFsPhyAbstractIoAgent
import spinal.lib.com.usb.udc.{UsbDeviceCtrl, UsbDeviceCtrlParameter}


case class UsbDeviceTop() extends Component {
  val ctrlCd = ClockDomain.external("ctrlCd", frequency = FixedFrequency(100 MHz))
  val phyCd = ClockDomain.external("phyCd", frequency = FixedFrequency(48 MHz))

  val ctrl = ctrlCd on new UsbDeviceCtrl(
    p = UsbDeviceCtrlParameter(
      addressWidth = 14
    ),
    bmbParameter = BmbParameter(
      addressWidth = UsbDeviceCtrl.ctrlAddressWidth,
      dataWidth = 32,
      sourceWidth = 0,
      contextWidth = 0,
      lengthWidth = 2
    )
  )

  val phy = phyCd on new UsbDevicePhyNative(sim = true)
  ctrl.io.phy.cc(ctrlCd, phyCd) <> phy.io.ctrl

  val bmb = ctrl.io.ctrl.toIo()
  val usb = phy.io.usb.toIo()
  val power = phy.io.power.toIo()
  val pullup = phy.io.pullup.toIo()
  val interrupts = ctrl.io.interrupt.toIo()
}


object UsbDeviceGen extends App {
  SpinalVerilog(new UsbDeviceTop())
}

```

--------------------------------

### Parametrize SpinalHDL Generation from Shell

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Other language features/vhdl_generation.rst

Shows how to use command-line arguments to configure SpinalHDL generation, such as selecting the output mode and target directory.

```scala
def main(args: Array[String]): Unit = {
  SpinalConfig.shell(args)(new UartCtrl)
}
```

--------------------------------

### SpinalHDL Port Declaration Syntax

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/miscelenea/core/core_components.rst

Details the syntax for declaring input and output ports in SpinalHDL components, including generic types (Bool, Bits, UInt, SInt) and specifying bit widths.

```scala
   in/out(x : Data)
   in/out Bool()
   in/out Bits/UInt/SInt(x bits)
```

--------------------------------

### Initialize Reset Controller Clock Domain

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Legacy/pinsec/hardware_toplevel.rst

Sets up the clock domain for the reset controller, using the asynchronous reset and the main AXI clock. It configures the reset kind to BOOT, indicating initialization by the FPGA bitstream.

```scala
val resetCtrlClockDomain = ClockDomain(
  clock = io.axiClk,
  config = ClockDomainConfig(
    resetKind = BOOT
  )
)
```

--------------------------------

### SpinalHDL Vec Helper Functions: Counting and Existence

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/Vec.rst

Demonstrates the use of sCount and sExists helper functions for SpinalHDL Vecs. sCount can count elements matching a condition or a specific value, while sExists checks if any element satisfies a given condition or matches a value. Requires importing spinal.lib._.

```scala
    import spinal.lib._

    // Create a vector with 4 unsigned integers
    val vec1 = Vec.fill(4)(UInt(8 bits))

    // ... the vector is actually assigned somewhere

    val c1: UInt = vec1.sCount(_ < 128) // how many values are lower than 128 in vec
    val c2: UInt = vec1.sCount(0) // how many values are equal to zero in vec

    val b1: Bool = vec1.sExists(_ > 250) // is there a element bigger than 250
    val b2: Bool = vec1.sContains(0) // is there a zero in vec
```

--------------------------------

### HTML Document Generation Example

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/regIf.rst

Example of generating an HTML document for a register interface using `HtmlGenerator`. This requires a `busif` object and specifies the output name and title for the register file.

```scala
busif.accept(HtmlGenerator("regif", title = "XXX register file"))
```

--------------------------------

### SpinalHDL BusSlaveFactory: Read, Write, and Drive Methods

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Developers area/bus_slave_factory_impl.rst

This snippet defines the `BusSlaveFactory` trait in SpinalHDL, offering methods for interacting with a bus. It includes functionalities to read from and write to bus addresses, drive registers with incoming data, and manage data flow. The methods handle various data types and bit offsets, enabling flexible bus slave implementation. Dependencies include `Data`, `BigInt`, and other internal SpinalHDL constructs.

```scala
trait BusSlaveFactory  extends Are {
  // ...
  def readAndWrite(that : Data,
                   address: BigInt,
                   bitOffset : Int = 0): Unit = {
    write(that,address,bitOffset)
    read(that,address,bitOffset)
  }

  def drive(that : Data,
            address : BigInt,
            bitOffset : Int = 0) : Unit = {
    val reg = Reg(that)
    write(reg,address,bitOffset)
    that := reg
  }

  def driveAndRead(that : Data,
                   address : BigInt,
                   bitOffset : Int = 0) : Unit = {
    val reg = Reg(that)
    write(reg,address,bitOffset)
    read(reg,address,bitOffset)
    that := reg
  }

  def driveFlow[T <: Data](that : Flow[T],
                            address: BigInt,
                            bitOffset : Int = 0) : Unit = {
    that.valid := False
    onWrite(address) {
      that.valid := True
    }
    nonStopWrite(that.payload,bitOffset)
  }

  def createReadWrite[T <: Data](dataType: T,
                                  address: BigInt,
                                  bitOffset : Int = 0): T = {
    val reg = Reg(dataType)
    write(reg,address,bitOffset)
    read(reg,address,bitOffset)
    reg
  }

  def createAndDriveFlow[T <: Data](dataType : T,
                                  address: BigInt,
                                  bitOffset : Int = 0) : Flow[T] = {
    val flow = Flow(dataType)
    driveFlow(flow,address,bitOffset)
    flow
  }

  def doBitsAccumulationAndClearOnRead(   that : Bits,
                                          address : BigInt,
                                          bitOffset : Int = 0): Unit = {
    assert(that.getWidth <= busDataWidth)
    val reg = Reg(that)
    reg := reg | that
    read(reg,address,bitOffset)
    onRead(address) {
      reg := that
    }
  }

  def readStreamNonBlocking[T <: Data] (that : Stream[T],
                                        address: BigInt,
                                        validBitOffset : Int,
                                        payloadBitOffset : Int) : Unit = {
    that.ready := False
    onRead(address) {
      that.ready := True
    }
    read(that.valid  ,address,validBitOffset)
    read(that.payload,address,payloadBitOffset)
  }

  def readMultiWord(that : Data,
                 address : BigInt) : Unit  = {
    val wordCount = (widthOf(that) - 1) / busDataWidth + 1
    val valueBits = that.asBits.resize(wordCount*busDataWidth)
    val words = (0 until wordCount).map(id => valueBits(id * busDataWidth , busDataWidth bits))
    for (wordId <- (0 until wordCount)) {
      read(words(wordId), address + wordId*busDataWidth/8)
    }
  }

  def writeMultiWord(that : Data,
                  address : BigInt) : Unit  = {
    val wordCount = (widthOf(that) - 1) / busDataWidth + 1
    for (wordId <- (0 until wordCount)) {
      write(
        that = new DataWrapper {
          override def getBitsWidth: Int =
            Math.min(busDataWidth, widthOf(that) - wordId * busDataWidth)

          override def assignFromBits(value : Bits): Unit = {
            that.assignFromBits(
              bits     = value.resized,
              offset   = wordId * busDataWidth,
              bitCount = getBitsWidth bits)
          }
        },address = address + wordId * busDataWidth / 8,0
      )
    }
  }
}

```

--------------------------------

### Detect Clock Crossing Violation Example - SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Design errors/clock_crossing_violation.rst

Demonstrates a scenario in SpinalHDL where a clock crossing violation occurs due to registers operating on different clock domains. This code snippet is intended to show the problem before applying any fixes.

```scala
class TopLevel extends Component {
  val clkA = ClockDomain.external("clkA")
  val clkB = ClockDomain.external("clkB")

  val regA = clkA(Reg(UInt(8 bits)))   // PlayDev.scala:834
  val regB = clkB(Reg(UInt(8 bits)))   // PlayDev.scala:835

  val tmp = regA + regA                // PlayDev.scala:838
  regB := tmp
}
```

--------------------------------

### Define and Instantiate Components in SpinalHDL

Source: https://context7.com/spinalhdl/spinaldoc-rtd/llms.txt

Shows how to define a basic hardware component (like an AdderCell) with input/output ports using `Component` and `Bundle`. It also demonstrates creating a parent component (Adder) that instantiates child components, connects them, and can create arrays of components. Verilog generation is shown using `SpinalVerilog`.

```Scala
// Component definition (hardware module)
class AdderCell() extends Component {
  // Bundle called 'io' for external ports (recommended convention)
  val io = new Bundle {
    val a, b, cin = in port Bool()
    val sum, cout = out port Bool()
  }

  // Combinational logic
  io.sum := io.a ^ io.b ^ io.cin
  io.cout := (io.a & io.b) | (io.a & io.cin) | (io.b & io.cin)
}

// Parent component using child instances
class Adder(width: Int) extends Component {
  val io = new Bundle {
    val a, b = in UInt(width bits)
    val result = out UInt(width bits)
  }

  // Instantiate child components
  val cell0 = new AdderCell()
  val cell1 = new AdderCell()

  // Connect components (no port binding needed at instantiation)
  cell1.io.cin := cell0.io.cout

  // Create array of components
  val cellArray = Array.fill(width)(new AdderCell())
  cellArray(1).io.cin := cellArray(0).io.cout

  // Components can read their own outputs (unlike VHDL)
  when(cell0.io.cout) {
    // Use output value directly
  }
}

// Generate Verilog from top-level component
object Main extends App {
  SpinalVerilog(new Adder(8))
}
```

--------------------------------

### Declare SpinalEnum with Custom Default Encoding

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/enum.rst

This demonstrates how to explicitly set a custom encoding for an enumeration. The `defaultEncoding` parameter allows selection from predefined encoding strategies.

```scala
object Enumeration extends SpinalEnum(defaultEncoding=encodingOfYourChoice) {
  val element0, element1, ..., elementN = newElement()
}
```

--------------------------------

### SpinalHDL Clock Domain Definition

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Getting Started/Help for VHDL people/vhdl_comp.rst

Illustrates how to define and use a custom ClockDomain in SpinalHDL, specifying clock, reset, and configuration options like clock edge and reset polarity. This allows for organized management of clocking and reset for hardware areas.

```scala
val coreClockDomain = ClockDomain(
  clock = io.coreClk,
  reset = io.coreReset,
  config = ClockDomainConfig(
    clockEdge = RISING,
    resetKind = ASYNC,
    resetActiveLevel = HIGH
  )
)
val coreArea = new ClockingArea(coreClockDomain) {
  val myCoreClockedRegister = Reg(UInt(4 bits))
  // ...
  // coreClockDomain will also be applied to all sub components instantiated in the Area
  // ... 
}
```

--------------------------------

### Scala Generic Class: Queue with Type Constraint

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Getting Started/Scala Guide/basics.rst

Demonstrates a generic class 'Queue' with a type parameter 'T' constrained to be a subtype of 'Shape' using '<: Shape'. This ensures that only 'Shape' objects or their subclasses can be added to the queue, enforcing type safety.

```scala
class Shape() {   
    def getArea(): Float
}
class Rectangle() extends Shape { ... }

class  Queue[T <: Shape]() {
  def push(that: T): Unit = ...
  def pop(): T = ...
}
```

--------------------------------

### SpinalHDL Counter with Conditional Reset

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Getting Started/Scala Guide/interaction.rst

This snippet shows a basic counter increment in SpinalHDL. It includes a conditional elaboration block that, when enabled, checks if the counter reaches 42 and resets it to 0. This is useful for testing hardware elaboration logic.

```scala
counter := counter + 1
if(generateAClearWhenHit42) {  // Elaboration test, like an if generate in vhdl
  when(counter === 42) {       // Hardware test
    counter := 0
  }
}
```

--------------------------------

### S2mLink for Improved Backpressure Timings in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/Pipeline/introduction.rst

Illustrates the use of `S2mLink` to connect two nodes (`n0` and `n1`), focusing on registering the ready signal. This can be beneficial for improving combinatorial timing by reducing backpressure delays between pipeline stages.

```scala
val c01 = S2mLink(n0, n1)
```

--------------------------------

### SpinalHDL Hierarchy Violation Error Message

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Design errors/hierarchy_violation.rst

This is a text output representing a 'HIERARCHY VIOLATION' error message generated by SpinalHDL. It indicates that a signal is being driven from an incorrect scope, specifically attempting to assign to an 'in' signal from within the same component. The message pinpoints the signal and the source of the violation.

```text
HIERARCHY VIOLATION : (toplevel/io_a : in UInt[8 bits]) is driven by (toplevel/tmp :  UInt[8 bits]), but isn't accessible in the toplevel component.
  ***
  Source file location of the `io.a := tmp` via the stack trace
  ***
```

--------------------------------

### Map Clock Domain to BlackBox Ports in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Structuring/blackbox.rst

Illustrates how to map clock and reset signals from a ClockDomain to the input ports of a BlackBox using mapClockDomain and mapCurrentClockDomain. mapClockDomain allows specifying a particular ClockDomain, while mapCurrentClockDomain uses the active ClockDomain.

```scala
class MyRam(clkDomain: ClockDomain) extends BlackBox {

  val io = new Bundle {
    val clkA = in Bool()
    ...
    val clkB = in Bool()
    ...
  }

  // Clock A is map on a specific clock Domain 
  mapClockDomain(clkDomain, io.clkA)
  // Clock B is map on the current clock domain 
  mapCurrentClockDomain(io.clkB)
}
```

--------------------------------

### Scala: Detect Assignment Overlap in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Design errors/assignment_overlap.rst

Demonstrates a common scenario in SpinalHDL where a signal assignment completely overwrites a previous one, leading to an 'ASSIGNMENT OVERLAP' error. This snippet highlights the problematic code.

```scala
class TopLevel extends Component {
  val a = UInt(8 bits)
  a := 42
  a := 66 // Erase the a := 42 assignment
}
```

--------------------------------

### SpinalHDL: Using 'past' with Initial Value

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Formal verification/index.rst

This Scala example demonstrates using the `past` primitive in SpinalHDL with an initial value. The `init(False)` clause specifies that the initial value of `enable` should be `False` when `past(enable)` is evaluated for the first time.

```scala
when(past(enable) init(False)) { ... }
```

--------------------------------

### Configure and Instantiate Coherent Tilelink Bus in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/Bus/tilelink/tilelink.rst

This example demonstrates the configuration and instantiation of Tilelink buses with coherency channels enabled. It uses a more detailed `tilelink.BusParameter` constructor to specify various coherency-related options.

```scala
import spinal.lib.bus.tilelink
val param = tilelink.BusParameter(
  addressWidth = 32,
  dataWidth = 64,
  sizeBytes = 64,
  sourceWidth = 4,
  sinkWidth = 0,
  withBCE = false,
  withDataA = true,
  withDataB = false,
  withDataC = false,
  withDataD = true,
  node = null
)
val busA, busB = tilelink.Bus(param)
busA << busB
```

--------------------------------

### Compile SpinalHDL Library with Mill

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Developers area/mill support.rst

This command compiles the SpinalHDL library using Mill. It's the basic step to ensure the code is built successfully. The equivalent Sbt command is also provided.

```sh
mill __.compile
```

```sh
sbt compile
```

--------------------------------

### Verilog RAM Attributes Example

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Sequential logic/memory.rst

This snippet demonstrates how HDL attributes might be inserted by SpinalHDL for memory components, specifically when a device-vendor configuration is present. These attributes often control memory instantiation and behavior in the target FPGA or ASIC.

```verilog
(* ram_style = "distributed" *)
(* ramsyle = "no_rw_check" *)
```

--------------------------------

### Safe Clock Domain Crossing with BufferCC - SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Design errors/clock_crossing_violation.rst

Demonstrates the use of the 'BufferCC' type in SpinalHDL for safely crossing asynchronous clock domains, particularly for single-bit signals or Gray-coded values. It highlights the requirement for specific data types and warns against its use with multi-bit signals.

```scala
class AsyncFifo extends Component {
      val popToPushGray = Bits(ptrWidth bits)
      val pushToPopGray = Bits(ptrWidth bits)
     
      val pushCC = new ClockingArea(pushClock) {
        val pushPtr     = Counter(depth << 1)
        val pushPtrGray = RegNext(toGray(pushPtr.valueNext)) init(0)
        val popPtrGray  = BufferCC(popToPushGray, B(0, ptrWidth bits))
        val full        = isFull(pushPtrGray, popPtrGray)
        ...
      }
     
      val popCC = new ClockingArea(popClock) {
        val popPtr      = Counter(depth << 1)
        val popPtrGray  = RegNext(toGray(popPtr.valueNext)) init(0)
        val pushPtrGray = BufferCC(pushToPopGray, B(0, ptrWidth bits))
        val empty       = isEmpty(popPtrGray, pushPtrGray)   
        ...
      }
   }
```

--------------------------------

### Initialize Bundle Elements in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Sequential logic/registers.rst

Shows how to initialize individual elements of a Bundle within a register in SpinalHDL using the init() function.

```scala
case class ValidRGB() extends Bundle {
  val valid   = Bool()
  val r, g, b = UInt(8 bits)
}

val reg = Reg(ValidRGB())
reg.valid init(False)  // Only the valid if that register bundle will have a reset value.
```

--------------------------------

### SpinalEnum Type Casting to Bits

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/enum.rst

This code shows how to cast an enumeration element to its underlying bit representation using `.asBits`. It also demonstrates casting the resulting Bits to UInt or SInt.

```scala
import UartCtrlTxState._

val stateNext = UartCtrlTxState()
val myBits = sIdle.asBits // Cast enum element to Bits
// myBits can then be cast to UInt or SInt if needed
// val myUInt = myBits.asUInt
// val mySInt = myBits.asSInt
```

--------------------------------

### SpinalHDL Hardware Assertion Example

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Other language features/assertion.rst

Demonstrates the usage of hardware assertions in SpinalHDL to check handshake protocol signals. It includes defining signals, conditional logic, and an assertion with a custom message and severity level.

```scala
class TopLevel extends Component {
    val valid = RegInit(False)
    val ready = in Bool()

    when(ready) {
      valid := False
    }
    // some logic

    assert(
      assertion = !(valid.fall && !ready),
      message   = "Valid dropped when ready was low",
      severity  = ERROR
    )
  }
```

--------------------------------

### UART Controller Usage Example (Scala)

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Examples/Intermediates ones/uart.rst

This Scala snippet illustrates a complete example of using the UartCtrl component. It configures the UART for 921600 baud, no parity, and 1 stop bit, and demonstrates reading received bytes to LEDs and periodically sending switch inputs to the UART. It requires instantiation of UartCtrl.

```scala
case class UartCtrlUsageExample(
    val uartCtrl : UartCtrl
) extends Component {
  val io = new Bundle {
    val leds = out UInt (8 bits)
    val switches = in UInt (8 bits)
  }

  // Connect the UartCtrl instance to the component IO
  val uart = uartCtrl.io

  // UART configuration: 921600 baud/s, no parity, 1 stop bit
  uart.config.BAUDRATE := 921600
  uart.config.PARITY := False
  uart.config.STOP_BIT := 1

  // Each time a byte is received from the UART, it writes it on the leds output.
  io.leds := uart.read.payload

  // Every 2000 cycles, it sends the switches input value to the UART.
  val timer = Reg(UInt (32 bits)) init (0)
  timer := timer + 1
  when(timer === 2000 - 1) {
    uart.write.payload := io.switches
    uart.write.valid := True
    timer := 0
  }
}
// end UartCtrlUsageExample
```

--------------------------------

### JSON Document Generation Example

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/regIf.rst

Example of generating a JSON document for a register interface using `JsonGenerator`. This function requires the output name for the register file.

```scala
busif.accept(JsonGenerator("regif"))
```

--------------------------------

### State Logic - onEntry

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/fsm.rst

Defines logic that executes once when a specific state is entered in a SpinalHDL state machine. This is useful for initialization or setup tasks associated with entering a state.

```scala
state.onEntry {
  yourStatements
}
```

--------------------------------

### Signal Naming Loss in Scala Functions without Area

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Getting Started/Scala Guide/interaction.rst

Illustrates that signals defined within a standard Scala function in SpinalHDL are not preserved in the generated RTL. The example shows a 'temp' signal inside 'myFunction' that will be lost.

```scala
def myFunction(arg: UInt) {
  val temp = arg + 1  // You will not retrieve the `temp` signal in the generated RTL
  return temp
}

val value = myFunction(U"000001") + 42
```

--------------------------------

### Create AXI Clocking Area

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Legacy/pinsec/hardware_toplevel.rst

Encloses the main components of the Pinsec SoC within an AXI clocked area, utilizing the previously defined axiClockDomain. This ensures all components instantiated within this area are synchronized to the AXI clock and reset.

```scala
val axi = new ClockingArea(axiClockDomain) {
  // Here will come the rest of Pinsec
}
```

--------------------------------

### Configure SpinalHDL Generation

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Other language features/vhdl_generation.rst

Demonstrates how to configure SpinalHDL for VHDL or Verilog generation, specifying the output directory.

```scala
SpinalConfig(mode=VHDL, targetDirectory="temp/myDesign").generate(new UartCtrl)

// Or for Verilog in a more scalable formatting:
SpinalConfig(
  mode=Verilog,
  targetDirectory="temp/myDesign"
).generate(new UartCtrl)
```

--------------------------------

### SpinalHDL Stateless Utilities Examples

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/utils.rst

Demonstrates the usage of various stateless utility functions in SpinalHDL for bit manipulation and data conversion. These functions operate on inputs without maintaining internal state.

```Scala
val grayValue = toGray(x.asUInt)
val uintValue = fromGray(grayValue.asBits)
val reversedBits = Reverse(myBits)
val ohIndex = OHToUInt(oneHotBits.asSeq)
val setBitsCount = CountOne(myBits.asSeq)
val leadingZeros = CountLeadingZeroes(myBits)
val majority = MajorityVote(myBits.asSeq)
val swappedEndianness = EndiannessSwap(myBits)
val maskedFirst = OHMasking.first(myBits)
val maskedLast = OHMasking.last(myBits)
val roundRobinMask = OHMasking.roundRobin(requests, ohPriority)
val muxedValue = MuxOH(oneHotVector, listOfValues)
val priorityMuxedValue = PriorityMux(selectionVector, inputVector)
val priorityMuxedValue2 = PriorityMux(listOfPairs)
```

--------------------------------

### Sphinx New Section Index File Structure

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Developers area/howtodocument.rst

This reStructuredText (ReST) code demonstrates the structure of an index file for a new section in Sphinx documentation. It includes a title, a toctree directive with :glob: to include all files in the directory, and specifies the main index file.

```rst
======
Cheese
======

.. toctree::
   :glob:

   introduction
   *
```

--------------------------------

### Simple Fiber Framework Example in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/fiber.rst

Demonstrates the basic usage of the Fiber framework, including creating Handles, defining tasks that depend on these Handles, and loading values asynchronously. This example illustrates how to overcome sequential execution by loading Handle values after their dependent tasks are defined.

```scala
import spinal.core.fiber._

// Create two empty Handles
val a, b = Handle[Int] 

// Create a Handle which will be loaded asynchronously by the given body result
val calculator = Handle {
    a.get + b.get // .get will block until they are loaded
}

// Same as above
val printer = Handle {
    println(s"a + b = ${calculator.get}") // .get is blocking until the calculator body is done
}

// Synchronously load a and b, this will unblock a.get and b.get 
a.load(3)
b.load(4)
```

--------------------------------

### Connect Inter-Component Signals

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Legacy/pinsec/hardware_toplevel.rst

This snippet shows how to connect internal component signals, specifically interrupts and debug reset lines. It routes interrupt signals from peripherals to the core and manages the debug reset flow.

```scala
core.io.interrupt(0) := uartCtrl.io.interrupt
core.io.interrupt(1) := timerCtrl.io.interrupt

core.io.debugResetIn := resetCtrl.axiReset
when(core.io.debugResetOut) {
  resetCtrl.coreResetUnbuffered := True
}
```

--------------------------------

### Configure AvalonMM Bus with Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Developers area/bus_slave_factory_impl.rst

Provides a factory method to create a standard Avalon MM bus configuration. It uses pipelined mode and customizes parameters like `useByteEnable` and `useWaitRequestn`.

```scala
object AvalonMMSlaveFactory {
  def getAvalonConfig( addressWidth : Int,
                       dataWidth : Int) = {
    AvalonMMConfig.pipelined(   // Create a simple pipelined configuration of the Avalon Bus
      addressWidth = addressWidth,
      dataWidth = dataWidth
    ).copy(                     // Change some parameters of the configuration
      useByteEnable = false,
      useWaitRequestn = false
    )
  }

  def apply(bus : AvalonMM) = new AvalonMMSlaveFactory(bus)
}
```

--------------------------------

### Scala ResetCtrl asyncAssertSyncDeassertDrive Function

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/utils.rst

Shows the ResetCtrl.asyncAssertSyncDeassertDrive function in Scala, which directly assigns the filtered reset value to a clock domain's reset. This is an alternative to asyncAssertSyncDeassert for immediate application.

```scala
// Example usage would typically involve calling ResetCtrl.asyncAssertSyncDeassertDrive
// ResetCtrl.asyncAssertSyncDeassertDrive(inputSignal, clockDomain)
```

--------------------------------

### SpinalHDL TileLink CpuFiber Master Integration

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/Bus/tilelink/tilelink_fabric.rst

An example of a master integration component (CpuFiber) that defines downward-facing TileLink nodes. It forces specific bus parameters and defines the traffic and source IDs for master agents. It also sets supported slave-initiated requests to none.

```scala
import spinal.lib.bus.tilelink
import spinal.core.fiber.Fiber

class CpuFiber extends Area {
  // Define a node facing downward (toward slaves only)
  val down = tilelink.fabric.Node.down()

  val fiber = Fiber build new Area {
    // Here we force the bus parameters to a specific configurations.
    down.m2s forceParameters tilelink.M2sParameters(
      addressWidth = 32,
      dataWidth = 64,
      // We define the traffic of each master using this node. (one master => one M2sAgent).
      // In our case, there is only the CpuFiber.
      masters = List(
        tilelink.M2sAgent(
          name = CpuFiber.this, // Reference to the original agent.
          // A agent can use multiple sets of source ID for different purposes.
          // Here we define the usage of every sets of source ID.
          // In our case, let's say we use ID [0-3] to emit get/putFull requests.
          mapping = List(
            tilelink.M2sSource(
              id = SizeMapping(0, 4),
              emits = M2sTransfers(
                // Meaning the get access can be any power of 2 size in [1, 64].
                get = tilelink.SizeRange(1, 64), 
                putFull = tilelink.SizeRange(1, 64)
              )
            )
          )
        )
      )
    )

    // Let's say the CPU doesn't support any slave initiated requests (memory coherency).
    down.s2m.supported load tilelink.S2mSupport.none()

    // Then we can generate some hardware (nothing useful in this example)
    down.bus.a.setIdle()
    down.bus.d.ready := True
  }
}
```

--------------------------------

### ReadOnly Version (ROV) Register Usage

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/regIf.rst

Shows how to use the ReadOnly Version (ROV) register type for solidified version information in ASIC designs. ROV registers are not expected to generate wire signals and are defined directly with their value and name.

```scala
val version = M_REG0.field(Bits(32 bit), RO, 0, "xx-device version")
version := BigInt("F000A801", 16)
```

```scala
M_REG0.field(Bits(32 bit), ROV, BigInt("F000A801", 16), "xx-device version")(Symbol("Version"))
```

--------------------------------

### StreamFifoCC Component

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/stream.rst

The StreamFifoCC component is a dual-clock domain version of the StreamFifo. It allows for buffered stream communication between different clock domains.

```APIDOC
## StreamFifoCC Component

### Description
A dual-clock domain FIFO component for buffered stream communication between different clock domains.

### Instantiation Example
```scala
val clockA = ClockDomain(???) // Define ClockDomain A
val clockB = ClockDomain(???) // Define ClockDomain B
val streamA, streamB = Stream(Bits(8 bits))
// ...
val myFifo = StreamFifoCC(
  dataType  = Bits(8 bits),
  depth     = 128,
  pushClock = clockA,
  popClock  = clockB
)
myFifo.io.push << streamA
myFifo.io.pop  >> streamB
```

### Parameters
- **dataType** (T) - Payload data type.
- **depth** (Int) - Size of the memory used to store elements.
- **pushClock** (ClockDomain) - The clock domain used by the push side.
- **popClock** (ClockDomain) - The clock domain used by the pop side.

### IO Signals
- **push** (Stream[T]) - Used to push elements into the FIFO.
- **pop** (Stream[T]) - Used to pop elements from the FIFO.
- **pushOccupancy** (UInt) - Indicates the internal memory occupancy from the push side perspective. The width is `log2Up(depth + 1)` bits.
- **popOccupancy** (UInt) - Indicates the internal memory occupancy from the pop side perspective. The width is `log2Up(depth + 1)` bits.
```

--------------------------------

### Find All Adders Manually in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Developers area/spinalhdl_datamodel.rst

This SpinalHDL code snippet demonstrates how to manually traverse the component, statement, and expression tree to identify all adder operations within a netlist. It defines a custom compilation phase `PrintBaseTypes` that recursively visits components, statements, and expressions, printing details when an `Operator.BitVector.Add` is encountered. This approach highlights the underlying structure before introducing shortcuts.

```scala
object FindAllAddersManually {
  class Toplevel extends Component {
    val a,b,c = in UInt(8 bits)
    val result = out(a + b + c)
  }

  import spinal.core.internals._

  class PrintBaseTypes(message : String) extends Phase {
    override def impl(pc: PhaseContext) = {
      println(message)

      recComponent(pc.topLevel)

      def recComponent(c: Component): Unit = {
        c.children.foreach(recComponent)
        c.dslBody.foreachStatements(recStatement)
      }

      def recStatement(s: Statement): Unit = {
        s.foreachExpression(recExpression)
        s match {
          case ts: TreeStatement => ts.foreachStatements(recStatement)
          case _ =>
        }
      }

      def recExpression(e: Expression): Unit = {
        e match {
          case op: Operator.BitVector.Add => println(s"Found ${op.left} + ${op.right}")
          case _ =>
        }
        e.foreachExpression(recExpression)
      }

    }
    override def hasNetlistImpact = false

    override def toString = s"${super.toString} - $message"
  }

  def main(args: Array[String]): Unit = {
    val config = SpinalConfig()

    // Add a early phase
    config.addTransformationPhase(new PrintBaseTypes("Early"))

    // Add a late phase
    config.phasesInserters += {phases =>
      phases.insert(phases.indexWhere(_.isInstanceOf[PhaseVerilog]), new PrintBaseTypes("Late"))
    }
    config.generateVerilog(new Toplevel())
  }
}
```

--------------------------------

### Clean Docs with Docker

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/README.rst

This command demonstrates how to execute a 'make clean' target within the previously built 'spinaldoc-rtd' Docker container. It mounts the current directory to '/docs' to ensure any temporary build files are cleaned from the host system's perspective.

```shell
docker run -it --rm -v $PWD:/docs spinaldoc-rtd make clean
```

--------------------------------

### Define Binary Prefixes in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Other language features/utils.rst

SpinalHDL supports defining integer numbers using binary prefix notation according to IEC standards. This is particularly useful for memory size definitions, inferring BigInt types. BigInt values can also be printed in byte units.

```scala
val memSize = 512 MiB      // infers type BigInt
val dpRamSize = 4 KiB      // infers type BigInt
```

```scala
val memSize = 512 MiB
 
println(memSize)
>> 536870912 

println(memSize.byteUnit)
>> 512MiB

val dpRamSize = BigInt("123456789", 16)

println(dpRamSize.byteUnit())
>> 4GiB+564MiB+345KiB+905Byte

println((32.MiB + 12.KiB + 223).byteUnit())
>> 32MiB+12KiB+223Byte

println((32.MiB + 12.KiB + 223).byteUnit(ceil = true))
>> 33~MiB
```

--------------------------------

### Simulate Combinational Adder in Scala

Source: https://context7.com/spinalhdl/spinaldoc-rtd/llms.txt

This snippet demonstrates simulating a simple 8-bit adder component. It uses SpinalHDL's simulation API to drive inputs, wait for results, and assert correctness. The simulation includes test cases for all possible input combinations and specific value checks.

```scala
import spinal.core._
import spinal.core.sim._
import spinal.lib._

// Hardware design to simulate
class Adder extends Component {
  val io = new Bundle {
    val a = in UInt(8 bits)
    val b = in UInt(8 bits)
    val result = out UInt(8 bits)
  }
  io.result := io.a + io.b
}

// Simulation testbench written in Scala
object AdderSim extends App {
  SimConfig.withWave.doSim(new Adder) {
    dut =>
      // Fork background thread for clock
      val clockThread = fork {
        dut.clockDomain.forkStimulus(period = 10)
      }

      // Test multiple input combinations
      for(a <- 0 to 255; b <- 0 to 255) {
        dut.io.a #= a                    // Drive input a
        dut.io.b #= b                    // Drive input b
        sleep(1)                         // Wait 1 time unit
        assert(dut.io.result.toInt == ((a + b) & 0xFF))
      }

      // Test with delays
      dut.io.a #= 10
      dut.io.b #= 20
      dut.clockDomain.waitSampling()     // Wait for clock edge
      assert(dut.io.result.toInt == 30)

      println("Simulation passed")
  }
}
```

--------------------------------

### Use TriStateArray Bundle in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/IO/tristate.rst

An example demonstrating the usage of the TriStateArray bundle in SpinalHDL. It shows how to instantiate the bundle and control individual output enables via the Bits 'writeEnable' signal.

```scala
val io = new Bundle {
  val dataBus = master(TriStateArray(32 bits))
}

io.dataBus.writeEnable := 0x87654321
io.dataBus.write := 0x12345678
when(io.dataBus.read === 42) {

}
```

--------------------------------

### Define a Clock Domain in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Structuring/clock_domain.rst

Demonstrates the basic syntax for defining a clock domain in SpinalHDL, specifying clock and reset signals. This is fundamental for creating reusable clocking structures.

```scala
ClockDomain(
  clock: Bool 
  [,reset: Bool]
  [,softReset: Bool]
  [,clockEnable: Bool]
  [,frequency: IClockDomainFrequency]
  [,config: ClockDomainConfig]
)
```

--------------------------------

### SpinalHDL Bit Vector Concatenation

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/bits.rst

Demonstrates the concatenation operator `##` in SpinalHDL for combining two bit vectors into a single larger bit vector, with the first operand becoming the most significant bits.

```scala
   // Concatenate, x->high, y->low
   val concatenatedBits = x ## y
```

--------------------------------

### Allow Unset Register for Init in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Design errors/unassigned_register.rst

Addresses the 'UNASSIGNED REGISTER' error for registers with an 'init' statement but no explicit assignment. The solution uses '.allowUnsetRegToAvoidLatch' to inform SpinalHDL that the register can be combinational if no assignment occurs.

```scala
class TopLevel extends Component {
  val result = out(UInt(8 bits))
  val a = Reg(UInt(8 bits)) init(42)

  if(something)
    a := somethingElse
  result := a
}
```

```text
UNASSIGNED REGISTER (toplevel/a :  UInt[8 bits]), defined at
  ***
  Source file location of the toplevel/a definition via the stack trace
  ***
```

```scala
class TopLevel extends Component {
  val result = out(UInt(8 bits))
  val a = Reg(UInt(8 bits)).init(42).allowUnsetRegToAvoidLatch

  if(something)
    a := somethingElse
  result := a
}
```

--------------------------------

### Vec Comparison and Type Casting in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/Vec.rst

Illustrates how to perform equality (===) and inequality (=/=/=) comparisons between two Vec instances in SpinalHDL, which compares all elements. It also shows how to cast a Vec to its bit representation using .asBits.

```scala
// Create a vector of 2 signed integers
   val vec2 = Vec.fill(2)(SInt(8 bits))
   val vec1 = Vec.fill(2)(SInt(8 bits))

   myBool := vec2 === vec1  // Compare all elements
   // is equivalent to:
   // myBool := vec2(0) === vec1(0) && vec2(1) === vec1(1)

   // Create a vector of 2 signed integers
   val vec1 = Vec.fill(2)(SInt(8 bits))

   myBits_16bits := vec1.asBits
```

--------------------------------

### Structured Reporting for Complex Data Types in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Other language features/report.rst

Details how to implement structured reporting for complex data types like `Bundle`s in SpinalHDL (since version 1.12.2) by using the `Formattable` trait. This allows defining a custom `format()` method for nested reporting of intricate data structures.

```scala
trait Formattable {
  def format(): Seq[Any]
}

case class DataPayload() extends Bundle with Formattable {
  val value = UInt(16 bits)
  val checksum = UInt(8 bits)
  override def format(): Seq[Any] = Seq(L"DataPayload(value=0x${value}, checksum=0x${checksum})")
}
```

```scala
case class PacketHeader() extends Bundle with Formattable {
  val packetLength = UInt(8 bits)
  val packetType = UInt(4 bits)
  val payload = DataPayload()
  override def format(): Seq[Any] = Seq(
    L"PacketHeader(",
    L"packetLength=0x${packetLength},",
    L" packetType=0x${packetType},",
    L" payload=${payload.format},", 
    L")"
  ).flatten
}
```

```scala
class MyComponent extends Component {
  val io = PacketHeader() 
  report(io.format)
}
```

```text
PacketHeader(packetLength=0x0c, packetType=0x1, payload=DataPayload(value=0x5678, checksum=0x78))
```

--------------------------------

### Instantiate BlackBox and Connect Signals in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Structuring/blackbox.rst

Shows how to instantiate a BlackBox (Ram_1w_1r) within a SpinalHDL Component (TopLevel) and connect its signals to the top-level IO. The instantiation process is similar to instantiating any other SpinalHDL Component, followed by signal mapping.

```scala
// Create the top level and instantiate the Ram
class TopLevel extends Component {
  val io = new Bundle {
    val wr = new Bundle {
      val en   = in Bool()
      val addr = in UInt (log2Up(16) bits)
      val data = in Bits (8 bits)
    }
    val rd = new Bundle {
      val en   = in Bool()
      val addr = in UInt (log2Up(16) bits)
      val data = out Bits (8 bits)
    }
  }

  // Instantiate the blackbox
  val ram = new Ram_1w_1r(8,16)

  // Connect all the signals
  io.wr.en   <> ram.io.wr.en
  io.wr.addr <> ram.io.wr.addr
  io.wr.data <> ram.io.wr.data
  io.rd.en   <> ram.io.rd.en
  io.rd.addr <> ram.io.rd.addr
  io.rd.data <> ram.io.rd.data
}

object Main {
  def main(args: Array[String]): Unit = {
    SpinalVhdl(new TopLevel)
  }
}
```

--------------------------------

### Detect Combinatorial Loop in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Design errors/combinatorial_loop.rst

This Scala code demonstrates a combinatorial loop in SpinalHDL. The loop is formed by circular dependencies between signals 'a', 'b', and 'd'. SpinalHDL will detect this and report an error.

```scala
class TopLevel extends Component {
  val a = UInt(8 bits)
  val b = UInt(8 bits)
  val c = UInt(8 bits)
  val d = UInt(8 bits)

  a := b
  b := c | d
  d := a
  c := 0
}
```

--------------------------------

### SpinalHDL Pipeline: Advanced NodesBuilder Example

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/Pipeline/introduction.rst

Illustrates an advanced SpinalHDL pipeline using NodesBuilder for more integrated node management and stage generation. This approach simplifies the connection and arbitration logic for pipeline stages.

```scala
import spinal.core._
import spinal.core.sim._
import spinal.lib._
import spinal.lib.misc.pipeline._

class TopLevel extends Component {
  val VALUE = Payload(UInt(16 bits))

  val io = new Bundle {
    val up = slave Stream(VALUE)  // VALUE can also be used as a HardType
    val down = master Stream(VALUE)
  }
  
  // NodesBuilder will be used to register all the nodes created, connect them via stages and
  // generate the hardware.
  val builder = new NodesBuilder()

  // Let's define a Node which connect from io.up .
  val n0 = new builder.Node {
    arbitrateFrom(io.up)
    VALUE := io.up.payload
  }

  // Let's define a Node which do some processing.
  val n1 = new builder.Node {
    val RESULT = insert(VALUE + 0x1200)
  }

  //  Let's define a Node which connect to io.down.
  val n2 = new builder.Node {
    arbitrateTo(io.down)
    io.down.payload := n1.RESULT
  }

  // Let's connect those nodes by using registers stages and generate the related hardware.
  builder.genStagedPipeline()
}
```

--------------------------------

### StreamCCByToggle Component

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/stream.rst

The StreamCCByToggle component connects streams across clock domains using toggling signals. It is characterized by small area usage but also low bandwidth.

```APIDOC
## StreamCCByToggle Component

### Description
Connects streams across clock domains using toggling signals, offering small area usage and low bandwidth.

### Instantiation Example
```scala
val clockA = ClockDomain(???) // Define ClockDomain A
val clockB = ClockDomain(???) // Define ClockDomain B
val streamA, streamB = Stream(Bits(8 bits))
// ...
val bridge = StreamCCByToggle(
  dataType    = Bits(8 bits),
  inputClock  = clockA,
  outputClock = clockB
)
bridge.io.input  << streamA
bridge.io.output >> streamB
```

### Parameters
- **dataType** (T) - Payload data type.
- **inputClock** (ClockDomain) - The clock domain used by the input side.
- **outputClock** (ClockDomain) - The clock domain used by the output side.

### IO Signals
- **input** (Stream[T]) - The input stream connected to the `inputClock` domain.
- **output** (Stream[T]) - The output stream connected to the `outputClock` domain.
```

--------------------------------

### SpinalHDL JTAG Instruction Base Class

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Examples/Advanced ones/jtag.rst

Provides a base class for JTAG instructions, offering callbacks for capture, shift, update, and reset actions. This simplifies the implementation of new JTAG instructions by abstracting common logic and state management.

```scala
class JtagInstruction(val tap: JtagTapAccess, vallength: Int) extends Component {
  // end class JtagInstruction
}
```

--------------------------------

### Read/Write SpinalHDL Signals from Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Simulation/signal.rst

This snippet demonstrates how to read and write hardware signals (Bool, Bits, UInt, SInt, SpinalEnumCraft) from Scala during simulation. It covers conversions between hardware types and Scala primitives like Boolean, Int, Long, BigInt, and SpinalEnumElement. The assignment operators like '#=' are used for writing, and methods like '.toInt', '.toLong', '.toBigInt', and '.toEnum' are used for reading.

```scala
dut.io.a #= 42
dut.io.a #= 42l
dut.io.a #= BigInt("101010", 2)
dut.io.a #= BigInt("0123456789ABCDEF", 16)
println(dut.io.b.toInt)
```

--------------------------------

### Define APB3 Configuration Class in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Examples/Simple ones/apb3.rst

This code defines a Scala case class `Apb3Config` to represent the configuration options for an APB3 bus. It includes parameters for address width and selection width. This is a prerequisite for defining the APB3 bundle.

```scala
case class Apb3Config(
    addressWidth: Int,
    selWidth: Int
) extends Area
```

--------------------------------

### Companion Object Naming and Usage in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Getting Started/Scala Guide/coding_conventions.rst

Illustrates the convention for naming companion objects in SpinalHDL, which should start with an uppercase letter. It also shows an exception for objects used solely as functions without hardware generation.

```scala
object Fifo {
  def apply(that: Stream[Bits]): Stream[Bits] = {...}
}

object MajorityVote {
  def apply(that: Bits): UInt = {...}
}

object log2 {
  def apply(value: Int): Int = {...}
}
```

--------------------------------

### ReadOnly Value (RO) Register Usage

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/regIf.rst

Demonstrates the usage of the ReadOnly (RO) register type in SpinalHDL. RO registers do not create internal registers and require an external signal to drive their value. They are declared using `.field(..., RO, ...)`.

```scala
val io = new Bundle {
  val cnt = in UInt(8 bit)
}

val counter = M_REG0.field(UInt(8 bit), RO, 0, "counter")
counter :=  io.cnt
```

```scala
val xxstate = M_REG0.field(UInt(8 bit), RO, 0, "xx-ctrl state").asInput
```

```scala
val overflow = M_REG0.field(Bits(32 bit), RO, 0, "xx-ip parameter")
val ovfreg = Reg(32 bit)
overflow := ovfreg
```

```scala
val inc    = in Bool()
val counter = M_REG0.field(UInt(8 bit), RO, 0, "counter")
val cnt = Counter(100,  inc)
counter := cnt
```

--------------------------------

### Create Memory Mapped UART Controller with APB3 (Scala)

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Examples/Advanced ones/memory_mapped_uart.rst

Instantiates a UartCtrl component and creates the memory mapping logic to interface with the APB3 bus. This component exposes registers for clock division, frame configuration, and data read/write operations.

```scala
case class Apb3UartCtrl(
    uartCtrlParameter : UartCtrlParameter
) extends Component {
    val io = new Bundle {
        val apb = master(Apb3(Apb3UartCtrl.getApb3Config()))
        val uart = slave(UartCtrl(uartCtrlParameter))
    }

    val apbDecoder = new Apb3Decoder(io.apb.cmd.address)

    // APB3 slave factory
    val apb3SlaveFactory = Apb3SlaveFactory(io.apb, apbDecoder)

    // uartCtrl register mapping
    apb3SlaveFactory.drive(io.uart.config.clockDivider)
    apb3SlaveFactory.drive(io.uart.config.frame)
    apb3SlaveFactory.drive(io.uart.writeCmd)
    apb3SlaveFactory.read(io.uart.read)

    // end case class Apb3UartCtrl
```

--------------------------------

### AvalonMMConfig Definition in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/Bus/avalon/avalonmm.rst

Defines the configuration parameters for the AvalonMM bus. This includes widths for address, data, and burst count, as well as various boolean flags to enable/disable features like byte enables, debug access, read/write operations, response signals, locks, wait requests, read data valid signals, and burst counts. It also includes parameters for address and burst count units, burst behavior, timing, and pending transactions.

```scala
case class AvalonMMConfig(
  addressWidth : Int,
  dataWidth : Int,
  burstCountWidth : Int,
  useByteEnable : Boolean,
  useDebugAccess : Boolean,
  useRead : Boolean,
  useWrite : Boolean,
  useResponse : Boolean,
  useLock : Boolean,
  useWaitRequestn : Boolean,
  useReadDataValid : Boolean,
  useBurstCount : Boolean,
  // useEndOfPacket : Boolean,

  addressUnits : AddressUnits = symbols,
  burstCountUnits : AddressUnits = words,
  burstOnBurstBoundariesOnly : Boolean = false,
  constantBurstBehavior : Boolean = false,
  holdTime : Int = 0,
  linewrapBursts : Boolean = false,
  maximumPendingReadTransactions : Int = 1,
  maximumPendingWriteTransactions : Int = 0, // unlimited
  readLatency : Int = 0,
  readWaitTime : Int = 0,
  setupTime : Int = 0,
  writeWaitTime : Int = 0
)
```

--------------------------------

### Define Color Bundle with Addition Operator (Scala)

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Examples/Simple ones/color_summing.rst

Defines a Scala case class `Color` that represents a color with Red, Green, and Blue components. It includes an overloaded addition operator `+` to facilitate summing two `Color` instances. This is useful for hardware designs where color values might need to be aggregated.

```scala
case class Color(
    r: UInt,
    g: UInt,
    b: UInt
) {
  def +(that: Color) = {
    Color(
      r = (r + that.r) genericSize (r.getWidth.max(that.r.getWidth)),
      g = (g + that.g) genericSize (g.getWidth.max(that.g.getWidth)),
      b = (b + that.b) genericSize (b.getWidth.max(that.b.getWidth))
    )
  }
}
```

--------------------------------

### Run Multiple Tests in SpinalHDL Simulation

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Simulation/bootstraps.rst

This snippet demonstrates how to compile a design and run multiple distinct simulation tests sequentially. It utilizes the `SimConfig.compile` and `doSim` methods to manage test execution. No external dependencies are required beyond SpinalHDL's simulation framework.

```scala
val compiled = SimConfig.withWave.compile(new Dut)

compiled.doSim("testA") { dut =>
   // Simulation code here
}

compiled.doSim("testB") { dut =>
   // Simulation code here
}
```

--------------------------------

### StageLink for Buffered Node Connections in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/Pipeline/introduction.rst

Demonstrates the use of `StageLink` to connect two nodes (`n0` and `n1`) with registers for data/valid signals and arbitration on ready signals. This provides buffering between stages, helping to manage timing and data flow in a pipeline.

```scala
val c01 = StageLink(n0, n1)
```

--------------------------------

### Testbench Imports for SpinalSim

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Simulation/install/index.rst

Provides the necessary imports for using SpinalHDL's core and simulation functionalities within testbenches.

```scala
import spinal.core._
import spinal.core.sim._
```

--------------------------------

### Scala Function Definition with Explicit Return

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Getting Started/Scala Guide/basics.rst

Shows how to define a Scala function that takes two Float arguments and returns a Boolean indicating if their sum is greater than zero. Uses an explicit 'return' statement.

```scala
def sumBiggerThanZero(a: Float, b: Float): Boolean = {
  return (a + b) > 0
}
```

--------------------------------

### Define Pinsec System Clock Domains

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Legacy/pinsec/hardware_toplevel.rst

Defines the primary clock domains for the Pinsec SoC: axiClockDomain, coreClockDomain, vgaClockDomain, and jtagClockDomain. These are configured using the respective IO clocks and reset signals generated by the reset controller.

```scala
val axiClockDomain = ClockDomain(
  clock     = io.axiClk,
  reset     = resetCtrl.axiReset,
  frequency = FixedFrequency(50 MHz) // The frequency information is used by the SDRAM controller
)

val coreClockDomain = ClockDomain(
  clock = io.axiClk,
  reset = resetCtrl.coreReset
)

val vgaClockDomain = ClockDomain(
  clock = io.vgaClk,
  reset = resetCtrl.vgaReset
)

val jtagClockDomain = ClockDomain(
  clock = io.jtag.tck
)
```

--------------------------------

### Full Simple SpinalHDL Component Example

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Introduction/A simple example.rst

A complete example of a SpinalHDL component that includes port definitions and internal logic for a counter and flag.

```scala
case class MyTopLevel() extends Component {
  val io = new Bundle {
    val cond0 = in port Bool()
    val cond1 = in port Bool()
    val flag  = out port Bool()
    val state = out port UInt(8 bits)
  }

  val counter = Reg(UInt(8 bits)) init 0

  when(io.cond0) {
    counter := counter + 1
  }

  io.state := counter
  io.flag  := (counter === 0) | io.cond1
}
```

--------------------------------

### UART Decoder Simulation in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Simulation/examples/uart_decoder.rst

This Scala code simulates a UART decoder by forking a process that monitors a `uartPin`. It waits for the pin to go high (indicating reset release), then enters a loop to detect start bits, sample data bits, and detect stop bits. Transmitted bytes are reconstructed and printed to the simulation terminal. Dependencies include SpinalHDL's simulation utilities like `fork`, `waitUntil`, `sleep`, `assert`, and `print`. It expects a `uartPin` signal and a `baudPeriod` to be defined.

```scala
// Fork a simulation process which will analyze the uartPin and print transmitted bytes into the simulation terminal.
fork {
  // Wait until the design sets the uartPin to true (wait for the reset effect).
  waitUntil(uartPin.toBoolean == true)

  while(true) {
    waitUntil(uartPin.toBoolean == false)
    sleep(baudPeriod/2)

    assert(uartPin.toBoolean == false)
    sleep(baudPeriod)

    var buffer = 0
    for(bitId <- 0 to 7) {
      if(uartPin.toBoolean)
        buffer |= 1 << bitId
      sleep(baudPeriod)
    }

    assert(uartPin.toBoolean == true)
    print(buffer.toChar)
  }
}
```

--------------------------------

### Define RGB Color Structure (Scala)

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Examples/Intermediates ones/vga.rst

Defines a case class `RgbConfig` to represent a three-channel color structure (Red, Green, Blue). This is used for feeding pixels to the VGA controller and for the VGA bus output. It takes the bit width for each color channel as a parameter.

```scala
case class RgbConfig(rWidth: Int, gWidth: Int, bWidth: Int) {
  val r = UInt(rWidth bits)
  val g = UInt(gWidth bits)
  val b = UInt(bWidth bits)
}

```

--------------------------------

### Fix Clock Crossing Violation with crossClockDomain Tag - SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Design errors/clock_crossing_violation.rst

Illustrates how to resolve a clock crossing violation in SpinalHDL by applying the 'crossClockDomain' tag to a register. This tag explicitly informs the compiler that the clock crossing is intentional and safe.

```scala
class TopLevel extends Component {
  val clkA = ClockDomain.external("clkA")
  val clkB = ClockDomain.external("clkB")

  val regA = clkA(Reg(UInt(8 bits)))
  val regB = clkB(Reg(UInt(8 bits))).addTag(crossClockDomain)


  val tmp = regA + regA
  regB := tmp
}
```

--------------------------------

### Scala Definition for Valid Ready Payload Bus

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/miscelenea/core/core_components.rst

Defines a custom `MyBus` bundle in Scala that implements a Valid Ready Payload interface. It includes methods for connecting buses (`<<`) and integrating with a FIFO queue (`queue`).

```scala
class MyBus(payloadWidth:  Int) extends Bundle {
  val valid = Bool()
  val ready = Bool()
  val payload = Bits(payloadWidth bits)

  // connect that to this
  def <<(that: MyBus) : Unit = {
    this.valid := that.valid
    that.ready := this.ready
    this.payload := that.payload
  }

  // Connect this to the FIFO input, return the fifo output
  def queue(size: Int): MyBus = {
    val fifo = new Fifo(payloadWidth, size)
    fifo.io.push << this
    return fifo.io.pop
  }
}
```

--------------------------------

### Disable Combinatorial Loop Check in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Design errors/combinatorial_loop.rst

This Scala code demonstrates how to disable combinatorial loop checking for a specific signal in SpinalHDL. The '.noCombLoopCheck' attribute is appended to the signal declaration to prevent false positive loop detection.

```scala
class TopLevel extends Component {
  val a = UInt(8 bits).noCombLoopCheck
  a := 0
  a(1) := a(0)
}
```

--------------------------------

### Define SpinalHDL Components and Bundles as Case Classes

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Getting Started/Scala Guide/coding_conventions.rst

Demonstrates the preferred way to define SpinalHDL Components and Bundles using case classes. Case classes avoid the 'new' keyword, provide a 'clone' function useful for Reg and Stream instantiation, and make construction parameters directly visible.

```scala
class Fifo extends Component {

}

class Counter extends Area {

}

case class Color extends Bundle {

}
```

--------------------------------

### Subdivide and Concatenate Bits Vectors in SpinalHDL

Source: https://context7.com/spinalhdl/spinaldoc-rtd/llms.txt

Explains how to subdivide a large Bits vector into smaller slices for array-like access, including reverse order access and assignment through subdivisions. Also covers concatenation of multiple Bits vectors and resizing operations (auto, explicit, keeping MSB/LSB).

```Scala
// Subdivide into equal slices for array-like access
val sel = UInt(2 bits)
val myBitsWord = myBits_128bits.subdivideIn(32 bits)(sel)
// sel = 3 => myBitsWord = myBits_128bits(127 downto 96)
// sel = 2 => myBitsWord = myBits_128bits(95 downto 64)
// sel = 1 => myBitsWord = myBits_128bits(63 downto 32)
// sel = 0 => myBitsWord = myBits_128bits(31 downto 0)

// Reverse order access
val myVector = myBits_128bits.subdivideIn(32 bits).reverse
val myRevBitsWord = myVector(sel)

// Assign through subdivisions
val output8 = Bits(8 bit)
val pieces = output8.subdivideIn(2 slices)
pieces(0) := 0xf
pieces(1) := 0x5

// Concatenation
myBits_24bits := bits_8bits_1 ## bits_8bits_2 ## bits_8bits_3
// Or using Cat function
myBits_24bits := Cat(bits_8bits_1, bits_8bits_2, bits_8bits_3)

// Resize operations
myBits_32bits := B"32'x11223344"
myBits_8bits := myBits_32bits.resized           // Auto-resize, keeps LSB (0x44)
myBits_8bits := myBits_32bits.resize(8)         // Explicit 8-bit resize (0x44)
myBits_8bits := myBits_32bits.resizeLeft(8)     // Resize keeping MSB (0x11)
```

--------------------------------

### Scala ResetCtrl asyncAssertSyncDeassert Function

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/utils.rst

Illustrates the usage of ResetCtrl.asyncAssertSyncDeassert in Scala to filter an asynchronous reset signal, ensuring it is synchronously deasserted. This function helps in managing metastability by buffering the reset signal.

```scala
// Example usage would typically involve calling ResetCtrl.asyncAssertSyncDeassert with input signal and clockDomain
// val filteredReset = ResetCtrl.asyncAssertSyncDeassert(inputSignal, clockDomain)
```

--------------------------------

### Clone Unreleased SpinalHDL Version

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Introduction/faq.rst

This snippet demonstrates how to clone an unreleased version of SpinalHDL from a Git repository, specifically checking out the 'dev' branch. It uses `git clone --depth 1` for a shallow clone, saving disk space and download time. The command navigates into the cloned directory.

```sh
git clone --depth 1 -b dev https://github.com/SpinalHDL/SpinalHDL.git
cd SpinalHDL
```

--------------------------------

### Simulate with simSuccess() and Suspending doSim Thread in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Simulation/bootstraps.rst

An alternative method to `doSimUntilVoid` for simulating until `simSuccess()` is called. This example uses `doSim`, forks the clock stimulus, waits for a condition in a separate thread, calls `simSuccess()`, and then suspends the main `doSim` thread to prevent premature simulation exit.

```scala
SimConfig.compile(new TopLevel).doSim{ dut =>
  SimTimeout(1000)
  dut.clockDomain.forkStimulus(10)
  fork {
    dut.clockDomain.waitSamplingWhere(dut.counter.toInt == 20)
    println("done")
    simSuccess()
  }
  simThread.suspend() // Avoid the "doSim" completion
}
```

--------------------------------

### Create Slow Clock Domain Area with SlowArea in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Structuring/clock_domain.rst

Demonstrates how to create a new clock domain area that operates at a slower frequency than the current one using SlowArea. This is useful for managing different timing requirements within a component. The clock signal remains the same, but a clock-enable signal is added to slow the sampling rate.

```scala
class TopLevel extends Component {

  // Use the current clock domain : 100MHz
  val areaStd = new Area {
    val counter = out(CounterFreeRun(16).value)
  }

  // Slow the current clockDomain by 4 : 25 MHz
  val areaDiv4 = new SlowArea(4) {
    val counter = out(CounterFreeRun(16).value)
  }

  // Slow the current clockDomain to 50MHz
  val area50Mhz = new SlowArea(50 MHz) {
    val counter = out(CounterFreeRun(16).value)
  }
}

def main(args: Array[String]) {
  new SpinalConfig(
    defaultClockDomainFrequency = FixedFrequency(100 MHz)
  ).generateVhdl(new TopLevel)
}
```

--------------------------------

### Declare a Basic SpinalEnum

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/enum.rst

This snippet shows the fundamental way to declare an enumeration in SpinalHDL. It defines a list of named values. The default encoding is used, which is native for VHDL and binary for Verilog.

```scala
object Enumeration extends SpinalEnum {
  val element0, element1, ..., elementN = newElement()
}
```

--------------------------------

### Scala Case Class Example: Rectangle

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Getting Started/Scala Guide/basics.rst

Illustrates the use of Scala's 'case class' for defining a 'Rectangle' that extends 'Shape'. Case classes offer conciseness, automatic field accessors, and immutability. Benefits include less typing and improved code coherency.

```scala
case class Rectangle(width: Float, height: Float) extends Shape {
  override def getArea() = width * height
}
```

--------------------------------

### SpinalHDL: Example of an unassigned combinational signal (Scala)

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Design errors/no_driver_on.rst

Shows a SpinalHDL code snippet where a combinational signal 'a' is declared but not assigned a value, leading to the 'no driver' error. This highlights the scenario that triggers the check.

```scala
class TopLevel extends Component {
  val result = out(UInt(8 bits))
  val a = UInt(8 bits)
  result := a
}
```

--------------------------------

### CHeader Document Generation Example

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/regIf.rst

Example of generating a CHeader file for a register interface using `CHeaderGenerator`. This function takes the output name and a prefix as arguments.

```scala
busif.accept(CHeaderGenerator("header", "AP"))
```

--------------------------------

### StageCtrlPipeline for Controlled Hardware in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/Pipeline/introduction.rst

Demonstrates the StageCtrlPipeline for building hardware with arbitration and bypass capabilities. This example shows inserting inputs, summing them, checking the sum, and dropping transactions at specific stages.

```scala
// Let's define a few inputs/outputs.
val a,b = in UInt(8 bits)
val result = out(UInt(8 bits))

// Let's create the pipelining tool.
val pip = new StageCtrlPipeline

// Let's insert a and b into the pipeline at stage 0.
val A = pip.ctrl(0).insert(a)
val B = pip.ctrl(0).insert(b)

// Let's sum A and B at stage 1.
val onSum = new pip.Ctrl(1) {
  val VALUE = insert(A + B)
}
```

--------------------------------

### SpinalHDL BusSlaveFactory: Primitive Storage Elements

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Developers area/bus_slave_factory_impl.rst

This snippet defines several case classes that extend `BusSlaveFactoryElement` for managing primitives within the SpinalHDL bus system. These classes represent read operations, write operations, and callback functions triggered by bus events (onWrite, onRead). They are used to declare how data should be accessed and manipulated via the bus interface. These are foundational for building register-access logic.

```scala
trait BusSlaveFactoryElement

   // Ask to make `that` readable when a access is done on `address`.
   // bitOffset specify where `that` is placed on the answer
   case class BusSlaveFactoryRead(that : Data,
                                  address : BigInt,
                                  bitOffset : Int) extends BusSlaveFactoryElement

   // Ask to make `that` writable when a access is done on `address`.
   // bitOffset specify where `that` get bits from the request
   case class BusSlaveFactoryWrite(that : Data,
                                   address : BigInt,
                                   bitOffset : Int) extends BusSlaveFactoryElement

   // Ask to execute `doThat` when a write access is done on `address`
   case class BusSlaveFactoryOnWrite(address : BigInt,
                                     doThat : () => Unit) extends BusSlaveFactoryElement

   // Ask to execute `doThat` when a read access is done on `address`
   case class BusSlaveFactoryOnRead( address : BigInt,
                                     doThat : () => Unit) extends BusSlaveFactoryElement

   // Ask to constantly drive `that` with the data bus
   // bitOffset specify where `that` get bits from the request

```

--------------------------------

### APB Bundle with IMasterSlave in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Developers area/types.rst

An example of an APB bus bundle that extends `IMasterSlave`, simplifying the master/slave interface setup. It overrides the `asMaster` function to define the interface signals.

```scala
// You need to import spinal.lib._ to use IMasterSlave
   import spinal.core._
   import spinal.lib._

   case class APBConfig(addressWidth: Int,
                        dataWidth: Int,
                        selWidth : Int,
                        useSlaveError : Boolean)

   class APB(val config: APBConfig) extends Bundle with IMasterSlave {
     val PADDR      = UInt(addressWidth bits)
     val PSEL       = Bits(selWidth bits)
     val PENABLE    = Bool()
     val PREADY     = Bool()
     val PWRITE     = Bool()
     val PWDATA     = Bits(dataWidth bits)
     val PRDATA     = Bits(dataWidth bits)
     val PSLVERROR  = if(useSlaveError) Bool() else null   // This signal is created only when useSlaveError is true

     override def asMaster() : Unit = {
       out(PADDR,PSEL,PENABLE,PWRITE,PWDATA)
       in(PREADY,PRDATA)
       if(useSlaveError) in(PSLVERROR)
     }
     // The asSlave is by default the flipped version of asMaster.
   }
```

--------------------------------

### Hardware Generation with Builder in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/Pipeline/introduction.rst

Demonstrates how to use the Builder to generate hardware for a pipeline by providing a list of used links. This example connects nodes using StageLink and then invokes the Builder to create the necessary hardware.

```scala
// Let's define 3 Nodes for our pipeline
val n0, n1, n2 = Node()

// Let's connect those nodes by using simples registers
val s01 = StageLink(n0, n1)
val s12 = StageLink(n1, n2)

// Let's ask the builder to generate all the required hardware
Builder(s01, s12)
```

--------------------------------

### SpinalHDL Bit Subdivision using subdivideIn

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/bits.rst

Shows how to use the `subdivideIn` method to split a bit vector into slices. It covers subdivision into a fixed number of slices or slices of a fixed bit width, with an optional strictness parameter.

```scala
   // Subdivide
   val sel = UInt(2 bits)
   val myBitsWord = myBits_128bits.subdivideIn(32 bits)(sel)
       // sel = 3 => myBitsWord = myBits_128bits(127 downto 96)
       // sel = 2 => myBitsWord = myBits_128bits( 95 downto 64)
       // sel = 1 => myBitsWord = myBits_128bits( 63 downto 32)
       // sel = 0 => myBitsWord = myBits_128bits( 31 downto  0)

    // If you want to access in reverse order you can do:
    val myVector   = myBits_128bits.subdivideIn(32 bits).reverse
    val myRevBitsWord = myVector(sel)

    // We can also assign through subdivides
    val output8 = Bits(8 bit)
    val pieces = output8.subdivideIn(2 slices)
    // assign to output8
    pieces(0) := 0xf
    pieces(1) := 0x5
```

--------------------------------

### Sphinx Top-Level Index File Update

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Developers area/howtodocument.rst

This reStructuredText (ReST) code shows how to update the top-level index file in Sphinx documentation to include a new section. It uses the toctree directive with :maxdepth: and :titlesonly: to manage the inclusion of the new 'Cheese' section.

```rst
Welcome to SpinalHDL's documentation!
=====================================

.. toctree::
   :maxdepth: 2
   :titlesonly:

   rst/About SpinalHDL/index
   rst/Getting Started/index
   rst/Data types/index
   rst/Structuring/index
   rst/Semantic/index
   rst/Sequential logic/index
   rst/Design errors/index
   rst/Other language features/index
   rst/Libraries/index
   rst/Simulation/index
   rst/Examples/index
   rst/Legacy/index
   rst/Developers area/index
   rst/Cheese/index
```

--------------------------------

### Parameterize Hardware Component with BitWidth in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Structuring/components_hierarchy.rst

Shows how to create a parameterized hardware component 'MyAdder' in SpinalHDL using Scala's class constructor. The 'width' parameter allows the adder to operate on different bit-widths, promoting reusability. The example also demonstrates how to instantiate this parameterized component with a specific bit-width.

```scala
class MyAdder(width: 	BitCount) extends Component {
  val io = new Bundle {
    val a, b   = in port UInt(width)
    val result = out port UInt(width)
  }
  io.result := 	io.a + 	io.b
}

object Main {
  def main(args: Array[String]) {
    SpinalVhdl(new MyAdder(32 bits))
  }
}
```

--------------------------------

### Configure SpinalHDL RiscvAxi4 CPU Core

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Legacy/pinsec/hardware_toplevel.rst

Defines the configuration parameters for a RiscvAxi4 CPU core, including cache settings and optional extensions. This configuration is used during the CPU instantiation.

```scala
val coreConfig = CoreConfig(
  pcWidth = 32,
  addrWidth = 32,
  startAddress = 0x00000000,
  regFileReadyKind = sync,
  branchPrediction = dynamic,
  bypassExecute0 = true,
  bypassExecute1 = true,
  bypassWriteBack = true,
  bypassWriteBackBuffer = true,
  collapseBubble = false,
  fastFetchCmdPcCalculation = true,
  dynamicBranchPredictorCacheSizeLog2 = 7
)

// The CPU has a systems of plugin which allow to add new feature into the core.
// Those extension are not directly implemented into the core, but are kind of additive logic patch defined in a separated area.
coreConfig.add(new MulExtension)
coreConfig.add(new DivExtension)
coreConfig.add(new BarrelShifterFullExtension)

val iCacheConfig = InstructionCacheConfig(
  cacheSize =4096,
  bytePerLine =32,
  wayCount = 1,  // Can only be one for the moment
  wrappedMemAccess = true,
  addressWidth = 32,
  cpuDataWidth = 32,
  memDataWidth = 32
)

// There is the instantiation of the CPU by using all those construction parameters
new RiscvAxi4(
  coreConfig = coreConfig,
  iCacheConfig = iCacheConfig,
  dCacheConfig = null,
  debug = true,
  interruptCount = 2
)
```

--------------------------------

### Simulate until Main Thread Completes in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Simulation/bootstraps.rst

A SpinalHDL simulation template using `doSim` where the simulation concludes when the main stimulus thread finishes execution. It includes setting a simulation timeout, forking a clock stimulus, and waiting for a specific counter value before printing 'done'.

```scala
SimConfig.compile(new TopLevel).doSim { dut =>
  SimTimeout(1000)
  dut.clockDomain.forkStimulus(10)
  dut.clockDomain.waitSamplingWhere(dut.counter.toInt == 20)
  println("done")
}
```

--------------------------------

### Implement Fractal Pixel Solver Component - Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Examples/Intermediates ones/fractal.rst

Implements the PixelSolver component which handles the fractal calculation. It receives PixelTask streams and produces PixelResult streams without pipelining or multi-threading.

```scala
case class PixelSolver(
    generics: PixelSolverGenerics
) extends Component {
  import generics._

  val cmd = slave Stream (PixelTask(fixType()))
  val rsp = master Stream (PixelResult(iterationType()))

  val logic = new Area {
    val mandelbrotArea = new Area {
      val x = cmd.payload.x
      val y = cmd.payload.y

      val iteration = {
        val mst = Reg(iterationType()) init (0)
        val c = Reg(Bool) init (False)
        val cr = Reg(fixType()) init (0)
        val ci = Reg(fixType()) init (0)
        val a = Reg(fixType()) init (0)
        val b = Reg(fixType()) init (0)
        val j = Reg(fixType()) init (0)

        val maxIterations = 1024

        when(c) {
          cr := x
          ci := y
          mst := 0
          c := False
          a := 0
          b := 0
          j := 0
        }
          .elsewhen(
            (a * a + b * b) < {
              val mstMagSq = Reg(fixType()) init (0)
              mstMagSq := mst
              mstMagSq
            }
              && mst < maxIterations
          ) {
            val a2 = a * a
            val b2 = b * b
            val ab2 = (a + b).fake * (a + b).fake
            a := a2 - b2 + cr
            b := ab2 - a2 - b2 + ci
            mst := mst + 1
          }
          .otherwise {
            c := True
          }

        mst
      }
      when(cmd.valid) {
        c := True
      }

      rsp.payload.iteration := iteration
      rsp.valid := c
      cmd.ready := !c
    }
  }
}
```

--------------------------------

### Clock Domain Crossing with Manual Register Staging (IO)

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Structuring/clock_domain.rst

This example shows how to perform a clock domain crossing by manually instantiating two registers clocked by the destination clock domain. It uses the `crossClockDomain` tag to indicate the crossing. This implementation assumes clock and reset pins are provided by the component's IO. Dependencies include `Component`, `Bundle`, `in`, `out`, `Bool`, `ClockDomain`, `ClockingArea`, `RegNext`, and `addTag` with `crossClockDomain`.

```scala
// Implementation where clock and reset pins are given by components' IO
class CrossingExample extends Component {
  val io = new Bundle {
    val clkA = in Bool()
    val rstA = in Bool()

    val clkB = in Bool()
    val rstB = in Bool()

    val dataIn  = in Bool()
    val dataOut = out Bool()
  }

  // sample dataIn with clkA
  val area_clkA = new ClockingArea(ClockDomain(io.clkA,io.rstA)) {
    val reg = RegNext(io.dataIn) init(False)
  }

  // 2 register stages to avoid metastability issues
  val area_clkB = new ClockingArea(ClockDomain(io.clkB,io.rstB)) {
    val buf0   = RegNext(area_clkA.reg) init(False) addTag(crossClockDomain)
    val buf1   = RegNext(buf0)          init(False)
  }

  io.dataOut := area_clkB.buf1
}
```

--------------------------------

### Concatenating Boolean Signals in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/bool.rst

Combines multiple boolean signals into a single `Bits` type using the `##` operator. The order of concatenation determines the bit ordering, with the left operand becoming the most significant bits.

```scala
val a, b, c = Bool()

// Concatenation of three Bool into a single Bits(3 bits) type
val myBits = a ## b ## c
```

--------------------------------

### Apply Clock Domain to BlackBox Ports (Scala)

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Structuring/blackbox.rst

This snippet demonstrates how to apply the current clock domain to all ports of a BlackBox component in SpinalHDL. It ensures that the BlackBox interfaces are correctly synchronized with the surrounding hardware design. This is achieved by instantiating the BlackBox and then applying the ClockDomainTag to its IO bundle.

```scala
      val io = new Bundle {
        val clk, rst = in Bool()
        val a = in Bool()
        val b = out Bool()
      }
      ClockDomainTag(this.clockDomain)(io)
```

```scala
      val io = new Bundle {
        val clk, rst = in Bool()
        val a = in Bool()
        val b = out Bool()
      }
      setIoCd()
```

--------------------------------

### Define an Identity Component in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Simulation/bootstraps.rst

Defines a simple SpinalHDL component named 'Identity' that takes 'n' bits as input and outputs the same 'n' bits. This serves as a basic hardware building block for simulation.

```scala
import spinal.core._

// Identity takes n bits in a and gives them back in z
class Identity(n: Int) extends Component {
  val io = new Bundle {
    val a = in Bits(n bits)
    val z = out Bits(n bits)
  }

  io.z := io.a
}
```

--------------------------------

### APB Bundle Definition in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Developers area/types.rst

Defines the APB bus bundle with configurable parameters for address width, data width, select width, and slave error usage. It includes methods to configure the bundle as a master or slave interface.

```scala
class APB(val config: APBConfig) extends Bundle {
     val PADDR      = UInt(config.addressWidth bits)
     val PSEL       = Bits(config.selWidth bits)
     val PENABLE    = Bool()
     val PREADY     = Bool()
     val PWRITE     = Bool()
     val PWDATA     = Bits(config.dataWidth bits)
     val PRDATA     = Bits(config.dataWidth bits)
     val PSLVERROR  = if(config.useSlaveError) Bool() else null

     def asMaster(): this.type = {
       out(PADDR,PSEL,PENABLE,PWRITE,PWDATA)
       in(PREADY,PRDATA)
       if(config.useSlaveError) in(PSLVERROR)
       this
     }

     def asSlave(): this.type = this.asMaster().flip() // Flip reverse all in out configuration.
   }
```

--------------------------------

### Define PixelTask and PixelResult Bundles - Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Examples/Intermediates ones/fractal.rst

Defines the data bundles for pixel tasks and results. PixelTask contains 'x' and 'y' coordinates as SFix, while PixelResult contains the 'iteration' count as UInt. These bundles facilitate communication between components.

```scala
case class PixelTask(
    x: SFix,
    y: SFix
)

case class PixelResult(
    iteration: UInt
)
```

--------------------------------

### SpinalHDL Simple Plugin Composition Example

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/Misc/service_plugin.rst

A basic example of composing hardware using plugins. It defines a SubComponent with a PluginHost, a StatePlugin to create a register, and a DriverPlugin to increment that register. The TopLevel component instantiates these and embeds the plugins into the SubComponent's host.

```scala
import spinal.core._
import spinal.lib.misc.plugin._

// Let's define a Component with a PluginHost instance
class SubComponent extends Component {
  val host = new PluginHost()
}

// Let's define a plugin which create a register
class StatePlugin extends FiberPlugin {
  // during build new Area { body } will run the body of code in the Fiber build phase, in the context of the PluginHost
  val logic = during build new Area {
    val signal = Reg(UInt(32 bits))
  }
}

// Let's define a plugin which will make the StatePlugin's register increment
class DriverPlugin extends FiberPlugin {
  // We define how to get the instance of StatePlugin.logic from the PluginHost. It is a lazy val, because we can't evaluate it until the plugin is bound to its host.
  lazy val sp = host[StatePlugin].logic.get

  val logic = during build new Area {
    // Generate the increment hardware
    sp.signal := sp.signal + 1
  }
}

class TopLevel extends Component {
  val sub = new SubComponent()

  // Here we create plugins and embed them in sub.host
  new DriverPlugin().setHost(sub.host)
  new StatePlugin().setHost(sub.host)
}
```

--------------------------------

### Conditional Logic based on Boolean Value in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/bool.rst

Demonstrates how to use `when` statements with boolean signals for conditional logic. This is equivalent to comparing the boolean with `True` or `False`.

```scala
when(myBool) { // Equivalent to when(myBool === True)
    // do something when myBool is True
}

when(!myBool) { // Equivalent to when(myBool === False)
    // do something when myBool is False
}
```

--------------------------------

### Testbench for Simple 8-bit CPU in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/Pipeline/introduction.rst

Provides a testbench for the simple 8-bit CPU implemented in SpinalHDL. It uses SimConfig to compile and simulate the CPU, defining instructions and memory setup, and includes stimulus generation for the clock domain.

```scala
SimConfig.withFstWave.compile(new Cpu).doSim(seed = 2){
    dut =>
    def nop() = BigInt(0)
    def add(value: Int) = BigInt(1 | (value << 8))
    def jump(target: Int) = BigInt(2 | (target << 8))
    def led() = BigInt(3)
    def delay(cycles: Int) = BigInt(4 | (cycles << 8))
    val mem = dut.fetcher.mem
    mem.setBigInt(0, nop())
    mem.setBigInt(1, nop())
    mem.setBigInt(2, add(0x1))
    mem.setBigInt(3, led())
    mem.setBigInt(4, delay(16))
    mem.setBigInt(5, jump(0x2))

    dut.clockDomain.forkStimulus(10)
    dut.clockDomain.waitSampling(100)
  }
```

--------------------------------

### Scala Variable Declaration and Assignment

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Getting Started/Scala Guide/basics.rst

Demonstrates how to declare and assign values to mutable variables ('var') in Scala. It shows both explicit type declaration and type inference. Note that 'var' is less common than 'val' in Scala.

```scala
var number : Int = 0
number = 6
number += 4
println(number) // 10
```

```scala
var number = 0   // The type of 'number' is inferred as an Int during compilation.
```

--------------------------------

### SpinalHDL Type Casting to Bits, UInt, SInt, Bools

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/bits.rst

Demonstrates casting various data types (Bits, UInt, SInt) to different representations like Bits, SInt, UInt, and Bools. It includes examples of resizing casts and casting to a vector of Bools.

```scala
   // cast a Bits to SInt
   val mySInt = myBits.asSInt

   // create a Vector of bool
   val myVec = myBits.asBools

   // Cast a SInt to Bits
   val myBits = B(mySInt)

   // Cast the same SInt to Bits but resize to 3 bits
   //  (will expand/truncate as necessary, retaining LSB)
   val myBits = B(mySInt, 3 bits)
```

--------------------------------

### Scala Component for VHDL Generation

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/miscelenea/core/core_components.rst

A simple SpinalHDL component `MyTopLevel` that performs a logical AND operation on two boolean inputs and outputs the result. The `MyMain` object demonstrates how to instantiate this component and generate the corresponding VHDL code.

```scala
// spinal.core contain all basics (Bool, UInt, Bundle, Reg, Component, ..)
import spinal.core._

// A simple component definition
class MyTopLevel extends Component {
  // Define some input/output. Bundle like a VHDL record or a verilog struct.
  val io = new Bundle {
    val a = in Bool()
    val b = in Bool()
    val c = out Bool()
  }

  // Define some asynchronous logic
  io.c := io.a & io.b
}

// This is the main of the project. It create a instance of MyTopLevel and
// call the SpinalHDL library to flush it into a VHDL file.
object MyMain {
  def main(args: Array[String]) {
    SpinalVhdl(new MyTopLevel)
  }
}
```

--------------------------------

### Get Vec Bit Width in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/Vec.rst

Shows how to retrieve the total bit width of a SpinalHDL Vec using the .getBitsWidth method or the widthOf() function, which sums the widths of all elements within the vector.

```scala
// Create a vector of 2 signed integers
   val vec1 = Vec.fill(2)(SInt(8 bits))

   println(widthOf(vec1)) // 16
```

--------------------------------

### StreamFifo Component

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/stream.rst

The StreamFifo component provides a buffered stream implementation. It allows for queuing elements with a specified depth and supports optional configurations for asynchronous reads and bypass.

```APIDOC
## StreamFifo Component

### Description
A buffered stream implementation that allows queuing elements with a specified depth.

### Instantiation Example
```scala
val streamA, streamB = Stream(Bits(8 bits))
// ...
val myFifo = StreamFifo(
  dataType = Bits(8 bits),
  depth    = 128
)
myFifo.io.push << streamA
myFifo.io.pop  >> streamB
```

### Parameters
#### Mandatory Parameters
- **dataType** (T) - Payload data type
- **depth** (Int) - Number of elements stored in the FIFO. If `withAsyncRead` is false, an extra transaction can be stored.

#### Optional Parameters
- **withAsyncRead** (Boolean) - Default: `false`. Enables asynchronous read port. If false, adds 1 cycle latency.
- **withBypass** (Boolean) - Default: `false`. Bypasses the push port to the pop port when the FIFO is empty. If false, adds 1 cycle latency. Only available if `withAsyncRead == true`.
- **forFMax** (Boolean) - Default: `false`. Tunes the design for maximal clock frequency.
- **useVec** (Boolean) - Default: `false`. Uses a `Vec` of registers instead of a `Mem` to store content.
- **initPayload** (=> Option[T]) - Default: `None`. A function returning an optional value to initialize the `Vec` register when `useVec == true`.

### IO Signals
- **push** (Stream[T]) - Used to push elements into the FIFO.
- **pop** (Stream[T]) - Used to pop elements from the FIFO.
- **flush** (Bool) - Used to remove all elements from the FIFO.
- **occupancy** (UInt) - Indicates the internal memory occupancy. The width is `log2Up(depth + 1)` bits.
```

--------------------------------

### Hardware Set/Software Read-Write (HSRW/RWHS) Register Usage

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/regIf.rst

Demonstrates registers that can be configured by software and also set by hardware signals. `fieldHSRW` prioritizes hardware writes, while `fieldRWHS` prioritizes software writes.

```scala
val io = new Bundle {
  val xxx_set = in Bool()
  val xxx_set_val = in Bits(32 bit)
}

val reg0 = M_REG0.fieldHSRW(io.xxx_set, io.xxx_set_val, 0, "xx-device version")  // 0x0000
val reg1 = M_REG1.fieldRWHS(io.xxx_set, io.xxx_set_val, 0, "xx-device version")  // 0x0004
```

--------------------------------

### Find All Adders Concisely with walkExpression in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Developers area/spinalhdl_datamodel.rst

This SpinalHDL code snippet demonstrates a more concise method for finding all adder operations within a netlist using the `walkExpression` utility. By overriding the `impl` method of a `Phase`, it efficiently traverses the expression tree and directly identifies `Operator.BitVector.Add` instances, printing their operands. This approach is simpler than manual recursive traversal.

```scala
override def impl(pc: PhaseContext) = {
  println(message)
  pc.walkExpression {
    case op: Operator.BitVector.Add => println(s"Found ${op.left} + ${op.right}")
    case _ =>
  }
}
```

--------------------------------

### SpinalHDL Plugin Interaction in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/Misc/service_plugin.rst

This Scala code defines several SpinalHDL plugins (StatePlugin, DriverPlugin, SetupPlugin) and a top-level component that orchestrates their interaction. It showcases how plugins can access and modify each other's logic and state during different elaboration phases (setup and build) using mechanisms like retainers and asynchronous waits. This allows for dynamic configuration and dependency management between hardware components defined as plugins.

```scala
import spinal.core._
  import spinal.lib.misc.plugin._
  import spinal.core.fiber._

  class SubComponent extends Component {
    val host = new PluginHost()
  }

  class StatePlugin extends FiberPlugin {
    val logic = during build new Area {
      val signal = Reg(UInt(32 bits))
    }
  }

  class DriverPlugin extends FiberPlugin {
    // incrementBy will be set by others plugin at elaboration time
    var incrementBy = 0
    // retainer allows other plugins to create locks, on which this plugin will wait before using incrementBy
    val retainer = Retainer()

    val logic = during build new Area {
      val sp = host[StatePlugin].logic.get
      retainer.await()

      // Generate the incrementer hardware
      sp.signal := sp.signal + incrementBy
    }
  }

  // Let's define a plugin which will modify the DriverPlugin.incrementBy variable because letting it elaborate its hardware
  class SetupPlugin extends FiberPlugin {
    // during setup { body } will spawn the body of code in the Fiber setup phase (it is before the Fiber build phase)
    val logic = during setup new Area {
      // *** Setup phase code ***
      val dp = host[DriverPlugin]

      // Prevent the DriverPlugin from executing its build's body (until release() is called)
      val lock = dp.retainer()
      // Wait until the fiber phase reached build phase
      awaitBuild()

      // *** Build phase code ***
      // Let's mutate DriverPlugin.incrementBy
      dp.incrementBy += 1

      // Allows the DriverPlugin to execute its build's body
      lock.release()
    }
  }

  class TopLevel extends Component {
    val sub = new SubComponent()

    sub.host.asHostOf(
      new DriverPlugin(),
      new StatePlugin(),
      new SetupPlugin(),
      new SetupPlugin() // Let's add a second SetupPlugin, because we can
    )
  }
```

--------------------------------

### Define RGB Bundle with Helper Functions in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Developers area/types.rst

Shows how to define a custom Bundle named RGB to represent color channels (red, green, blue) with specified bit widths. Includes helper functions to check if the color is black or white.

```scala
case class RGB(channelWidth : Int) extends Bundle {
  val red   = UInt(channelWidth bits)
  val green = UInt(channelWidth bits)
  val blue  = UInt(channelWidth bits)

  def isBlack : Bool = red === 0 && green === 0 && blue === 0
  def isWhite : Bool = {
    val max = U((channelWidth-1 downto 0) -> true)
    return red === max && green === max && blue === max
  }
}
```

--------------------------------

### VHDL Component Instantiation Verbosity

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Getting Started/Help for VHDL people/vhdl_comp.rst

Highlights the verbosity of VHDL component instantiation, where all signals of the sub-component entity must be redefined and then explicitly mapped using a port map.

```VHDL
divider_cmd_valid : in std_logic;
  divider_cmd_ready : out std_logic;
  divider_cmd_numerator : in unsigned(31 downto 0);
  divider_cmd_denominator : in unsigned(31 downto 0);
  divider_rsp_valid : out std_logic;
  divider_rsp_ready : in std_logic;
  divider_rsp_quotient : out unsigned(31 downto 0);
  divider_rsp_remainder : out unsigned(31 downto 0);

divider : entity work.UnsignedDivider
  port map (
    clk             => clk,
    reset           => reset,
    cmd_valid       => divider_cmd_valid,
    cmd_ready       => divider_cmd_ready,
    cmd_numerator   => divider_cmd_numerator,
    cmd_denominator => divider_cmd_denominator,
    rsp_valid       => divider_rsp_valid,
    rsp_ready       => divider_rsp_ready,
    rsp_quotient    => divider_rsp_quotient,
    rsp_remainder   => divider_rsp_remainder
  );
```

--------------------------------

### Add Synthesizer Attributes in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Other language features/vhdl_generation.rst

Demonstrates adding synthesizer attributes like 'keep' to signals in Scala. This functionality is used to control how signals are synthesized, preventing optimizations that might remove them. It takes a signal and an attribute name as input.

```scala
val pcPlus4 = pc + 4
pcPlus4.addAttribute("keep")
```

--------------------------------

### Scala Object Definition for Static Members

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Getting Started/Scala Guide/basics.rst

Shows how to define an 'object' in Scala, which serves the purpose of static members found in other languages. Methods defined within an object are accessed directly via the object name.

```scala
object MathUtils {
  def pow2(value: Float): Float = value * value
}

MathUtils.pow2(42.0f)
```

--------------------------------

### SpinalHDL Rounding Operations

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/Int.rst

Demonstrates various rounding methods available for fixed-point numbers in SpinalHDL, such as roundToInf, floor, ceil, roundUp, and roundDown. It highlights the effect of the 'align' option and default rounding behavior.

```scala
val a  = SInt(16 bits)
val b  = a.roundToInf(6 bits)         // default 'align = false' with carry, got 11 bit
val b  = a.roundToInf(6 bits, align = true) // sat 1 carry bit, got 10 bit
val b  = a.floor(6 bits)              // return 10 bit
val b  = a.floorToZero(6 bits)        // return 10 bit
val b  = a.ceil(6 bits)               // ceil with carry so return 11 bit
val b  = a.ceil(6 bits, align = true) // ceil with carry then sat 1 bit return 10 bit
val b  = a.ceilToInf(6 bits)
val b  = a.roundUp(6 bits)
val b  = a.roundDown(6 bits)
val b  = a.roundToInf(6 bits)
val b  = a.roundToZero(6 bits)
val b  = a.round(6 bits)              // SpinalHDL uses roundToInf as the default rounding mode

val b0 = a.roundToInf(6 bits, align = true)         //  ---+ 
                                                       //     |--> equal
val b1 = a.roundToInf(6 bits, align = false).sat(1) //  ---+ 
```

--------------------------------

### SpinalHDL: Vector Declaration and Description

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Developers area/types.rst

Provides syntax for declaring and describing vectors in SpinalHDL. Covers creating vectors of a specified type and size, as well as creating vectors from a list of elements.

```Scala
// Declare vector of specific type and size
Vec(type : Data, size : Int)

// Declare vector from a list of elements
Vec(x,y,..)
```

--------------------------------

### Declare and Assign SpinalHDL Bool

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/bool.rst

Demonstrates the declaration of SpinalHDL Bool types, including initialization with default values, explicit true/false, and conversion from Scala Boolean types. The assignment operator ':=' is used to set the value of a Bool signal.

```scala
val myBool_1 = Bool()        // Create a Bool
myBool_1 := False            // := is the assignment operator (like verilog <=)

val myBool_2 = False         // Equivalent to the code above 

val myBool_3 = Bool(5 > 12)  // Use a Scala Boolean to create a Bool
```

--------------------------------

### SpinalHDL Enumeration Definition

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Developers area/types.rst

Demonstrates how to define an enumeration type in SpinalHDL using `SpinalEnum`. It showcases the creation of state elements within the enumeration.

```scala
object UartCtrlTxState extends SpinalEnum { // Or SpinalEnum(defaultEncoding=encodingOfYourChoice)
     val sIdle, sStart, sData, sParity, sStop = newElement()
   }
```

--------------------------------

### Filter Stream Elements When Condition is Met (Scala)

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/stream.rst

This code snippet demonstrates how to filter elements from a stream based on a condition. The `throwWhen` combinator conditionally drops elements from the source stream if the provided predicate (in this case, checking if the RGB payload is black) evaluates to true. It preserves the `valid` and `ready` signals for flow control.

```scala
case class RGB(channelWidth : Int) extends Bundle {
  val red   = UInt(channelWidth bits)
  val green = UInt(channelWidth bits)
  val blue  = UInt(channelWidth bits)

  def isBlack : Bool = red === 0 && green === 0 && blue === 0
}

val source = Stream(RGB(8))
val sink   = Stream(RGB(8))
sink <-< source.throwWhen(source.payload.isBlack)
```

--------------------------------

### Specify Register Reset Kind with Clock Domain in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Structuring/clock_domain.rst

Illustrates how to specify different reset kinds for registers using clock domain configurations like withBootReset(), withSyncReset(), and withAsyncReset(). This allows for fine-grained control over how registers are reset within a component, catering to boot, synchronous, or asynchronous reset strategies.

```scala
class  Top extends Component {
    val io = new Bundle {
      val data = in Bits(8 bit)
      val a, b, c, d = out Bits(8 bit)
    }
    io.a  :=  RegNext(io.data) init 0
    io.b  :=  clockDomain.withBootReset()  on RegNext(io.data) init 0
    io.c  :=  clockDomain.withSyncReset()  on RegNext(io.data) init 0
    io.d  :=  clockDomain.withAsyncReset() on RegNext(io.data) init 0
}
SpinalVerilog(new Top)
```

--------------------------------

### Conditional State Execution in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/fsm.rst

Demonstrates how to execute statements within a state machine when it's active or when it's transitioning to a specific state. This is fundamental for defining state logic.

```scala
state.whenIsActive {
  yourStatements
}
```

```scala
state.whenIsNext {
  yourStatements
}
```

--------------------------------

### APB3 Bundle Usage Example in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Examples/Simple ones/apb3.rst

This example demonstrates how to instantiate and use the defined APB3 Bundle within a SpinalHDL component. It shows the typical connections and signal assignments for an APB3 master and slave.

```scala
// start usage example
class Apb3Example extends Component {
  val io = new Bundle {
    val apb3Master = master(Apb3(Apb3Config(16, 2)))
    val apb3Slave  = slave(Apb3(Apb3Config(16, 2)))
  }

  // Example of connecting master to slave
  io.apb3Master.PSEL := io.apb3Slave.PSEL
  io.apb3Master.PADDR := io.apb3Slave.PADDR
  io.apb3Master.PENABLE := io.apb3Slave.PENABLE
  io.apb3Master.PWRITE := io.apb3Slave.PWRITE
  io.apb3Master.PWDATA := io.apb3Slave.PWDATA
  io.apb3Slave.PRDATA := io.apb3Master.PRDATA
  io.apb3Slave.PREADY := io.apb3Master.PREADY
  io.apb3Slave.PSLVERROR := io.apb3Master.PSLVERROR

  // end usage example
```

--------------------------------

### Configure and Run SpinalHDL Simulation with Template

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Simulation/bootstraps.rst

A template demonstrating comprehensive simulation configuration in SpinalHDL. It sets a specific clock frequency, enables wave capture, applies all optimizations, defines a workspace path, and then compiles and runs the simulation.

```scala
val spinalConfig = SpinalConfig(defaultClockDomainFrequency = FixedFrequency(10 MHz))

SimConfig
  .withConfig(spinalConfig)
  .withWave
  .allOptimisation
  .workspacePath("~/tmp")
  .compile(new TopLevel)
  .doSim { dut =>
    SimTimeout(1000)
    // Simulation code here
}
```

--------------------------------

### Define Analog signal for Bidirectional Data Bus - SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Other language features/analog_inout.rst

Defines an Analog signal named DQ for a bidirectional data bus within an SdramInterface bundle. This allows the signal to be in one of three states: 0, 1, or Z (high-impedance). It's a core part of defining interfaces with tristate capabilities.

```scala
case class SdramInterface(g : SdramLayout) extends Bundle {
  val DQ    = Analog(Bits(g.dataWidth bits)) // Bidirectional data bus
  val DQM   = Bits(g.bytePerWord bits)
  val ADDR  = Bits(g.chipAddressWidth bits)
  val BA    = Bits(g.bankWidth bits)
  val CKE, CSn, CASn, RASn, WEn  = Bool()
}
```

--------------------------------

### Define VGA Timings Structure (Scala)

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Examples/Intermediates ones/vga.rst

Defines a `VgaTimingsHV` case class to specify VGA timing parameters. This structure is more concise than a flat list, grouping related horizontal and vertical timing values. It uses `UInt` for each timing parameter, with a configurable bit width.

```scala
case class VgaTimingsHV(
    timingsWidth: Int
) extends Bundle {
  val hSyncStart = UInt(timingsWidth bits)
  val hSyncEnd = UInt(timingsWidth bits)
  val hColorStart = UInt(timingsWidth bits)
  val hColorEnd = UInt(timingsWidth bits)
  val vSyncStart = UInt(timingsWidth bits)
  val vSyncEnd = UInt(timingsWidth bits)
  val vColorStart = UInt(timingsWidth bits)
  val vColorEnd = UInt(timingsWidth bits)
}

```

--------------------------------

### SpinalHDL: Resize Operation for Bits

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Developers area/types.rst

Demonstrates the resize operation for the Bits type in SpinalHDL, allowing modification of the bit width. Supports resizing by retaining bits from the LSB or MSB side and filling new bits with zeros.

```Scala
// Resize (fills with zeros at MSB)
x.resize(y)

// Resize Left (fills with zeros at LSB)
x.resizeLeft(y)
```

--------------------------------

### Uart Encoder Simulation in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Simulation/examples/uart_encoder.rst

This Scala code simulates a Uart transmission process. It reads characters from the system's standard input and transmits them bit by bit on the uartPin, mimicking Uart communication. It includes logic for handling available input and managing transmission timing based on baud period.

```scala
// Fork a simulation process which will get chars typed into the simulation terminal and transmit them on the simulation uartPin.
     fork {
       uartPin #= true
       while(true) {
         // System.in is the java equivalent of the C's stdin.
         if(System.in.available() != 0) {
           val buffer = System.in.read()
           uartPin #= false
           sleep(baudPeriod)

           for(bitId <- 0 to 7) {
             uartPin #= ((buffer >> bitId) & 1) != 0
             sleep(baudPeriod)
           }

           uartPin #= true
           sleep(baudPeriod)
         } else {
           sleep(baudPeriod * 10) // Sleep a little while to avoid polling System.in too often.
         }
       }
     }
```

--------------------------------

### Implement Pinsec Reset Controller

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Legacy/pinsec/hardware_toplevel.rst

Implements the reset controller logic within the reset control clock domain. It manages buffered and unbuffered reset signals for AXI and core, incorporating a counter for reset duration and handling asynchronous reset assertion.

```scala
val resetCtrl = new ClockingArea(resetCtrlClockDomain) {
  val axiResetUnbuffered  = False
  val coreResetUnbuffered = False

  // Implement an counter to keep the reset axiResetOrder high 64 cycles
  // Also this counter will automaticly do a reset when the system boot.
  val axiResetCounter = Reg(UInt(6 bits)) init(0)
  when(axiResetCounter =/= U(axiResetCounter.range -> true)) {
    axiResetCounter := axiResetCounter + 1
    axiResetUnbuffered := True
  }
  when(BufferCC(io.asyncReset)) {
    axiResetCounter := 0
  }

  // When an axiResetOrder happen, the core reset will as well
  when(axiResetUnbuffered) {
    coreResetUnbuffered := True
  }

  // Create all reset used later in the design
  val axiReset  = RegNext(axiResetUnbuffered)
  val coreReset = RegNext(coreResetUnbuffered)
  val vgaReset  = BufferCC(axiResetUnbuffered)
}
```

--------------------------------

### Define APB3 Bundle in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Examples/Simple ones/apb3.rst

This code defines the APB3 `Bundle` in Scala, which represents the APB3 bus interface in hardware. It uses the `Apb3Config` to determine the widths of signals like PADDR, PSEL, and PWDATA/PRDATA. It includes standard APB3 signals such as PADDR, PSEL, PENABLE, PWRITE, PWDATA, PREADY, PRDATA, and optionally PSLVERROR.

```scala
case class Apb3(
    config: Apb3Config
) extends Bundle {
  val PADDR   = UInt(config.addressWidth bits)
  val PSEL    = Bits(config.selWidth bits)
  val PENABLE = Bool()
  val PWRITE  = Bool()
  val PWDATA  = Bits(config.dataWidth bits)
  val PREADY  = Bool()
  val PRDATA  = Bits(config.dataWidth bits)
  val PSLVERROR = Bool()
}
```

--------------------------------

### Configure AXI4CrossbarFactory Connections

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Legacy/pinsec/hardware_toplevel.rst

This snippet shows how to define the interconnections between AXI4 masters and the slaves that are accessible to them. It maps each master to a list of slaves it can communicate with, controlling visibility within the crossbar.

```scala
//         Master -> List of slaves which are accessible

axiCrossbar.addConnections(
  core.io.i       -> List(ram.io.axi, sdramCtrl.io.axi),
  core.io.d       -> List(ram.io.axi, sdramCtrl.io.axi, apbBridge.io.axi),
  jtagCtrl.io.axi -> List(ram.io.axi, sdramCtrl.io.axi, apbBridge.io.axi),
  vgaCtrl.io.axi  -> List(            sdramCtrl.io.axi)
)
```

--------------------------------

### Simulate Sequential Counter in Scala

Source: https://context7.com/spinalhdl/spinaldoc-rtd/llms.txt

This snippet shows how to simulate a clocked counter component. It utilizes SpinalHDL's simulation capabilities to manage clock cycles, reset the design, enable counting, and verify the final count value after a specified number of clock cycles. Waveform generation is enabled.

```scala
import spinal.core._
import spinal.core.sim._
import spinal.lib._

// Simulation with clocked design
class Counter extends Component {
  val io = new Bundle {
    val enable = in Bool()
    val value = out UInt(8 bits)
  }

  val reg = RegInit(U(0, 8 bits))
  when(io.enable) {
    reg := reg + 1
  }
  io.value := reg
}

object CounterSim extends App {
  SimConfig.withWave.doSim(new Counter) {
    dut =>
      dut.clockDomain.forkStimulus(10)
      dut.clockDomain.waitReset()        // Wait for reset to complete

      dut.io.enable #= true
      dut.clockDomain.waitSampling(10)   // Wait 10 clock cycles

      val finalValue = dut.io.value.toInt
      assert(finalValue == 10)
      println(s"Counter reached $finalValue")
  }
}
```

--------------------------------

### Build Chinese HTML Docs with venv

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/README.rst

This command extends the standard HTML build process to generate documentation in Chinese. It utilizes Sphinx's language configuration via the SPHINXOPTS environment variable. Ensure the virtual environment is activated and dependencies are installed.

```shell
make -e SPHINXOPTS="-D language='zh_CN'" html
```

--------------------------------

### StateMachine Base Class Usage

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/fsm.rst

Demonstrates the basic instantiation of the StateMachine base class in SpinalHDL. This serves as a foundation for defining more complex state machine logic.

```scala
val myFsm = new StateMachine {
  // Definition of states
}
```

--------------------------------

### Define and Instantiate Adder Component in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Structuring/components_hierarchy.rst

Demonstrates how to define a reusable component 'AdderCell' with input and output ports for boolean operations. It also shows how to instantiate multiple 'AdderCell' components within another component 'Adder', creating a hierarchy and connecting their signals.

```scala
class AdderCell() extends Component {
  // Declaring external ports in a Bundle called `io` is recommended
  val io = new Bundle {
    val a, b, cin = in port Bool()
    val sum, cout = out port Bool()
  }
  // Do some logic
  io.sum := io.a ^ io.b ^ io.cin
  io.cout := (io.a & io.b) | (io.a & io.cin) | (io.b & io.cin)
}

class Adder(width: Int) extends Component {
  ...
  // Create 2 AdderCell instances
  val cell0 = new AdderCell()
  val cell1 = new AdderCell()
  cell1.io.cin := cell0.io.cout   // Connect cout of cell0 to cin of cell1

  // Another example which creates an array of ArrayCell instances
  val cellArray = Array.fill(width)(new AdderCell())
  cellArray(1).io.cin := cellArray(0).io.cout   // Connect cout of cell(0) to cin of cell(1)
  ...
}
```

--------------------------------

### State Logic - onExit

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/fsm.rst

Defines logic that executes once when a specific state is exited in a SpinalHDL state machine. This is useful for cleanup or actions that should occur when leaving a state.

```scala
state.onExit {
  yourStatements
}
```

--------------------------------

### SpinalHDL Basic Imports

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Examples/index.rst

Essential imports required for any SpinalHDL project to define hardware components and use standard libraries. These are the foundational elements for writing hardware descriptions in Scala.

```scala
import spinal.core._
import spinal.lib._
```

--------------------------------

### Set Analog signal as inout bidirectional signal - SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Other language features/analog_inout.rst

Sets an Analog signal (DQ) as an 'inout' signal within the SdramInterface bundle, making it bidirectional. This is achieved by using the 'inout' keyword within the 'asMaster' method, signifying that this signal can both receive and transmit data.

```scala
case class SdramInterface(g : SdramLayout) extends Bundle with IMasterSlave {
  val DQ    = Analog(Bits(g.dataWidth bits)) // Bidirectional data bus
  val DQM   = Bits(g.bytePerWord bits)
  val ADDR  = Bits(g.chipAddressWidth bits)
  val BA    = Bits(g.bankWidth bits)
  val CKE, CSn, CASn, RASn, WEn  = Bool()

  override def asMaster() : Unit = {
    out(ADDR, BA, CASn, CKE, CSn, DQM, RASn, WEn)
    inout(DQ) // Set the Analog DQ as an inout signal of the component
  }
}
```

--------------------------------

### Detect Rising Edge of a Boolean Signal in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/bool.rst

Detects when a boolean signal transitions from false to true. It utilizes the `rise` method, which can optionally take an initialization value. The `when` construct is used to trigger actions based on the detected edge.

```scala
when(myBool_1.rise(False)) {
    // do something when a rising edge is detected 
}
```

--------------------------------

### Enable Memory Blackboxing in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Sequential logic/memory.rst

This snippet shows how to configure SpinalHDL to automatically blackbox memories. It uses `SpinalConfig` and `addStandardMemBlackboxing` with the `blackboxAll` policy to generate VHDL for a top-level component. This is crucial for handling memories with specific features like mixed-width ports that are not universally inferable in VHDL/Verilog.

```scala
def main(args: Array[String]) {
  SpinalConfig()
    .addStandardMemBlackboxing(blackboxAll)
    .generateVhdl(new TopLevel)
}
```

--------------------------------

### Handle Simulation Success, Failure, and Timeout in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Simulation/bootstraps.rst

This code illustrates how to programmatically end a simulation with success or failure using `simSuccess` and `simFailure`. It also shows how to implement a timeout mechanism with `SimTimeout` to prevent simulations from running indefinitely. The `forkStimulus` function is used to control the simulation's clock.

```scala
val period = 10
dut.clockDomain.forkStimulus(period)
SimTimeout(1000 * period)
```

--------------------------------

### Assign DontCare API in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/index.rst

Demonstrates how to use the assignDontCare API in SpinalHDL to assign a 'don't care' value (represented by 'x') to hardware signals. This is useful for providing default values.

```scala
val myBits  = Bits(8 bits)
myBits.assignDontCare() // Will assign all the bits to 'x'
```

--------------------------------

### Scala Generic Function: doSomething with Type Constraint

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Getting Started/Scala Guide/basics.rst

Presents a generic function 'doSomething' that accepts a type parameter 'T' constrained to be a subtype of 'Shape'. The function utilizes the 'getArea' method available on all 'Shape' types, showcasing constrained type parameterization in functions.

```scala
def doSomething[T <: Shape](shape: T): Something = { shape.getArea() }
```

--------------------------------

### Use TriState Bundle in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/IO/tristate.rst

An example demonstrating the usage of the TriState bundle in SpinalHDL. It shows how to instantiate the bundle, control write operations, and check read values.

```scala
val io = new Bundle {
  val dataBus = master(TriState(Bits(32 bits)))
}

io.dataBus.writeEnable := True
io.dataBus.write := 0x12345678
when(io.dataBus.read === 42) {

}
```

--------------------------------

### Control Flow with HaltIt in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/Pipeline/introduction.rst

Demonstrates how to use haltIt() for explicit and conditional halt requests within a Scala control link. This is useful for stopping transaction propagation downstream.

```scala
val c01 = CtrlLink(n0, n1)

c01.haltWhen(something) // Explicit halt request

when(somethingElse) {
    // Conditional scope sensitive halt request, same as c01.haltWhen(somethingElse)
    c01.haltIt() 
}
```

--------------------------------

### Instantiate Clock Divider for UartCtrlTx in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Examples/Intermediates ones/uart.rst

Instantiates a clock divider within the UartCtrlTx component to generate a sampling tick at the required baud rate. This tick serves as the timing reference for the state machine.

```scala
val clockDivider = new Area {
  val counter = Reg(UInt(log2Up(rxSamplePerBit) bits)) init(0)
  val tick = False
  ..
}
```

--------------------------------

### Switch Statement Formatting in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Getting Started/Scala Guide/coding_conventions.rst

Illustrates the conventional formatting for SpinalHDL 'switch' statements, including the 'is' and 'default' blocks. It also notes that 'is' and 'default' statements can be compressed onto a single line if it improves readability.

```scala
switch(value) {
  is(key) {

  }
  is(key) {

  }
  default {

  }
}
```

--------------------------------

### Create Namespaced Scope with Composite in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Structuring/naming.rst

Demonstrates how to use `Composite` in SpinalHDL to create a namespaced scope, using a parent `Nameable` as a prefix for its members. This feature was introduced in SpinalHDL 1.5.0. The `Composite` is an `Area` that utilizes its construction parameter as a namespace prefix. The example shows creating a comparator within a composite and returning only the comparator, not the composite itself.

```scala
class MyComponent extends Component {
    // Basically, a Composite is an Area that use its construction parameter as namespace prefix
    def isZero(value: UInt) = new Composite(value) {
      val comparator = value === 0
    }.comparator  // Note we don't return the Composite,
                  //  but the element of the composite that we are interested in

    val value = in UInt (8 bits)
    val result = out Bool()
    result := isZero(value)
  }
```

--------------------------------

### Configure RgbToSomething Output Register Stage in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/Pipeline/introduction.rst

This snippet shows how to configure the RgbToSomething component in SpinalHDL by specifying the 'addAt', 'invAt', 'mulAt', and 'resultAt' parameters, which control the output register stage.

```scala
SpinalVerilog(
  new RgbToSomething(
    addAt    = 0,
    invAt    = 0,
    mulAt    = 1,
    resultAt = 1
  )
)
```

--------------------------------

### Configure Reserved Address Read Value

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/regIf.rst

Sets the value returned when software reads a reserved address. This is useful for debugging and defaults to 0x0000EF00. This example shows the configuration in Scala and its Verilog equivalent.

```scala
busif.setReservedAddressReadValue(0x0000EF00)
```

```verilog
default: begin
      busif_rdata  <= 32'h0000EF00 ;
      busif_rderr  <= 1'b0         ;
   end
```

--------------------------------

### Clock Domain Crossing with Manual Register Staging (Parameters)

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Structuring/clock_domain.rst

This example demonstrates clock domain crossing where the source and destination `ClockDomain` objects are passed as parameters to the `Component`. Similar to the IO-based example, it uses two register stages clocked by the destination clock domain and the `crossClockDomain` tag. Dependencies include `Component`, `Bundle`, `in`, `out`, `Bool`, `ClockDomain`, `ClockingArea`, `RegNext`, and `addTag` with `crossClockDomain`.

```scala
// Alternative implementation where clock domains are given as parameters
class CrossingExample(clkA : ClockDomain,clkB : ClockDomain) extends Component {
  val io = new Bundle {
    val dataIn  = in Bool()
    val dataOut = out Bool()
  }

  // sample dataIn with clkA
  val area_clkA = new ClockingArea(clkA) {
    val reg = RegNext(io.dataIn) init(False)
  }

  // 2 register stages to avoid metastability issues
  val area_clkB = new ClockingArea(clkB) {
    val buf0   = RegNext(area_clkA.reg) init(False) addTag(crossClockDomain)
    val buf1   = RegNext(buf0)          init(False)
  }

  io.dataOut := area_clkB.buf1
}
```

--------------------------------

### Multi-way Branching with switch/is/default in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Semantic/when_switch.rst

Enables conditional signal assignment based on the value of a signal, similar to VHDL's 'case' or Verilog's 'case'. The 'switch' statement evaluates a signal and executes code blocks specified by 'is' clauses for matching values, with an optional 'default' block. 'is' clauses can be factorized using commas for logical OR. Additional options include 'coverUnreachable' and 'strict' for error handling.

```scala
switch(x) {
  is(value1) {
    // Execute when x === value1
  }
  is(value2) {
    // Execute when x === value2
  }
  default {
    // Execute if none of precedent conditions met
  }
}
```

```scala
switch(aluop) {
  is(ALUOp.add) {
    immediate := instruction.immI.signExtend
  }
  is(ALUOp.slt) {
    immediate := instruction.immI.signExtend
  }
  is(ALUOp.sltu) {
    immediate := instruction.immI.signExtend
  }
  is(ALUOp.sll) {
    immediate := instruction.shamt
  }
  is(ALUOp.sra) {
    immediate := instruction.shamt
  }
}
```

```scala
switch(aluop) {
  is(ALUOp.add, ALUOp.slt, ALUOp.sltu) {
      immediate := instruction.immI.signExtend
  }
  is(ALUOp.sll, ALUOp.sra) {
      immediate := instruction.shamt
  }
}
```

```scala
switch(my2Bits, coverUnreachable = true) {
      is(0) { ... }
      is(1) { ... }
      is(2) { ... }
      is(3) { ... }
      default { ... } // This will parse and validate without error now
}
```

```scala
switch(value, strict = false) {
      is(0) { ... }
      is(1,1,1,1,1) { ... } // This will be okay
      is(2) { ... }
  }
```

--------------------------------

### Implement AvalonMMSlaveFactory in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Developers area/bus_slave_factory_impl.rst

Extends `BusSlaveFactoryDelayed` to create an Avalon MM slave. It maps bus signals to internal read/write flows and handles element processing during the build phase, assigning data from the bus to elements and vice-versa.

```scala
class AvalonMMSlaveFactory(bus : AvalonMM) extends BusSlaveFactoryDelayed {
  assert(bus.c == AvalonMMSlaveFactory.getAvalonConfig(bus.c.addressWidth,bus.c.dataWidth))

  val readAtCmd = Flow(Bits(bus.c.dataWidth bits))
  val readAtRsp = readAtCmd.stage()

  bus.readDataValid := readAtRsp.valid
  bus.readData := readAtRsp.payload

  readAtCmd.valid := bus.read
  readAtCmd.payload := 0

  override def build(): Unit = {
    for(element <- elements) element match {
      case element : BusSlaveFactoryNonStopWrite =>
        element.that.assignFromBits(bus.writeData(element.bitOffset, element.that.getBitsWidth bits))
      case _ =>
    }

    for((address,jobs) <- elementsPerAddress) {
      when(bus.address === address) {
        when(bus.write) {
          for(element <- jobs) element match {
            case element : BusSlaveFactoryWrite => {
              element.that.assignFromBits(bus.writeData(element.bitOffset, element.that.getBitsWidth bits))
            }
            case element : BusSlaveFactoryOnWrite => element.doThat()
            case _ =>
          }
        }
        when(bus.read) {
          for(element <- jobs) element match {
            case element : BusSlaveFactoryRead => {
              readAtCmd.payload(element.bitOffset, element.that.getBitsWidth bits) := element.that.asBits
            }
            case element : BusSlaveFactoryOnRead => element.doThat()
            case _ =>
          }
        }
      }
    }
  }
}
```

--------------------------------

### Usage Example of ReadableOpenDrain in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/IO/readableOpenDrain.rst

Demonstrates how to instantiate and use the ReadableOpenDrain bundle as a master in a SpinalHDL design. It shows how to connect the bundle to a data bus and manipulate the write and read signals.

```scala
val io = new Bundle {
  val dataBus = master(ReadableOpenDrain(Bits(32 bits)))
}

io.dataBus.write := 0x12345678
when(io.dataBus.read === 42) {

}
```

--------------------------------

### Sphinx WaveDrom Register Description Example

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Developers area/howtodocument.rst

This code snippet illustrates how to describe register mappings using the sphinxcontrib-wavedrom plugin. It employs WaveJSON syntax to define register bits, names, and configuration, suitable for documentation.

```javascript
.. wavedrom::

   {"reg":[
     {"bits": 8, "name": "things"},
     {"bits": 2, "name": "stuff" },
     {"bits": 6}
    ],
    "config": { "bits":16,"lanes":1 }
    }
```

--------------------------------

### Scala RISC-V Core Instantiation

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Getting Started/Help for VHDL people/vhdl_comp.rst

Instantiates a RISC-V core in SpinalHDL, passing configured parameters for the core, instruction cache, data cache (set to null), debug interface, and interrupt count.

```scala
new RiscvCoreAxi4(
  coreConfig = coreConfig,
  iCacheConfig = iCacheConfig,
  dCacheConfig = null,
  debug = debug,
  interruptCount = interruptCount
)
```

--------------------------------

### Ada VHDL Bus and Interface Declaration (Records)

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Getting Started/Help for VHDL people/vhdl_comp.rst

Presents an alternative VHDL approach using records for bus and interface definitions. While more structured than wire-by-wire, it sacrifices parameterization and requires direction-specific definitions.

```ada
P_m : in APB_M;
  P_s : out APB_S;
```

--------------------------------

### SystemRDL Document Generation Example

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/regIf.rst

Example of generating a SystemRDL file for a register interface using `SystemRdlGenerator`. This function requires the output name, address map name, and optional name and description.

```scala
busif.accept(SystemRdlGenerator("regif", "addrmap_name", Some("name"), Some("desc")))
```

--------------------------------

### Control Simulation Stimulus in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/stream.rst

This snippet shows how to initiate a clock stimulus for a DUT (Device Under Test) in SpinalHDL. It utilizes the `forkStimulus` method to generate clock signals, providing a basic level of simulation control.

```Scala
dut.clockDomain.forkStimulus(10)

```

--------------------------------

### Configure AXI4CrossbarFactory Pipelining

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Legacy/pinsec/hardware_toplevel.rst

This snippet illustrates how to add pipelining stages between the AXI4 crossbar and specific slave interfaces to reduce combinatorial path lengths and improve timing. It uses helper functions from the Stream bus library for defining pipeline connections.

```scala
// Pipeline the connection between the crossbar and the apbBridge.io.axi
axiCrossbar.addPipelining(apbBridge.io.axi,(crossbar,bridge) => {
  crossbar.sharedCmd.halfPipe() >> bridge.sharedCmd
  crossbar.writeData.halfPipe() >> bridge.writeData
  crossbar.writeRsp             << bridge.writeRsp
  crossbar.readRsp              << bridge.readRsp
})

// Pipeline the connection between the crossbar and the sdramCtrl.io.axi
axiCrossbar.addPipelining(sdramCtrl.io.axi,(crossbar,ctrl) => {
  crossbar.sharedCmd.halfPipe()  >>  ctrl.sharedCmd
  crossbar.writeData            >/-> ctrl.writeData
  crossbar.writeRsp              <<  ctrl.writeRsp
  crossbar.readRsp               <<  ctrl.readRsp
})
```

--------------------------------

### Run Specified Test Suite with Mill

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Developers area/mill support.rst

Allows running a particular test suite by specifying its name with the `testOnly` command in Mill. This is useful for targeted testing during development. The Sbt equivalent is provided.

```sh
mill tester.test.testOnly spinal.xxxxx.xxxxx
```

```sh
sbt "tester/testOnly spinal.xxxxx.xxxxx"
```

--------------------------------

### Define BlackBox Generics in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Structuring/blackbox.rst

Demonstrates two methods for defining generics within a SpinalHDL BlackBox. The first method uses addGeneric directly, while the second uses an anonymous Generic object to group generic definitions. Both approaches allow passing parameters to the blackbox.

```scala
class Ram(wordWidth: Int, wordCount: Int) extends BlackBox {
    addGeneric("wordCount", wordCount)
    addGeneric("wordWidth", wordWidth)

    // OR 

    val generic = new Generic {
      val wordCount = Ram.this.wordCount
      val wordWidth = Ram.this.wordWidth
    }
}
```

--------------------------------

### Prevent Numeric Types in VHDL BlackBox (Scala)

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Structuring/blackbox.rst

This snippet demonstrates how to add a `noNumericType` tag to a SpinalHDL BlackBox. This tag instructs the compiler to use only `std_logic_vector` for signal types in the generated VHDL, avoiding specific numeric types like `signed` or `unsigned`. This is useful for ensuring compatibility with older VHDL tools or specific design constraints.

```scala
   class MyBlackBox() extends BlackBox {
     val io = new Bundle {
       val clk       = in  Bool()
       val increment =  in  Bool()
       val initValue =  in  UInt(8 bits)
       val counter   = out UInt(8 bits)
     }

     mapCurrentClockDomain(io.clk)

     noIoPrefix()

     addTag(noNumericType)  //  Only std_logic_vector
   }

```

--------------------------------

### Handle Unassigned Register in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Design errors/unassigned_register.rst

Demonstrates an unassigned register scenario in SpinalHDL and provides a fix. The initial code causes an 'UNASSIGNED REGISTER' error because 'a' is never assigned a value before being used. The fix involves assigning a value to 'a'.

```scala
class TopLevel extends Component {
  val result = out(UInt(8 bits))
  val a = Reg(UInt(8 bits))
  result := a
}
```

```text
UNASSIGNED REGISTER (toplevel/a :  UInt[8 bits]), defined at
  ***
  Source file location of the toplevel/a definition via the stack trace
  ***
```

```scala
class TopLevel extends Component {
  val result = out(UInt(8 bits))
  val a = Reg(UInt(8 bits))
  a := 42
  result := a
}
```

--------------------------------

### Define VGA Timings Bundles in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/Graphics/vga.rst

Defines bundles for managing VGA timing parameters, including horizontal and vertical timings. VgaTimingsHV handles start and end points for color and sync, while VgaTimings aggregates these for both H and V.

```scala
case class VgaTimingsHV(timingsWidth: Int) extends Bundle {
  val colorStart = UInt(timingsWidth bits)
  val colorEnd = UInt(timingsWidth bits)
  val syncStart = UInt(timingsWidth bits)
  val syncEnd = UInt(timingsWidth bits)
}

case class VgaTimings(timingsWidth: Int) extends Bundle {
  val h = VgaTimingsHV(timingsWidth)
  val v = VgaTimingsHV(timingsWidth)

   def setAs_h640_v480_r60 = ...
  def driveFrom(busCtrl : BusSlaveFactory,baseAddress : Int) = ...
}
```

--------------------------------

### Set Virtual Pins for Components with Many Pins (Scala)

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/EDA/altera/quartus_flow.rst

Provides a method to set components with a large number of pins as virtual pins using Altera-specific attributes. This is useful for simplifying testing of complex components.

```scala
val miaou: Vec[Flow[Bool]] = Vec(master(Flow(Bool())), 666)
miaou.addAttribute("altera_attribute", "-name VIRTUAL_PIN ON")
```

--------------------------------

### Configure VCS Simulation with Custom Flags

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Simulation/install/VCS.rst

Configures VCS simulation with custom flags for compilation and elaboration steps, often used for enabling debugging features like Verdi.

```scala
val flags = VCSFlags(
    compileFlags = List("-kdb"),
    elaborateFlags = List("-kdb")
  )

val config = 
  SimConfig
    .withVCS(flags)
    .withFSDBWave
    .workspacePath("tb")
    .compile(UIntAdder(8))
```

--------------------------------

### Update SpinalHDL Version in build.sbt

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Introduction/faq.rst

This snippet demonstrates how to update the SpinalHDL version in a `build.sbt` file to use a locally published 'dev' version. It shows the change from a specific version number (e.g., "1.7.3") to the string "dev", which points to the local build.

```scala
val spinalVersion = "dev"
```

--------------------------------

### AXI4 Bus Configuration and Channels in Scala

Source: https://context7.com/spinalhdl/spinaldoc-rtd/llms.txt

Defines the configuration and structure for an AXI4 bus, including parameters like address width, data width, and ID width. It also outlines the five independent channels (AW, W, B, AR, R) and provides examples of creating, accessing, and connecting AXI4 interfaces, as well as its read-only, write-only, and shared variations.

```scala
// AXI4 high-bandwidth bus configuration
case class Axi4Config(
  addressWidth: Int,
  dataWidth: Int,
  idWidth: Int,
  userWidth: Int = 0,
  useId: Boolean = true,
  useRegion: Boolean = true,
  useBurst: Boolean = true,
  useLock: Boolean = true,
  useCache: Boolean = true,
  useSize: Boolean = true,
  useQos: Boolean = true,
  useLen: Boolean = true,
  useLast: Boolean = true,
  useResp: Boolean = true,
  useProt: Boolean = true,
  useStrb: Boolean = true,
  useUser: Boolean = false
)

// AXI4 has 5 independent channels
case class Axi4(config: Axi4Config) extends Bundle with IMasterSlave {
  val aw = Stream(Axi4Aw(config))    // Write address channel
  val w  = Stream(Axi4W(config))     // Write data channel
  val b  = Stream(Axi4B(config))     // Write response channel
  val ar = Stream(Axi4Ar(config))    // Read address channel
  val r  = Stream(Axi4R(config))     // Read data channel

  override def asMaster(): Unit = {
    master(ar, aw, w)                // Master drives AR, AW, W
    slave(r, b)                      // Master receives R, B
  }
}

// Create AXI4 bus
val axiConfig = Axi4Config(
  addressWidth = 32,
  dataWidth    = 32,
  idWidth      = 4
)
val axiX = Axi4(axiConfig)
val axiY = Axi4(axiConfig)

// Access AXI4 channels
when(axiY.aw.valid && axiY.aw.ready) {
  // Write address handshake occurred
  val writeAddr = axiY.aw.payload.addr
  val writeId = axiY.aw.payload.id
}

when(axiY.r.valid) {
  axiY.r.ready := True
  val readData = axiY.r.payload.data
  val isLast = axiY.r.payload.last
}

// AXI4 variations
val axiRO = Axi4ReadOnly(axiConfig)   // Only AR and R channels
val axiWO = Axi4WriteOnly(axiConfig)  // Only AW, W, B channels
val axiShared = Axi4Shared(axiConfig) // Combined AWR channel (less area)

// Convert to variations
val writeOnlyBus = axiX.toWriteOnly   // Extract write-only interface
val readOnlyBus = axiX.toReadOnly     // Extract read-only interface

// Connect with width adaptation and default values
axiX >> axiY                          // Smart connection with safe adaptations
axiY << axiX                          // Reverse connection

```

--------------------------------

### VGA Controller Component Definition (Scala)

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Examples/Intermediates ones/vga.rst

Defines the `VgaCtrl` component, a SpinalHDL module for controlling the VGA output. It takes `RgbConfig` and `timingsWidth` as parameters and defines its input and output signals, including reset, timings, pixel input, error output, frame start signal, and the main VGA interface.

```scala
case class VgaCtrl(
    rgbConfig: RgbConfig,
    timingsWidth: Int = 12
) extends Component {
  val io = new Bundle {
    val softReset = in Bool()
    val timings = in(VgaTimingsHV(timingsWidth))
    val pixels = slave Stream (Bits(rgbConfig.rWidth + rgbConfig.gWidth + rgbConfig.bWidth bits))
    val error = out Bool()
    val frameStart = out Bool()
    val vga = master(Vga(rgbConfig))
  }

  // ... implementation details ...
}

```

--------------------------------

### SpinalHDL: Assigning a driver to a combinational signal (Scala)

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Design errors/no_driver_on.rst

Demonstrates how to resolve the 'no driver' error in SpinalHDL by assigning a value to a combinational signal. This prevents the error by ensuring the signal is driven.

```scala
class TopLevel extends Component {
  val result = out(UInt(8 bits))
  val a = UInt(8 bits)
  a := 42
  result := a
}
```

--------------------------------

### AFix Rounding Methods in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/AFix.rst

Lists and illustrates the use of various rounding methods available for AFix types in Scala, including floor, ceil, roundHalfUp, and roundHalfDown. Note that some methods have specific exponent requirements.

```scala
// The following require exp < 0
.floor() or .truncate()
.ceil()
.floorToZero()
.ceilToInf()
// The following require exp < -1
.roundHalfUp()
.roundHalfDown()
```

--------------------------------

### Declare a basic SpinalHDL Bundle

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/bundle.rst

This snippet shows the basic syntax for declaring a SpinalHDL Bundle, which groups named signals of any basic SpinalHDL type under a single name. Bundles are used for data structures, buses, and interfaces.

```scala
case class myBundle extends Bundle {
  val bundleItem0 = AnyType
  val bundleItem1 = AnyType
  val bundleItemN = AnyType
}
```

--------------------------------

### Control Simulation Time with Sleep and WaitUntil in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Simulation/threadFull.rst

Illustrates how to manipulate simulation time within SpinalSim using Scala. `sleep(time)` pauses the current thread for a specified duration, while `waitUntil(condition)` suspends execution until a given condition becomes true. These are essential for synchronizing testbench events.

```scala
// Sleep 1000 units of time
sleep(1000)

// waitUntil the dut.io.a value is bigger than 42 before continuing
waitUntil(dut.io.a > 42)
```

--------------------------------

### Detect Edges (Rise, Fall, Toggle) of a Boolean Signal in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/bool.rst

Detects rising, falling, and toggle edges of a boolean signal. The `edges` method returns a bundle containing boolean flags for each edge type. These can be used within `when` blocks to perform specific actions.

```scala
val edgeBundle = myBool_2.edges(False)
when(edgeBundle.rise) {
    // do something when a rising edge is detected
}
when(edgeBundle.fall) {
    // do something when a falling edge is detected
}
when(edgeBundle.toggle) {
    // do something at each edge
}
```

--------------------------------

### Scala Apply Method Example

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Getting Started/Scala Guide/basics.rst

Explains and demonstrates the special 'apply' method in Scala, which allows objects to be called as if they were functions. This is commonly used with collections and objects.

```scala
class Array() {
  def apply(index: Int): Int = index + 3
}

val array = new Array()
val value = array(4)   // array(4) is interpreted as array.apply(4) and will return 7
```

```scala
object MajorityVote {
  def apply(value: Int): Int = ...
}

val value = MajorityVote(4) // Will call MajorityVote.apply(4)
```

--------------------------------

### Define APB Interface Bundle in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Developers area/types.rst

Defines a Bundle representing an APB (Advanced Peripheral Bus) interface, including common signals like address, data, control, and optional slave error. Parameters control widths and the presence of PSLVERROR.

```scala
class APB(addressWidth: Int,
            dataWidth: Int,
            selWidth : Int,
            useSlaveError : Boolean) extends Bundle {

  val PADDR      = UInt(addressWidth bits)
  val PSEL       = Bits(selWidth bits)
  val PENABLE    = Bool()
  val PREADY     = Bool()
  val PWRITE     = Bool()
  val PWDATA     = Bits(dataWidth bits)
  val PRDATA     = Bits(dataWidth bits)
  val PSLVERROR  = if(useSlaveError) Bool() else null   // This signal is created only when useSlaveError is true
}

// Example of usage :
val bus = APB(addressWidth = 8,
              dataWidth = 32,
              selWidth = 4,
              useSlaveError = false)
```

--------------------------------

### Generate VHDL and Verilog from SpinalHDL Component

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Other language features/vhdl_generation.rst

This Scala code demonstrates how to generate VHDL and Verilog output from a SpinalHDL component. It defines a simple component `MyTopLevel` with input and output signals and then uses `SpinalVhdl` and `SpinalVerilog` to produce the respective hardware description language files. The generation functions require a factory function that returns a new instance of the component.

```scala
import spinal.core._

// A simple component definition.
class MyTopLevel extends Component {
  // Define some input/output signals. Bundle like a VHDL record or a Verilog struct.
  val io = new Bundle {
    val a = in  Bool()
    val b = in  Bool()
    val c = out Bool()
  }

  // Define some asynchronous logic.
  io.c := io.a & io.b
}

// This is the main function that generates the VHDL and the Verilog corresponding to MyTopLevel.
object MyMain {
  def main(args: Array[String]) {
    SpinalVhdl(new MyTopLevel)
    SpinalVerilog(new MyTopLevel)
  }
}
```

--------------------------------

### Horizontal and Vertical Synchronization Logic (Scala)

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Examples/Intermediates ones/vga.rst

Implements the core logic for generating horizontal and vertical synchronization signals within the `VgaCtrl` component. It defines an `HVArea` helper bundle for PWM-like counting and instantiates it twice to manage both horizontal and vertical synchronization based on the provided timings.

```scala
// end VgaCtrl io

  val HVArea = new Area {
    // ... HVArea implementation ...
  }

  val hSyncArea = HVArea
  val vSyncArea = HVArea

// end VgaCtrl HVArea

```

--------------------------------

### Scala Version Configuration in build.sbt

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Introduction/faq.rst

This snippet illustrates how to define the Scala version for a project within a `build.sbt` file. It uses the `ThisBuild / scalaVersion` setting to specify the desired Scala version, which is crucial for compatibility when using libraries like SpinalHDL.

```scala
ThisBuild / scalaVersion := "2.12.16"
```

--------------------------------

### SETUP_DATA Register

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/Com/usb_device.rst

Details the SETUP_DATA register used for endpoint 0 setup requests.

```APIDOC
## SETUP_DATA Register

### Description
When endpoint 0 receives a SETUP transaction, the data of the transaction will be stored in this register.

### Method
Not Applicable (Register Access)

### Endpoint
Endpoint 0

### Parameters
#### Register Address
- **0x0040 - 0x0047**

### Request Example
(Register read/write operations)

### Response
(Register values)

#### Success Response (200)
N/A

#### Response Example
(Register values)
```

--------------------------------

### SpinalHDL: Type Casting for Bool, Bits, UInt, and SInt

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Developers area/types.rst

Illustrates type casting between Bool, Bits, UInt, and SInt in SpinalHDL. Shows how to convert between these types, including binary casts and casting to a single Bool based on the least significant bit.

```Scala
// Cast to Bits
x.asBits

// Cast to UInt
x.asUInt

// Cast to SInt
x.asSInt

// Cast to Bool (based on LSB)
x.asBool
```

--------------------------------

### Fork and Join Simulation Threads in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Simulation/threadFull.rst

Demonstrates how to create and manage concurrent simulation threads in SpinalSim using Scala. The `fork` command starts a new thread, and `join` waits for its completion. This allows for parallel execution of testbench tasks.

```scala
// Create a new thread
val myNewThread = fork {
  // New simulation thread body
}

// Wait until `myNewThread` is execution is done.
myNewThread.join()
```

--------------------------------

### Add User-Friendly JTAG Instruction Wrappers in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Examples/Advanced ones/jtag.rst

This Scala code adds user-friendly functions to the JtagTapAccess trait, simplifying the instantiation of JTAG instructions. These wrappers abstract away some of the lower-level details, making it easier to integrate custom JTAG functionality. The provided example shows how to create an 'idcode' wrapper.

```scala
def idcode(value: Bits)(instructionId: Bits) = new JtagInstructionIdcode(instructionId) {
  override def doShift(): Unit = {
    shifter.write(value)
  }
  override def doReset(): Unit = {
    // TODO: implement reset logic
  }
}
```

--------------------------------

### StagePipeline for Sequential Hardware in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/Pipeline/introduction.rst

Illustrates the creation and usage of StagePipeline for building sequential hardware pipelines. It shows how to insert data, perform operations like sum and square at different stages, and connect the final result.

```scala
// Let's define a few inputs/outputs
val a,b = in UInt(8 bits)
val result = out(UInt(16 bits))

// Let's create the pipelining tool.
val pip = new StagePipeline

// Let's insert a and b into the pipeline at stage 0
val A = pip(0).insert(a)
val B = pip(0).insert(b)

// Lets insert the sum of A and B into the stage 1 of our pipeline
val SUM = pip(1).insert(pip(1)(A) + pip(1)(B))

// Clearly, i don't want to say pip(x)(y) on every pipelined thing.
// So instead we can create a pip.Area(x) which will provide a scope which work in stage "x"
val onSquare = new pip.Area(2){
  val VALUE = insert(SUM * SUM)
}

// Lets assign our output result from stage 3
result := pip(3)(onSquare.VALUE)

// Now that everything is specified, we can build the pipeline
pip.build()
```

--------------------------------

### Create Intermediate TileLink Node in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/Bus/tilelink/tilelink_fabric.rst

Illustrates how to instantiate an intermediate TileLink node in SpinalHDL, useful for organizing complex SoC interconnects. This example shows creating a 'peripherals' area with an intermediate node to manage access to multiple GPIO fibers.

```scala
val cpu = new CpuFiber()

val ram = new RamFiber()
ram.up at(0x10000, 0x200) of cpu.down
  
// Create a peripherals namespace to keep things clean.
val peripherals = new Area {
  // Create a intermediate node in the interconnect.
  val access = tilelink.fabric.Node()
  access at 0x20000 of cpu.down

  val gpioA = new GpioFiber()
  gpioA.up at 0x0000 of access

  val gpioB = new GpioFiber()
  gpioB.up at 0x1000 of access
}
```

--------------------------------

### Generated VHDL for BlackBox without Numeric Types (VHDL)

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Structuring/blackbox.rst

This VHDL code snippet shows the resulting component declaration for a BlackBox that has been tagged with `noNumericType`. Notice how the `initValue` and `counter` ports, which were defined as `UInt` in SpinalHDL, are now represented as `std_logic_vector` in the VHDL interface, adhering to the specified constraint.

```vhdl
   component MyBlackBox is
     port(
       clk       : in  std_logic;
       increment : in  std_logic;
       initValue : in  std_logic_vector(7 downto 0);
       counter   : out std_logic_vector(7 downto 0)    
     );
   end component;

```

--------------------------------

### Define MemoryConnection SpinalTag in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/Bus/tilelink/tilelink_fabric.rst

Defines the MemoryConnection trait, a SpinalTag used to represent memory bus connections. It specifies interfaces for masters and slaves, memory mapping, address transformers, and methods to convert memory transfer capabilities.

```Scala
trait MemoryConnection extends SpinalTag {
  // Side toward the masters of the system
  def up : Nameable with SpinalTagReady

  // Side toward the slaves of the system
  def down : Nameable with SpinalTagReady 
  
  // Specify the memory mapping of the slave from the master address (before transformers are applied)
  def mapping : AddressMapping 
  
  // List of alteration done to the address on this connection (ex offset, interleaving, ...)
  def transformers : List[AddressTransformer]  

  // Convert the slave MemoryTransfers capabilities into the master ones
  def sToM(downs : MemoryTransfers, args : MappedNode) : MemoryTransfers = downs 
}
```

--------------------------------

### UartCtrl Component Instantiation (Scala)

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Examples/Intermediates ones/uart.rst

Instantiates and connects UartCtrlRx and UartCtrlTx components, along with clock divider logic, to form the complete UART controller. This component integrates both transmit and receive functionalities.

```scala
class UartCtrl(
   val config : UartCtrlInitConfig = UartCtrlInitConfig()
) extends Component {
  val io = new Bundle {
    val txd = out Bool()
    val rxd = in Bool()
  }

  val uartCtrlTx = new UartCtrlTx(config.txGenerics)
  val uartCtrlRx = new UartCtrlRx(config.rxGenerics)

  uartCtrlTx.io.txd.connect(io.txd)
  uartCtrlRx.io.rxd.connect(io.rxd)

  val txdFlow = Flow (Bits(config.txGenerics.dataWidthMax bits))
  txdFlow.valid := uartCtrlTx.io.write.valid
  txdFlow.payload := uartCtrlTx.io.write.payload
  uartCtrlTx.io.write.ready := True

  val rxdFlow = Flow (Bits(config.rxGenerics.dataWidthMax bits))
  rxdFlow.valid := uartCtrlRx.io.read.valid
  rxdFlow.payload := uartCtrlRx.io.read.payload
  uartCtrlRx.io.read.ready := True

  val clockDivider = ClockDivider(config.clockFrequency, config.baudRate)
  clockDivider.io.enable.foreach(_ := True)

  uartCtrlTx.io.clockDivider.connect(clockDivider.io.output)
  uartCtrlRx.io.clockDivider.connect(clockDivider.io.output)

  uartCtrlTx.io.configFrame := config.frame
  uartCtrlRx.io.configFrame := config.frame

  uartCtrlTx.io.txd := True

  def write(data: Bits) = {
    txdFlow.valid := True
    txdFlow.payload := data
  }
}
```

--------------------------------

### SpinalHDL JTAG Instruction Interface

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Examples/Advanced ones/jtag.rst

Defines an abstract interface for JTAG instructions to interact with the JTAG TAP core. This allows instructions to be implemented independently and integrated seamlessly, promoting modularity and reusability.

```scala
trait JtagTapAccess {
  // JtagTapAccess convenience functions
}
```

--------------------------------

### BusIfVisitor Trait for Custom Documentation

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/regIf.rst

Demonstrates the BusIfVisitor trait, which allows developers to extend the BusIf.RegInsts for custom documentation generation. This trait provides methods to hook into the documentation generation process.

```scala
// lib/src/main/scala/spinal/lib/bus/regif/BusIfBase.scala

trait BusIfVisitor {
  def begin(busDataWidth : Int) : Unit
  def visit(descr : FifoDescr)  : Unit  
  def visit(descr : RegDescr)   : Unit
  def end()                     : Unit
}

```

--------------------------------

### StreamDemux Example in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/stream.rst

Illustrates the StreamDemux component which distributes a single input stream to one of multiple output streams, determined by a select signal. Other output streams remain inactive. Safe transaction handling is crucial and is elaborated in the notes.

```scala
val inputStream = Stream(Bits(8 bits))
val select = UInt(log2Up(portCount) bits)
val outputStreams = StreamDemux(inputStream, select, portCount)
```

--------------------------------

### Instantiate RgbToSomething Component with Default Stages (Scala)

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/Pipeline/introduction.rst

This snippet shows how to instantiate the RgbToSomething component with default stage configurations. It uses SpinalVerilog to generate the Verilog code for the component, which is designed to process RGB data through a series of stages.

```scala
SpinalVerilog(
        new RgbToSomething(
          addAt    = 0,
          invAt    = 1,
          mulAt    = 2,
          resultAt = 3
        )
      )
```

--------------------------------

### SpinalHDL Code Generation (VHDL/Verilog)

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Examples/index.rst

Demonstrates how to generate hardware description language (HDL) code, specifically VHDL or Verilog, from a SpinalHDL component. This involves defining a main object and calling SpinalVhdl or SpinalVerilog with your component instance.

```scala
object MyMainObject {
  def main(args: Array[String]) {
    SpinalVhdl(new TheComponentThatIWantToGenerate(constructionArguments))   // Or SpinalVerilog
  }
}
```

--------------------------------

### Transform Signal to Register using `.setAsReg()` (Scala)

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Sequential logic/registers.rst

Explains how to transform signals into registers using the `.setAsReg()` method. This avoids manual declaration and connection of `Reg` instances, allowing direct assignment to ports. Initialization values can also be provided.

```scala
   val io = new Bundle {
      val apb = master(Apb3(apb3Config))
   }

   io.apb.PADDR.setAsReg()
   io.apb.PWRITE.setAsReg() init(False)

   when(someCondition) {
      io.apb.PWRITE := True
   }
```

--------------------------------

### Implicit Payload Conversion in Scala Node Context

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/Pipeline/introduction.rst

Shows how to leverage implicit conversions within a `Node` context to simplify accessing and manipulating Payload data. This reduces verbosity by allowing direct use of Payload names instead of their node-qualified accessors (e.g., `n1(VALUE)`).

```scala
val VALUE = Payload(UInt(16 bits))
val n1 = new Node {
    // VALUE is implicitly converted into its n1(VALUE) representation
    val PLUS_ONE = insert(VALUE + 1) 
}
```

--------------------------------

### Define VGA Controller Component in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/Graphics/vga.rst

Defines the VgaCtrl component, which acts as a VGA controller. It interfaces with the system via a reset signal and incoming VGA timings, streams pixel data, and outputs the VGA interface signals.

```scala
case class VgaCtrl(rgbConfig: RgbConfig, timingsWidth: Int = 12) extends Component {
  val io = new Bundle {
    val softReset = in Bool()
    val timings   = in(VgaTimings(timingsWidth))

    val frameStart = out Bool()
    val pixels     = slave Stream (Rgb(rgbConfig))
    val vga        = master(Vga(rgbConfig))

    val error      = out Bool()
  }
  // ...
}
```

--------------------------------

### Define PLL BlackBox in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Examples/Simple ones/pll_resetctrl.rst

Defines a generic PLL BlackBox component in SpinalHDL. This definition is used to instantiate a PLL in the hardware design. It requires the SpinalHDL core library.

```scala
import spinal.core._
import spinal.lib._

case class PLL() extends BlackBox {
  val io = new Bundle {
    val clkIn = in Bool()
    val clkOut = out Bool()
    val isLocked = out Bool()
  }
}
```

--------------------------------

### Stream Forking with StreamFork2 and StreamFork in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/stream.rst

Clones incoming data from a single stream to multiple output streams. The `synchronous` parameter determines if outputs must fire together. `StreamFork2` is for two outputs, while `StreamFork` can handle a specified number of outputs.

```scala
val inputStream = Stream(Bits(8 bits)) 
val (outputStream1, outputStream2) = StreamFork2(inputStream, synchronous=false)
```

```scala
val inputStream = Stream(Bits(8 bits)) 
val outputStreams = StreamFork(inputStream,portCount=2, synchronous=true)
```

--------------------------------

### Declare Component Inputs and Outputs Using Bundles in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Developers area/types.rst

Shows the correct syntax for declaring Bundle instances as inputs and outputs of a SpinalHDL Component, using the `in()` and `out()` methods.

```scala
class MyComponent extends Component {
  val io = Bundle {
    val cmd = in(RGB(8))    // Don't forget the bracket around the bundle.
    val rsp = out(RGB(8))
  }
}
```

--------------------------------

### Initialize Register with Random Value (Scala)

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Sequential logic/registers.rst

Demonstrates how to initialize a UInt register with a random value for simulation purposes using `randBoot()`. This is useful when a reset value is not needed in RTL but an initial value is required for simulation to prevent 'x' propagation.

```scala
   // UInt register of 4 bits initialized with a random value
   val reg1 = Reg(UInt(4 bits)) randBoot()
```

--------------------------------

### UART Transmit Queue with Flow Control (Scala)

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Examples/Intermediates ones/uart.rst

This Scala snippet demonstrates adding a queue to the UART write interface for flow control. It allows for buffering data to be transmitted and managing the transmission rate. It utilizes SpinalHDL's Stream components for queuing and flow control.

```scala
  // start tx queue
  val txQueue = Stream(UInt(8 bits))
  txQueue >> uart.write
  // end tx queue
```

--------------------------------

### Implement Hardware Slots with SpinalHDL Area

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Examples/Advanced ones/slots.rst

This SpinalHDL code snippet demonstrates how to implement an array of hardware 'slots' using the Area abstraction. It avoids the use of Vec, integrating signals, registers, and logic definitions within each slot. The reader API is intended for SpinalHDL versions 1.9.1 and later.

```scala
package spinaldoc.examples.advanced

import spinal.core._
import spinal.lib._

class Slots extends Component {

  val io = new Bundle {
    val flush = in Bool()
    val flushdone = out Bool()
  }

  val AREA = new Area {
    val counter = Reg(UInt(4 bits)) init (0)
    val enable = False

    when(enable) {
      counter := counter + 1
    }
  }

  import AREA._ // Access AREA members directly

  val flushdone = OHMasking.first(io.flush) // Get the first active flush signal

  onMask(io.flush) { // Triggered when any signal in io.flush is high
    enable := True
    AREA.counter.clear()
  }

  io.flushdone := flushdone
}
```

--------------------------------

### Convert Int/Long/BigInt to Binary List

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/binarySystem.rst

Converts an Int, Long, or BigInt to a List of Ints representing its binary form. The list can be optionally aligned to a specified number of bits, with zero-filling at the most significant bit positions.

```scala
import spinal.core.lib._

$: 32.toBinInts
List(0, 0, 0, 0, 0, 1)
$: 1302309988L.toBinInts
List(0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 0, 0, 1)
$: BigInt("100101110", 2).toBinInts
List(0, 1, 1, 1, 0, 1, 0, 0, 1)
$: BigInt("123456789abcdef0", 16).toBinInts
List(0, 0, 0, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 0, 0, 0, 1, 0, 0, 1)
$: BigInt("1234567", 8).toBinInts
List(1, 1, 1, 0, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0, 0, 1, 0, 1)
$: BigInt("123451118", 10).toBinInts
List(0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 1)
```

```scala
import spinal.core.lib._

$: 39.toBinInts()
List(1, 1, 1, 0, 0, 1)
$: 39.toBinInts(8)    // align to 8 bit zero filled at MSB
List(1, 1, 1, 0, 0, 1, 0, 0)
```

--------------------------------

### SpinalHDL: Correct Unregistered Input Definition

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Design errors/register_defined_as_component_input.rst

This snippet shows the corrected way to define an input signal in SpinalHDL. It declares the input as a standard type (e.g., UInt) without the 'Reg' wrapper, adhering to the SpinalHDL restriction.

```scala
class TopLevel extends Component {
  val io = new Bundle {
    val a = in UInt(8 bits)
  }
}
```

--------------------------------

### HSRW/RWHS Register Logic Example

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/regIf.rst

Verilog code illustrating the behavior of HSRW and RWHS registers, showing how hardware and software writes are prioritized based on the register type.

```verilog
always @(posedge clk or negedge rstn)
  if(!rstn) begin
     reg0  <= '0;
     reg0  <= '0;
  end else begin
     if(hit_0x0000) begin
        reg0 <= wdata ;
     end
     if(io.xxx_set) begin      // HW have High priority than SW
        reg0 <= io.xxx_set_val ;
     end

     if(io.xxx_set) begin
        reg1 <= io.xxx_set_val ;
     end 
     if(hit_0x0004) begin      // SW have High priority than HW
        reg1 <= wdata ;
     end
  end
```

--------------------------------

### Create and Drive Payload Instances in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/Pipeline/introduction.rst

Demonstrates how to create a new Payload instance connected to a hardware signal and how to manually drive or read its arbitration and data within a Node. This is useful for initializing or setting specific values for hardware signals.

```scala
val n0, n1 = Node()

val PC = Payload(UInt(32 bits))
n0(PC) := 0x42
n0(PC, "true") := 0x42
n0(PC, 0x666) := 0xEE
val SOMETHING = n0.insert(myHardwareSignal) // This create a new Payload
when(n1(SOMETHING) === 0xFFAA){ ... }
```

--------------------------------

### Define SpinalHDL Bundle for Data Structure

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Getting Started/Help for VHDL people/vhdl_perspective.rst

Illustrates the definition of a SpinalHDL `Bundle`, which is equivalent to VHDL records. This example defines an `RGB` bundle with individual color channels, parameterized by `channelWidth`, similar to VHDL generics for data structures.

```scala
case class RGB(channelWidth: Int) extends Bundle {
  val r, g, b = UInt(channelWidth bits)
}
```

--------------------------------

### Define VGA Bus Bundle in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/Graphics/vga.rst

Defines the Vga bundle, which represents the VGA interface signals. It includes vertical and horizontal synchronization signals, a color enable signal, and the RGB color data.

```scala
case class Vga (rgbConfig: RgbConfig) extends Bundle with IMasterSlave {
  val vSync = Bool()
  val hSync = Bool()

  val colorEn = Bool()  // High when the frame is inside the color area
  val color = Rgb(rgbConfig)

  override def asMaster() = this.asOutput()
}
```

--------------------------------

### Fragment Header Insertion for Stream Bundles

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/fragment.rst

Demonstrates how to add a header to each packet within a Stream bundle of Fragments. The 'insertHeader' function takes a header of type 'T' and returns the modified Stream.

```SpinalHDL
x.insertHeader(header : T)
```

--------------------------------

### Declare and Initialize Vec in SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/Vec.rst

Demonstrates how to declare and initialize vectors in SpinalHDL using Vec.fill for fixed-size vectors of the same type and Vec with explicit elements for mixed types or referencing existing signals. It shows basic assignment and iteration.

```scala
   // Create a vector of 2 signed integers
   val myVecOfSInt = Vec.fill(2)(SInt(8 bits))
   myVecOfSInt(0) := 2                   // assignment to populate index 0
   myVecOfSInt(1) := myVecOfSInt(0) + 3  // assignment to populate index 1

   // Create a vector of 3 different type elements
   val myVecOfMixedUInt = Vec(UInt(3 bits), UInt(5 bits), UInt(8 bits))

   val x, y, z = UInt(8 bits)
   val myVecOf_xyz_ref = Vec(x, y, z)

   // Iterate on a vector
   for(element <- myVecOf_xyz_ref) {
     element := 0   // Assign x, y, z with the value 0
   }

   // Map on vector
   myVecOfMixedUInt.map(_ := 0) // Assign all elements with value 0

   // Assign 3 to the first element of the vector
   myVecOf_xyz_ref(1) := 3
```

--------------------------------

### SpinalHDL Component Definition and Instantiation

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/miscelenea/core/core_components.rst

Shows how to define reusable hardware components in SpinalHDL, including declaring input/output ports using Bundles and instantiating them to build hierarchical designs. It covers different ways to define ports like Bool, Bits, UInt, and SInt.

```scala
   class AdderCell extends Component {
     // Declaring all in/out in an io Bundle is probably a good practice
     val io = new Bundle {
       val a, b, cin = in Bool()
       val sum, cout = out Bool()
     }
     // Do some logic
     io.sum := io.a ^ io.b ^ io.cin
     io.cout := (io.a & io.b) | (io.a & io.cin) | (io.b & io.cin)
   }

   class Adder(width: Int) extends Component {
     ...
     // Create 2 AdderCell
     val cell0 = new AdderCell
     val cell1 = new AdderCell
     cell1.io.cin := cell0.io.cout // Connect carrys
     ...
     val cellArray = Array.fill(width)(new AdderCell)
     ...
   }
```

--------------------------------

### Scala Instruction Cache Configuration

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Getting Started/Help for VHDL people/vhdl_comp.rst

Defines configuration parameters for an instruction cache (ICache) in SpinalHDL, specifying size, line size, ways, memory access wrapping, and address/data widths.

```scala
val iCacheConfig = InstructionCacheConfig(
  cacheSize = 4096,
  bytePerLine = 32,
  wayCount = 1,  // Can only be one for the moment
  wrappedMemAccess = true,
  addressWidth = 32,
  cpuDataWidth = 32,
  memDataWidth = 32
)
```

--------------------------------

### Watch and Regenerate HDL with SBT

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Getting Started/SBT.rst

This demonstrates using the '~' prefix with 'runMain' in SBT to enable watch mode. SBT will automatically re-run the specified main class whenever source files change, recompiling and regenerating HDL code. This provides near real-time feedback during development.

```text
~ runMain projectname.MyTopLevelVerilog
```

--------------------------------

### VHDL output for InOutWrapper transformed component - SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Other language features/analog_inout.rst

Shows the VHDL entity and port declaration generated after applying InOutWrapper to a SpinalHDL component. The 'io_gpio' signal, originally a TriStateArray Bundle, is now declared as 'inout std_logic_vector'.

```vhdl
entity Apb3Gpio is
  port(
    io_gpio : inout std_logic_vector(31 downto 0); -- This io_gpio was originally a TriStateArray Bundle
    io_apb_PADDR : in unsigned(3 downto 0);
    io_apb_PSEL : in std_logic_vector(0 downto 0);
    io_apb_PENABLE : in std_logic;
    io_apb_PREADY : out std_logic;
    io_apb_PWRITE : in std_logic;
    io_apb_PWDATA : in std_logic_vector(31 downto 0);
    io_apb_PRDATA : out std_logic_vector(31 downto 0);
    io_apb_PSLVERROR : out std_logic;
    clk : in std_logic;
    reset : in std_logic
  );
end Apb3Gpio;
```

--------------------------------

### Default Entry State Configuration in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/fsm.rst

Shows the standard way to define an entry state for a state machine using `setEntry()`. This ensures that the state machine starts in the specified state after reset, and its `onEntry` logic is executed.

```scala
//  State sequence : BOOT, IDLE, STATE_A, STATE_B, ...
val fsm = new StateMachine {
  val IDLE, STATE_A, STATE_B, STATE_C = new State
  setEntry(IDLE)
  
  IDLE.whenIsActive(goto(STATE_A))
  STATE_A.whenIsActive(goto(STATE_B))
  STATE_B.whenIsActive(goto(STATE_C))
  STATE_C.whenIsActive(goto(STATE_B))
}
```

--------------------------------

### Generate Pinsec RTL using sbt

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Legacy/pinsec/hardware.rst

This snippet shows how to generate the RTL for the Pinsec project using the sbt build tool. It can be run directly from the command line or by creating a custom main object in your own SBT project.

```scala
sbt "project SpinalHDL-lib" "run-main spinal.lib.soc.pinsec.Pinsec"
```

```scala
import spinal.lib.soc.pinsec._

object PinsecMain {
  def main(args: Array[String]) {
    SpinalVhdl(new Pinsec(100 MHz))
    SpinalVerilog(new Pinsec(100 MHz))
  }
}
```

--------------------------------

### Fix Clock Crossing Violation with setSynchronousWith - SpinalHDL

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Design errors/clock_crossing_violation.rst

Shows how to make two clock domains synchronous in SpinalHDL using the 'setSynchronousWith' method. This approach asserts that the domains share a synchronous relationship, thereby preventing violation warnings.

```scala
class TopLevel extends Component {
  val clkA = ClockDomain.external("clkA")
  val clkB = ClockDomain.external("clkB")
  clkB.setSynchronousWith(clkA)

  val regA = clkA(Reg(UInt(8 bits)))
  val regB = clkB(Reg(UInt(8 bits)))


  val tmp = regA + regA
  regB := tmp
}
```

--------------------------------

### Stream Arbitration with StreamArbiterFactory in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/stream.rst

Arbitrates multiple input streams into a single output stream using various strategies like round-robin or priority-based. It supports different locking mechanisms to control arbitration behavior. Requires the Stream library.

```scala
val streamA, streamB, streamC = Stream(Bits(8 bits)) 
val arbiteredABC = StreamArbiterFactory.roundRobin.onArgs(streamA, streamB, streamC)
```

```scala
val streamD, streamE, streamF = Stream(Bits(8 bits)) 
val arbiteredDEF = StreamArbiterFactory.lowerFirst.noLock.onArgs(streamD, streamE, streamF)
```

--------------------------------

### Convert Binary List to Long (Scala)

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/binarySystem.rst

Converts a list of binary digits (0s and 1s) into a long integer. This is useful for binary numbers that exceed the range of a standard integer.

```scala
$: List(1, 1, 1, 0, 0, 1).binIntsToLong
39
```

--------------------------------

### Parallel State Machines (StateParallelFsm) in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Libraries/fsm.rst

Illustrates the use of `StateParallelFsm` to manage multiple nested state machines concurrently. The outer state machine continues only when all parallel inner state machines have finished.

```scala
val stateD = new StateParallelFsm (internalFsmA(), internalFsmB()) {
  whenCompleted {
    goto(stateE)
  }
}
```

--------------------------------

### Define UART Controller Frame Configuration in Scala

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Examples/Intermediates ones/uart.rst

Defines a bundle to configure the frame format of the UART controller, including data width, parity type, and stop bit count. This bundle is used to set up the transmission and reception parameters.

```scala
case class UartCtrlFrameConfig(g : UartCtrlGenerics) extends Bundle {
  //... (content omitted for brevity)
}
```

--------------------------------

### Declare Recoded Floating-Point Numbers

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Data types/Floating.rst

This section illustrates the syntax for declaring recoded floating-point numbers, which simplify handling edge cases in IEEE-754. It supports custom exponent and mantissa sizes, as well as standard precisions.

```scala
RecFloating(exponentSize: Int, mantissaSize: Int)
RecFloating16()
RecFloating32()
RecFloating64()
RecFloating128()
```

--------------------------------

### Scala Version Configuration in build.sc

Source: https://github.com/spinalhdl/spinaldoc-rtd/blob/master/source/SpinalHDL/Introduction/faq.rst

This snippet shows how to define the Scala version for a project using a `build.sc` file. It declares a `scalaVersion` constant, which is then used to configure the Scala version for the project, ensuring compatibility with dependencies.

```scala
def scalaVersion = "2.12.16"
```