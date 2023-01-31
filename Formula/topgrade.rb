class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/topgrade-rs/topgrade"
  url "https://github.com/topgrade-rs/topgrade/archive/refs/tags/v10.3.1.tar.gz"
  sha256 "9b94eb5c0fbffcbcf7a4862bf239e31cb9700f517f909d17aa109ba030efe17e"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed481b97aa2a28f238cb6f343bf21913986ca4ca2cd893e98a363edf733707b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e93b70134b368d0090990cc95639f82d61650826809d479b9f7e9c55a285099"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0a251d1ea30c19c849bcebdbecb44c0f80b61e582234e4a0317233fe606dee9e"
    sha256 cellar: :any_skip_relocation, ventura:        "44e6a0ae60095b01c717b58400b71ae9bae1ba698d09a57f224d64da1d66cc37"
    sha256 cellar: :any_skip_relocation, monterey:       "28bb20d2cd05602fac32dc624949004e6631aa46ae94a7aa13308a7975fe1c25"
    sha256 cellar: :any_skip_relocation, big_sur:        "7f43adf4f25984511ca8d5d78e17cdaa86cb479e944c26aee30f489555bc71e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84d019d5e61a867badc090dbcd360edbba743c5906d97727d492ed450fa35445"
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
