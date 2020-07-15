class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/containous/yaegi"
  url "https://github.com/containous/yaegi/archive/v0.8.13.tar.gz"
  sha256 "e76175e49af5bfaae97385891684bf87661f566a7a3a9698d698db84047ac165"
  license "Apache-2.0"
  head "https://github.com/containous/yaegi.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bf45292147ea66f36838dc93f1360a8b72a79762c707534e06cd5733c5d17b50" => :catalina
    sha256 "7d44dda2f0ef5548de5d7c4981b1f559a4817590fd6ce1912c98efaf1065490b" => :mojave
    sha256 "ab2308bd0be899ca01d5e1b5eaef2d6a580b50fa5cba7a80b5f231cbae57e561" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "cmd/yaegi/yaegi.go"
    prefix.install_metafiles
  end

  test do
    assert_match "4", pipe_output("#{bin}/yaegi", "println(3 + 1)", 0)
  end
end
