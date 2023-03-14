class Tlsx < Formula
  desc "Fast and configurable TLS grabber focused on TLS based data collection"
  homepage "https://github.com/projectdiscovery/tlsx"
  url "https://github.com/projectdiscovery/tlsx/archive/v1.0.6.tar.gz"
  sha256 "d721bec0af5a532ae25a52ca19fd26b781b6fa3b727b77ee701195e118b7c8e0"
  license "MIT"
  head "https://github.com/projectdiscovery/tlsx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f5f0411b4501ea55be82d466c03e28796e9637b402f2aacfbf4c7250d95c8a03"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c9592f391352549ea01af264fc2a10abd1ca12e7a85e699f68f079b286aa6cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bb08dd62100a6dca087b21a5ed61654b26af4173b78e9cc57dd51a3c8e6f9344"
    sha256 cellar: :any_skip_relocation, ventura:        "158bc31a500f0d2458e78d1cbf295521620bec075950c919f70a0b54db97f11c"
    sha256 cellar: :any_skip_relocation, monterey:       "f86cb68a9d254d3e6ddc2e8426768a3abd6f8a07df7f6491fb45e7ebd0f308ca"
    sha256 cellar: :any_skip_relocation, big_sur:        "e71a40f50ff734a859ad6fc784393f46035a6c17312e62ff746e3e37894b43c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfa685485c3c0f012b6fc6d2f63449220f193479a6f6ad7c09cd90a1a5882d10"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/tlsx/main.go"
  end

  test do
    system bin/"tlsx", "-u", "expired.badssl.com:443", "-expired"
  end
end
