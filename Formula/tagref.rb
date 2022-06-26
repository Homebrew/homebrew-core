class Tagref < Formula
  desc "Refer to other locations in your codebase"
  homepage "https://github.com/stepchowfun/tagref"
  url "https://github.com/stepchowfun/tagref/archive/v1.5.0.tar.gz"
  sha256 "dd6321133c2bef64f9230d6aaddfba8a4327749236638c23c65d0832ca2fef48"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45abd1598e37a33059809e5c61ca12bf834494956e045756516c0dd140f75a69"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ab88cb0ff4f7c4e50720ecb4fb6722076eea5da8dc8370af4272f0a822ac9b0"
    sha256 cellar: :any_skip_relocation, monterey:       "ef0210fc4bacb818e9cdd0a8de04c423c898e352c17fa9239ee3541c7407dde7"
    sha256 cellar: :any_skip_relocation, big_sur:        "8b2402e3f4d1236a9eec0d0123f42c8ff95de911cc332ef96a08b1c0521b2db6"
    sha256 cellar: :any_skip_relocation, catalina:       "e23d040b0b40038a20dda1bb7f5bd17b21115ec02d93b551c5830daa9de65b0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12073722b5c6b4d9b2021fbc1f3f76adc57a286dea9a0c19cc0a1daef8404983"
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
