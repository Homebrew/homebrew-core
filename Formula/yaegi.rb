class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/containous/yaegi"
  url "https://github.com/containous/yaegi/archive/v0.9.14.tar.gz"
  sha256 "73b0d886421b98789f564875262d257cbe426da282e5856d0e16286a12a05bf5"
  license "Apache-2.0"
  head "https://github.com/containous/yaegi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "10555b0da957f660ccfc6e26fc50c1aba106784a5f0a472cee5c73b51466d7f6"
    sha256 cellar: :any_skip_relocation, big_sur:       "e716de8b5b0952b91c9d3a0494dbbea750fb63ea48763f77a40690e2ade5c120"
    sha256 cellar: :any_skip_relocation, catalina:      "87e0f0a17ebb1423bdc6c1ca1825f9e37927316164807d9d109f59d08932ff93"
    sha256 cellar: :any_skip_relocation, mojave:        "597ea841f92f993849f81b9fc50a91ab4e7ec2be5b0052bdd54a71bef81457d9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/yaegi"
  end

  test do
    assert_match "4", pipe_output("#{bin}/yaegi", "println(3 + 1)", 0)
  end
end
