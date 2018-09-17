class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v0.14.0.tar.gz"
  sha256 "68c965f047226d71a0f7db5eadf45ea46d538c895bf83d76629d148ddf8ec66c"

  bottle do
    sha256 "2934a971a26dab81938a4268717cd8dfb86bb5dc2de9b0dff9c4212d73ec8aee" => :mojave
    sha256 "6d5be22cfdb13a065b1e140447f8f47b65b93b5dbda38a6b9c8b28f20c23be47" => :high_sierra
    sha256 "0c0cd8b6a69e2134dc123b507adc9d94636ccb55a7449243e3523f45d5b2564c" => :sierra
    sha256 "69f76f50f0e6aca35e53fd2964f47fc618b2f9602f5d677d0add20cab5065a97" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    output = shell_output("#{bin}/topgrade -n")
    assert_match "Dry running: #{HOMEBREW_PREFIX}/bin/brew upgrade", output
  end
end
