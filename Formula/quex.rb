class Quex < Formula
  desc "Generate lexical analyzers"
  homepage "http://quex.org/"
  url "https://downloads.sourceforge.net/project/quex/DOWNLOAD/quex-0.67.5.tar.gz"
  sha256 "f7fff3db5967fc2a5e0673aa5fa6f4f9388a53b89932d76499deb52ef26be1b9"

  head "https://svn.code.sf.net/p/quex/code/trunk"

  bottle do
    cellar :any_skip_relocation
    sha256 "d6365ec16ae1d94f38793ed9b92aae51e2bbfa8f046ecd4974bcdbddc03c324d" => :high_sierra
    sha256 "d6365ec16ae1d94f38793ed9b92aae51e2bbfa8f046ecd4974bcdbddc03c324d" => :sierra
    sha256 "d6365ec16ae1d94f38793ed9b92aae51e2bbfa8f046ecd4974bcdbddc03c324d" => :el_capitan
  end

  def install
    libexec.install "quex", "quex-exe.py"
    doc.install "README", "demo"
    # Use a shim script to set QUEX_PATH on the user's behalf
    (bin+"quex").write <<-EOS.undent
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
    system bin/"quex", "-i", doc/"demo/C/000/simple.qx", "-o", "tiny_lexer"
    File.exist? "tiny_lexer"
  end
end
