class Wires < Formula
  desc "WebDriver <-> Marionette proxy"
  homepage "https://github.com/mozilla/geckodriver"
  url "https://github.com/mozilla/geckodriver/archive/v0.8.0.tar.gz"
  sha256 "a3b2cc5fd48622cdc811f952565ab235e5b64b5776e1f03c889a5c5c02367e1a"

  bottle do
    cellar :any_skip_relocation
    sha256 "b7408f7a32326df3200fc88ace88a3d19a285cbba1a79631947b150422b43cef" => :el_capitan
    sha256 "4037fdfaaa442386412bfcb66ed40ab6527b584d2b76e41d5399d018d03b1eba" => :yosemite
    sha256 "f265f4acd2265a1be067ab453d47aada5db299c948843a8d32e74754e45374d2" => :mavericks
  end

  depends_on "rust" => :build

  def install
    system "cargo", "build"
    bin.install "target/debug/geckodriver"
    bin.install_symlink bin/"geckodriver" => "wires"
  end

  test do
    system "#{bin}/geckodriver", "--help"
  end
end
