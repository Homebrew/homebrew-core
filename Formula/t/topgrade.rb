class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/topgrade-rs/topgrade"
  url "https://github.com/topgrade-rs/topgrade/archive/refs/tags/v17.12.0.tar.gz"
  sha256 "30d817864537599284729d57c67afd7b9d10039802d4788afe4fc180a7bbe922"
  license "GPL-3.0-or-later"
  head "https://github.com/topgrade-rs/topgrade.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a43bb3cda7ffa35d2daa97a70f52b0158f698c24164b372e535fe7fa7b45fdcd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6e71ed23372b11a1a01e082a91593f7409c3398b3976c16a621f1dd4b4f9dabe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "73916bf92caf67b747f7d31123d0359f07d5d619d86a62f2cd885a74b18f56b2"
    sha256 cellar: :any,                 arm64_linux:       "e601f1a4e46ff858ad0174d2f91f24b58542ed93b674de9e56735059cabee4b8"
    sha256 cellar: :any,                 x86_64_linux:      "2b0f495492e7e13becf6aab37e66de03fe50beb68f20e7ace8f40d6db0176dc7"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
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
