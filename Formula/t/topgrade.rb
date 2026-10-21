class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/topgrade-rs/topgrade"
  url "https://github.com/topgrade-rs/topgrade/archive/refs/tags/v17.14.1.tar.gz"
  sha256 "738496f7edc90197c0d410cafc855095d1d9144a15a9624fce0c7306a4da9eea"
  license "GPL-3.0-or-later"
  head "https://github.com/topgrade-rs/topgrade.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1e4ad045076cb27670862f676159ec67f9a769de2c2c8be5317be4a5ba4bbf35"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "07c84b51f1899d56967a675b1291e2ffca57c200c2950a7a5161ddb31bbe5c1c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "078be9d2e93346269e10eec36790e08d4ee9bd368e5c07824ffaf8e25a15c861"
    sha256 cellar: :any,                 arm64_linux:       "545d2ac7be9ad8979d0e97f4ada9a08c2682db8a2e6e321093543f58e22ea4b8"
    sha256 cellar: :any,                 x86_64_linux:      "143941bb0752aec0603f92d3a7d61f1e7f8e5f045e869b2bc7152c8fa26aa0eb"
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
