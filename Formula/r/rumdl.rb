class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.2.60.tar.gz"
  sha256 "7fe31dd1795a929f1f3bbdbb2d95504d63ceed5df62eaac844f850f6921ec26d"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "786fb62778f76f0292a4381c64f77a803e482dcba8d0818761335ece51fbcb2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d17c4021fa8bd85aac710fa147491bf85b7f00c1944b3e0419faa2c0da24452"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f204f7d56853c4e002b180b65293f677d976766796e3f1094bfb970a10c1387a"
    sha256 cellar: :any_skip_relocation, sonoma:        "22f50e8ddd69ff51302b687888d173fe73f11879972afc4029e6c0c7e27cb9bc"
    sha256 cellar: :any,                 arm64_linux:   "a4e98ddd7f76b178ab9f02db9edf1c640f4219332168087bd826e16a489fcca2"
    sha256 cellar: :any,                 x86_64_linux:  "9b48a9e8173db380a2b74df2ce3ef5cf1fb0d3e151cda6826a649302b168cfdf"
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
