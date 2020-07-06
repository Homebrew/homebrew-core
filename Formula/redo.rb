class Redo < Formula
  include Language::Python::Virtualenv

  desc "Implements djb's redo: an alternative to make"
  homepage "https://redo.rtfd.io/"
  url "https://github.com/apenwarr/redo/archive/redo-0.42c.tar.gz"
  sha256 "6f1600c82d00bdfa75445e1e161477f876bd2615eb4371eb1bcf0a7e252dc79f"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "a1198ba3e8feb77e588367d6c829fccd07a89baa0eb85a0dddbd27d75d926fa6" => :catalina
    sha256 "801a8288a70e024e715b8fdfdcf6b2eca37d51ddb5f3b64d0809bf929c46e180" => :mojave
    sha256 "78615055158a19503f04f1ef8698b4dc9cf7f61753b9f5bc59bd3fe99c2c11d9" => :high_sierra
  end

  depends_on "python@3.8"

  resource "Markdown" do
    url "https://files.pythonhosted.org/packages/44/30/cb4555416609a8f75525e34cbacfc721aa5b0044809968b2cf553fd879c7/Markdown-3.2.2.tar.gz"
    sha256 "1fafe3f1ecabfb514a5285fca634a53c1b32a81cb0feb154264d55bf2ff22c17"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/c6/62/8a2bef01214eeaa5a4489eca7104e152968729512ee33cb5fbbc37a896b7/beautifulsoup4-4.9.1.tar.gz"
    sha256 "73cc4d115b96f79c7d77c1c7f7a0a8d4c57860d1041df407dd1aae7f07a77fd7"
  end

  def install
    venv = virtualenv_create(libexec, Formula["python@3.8"].opt_bin/"python3")
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
