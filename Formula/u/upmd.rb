class Upmd < Formula
  desc "Run tasks and dependency-aware workflows from Markdown"
  homepage "https://github.com/rezigned/upmd"
  url "https://github.com/rezigned/upmd/archive/refs/tags/v0.2.8.tar.gz"
  sha256 "aae23b21cd499859dcea0be9951ce9ebf7d28c4c1d19ad5af8330526cd168da3"
  license "MIT"
  head "https://github.com/rezigned/upmd.git", branch: "main"

  bottle do
    manifest_sha256 "3ca4625314d099a88943a907312e063cddab93e2bdcb6596cfc0821b12ec13de"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "41e039505d099216ad3106c05268f544ed957906cbd1614ce44c206b4e18e7f2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "76ee14dad6c3e83b27222296e2437bcbd324778d61638746fa6478365b793145"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1b87ca48223c792f0f69ba19d32bbf555a09858568dc1e649d844bdf820dc026"
    sha256 cellar: :any,                 arm64_linux:       "a69b8c530a55068549a2521b6d2f421ddb212f761f7c0854800834540d61b07a"
    sha256 cellar: :any,                 x86_64_linux:      "bd47b0a0408bcebd2c2d69b985f975ebde98783b07e42aec23df52bbb0dd569a"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/upmd --version")
    (testpath/"up.md").write <<~MARKDOWN
      # Offline task

      ```bash
      printf 'Homebrew task completed\\n'
      ```
    MARKDOWN
    output = shell_output("#{bin}/upmd --ci --all #{testpath}/up.md")
    assert_match "Homebrew task completed", output
  end
end
