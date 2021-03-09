class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v6.7.0.tar.gz"
  sha256 "490cc78234ebb69a986223eb25c6ed4aceb9a09024497857eb6f1960a62f880f"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "061c52b048813a8f4b3c0bcc01fdb31478686f0737610632e87f6601e3cb1d22"
    sha256 cellar: :any_skip_relocation, big_sur:       "67fda3bf11f78464e1ae1fa27178f6d5d2e7eebc4b9140f194d63fd1a13b6118"
    sha256 cellar: :any_skip_relocation, catalina:      "b950918acc6d82018d02335a0d555a41c107a4c61ed225a64cc6c582d3fb94c8"
    sha256 cellar: :any_skip_relocation, mojave:        "45fc83e550bc71c90e6a99354def4731134671e0dafc7f14364a5d6800245dad"
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
