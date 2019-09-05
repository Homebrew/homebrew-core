class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v2.9.0.tar.gz"
  sha256 "10c5a4659d8ad895a78077e848623eaf6c0a868232ef204464370ba1e45ecf2e"

  bottle do
    cellar :any_skip_relocation
    sha256 "3e45a3aa49b51fbb1694145160d7aedb0b49ce7957f48f8cbe1a1627d7edec29" => :mojave
    sha256 "04be82c6eb8b4c84f89370ec7193f1f5487e552ea381e06cac7c8833ba76651e" => :high_sierra
    sha256 "57f43dc7121add84793424024cda9382218b7e65c7cebef4f08a9766f487f68a" => :sierra
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
