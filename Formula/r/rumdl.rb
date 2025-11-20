class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.0.180.tar.gz"
  sha256 "292524c927359210235effc6eba358c40307b5e36f8d9ba39c5ead05651aa385"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c4041ddc10c49d3af1c019cb24393d2a15e42c82a660ca568aea54ccf1d8431"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f99973628d041afd4d304268c4c9be6b1fe552c871210e4c37b29ea729820ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3eeaa984e6fbc580d5335c386ab0e37c4a79848fe382db72dc148e149eb6de6"
    sha256 cellar: :any_skip_relocation, sonoma:        "c306793d453e0f786abe63fff2b0e378fb72cda01514830c49634dc4841009c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63c8668e527357ef6f37fbe580c920a4d32fc77bf1ab7d4689954db9a467296b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b602729eb805c364fc60c672a53fc2098fd8571570d9c33d0d7158bb88a9dbd"
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
