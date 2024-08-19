class Wllvm < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for building whole-program LLVM bitcode files"
  homepage "https://pypi.org/project/wllvm/"
  url "https://files.pythonhosted.org/packages/4b/df/31d7519052bc21d0e9771e9a6540d6310bfb13bae7dacde060d8f647b8d3/wllvm-1.3.1.tar.gz"
  sha256 "3e057a575f05c9ecc8669a8c4046f2bfdf0c69533b87b4fbfcabe0df230cc331"
  license "MIT"
  revision 1

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bbf98dd9a4969133083c1a5ff4a99a1eb585cd0d7e38cdaff296cd2ec2ccdfff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa7b51346868a77f7cf2bff65e85d6baa23511b8285863a1d4ae107488a43e6b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3486584a33b29ab6879a93e1506a47f53fbab9111f81a1a92f3ab5d29506d850"
    sha256 cellar: :any_skip_relocation, sonoma:         "2fbfbce80ce5074d98f9b201a1e8ca4c3b39a89b1e357d307abee6b8eab66b9d"
    sha256 cellar: :any_skip_relocation, ventura:        "55f22a1c92f0fd35308142e8aa463de80fb1979f67128f5cfa24799db39099a2"
    sha256 cellar: :any_skip_relocation, monterey:       "7faf88e2861ce76c86c1476d6793631971c2d87089be8d85453ac3dffe676309"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c466fd407dc9cef28b763df4376a41eef4dd76c3af22a8b7efcab96942837c0c"
  end

  depends_on "llvm" => :test
  depends_on "python@3.12"

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
