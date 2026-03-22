class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/topgrade-rs/topgrade"
  url "https://github.com/topgrade-rs/topgrade/archive/refs/tags/v17.1.0.tar.gz"
  sha256 "70f8fd6e2bbfe51ddcdde037a84796134afc2bbdbefefc310ec682f7cab9de20"
  license "GPL-3.0-or-later"
  head "https://github.com/topgrade-rs/topgrade.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6baa91952054e24df6d9b26439e0ff016d9c2478fd2fe7d6fd9f96a0e6ca6f60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd9d6bdafe32f1abae5e20cd3c3ae60437571d25c639cff48e49eab97f6f9453"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54c1788c7b3a916b1c774e6d5ae54803a647cd6cee4dbe0afbd59871c147aba5"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a94e3fb149b4621c287c22a0aef3d1d271443120e2a31f46deb1d426b0fd05c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "347d95b6416ec748f9227f93516938a47e9fc8357dfcc27efb0b9e57e029fcef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d7b14468bfe6f9fb916f8ce3d6d2e0254e133b6c659fe3616099da222d4e4bf"
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
