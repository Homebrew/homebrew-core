class Slacknimate < Formula
  desc "Text animation for Slack messages"
  homepage "https://github.com/mroth/slacknimate"
  url "https://github.com/mroth/slacknimate/archive/v1.1.0.tar.gz"
  sha256 "71c7a65192c8bbb790201787fabbb757de87f8412e0d41fe386c6b4343cb845c"
  license "MPL-2.0"
  head "https://github.com/mroth/slacknimate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "438d35da4f542723602cbaa0cb136069389c6216632d0145295b744eb473cfc8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "35f24a47ca03293bec53b2b622cc1c6f0a012b5c674c0fea83a79795474caefb"
    sha256 cellar: :any_skip_relocation, monterey:       "c52156ca14ce584ef223869a98553a7411098452ad8af38999ac90076d4a8895"
    sha256 cellar: :any_skip_relocation, big_sur:        "d8120fd0cedd32b5be89ff29f2eed08d060a810820cfc23f6f74e1c7201ff5ad"
    sha256 cellar: :any_skip_relocation, catalina:       "52bd6b01115cb8e84d3479ff6dea669a98b17b60cc6090b3384ac44fdcbdd93a"
    sha256 cellar: :any_skip_relocation, mojave:         "28f1871e38987c5b06e0666f172d0eefb9e6895ea8207a0ad171d467a2df7f7a"
    sha256 cellar: :any_skip_relocation, high_sierra:    "6849d5acbe802d8fb69007f144bba62a9c259a9093ccc920fb9a200edc9368fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "198c82b7bdd71a589e1e9e811f10a8f619bf0fe1de0accb3b1c8aaeb5621049b"
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
