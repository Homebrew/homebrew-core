class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/topgrade-rs/topgrade"
  url "https://github.com/topgrade-rs/topgrade/archive/refs/tags/v10.3.0.tar.gz"
  sha256 "6ed1fa0ca3c2031e183ad8852de41be77e216076508e896fc38b7ad1cce15d0d"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aed3d089f6da3208eb54063e56b614fe6775c9cf1406a0c49a5de93ad852ff07"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42daf0421e651b3d3259c9e71022f88777d6ccae8e81bc7f222b1049dbaed648"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "afb736491c54ecd54239b2cea02200c59a1809beb9daac3be89bbf410e29a253"
    sha256 cellar: :any_skip_relocation, ventura:        "80322201f47b0847fe7e042b5a168ee68e8cb4fa5946d81b1ec4d4108c48b5b6"
    sha256 cellar: :any_skip_relocation, monterey:       "45332eefc99324ea879501227fd1e226e66846ade2d6d336858578ce39025170"
    sha256 cellar: :any_skip_relocation, big_sur:        "b65edae7d9d5036a80f1674d01b000bfaaab013e223efb5829aa76b3d45cbf99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84a092a419aa973bb43d02cc179f1721e9e8a2952579f363616489fb8e1a15b6"
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
