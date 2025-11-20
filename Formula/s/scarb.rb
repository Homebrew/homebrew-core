class Scarb < Formula
  desc "Cairo package manager"
  homepage "https://docs.swmansion.com/scarb/"
  url "https://github.com/software-mansion/scarb/archive/refs/tags/v2.13.1.tar.gz"
  sha256 "110bcab81bbe587a0d12146abd7918c69c6b4b7a5237a2174514ea3740a2671d"
  license "MIT"
  head "https://github.com/software-mansion/scarb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "86965ab12b89a74f1cdd18a795ba9ee16805baa5ddc9d0da236837eb8f3e4d41"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eed00734c65ccfb20c22c376ad00ab9b88797c7a7c04b24608cd74c388cff35e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4492ec6bc7732b00af7554e4fe1c47662e2a605dd2923ffa2b7e0b42ccbda2a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1afe644860df329508102e62452327b4d38f9b8f55ae643873bd8c50344c22f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cfa1f4aaad1f0e9b859c013d6d92082a650973a33bd7bd4d9a512700f890f3d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "082cdf97736fb93eec95cbb361759071614e8509c10a6ede8aa0b5c935b0b891"
  end

  depends_on "rust" => :build
  uses_from_macos "zlib"

  def install
    %w[
      scarb
      extensions/scarb-cairo-language-server
      extensions/scarb-cairo-test
      extensions/scarb-doc
    ].each do |f|
      system "cargo", "install", *std_cargo_args(path: f)
    end
  end

  test do
    ENV["SCARB_INIT_TEST_RUNNER"] = "none"

    assert_match "#{testpath}/Scarb.toml", shell_output("#{bin}/scarb manifest-path")

    system bin/"scarb", "init", "--name", "brewtest", "--no-vcs"
    assert_path_exists testpath/"src/lib.cairo"
    assert_match "brewtest", (testpath/"Scarb.toml").read

    assert_match version.to_s, shell_output("#{bin}/scarb --version")
    assert_match version.to_s, shell_output("#{bin}/scarb cairo-test --version")
    assert_match version.to_s, shell_output("#{bin}/scarb doc --version")
  end
end
