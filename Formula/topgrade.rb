class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/topgrade-rs/topgrade"
  url "https://github.com/topgrade-rs/topgrade/archive/refs/tags/v10.3.1.tar.gz"
  sha256 "9b94eb5c0fbffcbcf7a4862bf239e31cb9700f517f909d17aa109ba030efe17e"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "610fe442ad5be1feccba64be5665754ed26e0c93e7bd1b46610cc842c105fc72"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf09d60d3f59ad7ee04a798b1ce1f4bad4ca8f1a9ddc5f370289e31f0619f099"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b5dd50edd29b03a6a9c703b45c81fb2b621befc775161f1b7dbdc1018c0bea7c"
    sha256 cellar: :any_skip_relocation, ventura:        "51318352fbb4e405bd4e3e43dabcb8a38c97dae17952aacba8272244c88c032a"
    sha256 cellar: :any_skip_relocation, monterey:       "dd9889a10afb715d6a9ccd6073a73af8f92b8af3f11031f9c78f6c3c18e18d0c"
    sha256 cellar: :any_skip_relocation, big_sur:        "5191d983d2d8457daa7a6e3b21405b355c5578664ba499904e309a5b73da8738"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f136791ed6bda7a9bf6b2c78c0428fbfc601fb003c645eebe5715ff774fa4793"
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
