class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/topgrade-rs/topgrade"
  url "https://github.com/topgrade-rs/topgrade/archive/refs/tags/v10.2.4.tar.gz"
  sha256 "b7390d609259a4fa4b4c2db6fdc685e12e65d2f9bc98d442d713bf1c9bce7677"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f189da63229c16872e8b0384b6972d37625e964573826795d4d3c18078875ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1cf38f6e4cb28447700761a62976e2127404f38aa83505c65b4c0d5da5ddc28"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "83212d2c55c71d9e434be73bcfce38660010c4a887163670414d8235a9928943"
    sha256 cellar: :any_skip_relocation, ventura:        "fbc364568dd24adca1bb003c0d1a70673a05f6cada94dd77fb74afcff1b7afa8"
    sha256 cellar: :any_skip_relocation, monterey:       "db9db16a4700f018b9fcf88f691886ce0a00519019925df1abe4cdbb2667990b"
    sha256 cellar: :any_skip_relocation, big_sur:        "1c67aeabfe6cacfea22d823cfcae415c8ca5de578a8635e0b2797386d2bd1423"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bb09d606336d6ecbb7c0bf5b7eb08fb7ad15a764df1d8192ddd1b93a046dab7"
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
