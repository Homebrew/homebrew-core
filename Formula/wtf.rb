class Wtf < Formula
  desc "Translate common Internet acronyms"
  homepage "http://cvsweb.netbsd.org/bsdweb.cgi/src/games/wtf/"
  url "https://downloads.sourceforge.net/project/bsdwtf/wtf-20180813.tar.gz"
  sha256 "194b49de7d45fbd416ad43a1f8854157fdaf26b12553dffdf07e3ac8cddaf2d5"

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
