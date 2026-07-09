class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.2.28.tar.gz"
  sha256 "a9cf526e643909d8a9625e9721aedef69c8266a30293d3d131c82223dcca80eb"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "659698d52f9a520dc3c060f30148e6703dffaffab6a54b5d05bc79a6ec1eef98"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f482a61e0003b22fe94f3defb1e831f013cdbdfefce39cb795f3342f92695ac7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "195399252a0745e09ea15ab7c995a23a082a6141d52d30a8252e69940c7345cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a4f075a711f27b17d0ac36be7872ebbd21556c8897640a88e5061b88b574fd7"
    sha256 cellar: :any,                 arm64_linux:   "fd0b270c57092d248d0bedd3e6b200478679dabfa45088a80e619523d76580f7"
    sha256 cellar: :any,                 x86_64_linux:  "47d33fe55c5de52adac3eebb5d48f52c4a9a877c8ea99a61751f3fc1a2a235e8"
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
