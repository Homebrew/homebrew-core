class Slacknimate < Formula
  desc "Text animation for Slack messages"
  homepage "https://github.com/mroth/slacknimate"
  url "https://github.com/mroth/slacknimate/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "71c7a65192c8bbb790201787fabbb757de87f8412e0d41fe386c6b4343cb845c"
  license "MPL-2.0"
  head "https://github.com/mroth/slacknimate.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "2d16153371e5e8375e39cdfb1733d6cfaf21490305b53c1792484f91ce5b1f20"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d9ac5eee6054981abdbaf4e761840dbc63ec20dfdf7c5e36abbc2f7537fd9804"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1932450215802048e308af408e1255649dadb49e440a4dd1e172d1497d890e70"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e1dcbf1a976b1addb776b43655464f1139969ade15c765d1fbad335529227c1a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "438d35da4f542723602cbaa0cb136069389c6216632d0145295b744eb473cfc8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "35f24a47ca03293bec53b2b622cc1c6f0a012b5c674c0fea83a79795474caefb"
    sha256 cellar: :any_skip_relocation, sonoma:         "237383328fe4307d81c19f79f5f8522d98997d1807095ffd7ced04a6bd4990cf"
    sha256 cellar: :any_skip_relocation, ventura:        "15d0a3c26c46a946fd57fc49a92761ab1102df426d6b68bdbf7586d3cb436d90"
    sha256 cellar: :any_skip_relocation, monterey:       "c52156ca14ce584ef223869a98553a7411098452ad8af38999ac90076d4a8895"
    sha256 cellar: :any_skip_relocation, big_sur:        "d8120fd0cedd32b5be89ff29f2eed08d060a810820cfc23f6f74e1c7201ff5ad"
    sha256 cellar: :any_skip_relocation, catalina:       "52bd6b01115cb8e84d3479ff6dea669a98b17b60cc6090b3384ac44fdcbdd93a"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "1c7190147489c731c8266d014b7919c8ef489cef1d86fa4a2ebf8206bd2ba7d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "198c82b7bdd71a589e1e9e811f10a8f619bf0fe1de0accb3b1c8aaeb5621049b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/slacknimate"
  end

  test do
    system bin/"slacknimate", "--version"
    system bin/"slacknimate", "--help"
  end
end
