class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v8.1.2.tar.gz"
  sha256 "08071f8298cf1b1a14d54aa89a9f1b17f5b6f6aec3e7b93f7751f2c2748fc49f"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1549b270adeb20f46e5fea9fa698e455db1c175c0bbbf83053b9e466ba55965"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf1ad0d0e9145093699c8f3a10e8b566102256b671e5fecb4395533ac16228fe"
    sha256 cellar: :any_skip_relocation, monterey:       "746549f5333670efde6d020a6288a2580e76a1a39073a83cb926da19a088f566"
    sha256 cellar: :any_skip_relocation, big_sur:        "62b5347ff97068e098cf075f6313109d6a48d43153a9078b512dcf1b34ca5959"
    sha256 cellar: :any_skip_relocation, catalina:       "c38ff7471229a961bac22ddeb3fe7a2583650c0b92d55c46d018a1825878ebb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9583b77e9969a30da24542df600f63df41179622eb2539ea07ac2408cf7c0f66"
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
