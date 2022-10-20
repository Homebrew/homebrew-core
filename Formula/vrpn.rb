class Vrpn < Formula
  desc "Virtual reality peripheral network"
  homepage "https://github.com/vrpn/vrpn/wiki"
  url "https://github.com/vrpn/vrpn/releases/download/version_07.35/vrpn_07.35.zip"
  sha256 "06b74a40b0fb215d4238148517705d0075235823c0941154d14dd660ba25af19"
  head "https://github.com/vrpn/vrpn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e16ae039e897123feecad339bba4ebdb34773a30924ac0046e5785c86c37e243"
    sha256 cellar: :any,                 arm64_big_sur:  "7937578e438051b79f3270c6fbcd9025d1f4cf42785aa04d72d2c4d245733fa3"
    sha256 cellar: :any,                 monterey:       "2b172896f3d3c3103643f4d7ded96c1302730677741ee3db5b2cd1d94a65d4b0"
    sha256 cellar: :any,                 big_sur:        "994b39680e7cb653839053a76ad471e29b1fefbce14a9bbf5434d9de8625732d"
    sha256 cellar: :any,                 catalina:       "c3fb15bbfbde5f246e3776cde0489227836a695bef07a7a25cc928f2e28a935b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9f1717e1d29898fb06c95d84c99c1beee02403f6e64f9617569e08e358abbbb"
  end

  depends_on "cmake" => :build
  depends_on "libusb" # for HID support

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                            "-DCMAKE_OSX_SYSROOT=#{MacOS.sdk_path}",
                            "-DVRPN_BUILD_CLIENTS:BOOL=OFF",
                            "-DVRPN_BUILD_JAVA:BOOL=OFF"
      system "make", "install"
    end
  end
end
