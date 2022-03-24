class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v8.3.0.tar.gz"
  sha256 "a818cbdc64aafe77a589299d5717988fd5e5403af0998a9945b9d17a5b6f499b"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc26d3fc86b470e937565feadad718581658bf6e64fd51c8cc82dd704da3d5a4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "28c59ae0bd0d8cc997d87b55f0343aecd722be0b44c39940c95ffe1967526542"
    sha256 cellar: :any_skip_relocation, monterey:       "a758d48253e222e78e6a2a8fddcd5076fc0ca85890e8e89759fb3d100e091abc"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f23b782598430c3870fa542ee43e0d655e38542888047a0a8eaf967ebbecfb0"
    sha256 cellar: :any_skip_relocation, catalina:       "88051de1a733b8e7d89da3692494c496a54f44b183e853516f54d6d49c42eb6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb329e1aa7af290a3261ab2ca3caf50fe2ce18b7a82a7e465ac0da6e0a0bde3f"
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
    assert_match %r{Dry running: (?:#{HOMEBREW_PREFIX}/bin/)?brew upgrade}o, output
    refute_match(/\sSelf update\s/, output)
  end
end
