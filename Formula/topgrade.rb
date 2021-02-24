class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v6.6.0.tar.gz"
  sha256 "95c530e59a16c51f8f07fbe8a9f1a03947642a905267a6233e7cadb598f096b9"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f97bc73b40311abb767ef55b9b3ea6e4684a7f989d10c3327899a64a03c36149"
    sha256 cellar: :any_skip_relocation, big_sur:       "9560fbb9ecc27da1bae9d0c018ee32baa2ff39b8ca30f55fcf464ffc2cf06b60"
    sha256 cellar: :any_skip_relocation, catalina:      "66f56476b59ad564bc9ac6598864654abd6eb631f6eb1c9a8d0e3c980033ccce"
    sha256 cellar: :any_skip_relocation, mojave:        "4c034f504f21e3de4833f6010d2b2461d5657b465a3c048685677595b9ca1a0b"
  end

  depends_on "rust" => :build
  depends_on xcode: :build if MacOS::CLT.version >= "11.4" # libxml2 module bug

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
    assert_match "Dry running: #{HOMEBREW_PREFIX}/bin/brew upgrade", output
    assert_not_match(/\sSelf update\s/, output)
  end
end
