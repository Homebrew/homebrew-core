class Tagref < Formula
  desc "Refer to other locations in your codebase"
  homepage "https://github.com/stepchowfun/tagref"
  url "https://github.com/stepchowfun/tagref/archive/refs/tags/v1.8.5.tar.gz"
  sha256 "5c97a144ff485f90bda461e2f9fdc73840270cf1e0c5b380505330ec66d9ecb7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4707788e76d6ae8669cd3110119e2791830d391e06fe9025a099d46008e4051b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3351b75307079128e894ef3831d8a1ee8324cc8b42be3dcfd164b57f96ff1aaa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60aa9bb8febfc5788803dfb3ec461dbd5e6184e8ffc975f8c8924628a73214ca"
    sha256 cellar: :any_skip_relocation, sonoma:         "36bfe90501d792cf6f83e6d0017a08dbbfbe4aea2ff9dcddcd8e788c3b1400ec"
    sha256 cellar: :any_skip_relocation, ventura:        "f480c2055b3267ee5f745d9f59d33d37d88d432eaa333984f9a84081ba6dcae4"
    sha256 cellar: :any_skip_relocation, monterey:       "0ae6c2ca56a63d84b24c1306f65041a7d8eca25d5440dc9e7aceaecadfb86f95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7417dec82f756a1084e1625370cb18c63808bf96379847d829d309f06f62369d"
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
