class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.2.23.tar.gz"
  sha256 "b5f997a1dd3904283197b7ab6355f55211281d6e4d39229ef1b3c6d66f3d838f"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4443fad968d2546a2353b02a2a4057bba6bfb6deadc511a2d72e6876fc0bc96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4fe7d689a1a1fafe0cac0b86b88b11914a2d3da37809010a7b16b69bd7f794f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b1b7ae8b61521a35ee1794ce094eec2eeebf75eb50904d36d7dba7e48533e6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ef3ce97c8fae2d24d7d1d1e2323ac2a58a9d41bc5ab3b4fd6d24397a81be6b3"
    sha256 cellar: :any,                 arm64_linux:   "597dc88d4d7ac522c2aae5a8b8cf0ac0efeac5e9771174e4f87ad10849fee63c"
    sha256 cellar: :any,                 x86_64_linux:  "97d8e19bcf3036ad3aa6dbc0e859bfbb6d8aa654c28f8ab5122f932c799e5d27"
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
