class Tlsx < Formula
  desc "Fast and configurable TLS grabber focused on TLS based data collection"
  homepage "https://github.com/projectdiscovery/tlsx"
  url "https://github.com/projectdiscovery/tlsx/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "5fd59ee8a18b5005cfa95e053087c828793c7eae487e010ba92716400d2e7f9c"
  license "MIT"
  head "https://github.com/projectdiscovery/tlsx.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b58dc68de8ca20152767038221d74080eaa87f2924877cb8badac8cd381068eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9793af55339fab7c9ffda1157f5aa781f82ede983c5a10d79caf6d4443c3662"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "143b1799ee5ddf88419481fbe0e1b54bad80128caf21f3ac5989965ea7b0ba48"
    sha256 cellar: :any_skip_relocation, ventura:        "06be67477fe40704140770c75b8111ddb6a509f149989e3a7f67761305c5b352"
    sha256 cellar: :any_skip_relocation, monterey:       "2ee0a896c741660d126d0914312c2360bd33db31be3713c0a52579b519431989"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa4c17e03a8533fca4db014c9fc7bc11789e42be9b7662ac99e08b8076c4bb88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15b19b387ccdc0a75cc1c00b65034e312222bfd2df7e83fac78dfd2add86655d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/tlsx"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tlsx -version 2>&1")
    system bin/"tlsx", "-u", "expired.badssl.com:443", "-expired"
  end
end
