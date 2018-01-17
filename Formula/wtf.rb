class Wtf < Formula
  desc "Translate common Internet acronyms"
  homepage "http://cvsweb.netbsd.org/bsdweb.cgi/src/games/wtf/"
  url "https://downloads.sourceforge.net/project/bsdwtf/wtf-20180117.tar.gz"
  sha256 "0cabccfb883a0d0bde4e46da18fb90f2b554e885e6e7a7ad1457b75342d6276f"

  bottle :unneeded

  def install
    inreplace %w[wtf wtf.6], "/usr/share", share
    bin.install "wtf"
    man6.install "wtf.6"
    (share+"misc").install %w[acronyms acronyms.comp]
    (share+"misc").install "acronyms-o.real" => "acronyms-o"
  end

  test do
    system bin/"wtf", "needle"
  end
end
