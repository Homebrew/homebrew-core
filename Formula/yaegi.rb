class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/containous/yaegi"
  url "https://github.com/containous/yaegi/archive/v0.9.12.tar.gz"
  sha256 "da2b94d35c7c78de9bf33f7140c4283a953684aed9f88df6104530b6ebb2adb1"
  license "Apache-2.0"
  head "https://github.com/containous/yaegi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "820c4b465b1dde8ee2d39869b6642fd2be39836bf026737b37eb93e9bd67545c"
    sha256 cellar: :any_skip_relocation, big_sur:       "a0e1dc410e2a913a7951904ce7de54b1777b97fd452be45f16153079686037b9"
    sha256 cellar: :any_skip_relocation, catalina:      "9e0e585e13b1c4753904ff8ff96cefcfb9589c8a85b05a6bb1e553875d4ab1ef"
    sha256 cellar: :any_skip_relocation, mojave:        "6426147ee6ccb129167c1895119fa20d54e90a0b856ab586a87acd2a8a53c176"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/yaegi"
  end

  test do
    assert_match "4", pipe_output("#{bin}/yaegi", "println(3 + 1)", 0)
  end
end
