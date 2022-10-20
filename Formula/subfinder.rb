class Subfinder < Formula
  desc "Subdomain discovery tool"
  homepage "https://github.com/projectdiscovery/subfinder"
  url "https://github.com/projectdiscovery/subfinder/archive/v2.5.4.tar.gz"
  sha256 "2319fed527f0485ac08081ca0f20a1cb6284865b67a0b2f412ea8668c284e8bb"
  license "MIT"
  head "https://github.com/projectdiscovery/subfinder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e91cef227d1ef13da2b904b0d5e807dfd66ef6e1c0a41a4b5771447936c14abc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7998d6a3abfb3015b4dc97e93ace1c0608100e3b7f7d311696b0329b9cb46a20"
    sha256 cellar: :any_skip_relocation, monterey:       "5706bd4c68ae6c73a9d8a92939b3b24604866e1856c6d28d3692a901c069f239"
    sha256 cellar: :any_skip_relocation, big_sur:        "2f5054220a14d4478407e8a5ef2784470fd28dcfb3b282d6e441bad3a8db4857"
    sha256 cellar: :any_skip_relocation, catalina:       "59f706d59b9c143e71847561d703f55976eac7033e375a8295d230f3067ecb78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa84aace5c80dceabcf2e0e8dfb35a9bfaced6e0415cde724e941a21d9955071"
  end

  depends_on "go" => :build

  def install
    cd "v2" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/subfinder"
    end
  end

  test do
    assert_match "docs.brew.sh", shell_output("#{bin}/subfinder -d brew.sh")
    assert_predicate testpath/".config/subfinder/config.yaml", :exist?
  end
end
