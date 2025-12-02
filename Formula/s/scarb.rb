class Scarb < Formula
  desc "Cairo package manager"
  homepage "https://docs.swmansion.com/scarb/"
  url "https://github.com/software-mansion/scarb/archive/refs/tags/v2.14.0.tar.gz"
  sha256 "36b99d8f9e000007c2468d93a9d24cd3f2652f90f42343b589ce7dac65299c5f"
  license "MIT"
  head "https://github.com/software-mansion/scarb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b6e03715a30464da4afb0208f9be92ed583f9a2c0d819c532c03da0e582beb9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9cb52afa242b428819746a1107c468cd5072b1c4aa1dc99a2a7cef263e134ae3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f81fbfd837c94f6b46a46ae2851869d66c4f995aa514483cc75fedd616e9de04"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3fa211392013080b54adf1275743889e6f6cf44a8bc81e44701a929378a10d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ca32701138d3fcdddedc9839546cf242111646709a03e3854ba623438c26101"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83b96662b32d69fa8578ab927d493b1cced95475d96b58ea243f0e1d9e4b468f"
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
