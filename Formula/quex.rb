class Quex < Formula
  desc "Generate lexical analyzers"
  homepage "http://quex.org/"
  url "https://downloads.sourceforge.net/project/quex/DOWNLOAD/quex-0.68.1.tar.gz"
  sha256 "12f11eb515e5d30469041c7f17dba02290fe634bcb9d655a2121ada1a84d6c6b"
  head "https://svn.code.sf.net/p/quex/code/trunk"

  bottle do
    cellar :any_skip_relocation
    sha256 "da04cc7e91f0a5f2de59dac9fc6cc4f8c42ac6d0768c85dd7cdd48adec8181fb" => :high_sierra
    sha256 "da04cc7e91f0a5f2de59dac9fc6cc4f8c42ac6d0768c85dd7cdd48adec8181fb" => :sierra
    sha256 "da04cc7e91f0a5f2de59dac9fc6cc4f8c42ac6d0768c85dd7cdd48adec8181fb" => :el_capitan
  end

  def install
    libexec.install "quex", "quex-exe.py"
    doc.install "README", "demo"

    # Use a shim script to set QUEX_PATH on the user's behalf
    (bin/"quex").write <<~EOS
      #!/bin/bash
      QUEX_PATH="#{libexec}" "#{libexec}/quex-exe.py" "$@"
    EOS

    if build.head?
      man1.install "doc/manpage/quex.1"
    else
      man1.install "manpage/quex.1"
    end
  end

  test do
    system bin/"quex", "-i", doc/"demo/C/01-Trivial/simple.qx", "-o", "tiny_lexer"
    assert_predicate testpath/"tiny_lexer", :exist?
  end
end
