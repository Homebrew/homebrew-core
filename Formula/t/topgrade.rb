class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/topgrade-rs/topgrade"
  url "https://github.com/topgrade-rs/topgrade/archive/refs/tags/v17.15.0.tar.gz"
  sha256 "f0eb9da1fa3de3fb250ff0045a12372709a4b005096f8d0becfdc6cb099323a8"
  license "GPL-3.0-or-later"
  head "https://github.com/topgrade-rs/topgrade.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2c120473278f3c58e261d971bb7c5dcda2d58e602498f64690b7f5fc2016c461"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ce5a2e09b87298c207083937030bab702f0feba2a95d564ee16dab91a99d56de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e55213b878b122cfe132da448333e5a27869cd0b537b0fbf3dc5edf854d18e7d"
    sha256 cellar: :any,                 arm64_linux:       "6754700508ea862fc715cbbb066358b50809d7f6b033b1f2cd1eaa2e68069eb3"
    sha256 cellar: :any,                 x86_64_linux:      "b3b50c52347c803ca1c2f5d273901057b3aed6cfdf22edf444be773eaa767c02"
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
