class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/topgrade-rs/topgrade"
  url "https://github.com/topgrade-rs/topgrade/archive/refs/tags/v10.2.2.tar.gz"
  sha256 "00dd0afa9ba166d61e63ea7387b3c6dfd6c905f5a42c1cefc394e7d0a869a6a1"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5cedd3e6c281da8f453cae86a1e9078117416e8b7f2613bd79ab8ed7258aa694"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2a0c780e0dd598b785fead4b9f06c3e3a6cd0431c9c6a77aa0d73821f5579e1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0f0ba5ed73e5a81f396b6d301a879203ebf98355ce81e98202dd3d1ea38cc31d"
    sha256 cellar: :any_skip_relocation, ventura:        "05740f44c953c964d7f8ce076e5ea2b5d9e18eebdaa34801d49a2195649d517d"
    sha256 cellar: :any_skip_relocation, monterey:       "7b7886ad1e11da27b2b97fe4bd1f759518d53b16c84faed86628ef8be2a30fe8"
    sha256 cellar: :any_skip_relocation, big_sur:        "bab6ea8b55cc062cd66ebfbc597326a7c6ebe3733ae89310792e0e750befbfbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c9b90f02acd799b8877d685f8a5b185d78192d15949aeaa618ee1a8a86f0dec"
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
