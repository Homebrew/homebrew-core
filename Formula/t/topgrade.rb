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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "590ad28907dd2932b432471bafd179017d2e5368588309385ffac01b9a5310d9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "20e337020b9903f0c02f5e2b813b6ee317e3f1385e1bcad3bc6a91846c735c7a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b3015b06e5166fbdd6acf8451e11bb382ad27ce9acab8f8dea805732a8eee58b"
    sha256 cellar: :any,                 arm64_linux:       "708708d4312f28acd497bd29dc92bb1c1b824c353a5909b3d2748bb7a7f77f2f"
    sha256 cellar: :any,                 x86_64_linux:      "48a090d6272744a9fc1bcfe24794e1fb32379feddf9f08331a73d40c787b4a17"
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
