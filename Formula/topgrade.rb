class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/topgrade-rs/topgrade"
  url "https://github.com/topgrade-rs/topgrade/archive/refs/tags/v12.0.0.tar.gz"
  sha256 "c99bb88995da5e7d86055d10eced8950740fa2ed986f0b9b159e64a22a0842ed"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2461a0fe529e4e5ab5d623b3310e3e3f3b091a1a15852ddf0b9859b4aaf8eb43"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2e7a37a94aeee7f48701b2a62f074c413b83d9032421866aced884967797a70"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "17be26870c62065dcc0bd5f978095a0a05fc58da7eac48ba66b5e8e06c190ed9"
    sha256 cellar: :any_skip_relocation, ventura:        "0cc6864da208837b96fa4b064234b86ab0e2c60f928f84b8c6e8175dd29e7c35"
    sha256 cellar: :any_skip_relocation, monterey:       "2c1ba5dfc70e8c82bd5d1a63f302023616927437cec7fd5e5540860bea310151"
    sha256 cellar: :any_skip_relocation, big_sur:        "31c3e5f42fc78ac6c7d9e3823a67d9f23b39e67fbaadf0b8d26dc9018816e3af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5a7c03fd6a9fc96d39e13c9de0885b206c3cf781521cbe178e98e53ef4b56fd"
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
