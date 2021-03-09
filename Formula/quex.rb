class Quex < Formula
  desc "Generate lexical analyzers"
  homepage "https://quex.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/quex/quex-0.71.0.zip"
  sha256 "2e8df936f1daea1367f58aabea92e05136f439eea3cd6cbea96c6af1969e4901"
  license "MIT"
  head "https://svn.code.sf.net/p/quex/code/trunk"

  livecheck do
    url :stable
    regex(%r{url=.*?/quex[._-]v?(\d+(?:\.\d+)+)\.[tz]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "dc866a83867dca24a0126b57d9dfb5b1613d491e6eac63d4f22d7ca2f92368db"
    sha256 cellar: :any_skip_relocation, catalina: "7a0be7cfed70b009c5e04fef0db429d7e677c74d24659cc3fe33aec1e278f7a0"
    sha256 cellar: :any_skip_relocation, mojave:   "42e34011b0350928c50d20a4bc12a813e8cdd7934e9879484df46af8de6cfff0"
  end

  # https://sourceforge.net/p/quex/bugs/310/
  depends_on "python@3.7"

  def install
    # Backport one change from https://sourceforge.net/p/quex/git/ci/28c8343c6fe054e5e1a085daebcca43715bc6108/#diff-7
    # to allow running under Python 3.7
    inreplace "quex/input/code/base.py", "_pattern_type", "Pattern"
    libexec.install "quex", "quex-exe.py"
    doc.install "README", "demo"

    # Use a shim script to set QUEX_PATH on the user's behalf
    (bin/"quex").write <<~EOS
      #!/bin/bash
      QUEX_PATH="#{libexec}" "#{Formula["python@3.7"].opt_bin}/python3" "#{libexec}/quex-exe.py" "$@"
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
