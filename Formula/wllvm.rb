class Wllvm < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for building whole-program LLVM bitcode files"
  homepage "https://pypi.org/project/wllvm/"
  url "https://files.pythonhosted.org/packages/4b/df/31d7519052bc21d0e9771e9a6540d6310bfb13bae7dacde060d8f647b8d3/wllvm-1.3.1.tar.gz"
  sha256 "3e057a575f05c9ecc8669a8c4046f2bfdf0c69533b87b4fbfcabe0df230cc331"
  license "MIT"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "407bf86e983aa21c26b3b2551c60430a4f88d6673d53500204a1c4c405638f99"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "407bf86e983aa21c26b3b2551c60430a4f88d6673d53500204a1c4c405638f99"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "407bf86e983aa21c26b3b2551c60430a4f88d6673d53500204a1c4c405638f99"
    sha256 cellar: :any_skip_relocation, ventura:        "e42c4bb6b456a9e91a62729e53a547d3df665e39ffb6cd39e9cc87d672a4fda5"
    sha256 cellar: :any_skip_relocation, monterey:       "e42c4bb6b456a9e91a62729e53a547d3df665e39ffb6cd39e9cc87d672a4fda5"
    sha256 cellar: :any_skip_relocation, big_sur:        "e42c4bb6b456a9e91a62729e53a547d3df665e39ffb6cd39e9cc87d672a4fda5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "213ee00f14ad940edf9be4b87d2b65f39246646173e1eee21f6fedf5d459b164"
  end

  depends_on "llvm" => :test
  depends_on "python@3.11"

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
