class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v9.0.1.tar.gz"
  sha256 "70a1cf2c6a4de41e4c708409842968f3cf05dd5f238efac7ca0f1c9064be670a"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e833ad4c15652e89a5ce932486966eae583b2be5a25b04a3090ab06f469f0e2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "89f6535e7120185a9efdd4891fd6bbad007cb5cdc976a7441fdda2cc244b1567"
    sha256 cellar: :any_skip_relocation, monterey:       "b15e7ccf6dd39febb6145164cbe0fadcb86c9be6c746a2ad08c3be8e0bffb00c"
    sha256 cellar: :any_skip_relocation, big_sur:        "f23fa19b3ffa2c8603d438d393f86a6d2e50e22838157e52569024280a780d29"
    sha256 cellar: :any_skip_relocation, catalina:       "27e74eabba862e234e1a611b4525426079a33013ff4a54a8dbbf589126ddbd84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12f1ada8749e8f6c43fe68ca8dcc2771dd4aaa8ab86d3821eb982fe4cee2cad7"
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
