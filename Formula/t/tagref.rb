class Tagref < Formula
  desc "Refer to other locations in your codebase"
  homepage "https://github.com/stepchowfun/tagref"
  url "https://github.com/stepchowfun/tagref/archive/refs/tags/v1.12.1.tar.gz"
  sha256 "3d0017911afb6d9b887444c6da32f1642ad4046b4098af3d412fae1b58fece8c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd2cf5d505804dcc7c87391c136ca3427f9b425a2893a6eec1106d316e2d2257"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b9da9b70cb41294edb6aa01f93ebd3fe60c55b92c1c27b169b477f23622a0e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fda41c0c9e8ab44b84a739ccfca6988dde0e79b1e0e1eeabe198056cdf781c79"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b3d31a89ce136aa4d439da6ee58b707d94e197443aab0910410a902ff0c5321"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc3d2ef9a8a1e2660dee7638329c0247b7cf6231875e4d83e7a3bc1f2f5dc162"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0d200fb78fd990e680ab7cbcd0e67745094bad5e3e062d26be4aef65cf838db"
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
