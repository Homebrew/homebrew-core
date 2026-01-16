class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/topgrade-rs/topgrade"
  url "https://github.com/topgrade-rs/topgrade/archive/refs/tags/v16.8.0.tar.gz"
  sha256 "d3cb27fa946440eb2ff6253a1a15ac16d6d02f6594bf98ada8e015f3b623a874"
  license "GPL-3.0-or-later"
  head "https://github.com/topgrade-rs/topgrade.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "33148784ade05e395555f6493010060c18cf5f6b30dd9b122ff54cb68ab2309a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ddd2c5903d80b612fb28d528498543ab06b5ea6f1bbcfb233c825723365439c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ffd1762971d23c26d99545f358202cc4179bba5fd36c5d2ec5bb2b6fb6a7743e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c6718b4b21df6a2e5bed3f81f1ed1d57590437f920074e135cf68f323458952d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91a4faa175cc06b8e74fa80f3cba3b6364c3bb9d31fac6005ea34cb4351b97a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "160f9dfd7405f59508e14ad7e02c618aef0092353c4b116341d6c23b5008bed7"
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
