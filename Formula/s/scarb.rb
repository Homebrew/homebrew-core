class Scarb < Formula
  desc "Cairo package manager"
  homepage "https://docs.swmansion.com/scarb/"
  url "https://github.com/software-mansion/scarb/archive/refs/tags/v2.11.1.tar.gz"
  sha256 "613ab337a19c131da49d87336335227770419513c6f4bbf336ca44cb9862c715"
  license "MIT"
  head "https://github.com/software-mansion/scarb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1dfc28db7190bbe57995e9225d000a779bf3ebb5e9bba15f1e85c9f6f88d3da8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0d96926a7abe797f2916888e5c55a1e4d50bd24655562c54630c83536d12205"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fb333a8bd69325d91ba3b2c11167f39044283b87f6687ce2baaf03e4889905a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "114a0448ef201be8e01e22d80a37cab834cf93ad6b45bb9a446844cd7710f085"
    sha256 cellar: :any_skip_relocation, ventura:       "47b8ab563a01fd4023241ad00229d15ba4a3fd0db2d403bf8921b38b7c42bf1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e171e071fb3b0d9134a6d66b32cafc78ef2030e57f7dc7f61b7a9004fd2f916"
  end

  depends_on "rust" => :build
  uses_from_macos "zlib"

  def install
    %w[
      scarb
      extensions/scarb-cairo-language-server
      extensions/scarb-cairo-run
      extensions/scarb-cairo-test
      extensions/scarb-doc
    ].each do |f|
      system "cargo", "install", *std_cargo_args(path: f)
    end
  end

  test do
    ENV["SCARB_INIT_TEST_RUNNER"] = "cairo-test"

    assert_match "#{testpath}/Scarb.toml", shell_output("#{bin}/scarb manifest-path")

    system bin/"scarb", "init", "--name", "brewtest", "--no-vcs"
    assert_path_exists testpath/"src/lib.cairo"
    assert_match "brewtest", (testpath/"Scarb.toml").read

    assert_match version.to_s, shell_output("#{bin}/scarb --version")
    assert_match version.to_s, shell_output("#{bin}/scarb cairo-run --version")
    assert_match version.to_s, shell_output("#{bin}/scarb cairo-test --version")
    assert_match version.to_s, shell_output("#{bin}/scarb doc --version")
  end
end
