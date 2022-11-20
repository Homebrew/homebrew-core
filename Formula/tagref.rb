class Tagref < Formula
  desc "Refer to other locations in your codebase"
  homepage "https://github.com/stepchowfun/tagref"
  url "https://github.com/stepchowfun/tagref/archive/v1.5.0.tar.gz"
  sha256 "dd6321133c2bef64f9230d6aaddfba8a4327749236638c23c65d0832ca2fef48"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0be96defc6eb0491d7ba3dcc9c2cd6690e92558fe6c2a39b7f99ad1a36cfead"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "701bf977e8d122b7ed718602f0ff06223acdbc05272ad8f00c22b1e29a1fa3f8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e9b75447989ea48f149fd1705cd17a2e571e69c2ce2462f245573f6d25f1fd48"
    sha256 cellar: :any_skip_relocation, monterey:       "7688a4c441a2181e49eb77d311be518d11210fafac4f8a742f1a0922d5ece1f8"
    sha256 cellar: :any_skip_relocation, big_sur:        "35d290ce5c4fa8d08c4f3931fa33781695efdf37fb3377045880c2e27dd86a65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b460c3536e00f00d1db4ab844e1023a560208774089da654c1641f9e0d2d8d73"
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
