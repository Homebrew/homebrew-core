class Wllvm < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for building whole-program LLVM bitcode files"
  homepage "https://pypi.org/project/wllvm/"
  url "https://files.pythonhosted.org/packages/4b/df/31d7519052bc21d0e9771e9a6540d6310bfb13bae7dacde060d8f647b8d3/wllvm-1.3.1.tar.gz"
  sha256 "3e057a575f05c9ecc8669a8c4046f2bfdf0c69533b87b4fbfcabe0df230cc331"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0e2d0379de94210ef4627ba7093361c994bc44d732a9c8c3abe56237b37a792e"
    sha256 cellar: :any_skip_relocation, big_sur:       "15cfa5f572614f6f4c3cd2bc30f3983830b5cae8736f08e1514bc9608cef0dc1"
    sha256 cellar: :any_skip_relocation, catalina:      "860faf0ed34adee6eeedbed016b90f0dc53cf2d74c7a2a68685ce7c49e6e2ce6"
    sha256 cellar: :any_skip_relocation, mojave:        "c953b8c3d45d6df5a67e5d334fe279a50cef7ccf9d67e7d53db995285da433c3"
  end

  depends_on "llvm" => :test
  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV.prepend_path "PATH", Formula["llvm"].opt_bin
    (testpath/"test.c").write "int main() { return 0; }"

    with_env(LLVM_COMPILER: "clang") do
      system bin/"wllvm", testpath/"test.c", "-o", testpath/"test"
    end
    assert_predicate testpath/".test.o", :exist?
    assert_predicate testpath/".test.o.bc", :exist?

    system bin/"extract-bc", testpath/"test"
    assert_predicate testpath/"test.bc", :exist?
  end
end
