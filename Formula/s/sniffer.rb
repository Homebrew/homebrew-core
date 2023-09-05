class Sniffer < Formula
  desc "Modern alternative network traffic sniffer"
  homepage "https://github.com/chenjiandongx/sniffer"
  url "https://github.com/chenjiandongx/sniffer/archive/v0.6.1.tar.gz"
  sha256 "130d588c2472939fc80e3c017a1cae4d515770f1bcab263d985e3be1498d2dbc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f77165b86670a4cddd7071e9c9e5efe462cd5ac96c6c8a79596b218476144c9d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a446d1d26c6c1c3a7dead0950a3c2587aff620cb446c5db58871a1bf047b1f98"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9683d3d59a70c73893741a91b2a7c7c92cdb2ce4f877c057d74ed5a0c58e16a"
    sha256 cellar: :any_skip_relocation, ventura:        "a5fa19865d18c4d3fc1de3f1159f568101d94670b77fe4708a46355c1507d0f6"
    sha256 cellar: :any_skip_relocation, monterey:       "4fabbd3468af11d5f43ffd04c3399c4e2f386470db7aad023629b0ed64a3b979"
    sha256 cellar: :any_skip_relocation, big_sur:        "257cb8e41ce952e8bdd68dcce870d19c82ae2896b5fab09207e443efb5a5d1c6"
    sha256 cellar: :any_skip_relocation, catalina:       "bcf4380d82a2f9e9e5381983201d7fd831afce2f6315e59e064e86d4c2760153"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1550c170928d31d83c7cffa56a52518dee17d4232603cc79a269451f110b935d"
  end

  depends_on "go" => :build

  uses_from_macos "libpcap"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "lo", shell_output("#{bin}/sniffer -l")
  end
end
