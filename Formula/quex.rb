class Quex < Formula
  desc "Generate lexical analyzers"
  homepage "https://quex.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/quex/quex-0.70.0.tar.gz"
  sha256 "761b68d68255862001d1fe8bf8876ba3d35586fd1927a46a667aea11511452cd"
  head "https://svn.code.sf.net/p/quex/code/trunk"

  bottle do
    cellar :any_skip_relocation
    sha256 "f3d39a7468e8c529ce1c0d6ab5b2d028f50771304993e9f2e996490f846c4b6c" => :catalina
    sha256 "f3d39a7468e8c529ce1c0d6ab5b2d028f50771304993e9f2e996490f846c4b6c" => :mojave
    sha256 "f3d39a7468e8c529ce1c0d6ab5b2d028f50771304993e9f2e996490f846c4b6c" => :high_sierra
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
    system bin/"quex", "-i", doc/"demo/C/01-Trivial/easy.qx", "-o", "tiny_lexer"
    assert_predicate testpath/"tiny_lexer", :exist?
  end
end
