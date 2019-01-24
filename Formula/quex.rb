class Quex < Formula
  desc "Generate lexical analyzers"
  homepage "https://quex.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/quex/quex-0.69.3.tar.gz"
  sha256 "ad0fbb6bef8116ac312d6ab9e93b444ca5826f9c683a6dae1c1f606cf7e78fcf"
  head "http://svn.code.sf.net/p/quex/code/trunk"

  bottle do
    cellar :any_skip_relocation
    sha256 "fd2be2bb933af7bc6b2b1313d4ff30019293a9c821c8e4bbfc499c2a3f7f4711" => :mojave
    sha256 "745f6d4fe25cb48f6e3389a6746027790c9c73dcdadd449d6bfba1845f2fe7b7" => :high_sierra
    sha256 "745f6d4fe25cb48f6e3389a6746027790c9c73dcdadd449d6bfba1845f2fe7b7" => :sierra
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
