class Wllvm < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for building whole-program LLVM bitcode files"
  homepage "https://pypi.org/project/wllvm/"
  url "https://files.pythonhosted.org/packages/4b/df/31d7519052bc21d0e9771e9a6540d6310bfb13bae7dacde060d8f647b8d3/wllvm-1.3.1.tar.gz"
  sha256 "3e057a575f05c9ecc8669a8c4046f2bfdf0c69533b87b4fbfcabe0df230cc331"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b146448a287a26c086f41c4db6222e2f2969bbc12a4d86c9eaf05e2ce5ed4da2"
    sha256 cellar: :any_skip_relocation, big_sur:       "fe0b731ecde0d7e66f096f374741fc177fa01c2d866d28d2519b009f7f3f881a"
    sha256 cellar: :any_skip_relocation, catalina:      "87139d500bf0594a1573a3d6c7f860db22d5608f1556771cf4ae2dd06e45d828"
    sha256 cellar: :any_skip_relocation, mojave:        "cbaafe80bf7c436c2aca8d8080f1772d5d592836ce05d8b3864345b53bd4f4e2"
  end

  depends_on "llvm"
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
