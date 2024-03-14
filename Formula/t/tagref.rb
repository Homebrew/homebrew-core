class Tagref < Formula
  desc "Refer to other locations in your codebase"
  homepage "https://github.com/stepchowfun/tagref"
  url "https://github.com/stepchowfun/tagref/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "47d18c8fe3b037fd32fbeeeb91cf763840a809050a82a386dd56f73505a375fd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "78d0f11d433080f87af41e065e24e5d5458674a25aa679342366eb85dfc57316"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6fb1c4fc89eaa539ed136d4e999e3ebe13487ba2f400265596914136f2691403"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12d1beeeb0ec188bc0fbb23367bfd92efd5692e5d548b5de40fbc2a83e06d9fb"
    sha256 cellar: :any_skip_relocation, sonoma:         "a4754276aa29b708efdca8c8e17fae7a97492f9b200afad4d85a04b9a835cc5f"
    sha256 cellar: :any_skip_relocation, ventura:        "62a44193a79bfbb753155eba2448eac4bf2e1d40737e1846f04a2e9ca57ee44d"
    sha256 cellar: :any_skip_relocation, monterey:       "1f49677fe25e47c33421a250ee7b05f41ed98084475c518a6bbdbe85c1a040ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a511855a0d6ba412935f490d7c3adc74008a35cd4bfa9f5c0258f1d916df64f"
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
