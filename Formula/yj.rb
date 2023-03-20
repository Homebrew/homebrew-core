class Yj < Formula
  desc "CLI to convert between YAML, TOML, JSON and HCL"
  homepage "https://github.com/sclevine/yj"
  url "https://github.com/sclevine/yj/archive/v5.1.0.tar.gz"
  sha256 "9a3e9895181d1cbd436a1b02ccf47579afacd181c73f341e697a8fe74f74f99d"
  license "Apache-2.0"
  head "https://github.com/sclevine/yj.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "629640c9e3caf08148948158d044817e212a3274ec40af248d2cd14151ecfe7c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6006ef14b2246ac63c166b0c2e7ddd59265ab3e38d46d3f6373e4a9c33897000"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6006ef14b2246ac63c166b0c2e7ddd59265ab3e38d46d3f6373e4a9c33897000"
    sha256 cellar: :any_skip_relocation, ventura:        "568b374d40bd5a4826fad11c89c40f0fded5a14aedfac2d7d5fc85a90770e530"
    sha256 cellar: :any_skip_relocation, monterey:       "5171d044ed87a081eaa9cf71a7acad2bede581c9b451a0f21b3908e4d2e45105"
    sha256 cellar: :any_skip_relocation, big_sur:        "5171d044ed87a081eaa9cf71a7acad2bede581c9b451a0f21b3908e4d2e45105"
    sha256 cellar: :any_skip_relocation, catalina:       "5171d044ed87a081eaa9cf71a7acad2bede581c9b451a0f21b3908e4d2e45105"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca06f08696b263564c3f22ad114cca8863eb06f805a83c6b5fbf4134854a0413"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match '{"a":1}', pipe_output("#{bin}/yj -t", "a=1")
  end
end
