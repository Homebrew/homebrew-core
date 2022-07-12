class Solang < Formula
  desc "Solidity Compiler for Solana, Substrate, and ewasm"
  homepage "https://solang.readthedocs.io/en/latest/"
  url "https://github.com/hyperledger-labs/solang/archive/refs/tags/v0.1.12.tar.gz"
  sha256 "ee0cdf17469a3a8db8db5c3e37632d9a51a85000604ff05e77ced3d23f28b393"
  license "Apache-2.0"

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build
  depends_on "rust" => :build

  resource "llvm" do
    url "https://github.com/solana-labs/llvm-project.git",
        revision: "920bf6a3c2476f640448cc534399ad17820f10d7"
  end

  def install
    resource("llvm").stage do
      system "cmake", "-S", "llvm-project", "-B", "build",
                      *std_cmake_args(install_prefix: buildpath/"solana-llvm"),
                      "-DLLVM_ENABLE_ASSERTIONS=ON",
                      "-DLLVM_ENABLE_PROJECTS=lld",
                      "-DLLVM_ENABLE_TERMINFO=OFF",
                      "-DLLVM_ENABLE_LIBXML2=OFF",
                      "-DLLVM_ENABLE_ZLIB=OFF",
                      "-DLLVM_TARGETS_TO_BUILD=WebAssembly;BPF"
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end
    ENV.prepend_path "PATH", buildpath/"solana-llvm/bin"
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
    system bin/"solang", "--target", "solana", "flipper.sol"
    assert_predicate testpath/"flipper.abi", :file?
    assert_predicate testpath/"bundle.so", :file?
  end
end
