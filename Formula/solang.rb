class Solang < Formula
  desc "Solidity Compiler for Solana, Substrate, and ewasm"
  homepage "https://solang.readthedocs.io/en/latest/"
  url "https://github.com/hyperledger-labs/solang/archive/refs/tags/v0.1.12.tar.gz"
  sha256 "ee0cdf17469a3a8db8db5c3e37632d9a51a85000604ff05e77ced3d23f28b393"
  license "Apache-2.0"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "python@3.10" => :build
  depends_on "rust" => :build

  def install
    system "git", "clone", "--depth", "1", "--branch", "solana-rustc/13.0-2021-08-08", "https://github.com/solana-labs/llvm-project"
    mkdir "solana-llvm13.0"
    cd "llvm-project" do
      system "cmake", "-G", "Ninja", "-DLLVM_ENABLE_ASSERTIONS=On", "-DLLVM_ENABLE_PROJECTS=lld",
      "-DLLVM_ENABLE_TERMINFO=Off", "-DLLVM_ENABLE_LIBXML2=Off", "-DLLVM_ENABLE_ZLIB=Off",
      "-DLLVM_TARGETS_TO_BUILD='WebAssembly;BPF'", "-DCMAKE_BUILD_TYPE=Release",
      "-DCMAKE_INSTALL_PREFIX=../solana-llvm13.0", "-B", "build", "llvm"
      system "cmake", "--build", "build", "--target", "install"
    end
    ENV["PATH"]="#{buildpath}/solana-llvm13.0/bin:" + ENV["PATH"]
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"flipper.sol").write <<~EOS
      contract flipper {
	      bool private value;
          constructor(bool initvalue) {
            value = initvalue;
          }

	        function flip() public {
		        value = !value;
	        }

      	  function get() public view returns (bool) {
		        return value;
	        }
        }
    EOS
    system "#{bin}/solang", "--target", "solana", "flipper.sol"
    assert File.file?("#{testpath}/flipper.abi")
    assert File.file?("#{testpath}/bundle.so")
  end
end
