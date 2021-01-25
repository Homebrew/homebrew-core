class Redo < Formula
  include Language::Python::Virtualenv

  desc "Implements djb's redo: an alternative to make"
  homepage "https://redo.rtfd.io/"
  url "https://github.com/apenwarr/redo/archive/redo-0.42c.tar.gz"
  sha256 "6f1600c82d00bdfa75445e1e161477f876bd2615eb4371eb1bcf0a7e252dc79f"
  license "Apache-2.0"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "0615d83e9b519ec99eda993775fbea61fe32a0a83cd5a2ffc7c3da0323cd0322" => :big_sur
    sha256 "925acd1a773f80586f5f5d1d086b91f9f50aadfa7583e0c20ee192680d0dd335" => :arm64_big_sur
    sha256 "4531c1e25405e7cc940e109fdc7f028cfc84b6b224874d861f112371da993fac" => :catalina
    sha256 "9b3f873c69959f246ea6c8abbea58f875e436fa260aefcb2697d798cfd803b3e" => :mojave
    sha256 "0e30bad1e3dad48d66fb4061e4fb7dbd7b5b3450a53a93275990a66b2bc558dc" => :high_sierra
  end

  depends_on "python@3.9"

  resource "Markdown" do
    url "https://files.pythonhosted.org/packages/44/30/cb4555416609a8f75525e34cbacfc721aa5b0044809968b2cf553fd879c7/Markdown-3.2.2.tar.gz"
    sha256 "1fafe3f1ecabfb514a5285fca634a53c1b32a81cb0feb154264d55bf2ff22c17"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/c6/62/8a2bef01214eeaa5a4489eca7104e152968729512ee33cb5fbbc37a896b7/beautifulsoup4-4.9.1.tar.gz"
    sha256 "73cc4d115b96f79c7d77c1c7f7a0a8d4c57860d1041df407dd1aae7f07a77fd7"
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
