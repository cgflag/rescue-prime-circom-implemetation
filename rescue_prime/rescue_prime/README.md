# README

Rescue-Prime 是一种基于密码学的哈希函数，它在区块链和零知识证明系统中有着广泛的应用。以下是该项目的 Markdown 说明文档，旨在帮助用户理解和使用这个 Rescue-Prime 的 Circom 实现。

## 项目概述

这个项目提供了 Rescue-Prime 哈希函数的 Circom 实现，允许用户在 zk-SNARKs 应用中使用它来生成哈希值。Circom 是一种用于创建零知识证明电路的语言，而 Rescue-Prime 是为这些类型的电路优化的哈希函数。

## 项目依赖

要使用这个项目，您需要先安装 Circom 和相关的工具。以下是基本的步骤：

Circom的环境和依赖包括：

​	Rust：Circom的核心工具是用Rust编写的Circom编译器。为了在系统中使用Rust，你可以安装rustup。
​	Node.js和npm或yarn：Circom还分发了一系列npm包，所以Node.js和一些包管理器如npm或yarn应该在你的系统中可用。为了获得更好的性能，建议安装10或更高版本的Node.js。
​	circomlib：Circom可以通过组合称为模板的较小通用电路来创建大型电路。circomlib是一个包含数百个电路（如比较器，哈希函数，数字签名，二进制和十进制转换器等）的circom模板库。
​	snarkjs：snarkjs是一个npm包，其中包含从Circom生成的工件生成和验证ZK证明的代码。
安装Circom的步骤如下：

**克隆Circom仓库**：

```git clone https://github.com/iden3/circom.git51。```
进入Circom目录，使用

```cargo build --release```

进行编译

**安装二进制文件**：

```cargo install --path circom```

其他依赖环境的安装命令：
1. **Rust**：
    - 在Linux或macOS上，打开终端并输入以下命令：
    ```bash
    curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh
    ```
    - 在Windows上，你可以访问[这个链接]，然后按照页面上的指示进行安装。

2. **Node.js**：
    - 在macOS和Linux上，你可以使用包管理器来安装Node.js。例如，使用Homebrew（macOS）或apt（Linux）：
    ```bash
    brew install node  # macOS
    sudo apt install nodejs  # Linux
    ```
    - 在Windows上，你可以使用Chocolatey来安装Node.js：
    ```bash
    choco install nodejs
    ```
    - 或者，你可以从Node.js的[官方下载页面]下载适合你的平台的安装包。

3. **circomlib**：
    ```bash
    npm install -g circomlib
    ```

4. **snarkjs**：
    ```bash
    npm install -g snarkjs@latest
    ```

## 文件结构

- `rescue-XLIX-permutation-single-round.circom`

这是Rescue-Prime哈希函数中的一个基本组成部分。每一轮的操作包括：

​	前向S-box层：对状态中的每个元素应用幂映射（例如，α）。

​	MDS矩阵：通过矩阵向量乘法将MDS矩阵应用于状态。

​	轮常数注入：将下一个预定义的m个常数从轮常数列表{Ci}添加到状态中。

​	反向（后向）S-box层：对状态中的每个元素应用逆幂映射（例如，α^-1）。

- `rescue-XLIX-permutation.circom`

  这是Rescue-Prime哈希函数的核心部分，它由N次迭代的Rescue-XLIX轮函数组成。

- `rescue-prime-hash.circom`

  这是基于Rescue-XLIX置换的哈希函数。它接收输入，通过Rescue-XLIX置换进行处理，然后输出哈希值。这是本项目的**主文件**。

- `round-constants.circom`

  这是Rescue-Prime哈希函数中用于轮常数注入的预定义常数。这些常数在每轮操作中被添加到状态中。

- `rescue.circom`和`rescue-constants.circom`

  这是用以参考的普通rescue哈希函数的实现，可以明显看到其中的欠约束问题。（使用<--赋值）

## 使用示例

### 编译Circom文件

使用以下命令来编译Circom文件：
```bash
circom your_circuit.circom --r1cs --wasm --sym --c

这个命令会生成以下几种类型的文件：

--r1cs：生成一个名为your_circuit.r1cs的文件，该文件以二进制格式包含电路的R1CS约束系统。
--wasm：生成一个WebAssembly程序，该程序接收私有和公共输入，并生成电路证明。
--sym：为电路的每个信号输出：由编译器给出的唯一编号，Circom合格名称，包含它的见证信号的编号，以及它所属的组件的（唯一）编号。
--c：生成一个C++程序，该程序接收私有和公共输入，并生成电路证明。
```

### 选择编译选项
Circom编译器提供了许多编译选项，你可以通过运行以下命令来查看所有可用的选项和标志：

```circom --help```

