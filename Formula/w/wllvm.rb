class Wllvm < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for building whole-program LLVM bitcode files"
  homepage "https://pypi.org/project/wllvm/"
  url "https://files.pythonhosted.org/packages/4b/df/31d7519052bc21d0e9771e9a6540d6310bfb13bae7dacde060d8f647b8d3/wllvm-1.3.1.tar.gz"
  sha256 "3e057a575f05c9ecc8669a8c4046f2bfdf0c69533b87b4fbfcabe0df230cc331"
  license "MIT"
  revision 1

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f248aeb32b9b78c63e59f10eb7d2a51506d97a17cd1566098a11bcb55cea4005"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ac2be94727ddc9d9b96ebb3dd4bc5045220b274c56bf55146e03556e612ade0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f1847d6339c7feaa5fa742a9176ba675ba85f500f8cd8d1982618ca8a96eb55"
    sha256 cellar: :any_skip_relocation, sonoma:         "345ac6f068520408b820bd2e6db8848ab14183ff987a0657896b8de88d9d7d36"
    sha256 cellar: :any_skip_relocation, ventura:        "f0e846f9ce218f4ba70cb5b4fc820873d7635b57e45d3380e9b95390ade46e00"
    sha256 cellar: :any_skip_relocation, monterey:       "c0ab2b734ffe3421c7880dd8daf928775f481844c3b087343b48a43f232b8af2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d498bbcc563be8807d7bbdc6cd7aaf6d5f7fefb11b9f0fd38418a0274198f680"
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
