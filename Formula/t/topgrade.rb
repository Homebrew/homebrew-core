class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/topgrade-rs/topgrade"
  url "https://github.com/topgrade-rs/topgrade/archive/refs/tags/v17.11.0.tar.gz"
  sha256 "d93647cb5978e1d7e0100e2fcca5fdf0186b7aa742267ac34ebc384550518b33"
  license "GPL-3.0-or-later"
  head "https://github.com/topgrade-rs/topgrade.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a29c1ef79fd643715b348294517848a2b276264ed68d150dc4243a8e8bba10fd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f5f63ca41045f89bb9e377da8788f3315765d4d8f96c97885e3e7fc4e098b87f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "299f2f0559e1a51dee7a39b39b9acb0bbf286d91b5d65ee71cd055d256610432"
    sha256 cellar: :any,                 arm64_linux:       "6c6536b00e5f34c98fcac9904a14211d181a3afc41ec7ed85e042bc3600ced0a"
    sha256 cellar: :any,                 x86_64_linux:      "27dafedde0135fdb169d9508e89b9207afea48ac93a4be435b7cfc6bf43f6b8e"
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
