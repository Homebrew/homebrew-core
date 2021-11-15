class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v8.0.3.tar.gz"
  sha256 "c60dd5ae7d1d3bcfe941ead9f088c4b0413b9a4561fb9154429faf86a43e0983"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22e7687003f291523b7d9c896e20187a1fb6e5342a749c6b26aabb369ca9df05"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a51ced540a584c8290d7f209150a158c5ace60641696b76279a6065df12e14ec"
    sha256 cellar: :any_skip_relocation, monterey:       "499ac8f20345faf599a8fa1957632bb62e8a5fec528e4463c2a876b2c647c9cd"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f5518853d596d32c387b9b98d873dd78ac89b07c205540e239e55eaaf24bbcb"
    sha256 cellar: :any_skip_relocation, catalina:       "6a4f9ffd1fefd6a5fff8b7c5ad5876ec7a3083a74fb30ad5f4a729f728a9e5d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f31d58438c460fa584919921715695335b7a5c8d4b0b7a73b164124a07efb41"
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
