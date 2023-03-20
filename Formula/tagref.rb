class Tagref < Formula
  desc "Refer to other locations in your codebase"
  homepage "https://github.com/stepchowfun/tagref"
  url "https://github.com/stepchowfun/tagref/archive/v1.6.0.tar.gz"
  sha256 "e5ca75065068bbf0b6727f7ca8f6b4620770638c756996e98f8dd69b224026b4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e89a3cb6bddc131a542ddeb32b434b90b39af82f74b96b6d3ec76322fb905c8d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f953648a67f2b9a5b96bc6aa51a9c8fdccc49fdd8abfe2c91b2939c63b2475f8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "109b43181df9fc99f5bcfe6ebb7353e832583d189724b069ba7b45f5066f70d0"
    sha256 cellar: :any_skip_relocation, ventura:        "833e0085ed89a04e879b8f30273df801e05460525952cd7227deeb07f3da2719"
    sha256 cellar: :any_skip_relocation, monterey:       "2cff3223d0cad9e241e3a563987a287456c74a73f37dad01d1d6330ccdfd2783"
    sha256 cellar: :any_skip_relocation, big_sur:        "2bf19fec45d16574085abaa63e835e5809adf3e731fe0de82678670a3149e98c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31c9592dd851ebcfbe5ccc7050519127ec34ad477ed3a95c5f067c1a3b63abbe"
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
