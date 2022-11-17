class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/topgrade-rs/topgrade"
  url "https://github.com/topgrade-rs/topgrade/archive/refs/tags/v10.1.2.tar.gz"
  sha256 "978d6cf2c5d6ab71fe21960a98c27050c3ead132f322dd268abc287185dbef60"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d9a8599638c972b2bbea5d6a2c8f7ed393ccaa71779dd70222ed596798435e0f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa6e8d8eadeaa7194df48fceff81126bb4e2142dfc6a21eeff32221c56d68164"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a7899925f2b5801f3af2a56a2e6f9d0377dd9e5aa71936f33898cf28c897d7f4"
    sha256 cellar: :any_skip_relocation, ventura:        "c4e9d376609e600d9b328f7f31bb1df833072777fe5c7603befd043e38d6cb21"
    sha256 cellar: :any_skip_relocation, monterey:       "929c05ed6e89e9c8a2fc6508b6678b4108332ee9af25527f5a51b2e4f40ed181"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e39b13b688c8975fdb2a7a2c5144a131257afe90835a92bf909a5a11a9ac227"
    sha256 cellar: :any_skip_relocation, catalina:       "f7a918f2e10d17f3e8a9f49d416bec042f656877851fa5ed19a2fb953d72442a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be20b0c6c7ff18d689dead8a1f3f53c9fcc882dff4dc175e10e0f3cb6c09b7fe"
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
