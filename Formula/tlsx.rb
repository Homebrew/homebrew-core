class Tlsx < Formula
  desc "Fast and configurable TLS grabber focused on TLS based data collection"
  homepage "https://github.com/projectdiscovery/tlsx"
  url "https://github.com/projectdiscovery/tlsx/archive/v0.0.7.tar.gz"
  sha256 "82b54e89ff5c73f5a8536443466c897a6b0bb5ee50ea101390c10211bdf4f00e"
  license "MIT"
  head "https://github.com/projectdiscovery/tlsx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "def95d46524312462daf6cba486d6d4764d7c1583b06f3dc4c4ebcc1121e4fa1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f24ad25954a0c0a342c48227ab38ec0976a9ddc8e19ecc0f4af3707bae57a5c1"
    sha256 cellar: :any_skip_relocation, monterey:       "8966a1c0becc6d7d1c73f31607880f3bd68ac51386ac86a0782d70f4f7369521"
    sha256 cellar: :any_skip_relocation, big_sur:        "78dd848bc8d7612d85d670645dec08c42ebfff6cd4efac46148ad3e343eda856"
    sha256 cellar: :any_skip_relocation, catalina:       "87582835b21f489ce000007f3e0e2a04eec74811e3c74930675e2e159f1e0f99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1923ed9a833dd5ca27ff7753d3688621ae22487e5a27938c91c81baecefd19e6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/tlsx/main.go"
  end

  test do
    system "tlsx", "-u", "expired.badssl.com:443", "-expired"
  end
end
