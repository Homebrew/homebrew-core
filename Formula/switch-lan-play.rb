class SwitchLanPlay < Formula
  desc "Make you and your friends play games like in a LAN"
  homepage "https://github.com/spacemeowx2/switch-lan-play"
  url "https://github.com/spacemeowx2/switch-lan-play.git",
    :tag      => "v0.1.0",
    :revision => "eda2c4dcb1db7948fcc0ae5d129fc4b8f4369ca2"

  bottle do
    cellar :any_skip_relocation
    sha256 "a04c4d8d196c9777c5cf03fab67cb5dc94b5f2890396ed38559ff1147182fab6" => :catalina
    sha256 "be0f9d8661c0c8ce72abcc42dcd67a2e34bcd23fdd3cee01bf2a7f60690d2146" => :mojave
    sha256 "aed551064a4fca5c96d1059020d0cde04c49f72d5b90ee29280137e8f26f93a7" => :high_sierra
    sha256 "fa6f336a8bd322bfb4bfe9bf47f0705fdf37658719eb3c03252e5532ed71c554" => :sierra
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lan-play --version")
    assert_match "1.", shell_output("#{bin}/lan-play --list-if")
  end
end
