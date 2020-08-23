class Slacknimate < Formula
  desc "Text animation for Slack messages"
  homepage "https://github.com/mroth/slacknimate"
  url "https://github.com/mroth/slacknimate/archive/v1.1.0.tar.gz"
  sha256 "71c7a65192c8bbb790201787fabbb757de87f8412e0d41fe386c6b4343cb845c"
  license "MPL-2.0"
  head "https://github.com/mroth/slacknimate.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "52bd6b01115cb8e84d3479ff6dea669a98b17b60cc6090b3384ac44fdcbdd93a" => :catalina
    sha256 "28f1871e38987c5b06e0666f172d0eefb9e6895ea8207a0ad171d467a2df7f7a" => :mojave
    sha256 "6849d5acbe802d8fb69007f144bba62a9c259a9093ccc920fb9a200edc9368fa" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build",
      "-ldflags", "-s -w -X main.version=#{version}", *std_go_args, "./cmd/slacknimate"
  end

  test do
    system "#{bin}/slacknimate", "--version"
    system "#{bin}/slacknimate", "--help"
  end
end
