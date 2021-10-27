class Redo < Formula
  include Language::Python::Virtualenv

  desc "Implements djb's redo: an alternative to make"
  homepage "https://redo.rtfd.io/"
  url "https://github.com/apenwarr/redo/archive/redo-0.42d.tar.gz"
  sha256 "47056b429ff5f85f593dcba21bae7bc6a16208a56b189424eae3de5f2e79abc1"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a53fdaf0a75d657dd627f7ecd0fa33826e065554b31b07540c1378f383b4964"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "22dd0cd4b9d1e945d90a6bce7138c7c0b5e834d74c0be14fd39258b8225dd8af"
    sha256 cellar: :any_skip_relocation, monterey:       "37bb6b29d00caa6c9d81fbe6418350ad833203c63095b8a79189320f32b00d6f"
    sha256 cellar: :any_skip_relocation, big_sur:        "db186be965150e95e72d55d47acb86cf4839fa7949149e01522870c7a640edce"
    sha256 cellar: :any_skip_relocation, catalina:       "ed58682729a217dcbfa7ace51f5ec8a3d57cdb30248173820d1bdbd599999675"
    sha256 cellar: :any_skip_relocation, mojave:         "653c09646f838dfed31e0f79f3364d2604cc688a8735e098736092a55a631d3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e6d7dcf5e439d5a882a2bf480cff8a35b2e3cfe22e967935de67313444d3a46"
  end

  depends_on "python@3.10"

  resource "Markdown" do
    url "https://files.pythonhosted.org/packages/49/02/37bd82ae255bb4dfef97a4b32d95906187b7a7a74970761fca1360c4ba22/Markdown-3.3.4.tar.gz"
    sha256 "31b5b491868dcc87d6c24b7e3d19a0d730d59d3e46f4eea6430a321bed387a49"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/a1/69/daeee6d8f22c997e522cdbeb59641c4d31ab120aba0f2c799500f7456b7e/beautifulsoup4-4.10.0.tar.gz"
    sha256 "c23ad23c521d818955a4151a67d81580319d4bf548d3d49f4223ae041ff98891"
  end

  def install
    venv = virtualenv_create(libexec, Formula["python@3.10"].opt_bin/"python3")
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
