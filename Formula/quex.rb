class Quex < Formula
  desc "Generate lexical analyzers"
  homepage "https://quex.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/quex/quex-0.71.2.zip"
  sha256 "0453227304a37497e247e11b41a1a8eb04bcd0af06a3f9d627d706b175a8a965"
  license "MIT"
  revision 1
  head "https://svn.code.sf.net/p/quex/code/trunk"

  livecheck do
    url :stable
    regex(%r{url=.*?/quex[._-]v?(\d+(?:\.\d+)+)\.[tz]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "369f0965ed61b6887f0b52c19827ac48b78844dc70525655f3a5d728605f82b2"
  end

  depends_on "python@3.10"

  def install
    libexec.install "quex", "quex-exe.py"
    doc.install "README", "demo"

    # Use a shim script to set QUEX_PATH on the user's behalf
    (bin/"quex").write <<~EOS
      #!/bin/bash
      QUEX_PATH="#{libexec}" "#{Formula["python@3.10"].opt_bin}/python3" "#{libexec}/quex-exe.py" "$@"
    EOS

    if build.head?
      man1.install "doc/manpage/quex.1"
    else
      man1.install "manpage/quex.1"
    end
  end

  test do
    system bin/"quex", "-i", doc/"demo/C/01-Trivial/easy.qx", "-o", "tiny_lexer"
    assert_predicate testpath/"tiny_lexer", :exist?
  end
end
