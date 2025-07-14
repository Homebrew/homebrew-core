class Sipp < Formula
  desc "Traffic generator for the SIP protocol"
  homepage "https://sipp.sourceforge.net/"
  url "https://github.com/SIPp/sipp.git",
      tag:      "v3.7.3",
      revision: "11b51748b274d24ac156ac40216600aca0f352a7"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "b67239ee8180fef3d4128c100680e6cde65be5198a34386da091ffb4bc95d1ec"
    sha256 cellar: :any,                 arm64_sonoma:   "72ed9a5bc30b1850ff9fe02173c0a5fe08627845cfd2f2844b141ded1b8d221c"
    sha256 cellar: :any,                 arm64_ventura:  "10ce3f796a877984b4b8f2e369651d22d087eafa7ba40a230bbbbfb03166250b"
    sha256 cellar: :any,                 arm64_monterey: "42c2c7aa062edb4ba49d21081f2c04e5d551c8ade5970285adabe06079cfc750"
    sha256 cellar: :any,                 sonoma:         "1ee37d5b7a3da4e71b78de85a7600272e786b867c93414f491e1164e364563e1"
    sha256 cellar: :any,                 ventura:        "8f2b4813adbacb46dab909c6fc047d158eac9769985c6926901de402d7f6ed12"
    sha256 cellar: :any,                 monterey:       "58075c4d4cb033ac64e42ff81ab27d930c8d6f2df58ce8b8aa739754480d2e63"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "9cd4c23adec1ccc19420fe994db704d7e1135759e35c72150aa2409006731098"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd398497f2002b1872b3dbe1ccb347797b37cb737a3b14e399f52b16d6a47f61"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  uses_from_macos "libpcap"
  uses_from_macos "ncurses"

  def install
    args = %w[
      -DUSE_PCAP=1
      -DUSE_SSL=1
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "SIPp v#{version}", shell_output("#{bin}/sipp -v", 99)
  end
end
