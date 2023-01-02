class Tlsx < Formula
  desc "Fast and configurable TLS grabber focused on TLS based data collection"
  homepage "https://github.com/projectdiscovery/tlsx"
  url "https://github.com/projectdiscovery/tlsx/archive/v1.0.2.tar.gz"
  sha256 "133c4c66ac39d7347cfacaeb19c2bc0ba7be8a0c83cba6621cbd079050cf5ed4"
  license "MIT"
  head "https://github.com/projectdiscovery/tlsx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a6a63c4c52caf2ff86740a00387f042e951e8e9181bd390b19f0715b9dc7115"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17af055d0dafdf6106461973459d33af5be3132bd31f5ceba3c33d0029fd2c9f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3747ad43ac4b4b84672d820bc1ace2b9538b40032888098982068f97e436ed6a"
    sha256 cellar: :any_skip_relocation, ventura:        "eae26bfe8923aad0fd9aa24466e9d3f3bb024ac62dbdae9556372253b21eaa6c"
    sha256 cellar: :any_skip_relocation, monterey:       "7a1f2ee3c28f8a9d9932e2a0c16463dfe8cfc4830fe5fd898ff11b0a33908f3e"
    sha256 cellar: :any_skip_relocation, big_sur:        "0cf7d5438e58dca3a96361a813e2e58c9a05f94e20053d844e1a6fbbc77a1186"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d827a83685ed5ab1b23001025e113c28ea80f6f3380a4634203b83821a481e53"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/tlsx/main.go"
  end

  test do
    system "tlsx", "-u", "expired.badssl.com:443", "-expired"
  end
end
