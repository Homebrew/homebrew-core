class Wllvm < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for building whole-program LLVM bitcode files"
  homepage "https://pypi.org/project/wllvm/"
  url "https://files.pythonhosted.org/packages/4b/df/31d7519052bc21d0e9771e9a6540d6310bfb13bae7dacde060d8f647b8d3/wllvm-1.3.1.tar.gz"
  sha256 "3e057a575f05c9ecc8669a8c4046f2bfdf0c69533b87b4fbfcabe0df230cc331"
  license "MIT"
  revision 1

  bottle do
    rebuild 6
    sha256 cellar: :any_skip_relocation, all: "34b9e23ff00414b2329a09ea3e9820175aa07881d236a218aeebd5abec34d9c6"
  end

  depends_on "llvm" => :test
  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV.prepend_path "PATH", Formula["llvm"].opt_bin
    (testpath/"test.c").write "int main() { return 0; }"

    with_env(LLVM_COMPILER: "clang") do
      system bin/"wllvm", testpath/"test.c", "-o", testpath/"test"
    end
    assert_path_exists testpath/".test.o"
    assert_path_exists testpath/".test.o.bc"

    system bin/"extract-bc", testpath/"test"
    assert_path_exists testpath/"test.bc"
  end
end
