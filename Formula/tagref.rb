class Tagref < Formula
  desc "Refer to other locations in your codebase"
  homepage "https://github.com/stepchowfun/tagref"
  url "https://github.com/stepchowfun/tagref/archive/v1.7.0.tar.gz"
  sha256 "fdeb078f07bfb90b978297a38d1bfdae83d482e9490df025565145cb6d417c62"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ec2d58fd92ec80ee65a222c73cfde7affb90aa5b85415eff9e42aea8fbb91c0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a605661e7b11231cf840daddad904ff745dcb39c070894e9c86b502e3c65712"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a5698331a2d34f3491d535d53bc096a5eb63923d8dff832a25cf1107ff57f8c5"
    sha256 cellar: :any_skip_relocation, ventura:        "8d0dcbc9d88f10af07190a23f324722efecd8876e8b647fe624a3689217e592b"
    sha256 cellar: :any_skip_relocation, monterey:       "e65e1ba32b1870718bc6cdecf31c4c441d77f0888e225ada1d8d52064bd31ee5"
    sha256 cellar: :any_skip_relocation, big_sur:        "ef1af8531f32c68e1fb59bce8fbff25632fbcc90ccda083756e3e939368958e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11181eede1b8d063ecc5c298a33ad0dc33463e8b196d6e5263507920314248ee"
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
