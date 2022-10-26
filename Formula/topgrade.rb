class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/topgrade-rs/topgrade"
  url "https://github.com/topgrade-rs/topgrade/archive/refs/tags/v10.0.1.tar.gz"
  sha256 "908ec302fda3a0549e49c4c19f1e3e2cbaba08dd8b7301c59370569a86a9f09a"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93ca79a7d1695ac1d1876d10d489a3083ba9f75833c2537d50c8cf04d234c130"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e3208512562df335f725643620fd4c88ab6e02f7e90f12cb14d0356db6496a7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c70c1ff6a08c659d840bdf187b1e3680f96cfcbf73517a785ac5b10b1e9eef84"
    sha256 cellar: :any_skip_relocation, monterey:       "29ebb6dcb8e89753c2e4a8e50045bf09fa13e3b09d95e75ed0253c0e85309293"
    sha256 cellar: :any_skip_relocation, big_sur:        "f22266c9e9632d3ded9e1043a38020b0a960ba30f6048352c429550ba6e02f30"
    sha256 cellar: :any_skip_relocation, catalina:       "40d2ed01d29300d2ef680674fe2b49a9ad62b8dd682dc20589a8d7beb5b8dd8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d67c9d814f69d009ffc3fd42ddc1a811a81ebb25e5f4689afbf6c4d1855a8db3"
  end

  depends_on "rust" => :build
  depends_on xcode: :build if MacOS::CLT.version >= "11.4" # libxml2 module bug

  # patch version, remove in next release
  patch do
    url "https://github.com/topgrade-rs/topgrade/commit/573bae7511c2ef84068b03f099364e90488d319c.patch?full_index=1"
    sha256 "d40303ae61159d4fd3e51803c90ebf9c7dd1fc509e25c19c13c94720d7f3ce98"
  end

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
