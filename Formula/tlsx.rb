class Tlsx < Formula
  desc "Fast and configurable TLS grabber focused on TLS based data collection"
  homepage "https://github.com/projectdiscovery/tlsx"
  url "https://github.com/projectdiscovery/tlsx/archive/v1.0.6.tar.gz"
  sha256 "d721bec0af5a532ae25a52ca19fd26b781b6fa3b727b77ee701195e118b7c8e0"
  license "MIT"
  head "https://github.com/projectdiscovery/tlsx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07853419b867cd83c956826c208f9a286318ab844dcde6e6503e000aa0dc198e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07853419b867cd83c956826c208f9a286318ab844dcde6e6503e000aa0dc198e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "07853419b867cd83c956826c208f9a286318ab844dcde6e6503e000aa0dc198e"
    sha256 cellar: :any_skip_relocation, ventura:        "32d7e17ef079f96a498e86f9714dee6e3024d8e7485f7e3e08fab46e88cbaad0"
    sha256 cellar: :any_skip_relocation, monterey:       "775ee13a20c66d8becce55af39cadb70ccfd937935e779fc5bd72cdf517eeb26"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d07f09b5b023858c53a4106f78da627286ea6479c9eca58b04c1b960b06c03f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97de8ad9181b81007c8179adb8dd181ed9b33e907d9cb25050b4e62837c58d85"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/tlsx/main.go"
  end

  test do
    system bin/"tlsx", "-u", "expired.badssl.com:443", "-expired"
  end
end
