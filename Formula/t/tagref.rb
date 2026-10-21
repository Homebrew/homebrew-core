class Tagref < Formula
  desc "Refer to other locations in your codebase"
  homepage "https://github.com/stepchowfun/tagref"
  url "https://github.com/stepchowfun/tagref/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "a422ed19499436ed126bd9b53c8744cc4ab81832f90b1b6ae8481ecb5ed4b1d8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "28c05dd13d6b9b7904b410fcc83c7f7c144b2e0fd9b872ebf6d98b661e394fc5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6f7c935aa0d4d42e47fd935cd98083d1937a66d0e5c33a5683d2ef40e6cdcc53"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3aad5edd2d0b625552ea9c5d7fbedc995bbd40243095d1435b4a8d27777460fb"
    sha256 cellar: :any,                 arm64_linux:       "617cc3b000daaeba096ef02da2ea3b6f183880fd634daba4bab9897a97f8be76"
    sha256 cellar: :any,                 x86_64_linux:      "2d9f0edebf2b55aaa44e90927ecc94ec45b07298d2964a5c7d1171aa01dec2ef"
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
      "2 tags, 0 group members, 2 references, 0 file references, and 0 directory references",
      output,
      "Tagref did not find all the tags.",
    )

    (testpath/"file-3.txt").write <<~EOS
      Here's a reference to a non-existent tag: [ref:baz]
    EOS

    output = shell_output("#{bin}/tagref 2>&1", 1)
    assert_match(
      "No tag or group found for [ref:baz] @ file-3.txt:1.",
      output,
      "Tagref did not complain about a missing tag.",
    )
  end
end
