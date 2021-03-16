class Wllvm < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for building whole-program LLVM bitcode files"
  homepage "https://pypi.org/project/wllvm/"
  url "https://files.pythonhosted.org/packages/63/cd/0cc7994c2a94983adb8b07f34a88e6a815f4d18a1e29eb68d094e5863f18/wllvm-1.3.0.tar.gz"
  sha256 "a98dd48350d8aae80fe03b92efb11c3e1b92f6aee482f4331f7c97265ca7a602"
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

    # extract-bc currently does not work on ARM.
    # https://github.com/SRI-CSL/whole-program-llvm/issues/29
    unless Hardware::CPU.arm?
      system bin/"extract-bc", testpath/"test"
      assert_predicate testpath/"test.bc", :exist?
    end
  end
end
