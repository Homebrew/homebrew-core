class Redo < Formula
  include Language::Python::Virtualenv

  desc "Implements djb's redo: an alternative to make"
  homepage "https://redo.rtfd.io/"
  url "https://github.com/apenwarr/redo/archive/refs/tags/redo-0.42d.tar.gz"
  sha256 "47056b429ff5f85f593dcba21bae7bc6a16208a56b189424eae3de5f2e79abc1"
  license "Apache-2.0"
  revision 2

  bottle do
    rebuild 7
    sha256 cellar: :any_skip_relocation, all: "fb1815e2abd0a29b23eb4fe2111213fa1942ec1e48bb53d40601a5a06e7ccb26"
  end

  depends_on "python@3.14"

  conflicts_with "goredo", because: "both install `redo` and `redo-*` binaries"

  # Build dependencies for https://github.com/apenwarr/redo/blob/main/docs/md2man.py
  pypi_packages package_name:   "",
                extra_packages: %w[beautifulsoup4 markdown]

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/c3/b0/1c6a16426d389813b48d95e26898aff79abbde42ad353958ad95cc8c9b21/beautifulsoup4-4.14.3.tar.gz"
    sha256 "6292b1c5186d356bba669ef9f7f051757099565ad9ada5dd630bd9de5fa7fb86"
  end

  resource "markdown" do
    url "https://files.pythonhosted.org/packages/2b/f4/69fa6ed85ae003c2378ffa8f6d2e3234662abd02c10d216c0ba96081a238/markdown-3.10.2.tar.gz"
    sha256 "994d51325d25ad8aa7ce4ebaec003febcce822c3f8c911e3b17c52f7f589f950"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/7b/ae/2d9c981590ed9999a0d91755b47fc74f74de286b0f5cee14c9269041e6c4/soupsieve-2.8.3.tar.gz"
    sha256 "3267f1eeea4251fb42728b6dfb746edc9acaffc4a45b27e19450b676586e8349"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  def install
    python3 = "python3.14"
    # Prevent system Python 2 from being detected
    inreplace "redo/whichpython.do", " python python3 python2 python2.7;", " #{python3};"

    # Prepare build-only virtualenv for generating manpages.
    venv = virtualenv_create(buildpath/"venv", python3)
    venv.pip_install resources

    # Set PYTHONPATH rather than prepending PATH with venv as shebangs are set to detected python.
    ENV.prepend_path "PYTHONPATH", buildpath/"venv"/Language::Python.site_packages(python3)

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
