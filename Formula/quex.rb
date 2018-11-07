class Quex < Formula
  desc "Generate lexical analyzers"
  homepage "https://quex.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/quex/DOWNLOAD/quex-0.68.2.tar.gz"
  sha256 "b6a9325f92110c52126fec18432d0d6c9bd8a7593bde950db303881aac16a506"
  head "http://svn.code.sf.net/p/quex/code/trunk"

  bottle do
    cellar :any_skip_relocation
    sha256 "d3dc54f074080d5853374c14ffc866417f4effbe6c547d316f147523ca02c9e9" => :mojave
    sha256 "e5d0e22c8d988408e52ddabcd0b1ddd7e858c6256b1449b919a83f8da5934354" => :high_sierra
    sha256 "e5d0e22c8d988408e52ddabcd0b1ddd7e858c6256b1449b919a83f8da5934354" => :sierra
    sha256 "e5d0e22c8d988408e52ddabcd0b1ddd7e858c6256b1449b919a83f8da5934354" => :el_capitan
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
