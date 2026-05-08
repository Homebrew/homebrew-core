class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.1.91.tar.gz"
  sha256 "bb1e3e7a08203456020e915606bf50d3f85708c14ac10367743628734663bd3d"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "872cac574d609676a2966a9e7b9d4d17d642fb115afb87b2dd9ca697ff8721ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9257b370fa57f5b0075e3795954267a1bdeb5d9892dfb5bc4e4dfdfc41be113a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dff247c9f37ea285595bba32d876910405368f0a5c284efda4255bf7422245f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "3594adf7846fdf92d5c2078b7c50b9a470287d54371045336749ad36071894c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "241393ff016e2193c1afa9c1a5ad79dcc62899a41d8e51ca3b1d2ddc251e838c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e438e3c24d1d9ff2993fbf24380450d21232ddf9166204a66ee79bd90aa662ed"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"rumdl", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rumdl version")

    (testpath/"test-bad.md").write <<~MARKDOWN
      # Header 1
      body
    MARKDOWN
    (testpath/"test-good.md").write <<~MARKDOWN
      # Header 1

      body
    MARKDOWN

    assert_match "Success", shell_output("#{bin}/rumdl check test-good.md")
    assert_match "MD022", shell_output("#{bin}/rumdl check test-bad.md 2>&1", 1)
    assert_match "Fixed", shell_output("#{bin}/rumdl fmt test-bad.md")
    assert_equal (testpath/"test-good.md").read, (testpath/"test-bad.md").read
  end
end
