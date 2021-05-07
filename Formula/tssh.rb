class Tssh < Formula
  desc "SSH Lightweight management tools"
  homepage "https://github.com/luanruisong/tssh"
  url "https://github.com/luanruisong/tssh/archive/refs/tags/2.1.1.tar.gz"
  sha256 "8ec776016adfa3c02c99bbdcb021f9a80dfa1725e645d4b0f4f33d091531e98e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bc3073bfc2b742a776029ea84e9f636a4d5f3c74eda9e5c6bb7c7bd5bed21363"
    sha256 cellar: :any_skip_relocation, big_sur:       "b416cc7c675e0d5a21c7e6812f6e39f9111ce2460f614ae0a4c567345b4ca0f4"
    sha256 cellar: :any_skip_relocation, catalina:      "f3db9a92163c71c92495c7a75c7a51c13cf4a3024d151885b410aa21d3a4f4ea"
    sha256 cellar: :any_skip_relocation, mojave:        "3be96045a90dd61710b14ad968ac3734ae892223a57e24cc5cb4c9aa3f63a3ec"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
  end

  test do
    output_v = shell_output("#{bin}/tssh -v")
    assert_match "version #{version}", output_v
    output_e = shell_output("#{bin}/tssh -e")
    assert_match "TSSH_HOME", output_e
  end
end
