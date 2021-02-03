class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/containous/yaegi"
  url "https://github.com/containous/yaegi/archive/v0.9.11.tar.gz"
  sha256 "8af771783160f880008f56770abbd7c3021167294239c9acac4626787f26f49a"
  license "Apache-2.0"
  head "https://github.com/containous/yaegi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e8e2e114ab838a7540ab78e98f2f41b0d083e2743d5c71b25dd3ac8e1da46613"
    sha256 cellar: :any_skip_relocation, big_sur:       "a03447c0a1a8358b510f21354c5927db6cbb622b4d7a2fa58276d59d8d91e0dc"
    sha256 cellar: :any_skip_relocation, catalina:      "0761773a460df6af65c38813e173fb2673246cf1e635950651151b3276bc4d59"
    sha256 cellar: :any_skip_relocation, mojave:        "1c9e3915c5d8a0494c0de9120c9e86e99d351e8424fce8c7e3f64f36507ab28e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/yaegi"
  end

  test do
    assert_match "4", pipe_output("#{bin}/yaegi", "println(3 + 1)", 0)
  end
end
