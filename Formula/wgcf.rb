class Wgcf < Formula
  desc "Generate WireGuard profile from Cloudflare Warp account"
  homepage "https://github.com/ViRb3/wgcf"
  url "https://github.com/ViRb3/wgcf/archive/v2.2.15.tar.gz"
  sha256 "b12971018c40d0a04492a9da9e9fea393394291044045e0117ec292364de1b57"
  license "MIT"
  head "https://github.com/ViRb3/wgcf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21806515169afe21892fb75d0d432b93d4cfe3a6daed3b09909421714f9bf471"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b28486cb0c67bcedb961ad51906329059eb15a77bc78f4533291d4b5fd892d0"
    sha256 cellar: :any_skip_relocation, monterey:       "f2c573408077ecec57f0ae3aec7774f1aee1843c9d0cbb5384a3c951e939ccf4"
    sha256 cellar: :any_skip_relocation, big_sur:        "8b10d1a574c8b78023c0b6c5ca96b270ddba0031703f4e8776ec99baa6eeb175"
    sha256 cellar: :any_skip_relocation, catalina:       "f85d8abe59bddf8fd4c1a69badae9226a28c716ebceb9a5382377f7f2a525ea8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35d904f899e327e40f8ecbb8607ca8a37ce62823ee272cd707ec397d84986b27"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "#{bin}/wgcf", "trace"
  end
end
