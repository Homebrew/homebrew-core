class Tagref < Formula
  desc "Refer to other locations in your codebase"
  homepage "https://github.com/stepchowfun/tagref"
  url "https://github.com/stepchowfun/tagref/archive/v1.8.3.tar.gz"
  sha256 "72c5b78619561b22b7079a1d6286a27f9c0dcb258f2da53367a1a886070234b3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e91bf239ed547b630a579006dbd8f4013065fc05e128d7acfec46c44ffcae3d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a042a420278a41a4ee426dfb42b44bc30ea7a3beaacc43ce5141247932da77f2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "70e033198c3e7ef702e01c52a90b064a7ffb979d765e4677247ace191740dc31"
    sha256 cellar: :any_skip_relocation, ventura:        "74fe84d5d287cca35e38085fdf2202439bff4fa6a243034e4a56ba6de081e821"
    sha256 cellar: :any_skip_relocation, monterey:       "fa5ef5bde57b0cdea3472ee33135954e81fc2da36bac21f2f3deb1b72ab50732"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f5a5d354f7d621af95be9c48d54b342cbd2fc4857873350f36fa11d381de62b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "980ac6ac00b450f1f94faa164a315c5e78e70a591edad06105c8956ee6653c6a"
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
