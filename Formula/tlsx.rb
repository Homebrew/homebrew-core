class Tlsx < Formula
  desc "Fast and configurable TLS grabber focused on TLS based data collection"
  homepage "https://github.com/projectdiscovery/tlsx"
  url "https://github.com/projectdiscovery/tlsx/archive/v0.0.9.tar.gz"
  sha256 "5d541d96022eeb303d9109ae652f8b520e429d64cbd44c1a45515c91dee1b6d4"
  license "MIT"
  head "https://github.com/projectdiscovery/tlsx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97b112d59d3e9ce1efef7ec321bf6a1fd3f3770d3cd51e3c22c3804b934c3830"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b1be913a5b4edadbb2e187912c00274edd38ff461b702982a928922dbb6d319"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3bc1b5315b5a30b9ab66a79c242b2835ec5169ef1145eaf2557db8f4d548679f"
    sha256 cellar: :any_skip_relocation, ventura:        "cfdb9e08ef6cfb9c4cbce4e6e5fc119ede9259b8ded74528f6722087c09f02c6"
    sha256 cellar: :any_skip_relocation, monterey:       "4470b7af94742e331df0fd6b349a9458b8a3f41f194f4aa59ee6b545e8633dbb"
    sha256 cellar: :any_skip_relocation, big_sur:        "f32683a15e959bcda241ac87a8cb19d128b7b63851f18e199b522b3d4366d684"
    sha256 cellar: :any_skip_relocation, catalina:       "70f2e076b5de5735eb4d28fdcb434d7b3f15d46b56bfb5c1bcd6b8c237a41f98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bec1cad0ca93db5a8e0b6ea495e6e58ac87d38719073ec8ca4ca485084c2c975"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/tlsx/main.go"
  end

  test do
    system "tlsx", "-u", "expired.badssl.com:443", "-expired"
  end
end
