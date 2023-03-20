class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/topgrade-rs/topgrade"
  url "https://github.com/topgrade-rs/topgrade/archive/refs/tags/v10.3.3.tar.gz"
  sha256 "a6477aeade723aa16b0e4e03d4ea4b905fb256823ef578cf7c7e3ee24cca01ca"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b457d620b8f01715c4cc7a0f5e4add7765562b4d8bef1e7ffa1fac0bfe327a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "abfde12bf5c8ad5885b0476286785e9f5009623cbb532d3f8eab1baec7e0c5e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0f901b65dafc634a6e175a22676bcfe52f92c2dee5803259b3ce9fd2069f7bcd"
    sha256 cellar: :any_skip_relocation, ventura:        "c2ab3ddcfde3085dff39e82bee131c82452a833ef8e8eaa552c17c9c612767b1"
    sha256 cellar: :any_skip_relocation, monterey:       "94c585925de1564bb5807828ce8cce262d9dd3335b520df8925b5e62fbaa9f60"
    sha256 cellar: :any_skip_relocation, big_sur:        "79cc29186b1e45a8ff4924cc889df362f1e0c1df0d1435c0c26bbbc227df1ee2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e22a8ac5efed01cd9679c1550e3fd39fe0541bf9da766c313f183c8680436aa"
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
