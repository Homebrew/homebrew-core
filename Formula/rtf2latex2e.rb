class Rtf2latex2e < Formula
  desc "RTF-to-LaTeX translation"
  homepage "http://rtf2latex2e.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/rtf2latex2e/rtf2latex2e-unix/2-2/rtf2latex2e-2-2-2.tar.gz"
  version "2.2.2"
  sha256 "eb742af22f2ae43c40ea1abc5f50215e04779e51dc9d91cac9276b98f91bb1af"

  bottle do
    sha256 "851c5d2385dc138a9944da16a0602ae3f72e9300daaaea9679c31cd6edf96237" => :sierra
    sha256 "33b09e64921d8e0e39a63cb53f00d0e97c599715b13dfda8858293f5b1a646d4" => :el_capitan
    sha256 "3ec1089506f8f74d5718e33c9747cc5e2bc8b49542a121c20d4144797df33370" => :yosemite
    sha256 "6a823165a717df722d5072957d357bacee804512cf5242d0c1967b9ef300abda" => :mavericks
  end

  def install
    system "make", "install", "prefix=#{prefix}", "CC=#{ENV.cc}"
  end

  def caveats; <<-EOS.undent
    Configuration files have been installed to:
      #{opt_pkgshare}
    EOS
  end

  test do
    (testpath/"test.rtf").write <<-'EOF'.undent
    {\rtf1\ansi
    {\b hello} world
    }
    EOF
    system bin/"rtf2latex2e", "-n", "test.rtf"
    assert_match "textbf{hello} world", File.read("test.tex")
  end
end
