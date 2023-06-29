class Tlsx < Formula
  desc "Fast and configurable TLS grabber focused on TLS based data collection"
  homepage "https://github.com/projectdiscovery/tlsx"
  url "https://github.com/projectdiscovery/tlsx/archive/v1.1.0.tar.gz"
  sha256 "229a66579c469e896890f45fcd3e9f5f9990c480cf4718a48dc978fde9878091"
  license "MIT"
  head "https://github.com/projectdiscovery/tlsx.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "71c678689eb07e20e16ce470c078d8c92a1f4caf020e75648984f7ebe8d7f1ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71c678689eb07e20e16ce470c078d8c92a1f4caf020e75648984f7ebe8d7f1ee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "71c678689eb07e20e16ce470c078d8c92a1f4caf020e75648984f7ebe8d7f1ee"
    sha256 cellar: :any_skip_relocation, ventura:        "d1b71fb9d14cd52f02da35c0be1a1e317ac9016f62c884c3c66e3ba5250b870d"
    sha256 cellar: :any_skip_relocation, monterey:       "15c6c3533e62bed1339132e94e20605478b37eef141f86d6a29a9f1759e21f6b"
    sha256 cellar: :any_skip_relocation, big_sur:        "4362cce0bcc64e37f1d1c9c193670238adf7caec36716b636cb4f479e687d3b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dad37ae0f8eeba7ce4a216ea87397f7c588decec47485a34ff0820354083cc67"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/tlsx/main.go"
  end

  test do
    system bin/"tlsx", "-u", "expired.badssl.com:443", "-expired"
  end
end
