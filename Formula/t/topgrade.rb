class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/topgrade-rs/topgrade"
  url "https://github.com/topgrade-rs/topgrade/archive/refs/tags/v17.17.0.tar.gz"
  sha256 "098028f8ce381142d52aab7823c2a7d1ee208c11ae53bbc8b0bfc587d9813643"
  license "GPL-3.0-or-later"
  head "https://github.com/topgrade-rs/topgrade.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    manifest_sha256 "c1d1896e5c59fb520aaa96d869d884e1d1ed3334ad01d3b5d3f1bdc652642d8e"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "faca9c37f7981ad94cdb90549f14c1df29cd72f4a6c52b9f7152e596d0c01707"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3458f2ef196e9488c96e91d717a47b9b416c02420c350f9bdb29b46d38fcea03"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "221c1769c64ab361e94ee141e1df43bdeb0b2845b9acc7b83d6218040e670ecc"
    sha256 cellar: :any,                 arm64_linux:       "3928c9a0e3976a710bc1cc19553022c5c57ee2a37bfcca69aa19d8d807013b27"
    sha256 cellar: :any,                 x86_64_linux:      "35b1fd7fe68cdff91e44f91607e76addc27a2f3aa6b101bf91fc188342e15014"
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
