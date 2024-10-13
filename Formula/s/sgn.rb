class Sgn < Formula
  desc "Shikata ga nai (仕方がない) encoder ported into go with several improvements"
  homepage "https://github.com/EgeBalci/sgn"
  url "https://github.com/EgeBalci/sgn/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "a4ae48aa14dcf27ac8ed6850fb87fa97049062aa3152065c50a20effc0b98234"
  license "MIT"
  head "https://github.com/EgeBalci/sgn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "9a1126f8f93b8c871f04594d4311ebf4e1b122ece755c38414e5db57b2252c9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a1949bca90a05d5d299414a24d43cb1b86e874ef5270cac5055e1a27aa166937"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02d73bd9e582463b76013e58e14e6471077cb58a907bf9e3f4f2d5cf1732b41b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "946513aabdcb213bb452905a1db946d32982c48958cb24558b054d21604e88c3"
    sha256 cellar: :any_skip_relocation, sonoma:         "a81bd09fdfed445e9ac2af2f253f4e1c8a2741de93ae9b4336d283c0bd7ca51a"
    sha256 cellar: :any_skip_relocation, ventura:        "8545f154839509d12b1b1d2ee97c80022dee9e65b4c0b7a37acdaca4d4c92710"
    sha256 cellar: :any_skip_relocation, monterey:       "fa6dee4c2559d222be6fec668790792b5278c6929ac95241867d1daec0310334"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa3cf0a77f56361c1eefc36970949dd1fd3efb8db049af4ac4e4afbe8bd7f993"
  end

  depends_on "go" => :build
  depends_on "keystone" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    output = shell_output("#{bin}/sgn -i #{test_fixtures("mach/a.out")} -o #{testpath}/sgn.out")
    assert_match "All done ＼(＾O＾)／", output
  end
end
