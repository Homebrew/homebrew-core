class SwitchLanPlay < Formula
  desc "Make you and your friends play games like in a LAN"
  homepage "https://github.com/spacemeowx2/switch-lan-play"
  url "https://github.com/spacemeowx2/switch-lan-play.git",
      tag:      "v0.2.3",
      revision: "c0c663e3fdc95d6d6e8ab401caa2bfb5b5872e00"
  license "GPL-3.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "520620d6ae69e98a169edda5ed47b0ebb496a843eedacda867b1eb52b14c007e" => :big_sur
    sha256 "ae86854d36264397768367d7ce69466967e303b5047828a6720c6574101a24b8" => :arm64_big_sur
    sha256 "caa1992416c8eae4c281af3166238bb2bf8104c1d91d7dc37a2abd8715712ccc" => :catalina
    sha256 "62da027220b8d01270c8459cec638744ed06eac2ec046ccff56729b7f126eacf" => :mojave
    sha256 "41a10e6d0ce45410763c4774afa4286a8c633ac60348c0d0963e33cbef855c1d" => :high_sierra
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
