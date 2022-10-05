class Tlsx < Formula
  desc "Fast and configurable TLS grabber focused on TLS based data collection"
  homepage "https://github.com/projectdiscovery/tlsx"
  url "https://github.com/projectdiscovery/tlsx/archive/v0.0.8.tar.gz"
  sha256 "69725fd5bac23f9c4df1a0e5bb0d344153017bd1af772170162aeb6be0f7caac"
  license "MIT"
  head "https://github.com/projectdiscovery/tlsx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b72c3893105340381d8ce9a6cec5a8414eedd34fb0039a7039cab9530272c74"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "69d1ddb3b97e9efa0108779ddd945d828e896ae82dd587804870fbbd720c59bb"
    sha256 cellar: :any_skip_relocation, monterey:       "274a4eb458d59ac60af936f41817999dc8f8458eff1d3f3b1df277b4684d3985"
    sha256 cellar: :any_skip_relocation, big_sur:        "08688f59b9f3eb38bb1835ca9274f8cfa7fbcfd05ac56da1d3bc226c59e8f916"
    sha256 cellar: :any_skip_relocation, catalina:       "7129275851e583d519b72f60da45005caca5de9407ac11f8e9be30644dacdfbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d68cba9329d0819c1d8ab050fa98fc925b76d115af68d97c2b6374015f8571d5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/tlsx/main.go"
  end

  test do
    system "tlsx", "-u", "expired.badssl.com:443", "-expired"
  end
end
