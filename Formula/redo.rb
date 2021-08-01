class Redo < Formula
  include Language::Python::Virtualenv

  desc "Implements djb's redo: an alternative to make"
  homepage "https://redo.rtfd.io/"
  url "https://github.com/apenwarr/redo/archive/redo-0.42d.tar.gz"
  sha256 "47056b429ff5f85f593dcba21bae7bc6a16208a56b189424eae3de5f2e79abc1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "925acd1a773f80586f5f5d1d086b91f9f50aadfa7583e0c20ee192680d0dd335"
    sha256 cellar: :any_skip_relocation, big_sur:       "0615d83e9b519ec99eda993775fbea61fe32a0a83cd5a2ffc7c3da0323cd0322"
    sha256 cellar: :any_skip_relocation, catalina:      "4531c1e25405e7cc940e109fdc7f028cfc84b6b224874d861f112371da993fac"
    sha256 cellar: :any_skip_relocation, mojave:        "9b3f873c69959f246ea6c8abbea58f875e436fa260aefcb2697d798cfd803b3e"
    sha256 cellar: :any_skip_relocation, high_sierra:   "0e30bad1e3dad48d66fb4061e4fb7dbd7b5b3450a53a93275990a66b2bc558dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d8225be3c8980d7be6392a8d42f6c2e6fbf044ca9b781c474155f860f938a38"
  end

  depends_on "python@3.9"

  resource "Markdown" do
    url "https://files.pythonhosted.org/packages/49/02/37bd82ae255bb4dfef97a4b32d95906187b7a7a74970761fca1360c4ba22/Markdown-3.3.4.tar.gz"
    sha256 "31b5b491868dcc87d6c24b7e3d19a0d730d59d3e46f4eea6430a321bed387a49"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/6b/c3/d31704ae558dcca862e4ee8e8388f357af6c9d9acb0cad4ba0fbbd350d9a/beautifulsoup4-4.9.3.tar.gz"
    sha256 "84729e322ad1d5b4d25f805bfa05b902dd96450f43842c4e99067d5e1369eb25"
  end

  def install
    venv = virtualenv_create(libexec, Formula["python@3.9"].opt_bin/"python3")
    venv.pip_install resources
    # Set the interpreter so that ./do install can find the pip installed
    # resources
    ENV["DESTDIR"] = ""
    ENV["PREFIX"] = prefix
    system "./do", "install"
    man1.install Dir["docs/*.1"]
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/redo --version").strip
    # Test is based on https://redo.readthedocs.io/en/latest/cookbook/hello/
    (testpath/"hello.c").write <<~EOS
      #include <stdio.h>

      int main() {
          printf(\"Hello, world!\\n\");
          return 0;
      }
    EOS
    (testpath/"hello.do").write <<~EOS
      redo-ifchange hello.c
      cc -o $3 hello.c -Wall
    EOS
    assert_equal "redo  hello", shell_output("redo hello 2>&1").strip
    assert_predicate testpath/"hello", :exist?
    assert_equal "Hello, world!\n", shell_output("./hello")
    assert_equal "redo  hello", shell_output("redo hello 2>&1").strip
    assert_equal "", shell_output("redo-ifchange hello 2>&1").strip
    touch "hello.c"
    assert_equal "redo  hello", shell_output("redo-ifchange hello 2>&1").strip
    (testpath/"all.do").write("redo-ifchange hello")
    (testpath/"hello").delete
    assert_equal "redo  all\nredo    hello", shell_output("redo 2>&1").strip
  end
end
