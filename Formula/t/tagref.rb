class Tagref < Formula
  desc "Refer to other locations in your codebase"
  homepage "https://github.com/stepchowfun/tagref"
  url "https://github.com/stepchowfun/tagref/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "18663bc5628a437eb756de72d0f0ecf1a1100806c768895d6c3be85ae92a9d7e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef46bd26be5719fd68aa0ed4a8b132d4fe1bcadf7e258f598bb3e3a11b71424d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8973472b765cf3ceaac8f21dd4d40fc66837b3ad8dcb80ca748ea6d3533e363a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9fd932b84bc1ebd27eaf725fd382fca7f04ffbf592ab0a15f1dee6d3e235a5fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "339d31bfb497429597f56e74f31fcf4ebb06945d5db6bf81c2f34a56d6e16498"
    sha256 cellar: :any,                 arm64_linux:   "b280a4fca55ed96b32662267c11d49d636064731c6f5b9c62e9a0d286c446f92"
    sha256 cellar: :any,                 x86_64_linux:  "508ba941b3247e43efa7ee2c93110e188a703e0ff23fbcc9ca5bb7e25f9492b6"
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
      "No tag found for [ref:baz] @ file-3.txt:1.",
      output,
      "Tagref did not complain about a missing tag.",
    )
  end
end
