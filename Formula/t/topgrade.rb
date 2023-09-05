class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/topgrade-rs/topgrade"
  url "https://github.com/topgrade-rs/topgrade/archive/refs/tags/v12.0.2.tar.gz"
  sha256 "3bd71c8ee3f38fdddc1f9475f1c46d4949ce2f016e26dda71ac3c723e7488c57"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5268979191541ca0ab2702329466d50944861d680112bc170135e016991ba13a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "edcc7354b9b12b1759d9eb88936d39baa9b58bdb1a3fd1d213b2afe34563333a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9e2e8c10e31525b7836b84c7f0331620db87758bb20213c9af1e02a8f18872f0"
    sha256 cellar: :any_skip_relocation, ventura:        "edfba733abd0f00eb22b1ed85a4ebe44b8d85bfd1b920abaaf11e4c3bfec9f67"
    sha256 cellar: :any_skip_relocation, monterey:       "f1eb24a672d6ac987f66fc5763c477b5cdb4a96a535f1cb4bfba30f309f9ca57"
    sha256 cellar: :any_skip_relocation, big_sur:        "c827ed042fb781f1e53cdc89ae1c91e33a46375861c82bfa630e557fdeb4c117"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c39ade708fcc7b632ba8a99344f78f88661a4a09266d591960fd11cec288d9e7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Configuration path details: https://github.com/r-darwish/topgrade/blob/HEAD/README.md#configuration-path
    # Sample config file: https://github.com/r-darwish/topgrade/blob/HEAD/config.example.toml
    (testpath/"Library/Preferences/topgrade.toml").write <<~EOS
      # Additional git repositories to pull
      #git_repos = [
      #    "~/src/*/",
      #    "~/.config/something"
      #]
    EOS

    assert_match version.to_s, shell_output("#{bin}/topgrade --version")

    output = shell_output("#{bin}/topgrade -n --only brew_formula")
    assert_match %r{Dry running: (?:#{HOMEBREW_PREFIX}/bin/)?brew upgrade}o, output
    refute_match(/\sSelf update\s/, output)
  end
end
