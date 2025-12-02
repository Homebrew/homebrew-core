class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.0.186.tar.gz"
  sha256 "d9452b877f6d6e6bec5ba9afcaadf2cb8f3f0fd966c498fb40675ee2fdbda540"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa829d718e157ace685a6c7fc0712ea1aa5177e4864de71f794bf5ea8c588a05"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0509ac23191ff559a543dd14f81f33cd132e2cb0b84df944e1d9bde608329a80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d866291bfd437893f114289d8448dc24ee61cf4174adff731573ea11784f476c"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b9bda3466e375e6fecb488c324ba94d98f0b99627c1afe0e82623564cc09c89"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a66c9ba908e79283032c2c2c779734dada925c9d2fc9099989f67eeadcd88b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebdea4b525918a0f8263d9c04c169c46fd56fccabb352b58f2d91fccd004ff61"
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
