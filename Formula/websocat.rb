class Websocat < Formula
  desc "Command-line client for WebSockets"
  homepage "https://github.com/vi/websocat"
  url "https://github.com/vi/websocat/archive/v1.11.0.tar.gz"
  sha256 "943d6f66045658cca7341dd89fe1c2f5bdac62f4a3c7be40251b810bc811794f"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "82c1a32b50dd9c07a625cadc44eade492e099a86bcd2111378c557d8d0174630"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af7d785dc7fbf24f0040ab34387f89c446f91b2f20ce5ac006874076bc9a12a6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6bcd20eb41f33a1404a9049c0c7b2a1401ff0206dae3727662f2a148318579a3"
    sha256 cellar: :any_skip_relocation, ventura:        "d0d58cc427f5588b766dd7f3589be840721bce3f843a6d8304ecdc448d60cc88"
    sha256 cellar: :any_skip_relocation, monterey:       "ac96cc2a92e1376a38d876acfb50d1d1cbc85796111a783ceef62431955f2171"
    sha256 cellar: :any_skip_relocation, big_sur:        "10ed5b08af56b99543afdcb6aa44baf4b59ae105c802985d81282b7ceb02ac58"
    sha256 cellar: :any_skip_relocation, catalina:       "81368b9bb04779db0bbc183a878e9ca716cbc6cb1d4d3b28c9670441255364af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe471d55a2ad82d0bd0fff47f3531271c01631b838344f467095e6617ade30d9"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", "--features", "ssl", *std_cargo_args
  end

  test do
    system "#{bin}/websocat", "-t", "literal:qwe", "assert:qwe"
  end
end
