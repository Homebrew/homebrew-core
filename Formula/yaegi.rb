class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/containous/yaegi"
  url "https://github.com/containous/yaegi/archive/v0.9.17.tar.gz"
  sha256 "976eb88cef567743839d078f2606df25bdd567d4cdf2a015c5df2eaf8524a449"
  license "Apache-2.0"
  head "https://github.com/containous/yaegi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "66c4101876412683a996264d8f8378e81ba5e7731f25e3b13a836d5c2fa5e9fa"
    sha256 cellar: :any_skip_relocation, big_sur:       "b8635798c3f7c9c92648a13a0bb39913341132238226e09e6a144c81ea6517f5"
    sha256 cellar: :any_skip_relocation, catalina:      "02e285260652a6799badeb308b04685b1dc9556d15ed6684673b96e85044bf49"
    sha256 cellar: :any_skip_relocation, mojave:        "f53ff0d925a2c7f41c7a78bbc43b35ad3edea13d18e8156b4224ca69c2d13026"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/yaegi"
  end

  test do
    assert_match "4", pipe_output("#{bin}/yaegi", "println(3 + 1)", 0)
  end
end
