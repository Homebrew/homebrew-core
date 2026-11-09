class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/topgrade-rs/topgrade"
  url "https://github.com/topgrade-rs/topgrade/archive/refs/tags/v17.16.0.tar.gz"
  sha256 "edcbec5fad717c4c41169269401d52d83854118bfe9e6870f68f383e470eac34"
  license "GPL-3.0-or-later"
  head "https://github.com/topgrade-rs/topgrade.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2a5a083e1ec41afac1b4252bf618978aea3e453789bce25e3d6be86d0e16c73d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ad1050dc8c73fc8ba16b41b916ae76a9735cbb96d2b5488a78c30acd5c4b8b31"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9e5fbef42304f31b2efb8ab0f3f12502b72a88330d794c14e9535dbfaddf2ff1"
    sha256 cellar: :any,                 arm64_linux:       "6765863e2074068a8f886c7b02192182f4ebcfdbce69b8c0a14b8cec77266f99"
    sha256 cellar: :any,                 x86_64_linux:      "9ff87686ae1f6fc66dad25f2529de1aa8507c68970ac7d98527fc8ee59991a64"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"topgrade", "--gen-completion")
    (man1/"topgrade.1").write Utils.safe_popen_read(bin/"topgrade", "--gen-manpage")
  end

  test do
    ENV["TOPGRADE_SKIP_BRKC_NOTIFY"] = "true"
    assert_match version.to_s, shell_output("#{bin}/topgrade --version")

    output = shell_output("#{bin}/topgrade -n --only brew_formula")
    assert_match %r{Dry running: (?:#{HOMEBREW_PREFIX}/bin/)?brew upgrade}o, output
    refute_match(/\sSelf update\s/, output)
  end
end
