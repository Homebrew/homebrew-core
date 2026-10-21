class Redo < Formula
  include Language::Python::Virtualenv

  desc "Implements djb's redo: an alternative to make"
  homepage "https://redo.rtfd.io/"
  url "https://github.com/apenwarr/redo/archive/refs/tags/redo-0.42d.tar.gz"
  sha256 "47056b429ff5f85f593dcba21bae7bc6a16208a56b189424eae3de5f2e79abc1"
  license "Apache-2.0"
  revision 4

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "8e37c342bcafe5f5f85d6cde4851c13083bca034f4ddc011b48928a54c8a19ec"
  end

  depends_on "python@3.15"

  conflicts_with "goredo", because: "both install `redo` and `redo-*` binaries"

  # Build dependencies for https://github.com/apenwarr/redo/blob/main/docs/md2man.py
  pypi_packages package_name:   "",
                extra_packages: %w[beautifulsoup4 markdown]

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/43/65/318323f98dbee45d42dff61d8f047181bc6f2268a9068cfad035a46be5af/beautifulsoup4-4.15.0.tar.gz"
    sha256 "288e3ca7d54b06f2ac191970bc275c1939cb46d450b255bf6718b04aa37ab4f7"
  end

  resource "markdown" do
    url "https://files.pythonhosted.org/packages/f8/4f/700155c8c20d9e655dd0732b5fc3c7614f291b9148da271d7388e50bf774/markdown-3.11.tar.gz"
    sha256 "180224db6aed87ba9ce1f2781ebcd5826253de8ff637112090e24b84502bbf9f"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/0e/b9/014459776d0be4dd5f0c196fd2c8dc523a4b817a561667fae4f330b04b48/soupsieve-3.0.1.tar.gz"
    sha256 "713d5c69f90ef84deffec0b9c6244796575e3c9fc9081cefb96091ce1200a308"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  def install
    # Prevent system Python 2 from being detected
    inreplace "redo/whichpython.do", " python python3 python2 python2.7;", " #{python3};"

    # Prepare build-only virtualenv for generating manpages.
    venv = virtualenv_create(buildpath/"venv", python3)
    venv.pip_install resources

    # Set PYTHONPATH rather than prepending PATH with venv as shebangs are set to detected python.
    ENV.prepend_path "PYTHONPATH", venv.site_packages

    ENV["DESTDIR"] = ""
    ENV["PREFIX"] = prefix
    system "./do", "install"

    # Ensure this symlink is the same across all our bottles,
    # otherwise the Linux bottle points to `/usr/bin/dash`.
    ln_sf "/bin/dash", lib/"redo/sh"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/redo --version").strip
    # Make sure man pages were generated and installed
    assert_path_exists man1/"redo.1"

    # Test is based on https://redo.readthedocs.io/en/latest/cookbook/hello/
    (testpath/"hello.c").write <<~C
      #include <stdio.h>

      int main() {
        printf("Hello, world!\\n");
        return 0;
      }
    C
    (testpath/"hello.do").write <<~EOS
      redo-ifchange hello.c
      cc -o $3 hello.c -Wall
    EOS
    assert_match "redo  hello", shell_output("#{bin}/redo hello 2>&1").strip
    assert_path_exists testpath/"hello"
    assert_equal "Hello, world!\n", shell_output("./hello")
    assert_match "redo  hello", shell_output("#{bin}/redo hello 2>&1").strip
    refute_match "redo", shell_output("#{bin}/redo-ifchange hello 2>&1").strip
    touch "hello.c"
    assert_match "redo  hello", shell_output("#{bin}/redo-ifchange hello 2>&1").strip
    (testpath/"all.do").write("redo-ifchange hello")
    (testpath/"hello").unlink
    assert_match "redo  all\nredo    hello", shell_output("#{bin}/redo 2>&1").strip
  end
end
