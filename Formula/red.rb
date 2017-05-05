class Red < Formula
  desc "Next-gen programming language, strongly inspired by REBOL"
  homepage "http://www.red-lang.org"
  url "http://static.red-lang.org/dl/mac/red-061"
  sha256 "afefaa392e5dbc1ec6d8805376ecffe86a1f6d1ce46d426800556f3c4f698693"
  head "https://github.com/red/red.git"

  def install
    mv "red-061", "red"
    bin.install "red"
  end

  test do
    system "#{bin}/red", "--version"
  end
end
