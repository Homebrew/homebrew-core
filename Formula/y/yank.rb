class Yank < Formula
  desc "Copy terminal output to clipboard"
  homepage "https://github.com/mptre/yank"
  url "https://github.com/mptre/yank/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "0f1d1000f358bfa373f3903ea2871e2585fa694a0b03d8ff7561c1205207dec5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00c28c7ce24bc415e296044403ece66f368bfc86649c736a28a2c8e9b0fd9cdf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9e485e944c8ef15eb19ad47e3319603f882199b07cdc58e993866c7d698f988"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ff290efc4ad41cea0a26d4d509bc25fd06f05cdc81902770d18b68c7047144a"
    sha256 cellar: :any_skip_relocation, sonoma:        "abc44e67bbd920cfead6fc08d0c01b3e3d36ac47f8846b8f8c8b0149ab215af2"
    sha256 cellar: :any,                 arm64_linux:   "96b03a908bb781d75f68412c389f4b8baffa0f8ba9e123068c92d94c8d2f488c"
    sha256 cellar: :any,                 x86_64_linux:  "9319791bcd8f0297e1588103d1df38fdcd364e1421885e41ebfad1ad2c489ac1"
  end

  on_linux do
    depends_on "xsel"
  end

  def install
    yankcmd = OS.mac? ? "pbcopy" : "xsel"
    system "make", "install", "PREFIX=#{prefix}", "YANKCMD=#{yankcmd}"
  end

  test do
    require "pty"
    PTY.spawn("echo key=value | #{bin}/yank -d = >#{testpath}/result") do |r, w, _pid|
      r.winsize = [80, 43]
      w.write "\016"
      sleep 1
      w.write "\r"
      sleep 1
    end
    assert_equal "value", (testpath/"result").read
  end
end
