class Quex < Formula
  include Language::Python::Shebang

  desc "Generate lexical analyzers"
  homepage "https://quex.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/quex/quex-0.71.2.zip"
  sha256 "0453227304a37497e247e11b41a1a8eb04bcd0af06a3f9d627d706b175a8a965"
  license "MIT"
  revision 1
  head "https://svn.code.sf.net/p/quex/code/trunk"

  livecheck do
    url :stable
    regex(%r{url=.*?/quex[._-]v?(\d+(?:\.\d+)+)\.[tz]}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, all: "f2d44465311851dc3bf25c68adc4d5041315e089d91ba9fce5d34a47f8a26782"
  end

  uses_from_macos "python"

  def install
    rewrite_shebang detected_python_shebang(use_python_from_path: true), "quex-exe.py"
    libexec.install "quex", "quex-exe.py"
    doc.install "README", "demo"

    # Use a shim script to set QUEX_PATH on the user's behalf
    (bin/"quex").write_env_script libexec/"quex-exe.py", QUEX_PATH: libexec

    if build.head?
      man1.install "doc/manpage/quex.1"
    else
      man1.install "manpage/quex.1"
    end
  end

  test do
    system bin/"quex", "-i", doc/"demo/C/01-Trivial/easy.qx", "-o", "tiny_lexer"
    assert_path_exists testpath/"tiny_lexer"
  end
end
