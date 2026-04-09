class Tagref < Formula
  desc "Refer to other locations in your codebase"
  homepage "https://github.com/stepchowfun/tagref"
  url "https://github.com/stepchowfun/tagref/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "a5172df6b7e3c943d9c805ffd31ec4b00d226c34c989b9c3cefe29eb0499361c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f1c5fd2add90743d9c53c225acd316dad04e486e73576f10d4b18696d24cc6c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96b4a153bf74f88b345e0b00301c445e6980247ae734f394339fae362a30b996"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cce149fc158f24678b2736d3b82d1cdcfc88dbcdd0d7929730ad21bf6af7d640"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4ff33ae056da1a427c596d6b2f4471f88a87821965eb968fd8b493a0133ed7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58d3b926d2c486a71ad0b37117bddaa4fc6c3742f36868668cc8a3b300e8fb36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "377d80c5354130daaee0ce3cb649f69b007c73a40cf032983cb9c8775e5e623b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"file-1.txt").write <<~EOS
      Here's a reference to the tag below: [ref:foo]
      Here's a reference to a tag in another file: [ref:bar]
      Here's a tag: [tag:foo]
    EOS

    (testpath/"file-2.txt").write <<~EOS
      Here's a tag: [tag:bar]
    EOS

    ENV["NO_COLOR"] = "true"
    output = shell_output("#{bin}/tagref 2>&1")
    assert_match(
      "2 tags, 2 tag references, 0 file references, and 0 directory references",
      output,
      "Tagref did not find all the tags.",
    )

    (testpath/"file-3.txt").write <<~EOS
      Here's a reference to a non-existent tag: [ref:baz]
    EOS

    output = shell_output("#{bin}/tagref 2>&1", 1)
    assert_match(
      "No tag found for [ref:baz] @ ./file-3.txt:1.",
      output,
      "Tagref did not complain about a missing tag.",
    )
  end
end
