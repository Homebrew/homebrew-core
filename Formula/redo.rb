class Redo < Formula
  include Language::Python::Virtualenv

  desc "Implements djb's redo: an alternative to make"
  homepage "https://redo.rtfd.io/"
  url "https://github.com/apenwarr/redo/archive/redo-0.42a.tar.gz"
  sha256 "0ff0fd29f2767fe33374cfac97fd13b3dd27207bdacbeb5e02039b992d4fb815"

  depends_on "python@3.8"

  resource "Markdown" do
    url "https://files.pythonhosted.org/packages/98/79/ce6984767cb9478e6818bd0994283db55c423d733cc62a88a3ffb8581e11/Markdown-3.2.1.tar.gz"
    sha256 "90fee683eeabe1a92e149f7ba74e5ccdc81cd397bd6c516d93a8da0ef90b6902"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/3b/e4/7cfc641f11e0eef60123912611a5c9ee7d4638da7325878b695b9ae4bb6f/beautifulsoup4-4.9.0.tar.gz"
    sha256 "594ca51a10d2b3443cbac41214e12dbb2a1cd57e1a7344659849e2e20ba6a8d8"
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
