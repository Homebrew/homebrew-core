class Wrk < Formula
  desc "HTTP benchmarking tool"
  homepage "https://github.com/wg/wrk"
  url "https://github.com/wg/wrk/archive/4.0.2.tar.gz"
  sha256 "a4a6ad6727733023771163e7250189a9a23e6253b5e5025191baa6092d5a26fb"
  head "https://github.com/wg/wrk.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a72ee4121793cf744582d5adcbe3911013606ce6d9fb9b4686d363f96147d616" => :sierra
    sha256 "9dffba88a5ca3dfb25ea4be55bd45c9c4e3964543d4ea4485cb21fdba7f3c18c" => :el_capitan
    sha256 "0d8d195984217da0cc6e734e2f2c876cacbad02b18fe2b3b22a77d3e356104f0" => :yosemite
    sha256 "be9f47bac642704c6575810875dfd86bcdacdceb799c11a13bdab4d4f14965ab" => :mavericks
  end

  depends_on "openssl"

  conflicts_with "wrk-trello", :because => "both install `wrk` binaries"

  def install
    ENV.j1
    system "make"
    bin.install "wrk"
  end

  test do
    system "#{bin}/wrk", "-c", "1", "-t", "1", "-d", "1", "https://example.com/"
  end
end
