class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v6.5.2.tar.gz"
  sha256 "e7107ee2ebf87e09641c1555d56a1165d53eb8ffcfcbb04345d27cee6ec0c6f9"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "639218325506f4fa914283b38b7ab23301a7a277d953b3d8d407fbb7957f2e0c"
    sha256 cellar: :any_skip_relocation, big_sur:       "141634a0edf68f01222f1e0fa284c2f4c19bde4720caca72981b5edffb203ec1"
    sha256 cellar: :any_skip_relocation, catalina:      "7210af9c626969a15dc389648d16b2da5f70ed406038b53b206e5f21690639bf"
    sha256 cellar: :any_skip_relocation, mojave:        "c36b430b3b904b29b84f714e2bf2705d8d4c153d3a2c06d0fdc78bb41492be26"
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
    assert_not_match /\sSelf update\s/, output
  end
end
