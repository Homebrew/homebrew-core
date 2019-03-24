class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v1.10.0.tar.gz"
  sha256 "eb03775da3b86d5d4ae81169e20df52b2dab86d9a4cef15d41b3b9b4c9496b5f"

  bottle do
    cellar :any_skip_relocation
    sha256 "7298c8da361d9ef2ac953cba10feb82b237e770384beb7bd95bc68519886d3b4" => :mojave
    sha256 "46a308c8f08c9ce5b7c9fadc3c642e7e68763822cfe35a7877133dd879791c64" => :high_sierra
    sha256 "ad1d92bea040446828dcb14db49ca896203f0b753b8fbaab143e3910ec18c3cc" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    output = shell_output("#{bin}/topgrade -n")
    assert_match "Dry running: #{HOMEBREW_PREFIX}/bin/brew upgrade", output
    assert_not_match /\sSelf update\s/, output
  end
end
