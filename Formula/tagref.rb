class Tagref < Formula
  desc "Refer to other locations in your codebase"
  homepage "https://github.com/stepchowfun/tagref"
  url "https://github.com/stepchowfun/tagref/archive/v1.8.0.tar.gz"
  sha256 "bee818ea0cf4cfa14d87e36e18e937abd1205ef0e356baf4fcd6f405d4c59a6c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8389ed2946eaff1cb979140e35666ea45c4907ddcd7e4458d815055f41d82682"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0baf2e1bebd522a12566ade1ecd515814ffd19400c101c79458bd1d1c56ed324"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0a4bb4915c14051b3088ab140eb77ddfa10984b53b88278703c77d18ecf14e78"
    sha256 cellar: :any_skip_relocation, ventura:        "d987bebdeaed54d4e78e61855457ad366d7fbe47721582364ba2a90658961b23"
    sha256 cellar: :any_skip_relocation, monterey:       "d7d7c0f4ef1268570c018f7e6bcda9a1d4bd9607880cbbd76f67783b37382b7b"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c09a47f69193062a0a573b6bc92a8e61334fe6440c129edf0c13c22c334144f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ecc89330e911ce831cb2810aaa45a5f5aa4cce8983d85f38ab702c9d62782768"
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
      /2 tags and 2 references validated in \d+ files\./,
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
