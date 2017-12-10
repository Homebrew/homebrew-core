class Wtf < Formula
  desc "Translate common Internet acronyms"
  homepage "http://cvsweb.netbsd.org/bsdweb.cgi/src/games/wtf/"
  url "https://downloads.sourceforge.net/project/bsdwtf/wtf-20171202.tar.gz"
  sha256 "6328dd9ce1c9d84983335c5f2e5d067220557776a5dc06bfd2feb875e2db7a7f"

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
