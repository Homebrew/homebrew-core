class Tagref < Formula
  desc "Refer to other locations in your codebase"
  homepage "https://github.com/stepchowfun/tagref"
  url "https://github.com/stepchowfun/tagref/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "47d18c8fe3b037fd32fbeeeb91cf763840a809050a82a386dd56f73505a375fd"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "ddb3d0e12f6c24a0b83a387e5e1392fdeb16fbc0c8dc858690448dcd6575b7ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ead16f369050ce660900f833ef63cfa2040c7f0deba8a0545ee5fea24f57d15e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a0aa631523fd3592e9f52b7abb2f5670a927cb6779515614eee07cefc71f88ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ed4bf80ef6f1aed8347f311832712b181836ce4dece7e944dc388fd89018a72"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f400c0ef3ef0cbf288d732a56b925c0cb198b4258f8f77987c74c5a0643dd0b"
    sha256 cellar: :any_skip_relocation, sonoma:         "e3bc0ef94cf98c84d34ac8452224747603d7ec12c74f15912088f0815ce98859"
    sha256 cellar: :any_skip_relocation, ventura:        "58365312aba136e092131d67eec59209f83563bca4c39dc125f17160f60299a8"
    sha256 cellar: :any_skip_relocation, monterey:       "1eb81cfbe02b48597193f52be781db4d766f5fdf3c690b83d195c49b8028a675"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "a4a49434a44171844bb5b38fc02f2b1dc25cf1ff4985aa095ca1e865765ba093"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77b2f0a10a0bed8fb20f230a9f18590f9c2583657d173ef8c0c2b003443aa469"
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
