class Sgn < Formula
  desc "Shikata ga nai (仕方がない) encoder ported into go with several improvements"
  homepage "https://github.com/EgeBalci/sgn"
  url "https://github.com/EgeBalci/sgn/archive/refs/tags/2.0.tar.gz"
  sha256 "b894e4cb396a5bb118a4081db9c54938e4ca903f67a998e7de8ec2763f2fcf53"
  license "MIT"
  head "https://github.com/EgeBalci/sgn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f5990b3ec44deda15b1feb6da75576080e00d5bfdfc9d23147c18940a09c8af"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "32c9256c57f43403fca7b8a9b7c868f62151456a93be910f5060eb74a49b2140"
    sha256 cellar: :any_skip_relocation, monterey:       "ae6a45a60edc4e1d155427dedfa9c4d9baa653ca53278ad0021540751aaac83b"
    sha256 cellar: :any_skip_relocation, big_sur:        "65251c7362ce98f1aa9484aa23f67e78d6b7fb665c0117c2358ceec2009f029a"
    sha256 cellar: :any_skip_relocation, catalina:       "35ee722f342c3522588f1c5e3c9b5661ad7c5a44166ad3ee8283d2f8103201ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "392e46d698ec3b250eee575d40f727669e1de5a5e621245c916d61c72ea918ff"
  end

  depends_on "go" => :build
  depends_on "keystone" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match "All done ＼(＾O＾)／", shell_output("#{bin}/sgn -o #{testpath}/sgn.out #{test_fixtures("mach/a.out")}")
  end
end
