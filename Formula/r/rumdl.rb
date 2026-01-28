class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "6b1833fd08417ab0d1b734f03feca6293c894669a1bea32c1e1812ad1baa3ba2"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c02c383a92ec37465055df1447ee18b11c6b629d51b7a13d6664398856c1c999"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "261d3e7b353132fbc079db9b558a6a35462f5d532230a8310af8b913f7ae1492"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c4e1fbfa6035f8fbc56c5c14bc539caa366068f154bcc7ae207c69836f46ffc"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b9748d86d9dc079df60bc3b8788b21e60b8854844c4efaa4e7f5e499cbfa3bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f24bf3db71912e4500fd23e11c3147aacc19bc1687bba53471a961cabff7ad68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c1c360f30b80bb721d66a552a9f234d8aca2a1e4716644e8c3d8fa140cfe730"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
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
