class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v9.0.1.tar.gz"
  sha256 "70a1cf2c6a4de41e4c708409842968f3cf05dd5f238efac7ca0f1c9064be670a"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb8afeb38439c5087560050ef61394601e02260ed6b24dc90617fa4447ae3e79"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "94c675c937c4659a1eb511e7c46f9ec7607d031cf80ba66e18e44222cd3ca131"
    sha256 cellar: :any_skip_relocation, monterey:       "844ab6103beb84030b712dce7938224ac2d445035119f4a21b767c0b7657f70f"
    sha256 cellar: :any_skip_relocation, big_sur:        "b05f120d3adfaad977f6cb9e6485ff529c034c8e2542586974c94b86a626dbe5"
    sha256 cellar: :any_skip_relocation, catalina:       "5a375def909f6fa01e3b20079b8eac1341bc2b87f4b22387f4fd43c2af56c3ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37c87e1397e99eaf1c1f730a3dc87e53fd942a9c014599f56b5442522f986a19"
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
