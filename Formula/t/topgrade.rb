class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/topgrade-rs/topgrade"
  url "https://github.com/topgrade-rs/topgrade/archive/refs/tags/v17.8.0.tar.gz"
  sha256 "e723b723db7ef3179417e3529bd67a637a3ceafed8f63ee81202cfae9200ad9b"
  license "GPL-3.0-or-later"
  head "https://github.com/topgrade-rs/topgrade.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3bb415c428f15c803fe036228f8bcf5afccb332e2ef50abc665982668175b80a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a74056568e248084ccf8b8c0972941ec48d9a454ed450b998c2cfc4e09557578"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99d4e7865b86780c818106cf8c6cd8bcc1e8b1e6fb7980ea2faf02725dc09c96"
    sha256 cellar: :any_skip_relocation, sonoma:        "24261882573218eb95a2a424c6ff42831b6daa5b08359e479c4f95df0232cea3"
    sha256 cellar: :any,                 arm64_linux:   "38bcdf280ff28f5298d2a1ebc3e6faa8e0a6da4774e3d11bb44b62ae1ffe9e3b"
    sha256 cellar: :any,                 x86_64_linux:  "f0cf618abf283fbd143849bbd16ddb0608d7ef8ab884823388ffd02440a1dce7"
  end

  depends_on "rust" => :build

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
