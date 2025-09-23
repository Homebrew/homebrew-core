class Sgn < Formula
  desc "Shikata ga nai (仕方がない) encoder ported into go with several improvements"
  homepage "https://github.com/EgeBalci/sgn"
  url "https://github.com/EgeBalci/sgn/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "a4ae48aa14dcf27ac8ed6850fb87fa97049062aa3152065c50a20effc0b98234"
  license "MIT"
  head "https://github.com/EgeBalci/sgn.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d25705bb70e377ddb7415dcbff3d61567a70f21df885d80d8ffed77253ef555d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "225b80b3fc0c69f76b2476b4ac4348d98f2fc09d6130cf9eb16bcd7057187ff5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21c4e093b393168c2c38825c5c7e5bd567fe883895bc7de5dd201a553a77ab09"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0da9903de5c67fa1ab04304476c4d87312e50ec8cecf4f63ca45adac527112e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "4cd2918b3875487f6e2d9927e2bad5d39b09c77a7406716ac98bbc8266a60a9f"
    sha256 cellar: :any_skip_relocation, ventura:       "b5b2795c30c949a7772859cb74da2d499600069bd65bdd1c8c1a9137a6e9c8ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16fb106569f1bd6fa3893f57fd84751c4f0d6df486bfefe4ede5388845b9eb06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21bd9b282190025a691793764bf3212e1f26990ece0991fbb201d2ef03043ffc"
  end

  depends_on "go" => :build
  depends_on "keystone" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/sgn -i #{test_fixtures("mach/a.out")} -o #{testpath}/sgn.out")
    assert_match "All done ＼(＾O＾)／", output
  end
end
