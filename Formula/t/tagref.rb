class Tagref < Formula
  desc "Refer to other locations in your codebase"
  homepage "https://github.com/stepchowfun/tagref"
  url "https://github.com/stepchowfun/tagref/archive/v1.8.4.tar.gz"
  sha256 "dfa5e59312c06a3bf5dceee12045e193b6ae3d4eeb7fab42f1c1edb3f9fe838e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "709e5c538191ec4da822f21c29c67745d520522a44c5cdc12386ee252c74f9f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70c1adcf722b7d54cea4361e0282d67f432154f7c13f7a79f29439427d173b34"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1638f0e7c3f0e448a3bce949fb7624335a6fc4a492b4aa9111ef15ad72462220"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "70558da90d6dc09e838cee7f2e4df5c3720416650ff10b5ec9adbea4b457db82"
    sha256 cellar: :any_skip_relocation, sonoma:         "be21f24fbf59dee9b9893b54d1086fe827d99c8d515db6775c35054be1a22b91"
    sha256 cellar: :any_skip_relocation, ventura:        "3afd1c563d3dbc8dc539f534d30c5c2fe183318db294b34a1293ca2be87e28c5"
    sha256 cellar: :any_skip_relocation, monterey:       "d81c5188dd14f91040a01427e3df8a9291b48eccc3ec74122ae79541c7edcc79"
    sha256 cellar: :any_skip_relocation, big_sur:        "151a4439dab0defdb5fa0afb9291b297cd606aa6f7359a0248c9d56f86694ce0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b00e8b3f2574d8bbc289853bf76d2aa1fe63151ea34192855f469a60000c0e66"
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
