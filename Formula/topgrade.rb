class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v7.1.0.tar.gz"
  sha256 "db8a2777f0a1c3e59012936d3edb5a54d378a2be036604590557d6e3affde8d8"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9eb652572e2c25a5a708dcc082fff76649cf1024ba61a6b5ca0dbb996d1fc2f1"
    sha256 cellar: :any_skip_relocation, big_sur:       "5c74ee10cb5f589b2ac046e069d45da0158b811c91c95cf9b262d910eceb4641"
    sha256 cellar: :any_skip_relocation, catalina:      "c80e6e22e08a017e07804e068e068dc95720aaf2e5e3d8865fface332321364e"
    sha256 cellar: :any_skip_relocation, mojave:        "b1eb2fab57fa99740f05a2c2e9b31a8ad41c0b9e5e1ddd7906eb44fccf53a946"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "179215981744c07f1f76b0ecba3d5a07f1b1315c0304a60956a04ed7b995f397"
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
