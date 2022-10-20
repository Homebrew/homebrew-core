class Wllvm < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for building whole-program LLVM bitcode files"
  homepage "https://pypi.org/project/wllvm/"
  url "https://files.pythonhosted.org/packages/4b/df/31d7519052bc21d0e9771e9a6540d6310bfb13bae7dacde060d8f647b8d3/wllvm-1.3.1.tar.gz"
  sha256 "3e057a575f05c9ecc8669a8c4046f2bfdf0c69533b87b4fbfcabe0df230cc331"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf463932cd82d551e7ec1ab19c31c6317fe716c5e5f40d6cb89e2e799abc3511"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf463932cd82d551e7ec1ab19c31c6317fe716c5e5f40d6cb89e2e799abc3511"
    sha256 cellar: :any_skip_relocation, monterey:       "68f0c14c32a408b35a74ffd3993ddc00a76ead4fbb486591df2ff2c69d8b4485"
    sha256 cellar: :any_skip_relocation, big_sur:        "68f0c14c32a408b35a74ffd3993ddc00a76ead4fbb486591df2ff2c69d8b4485"
    sha256 cellar: :any_skip_relocation, catalina:       "68f0c14c32a408b35a74ffd3993ddc00a76ead4fbb486591df2ff2c69d8b4485"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "069f52ae61c69357a08d50c16a77a257122ff85e10c9b7deaa14ae4840460f21"
  end

  depends_on "llvm" => :test
  depends_on "python@3.10"

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
