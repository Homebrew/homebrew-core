class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/containous/yaegi"
  url "https://github.com/containous/yaegi/archive/v0.9.20.tar.gz"
  sha256 "595e2d6283afbc485444a4531113e7ee2e2f686d0d533dc4db130df6a37dcf25"
  license "Apache-2.0"
  head "https://github.com/containous/yaegi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6c7f987465c1d526182e791aee574e968304fed724af2317602ac1be24517911"
    sha256 cellar: :any_skip_relocation, big_sur:       "bc2df034ac820460dd80129a5602953ea17c1cdf3e16f1900cdffc3bd73cff3a"
    sha256 cellar: :any_skip_relocation, catalina:      "5c57000bc6385e53b22456f85d0ee56580ead57498101dea276c2d686f97b7f8"
    sha256 cellar: :any_skip_relocation, mojave:        "8eabf6538bccf4350bdf5b2e609e9cb83dd5f951490f92f91c445f2a4a971a78"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/yaegi"
  end

  test do
    assert_match "4", pipe_output("#{bin}/yaegi", "println(3 + 1)", 0)
  end
end
