class Wv2 < Formula
  desc "Programs for accessing Microsoft Word documents"
  homepage "https://wvware.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/wvware/wv2-0.4.2.tar.bz2"
  sha256 "9f2b6d3910cb0e29c9ff432f935a594ceec0101bca46ba2fc251aff251ee38dc"

  livecheck do
    url :stable
    regex(%r{url=.*?/wv2[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "e757d5cf4bd8db93cd2b4383b38c748ea78f0f301d1740aa661ec35ee9e9ea1d"
    sha256 cellar: :any, big_sur:       "097b7d4e10b4ef00d8298ef897acb9baa3c9b84aa0b7416e4e561700e8ab408b"
    sha256 cellar: :any, catalina:      "944451190aa61c6ea3dd74fffbc9e92e999b8eeb559a46f4c4708d5f9b4f154f"
    sha256 cellar: :any, mojave:        "7bda8de476777410ab350ceca0e089e20169f17a3d9cb31d313653c906766a85"
    sha256 cellar: :any, high_sierra:   "35120de253c5dcfd6da711f7529bd8e4a0ffd45eed540057ef57d1a9d2ab0091"
    sha256 cellar: :any, sierra:        "cd0856f53f0a143f5b0ea7dd61a0d23613db6de84538fa222e2819217a3ed3af"
    sha256 cellar: :any, el_capitan:    "b3a07e873f69b90ed83d47ccedb6bc5fefcb5dc5c9ffd1ecfd38c03dd094afea"
    sha256 cellar: :any, yosemite:      "51ea82d6630ceee1739d0f252462ef8c4394ffaf0fb81b0a5141990f865f1427"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libgsf"

  def install
    ENV.append "LDFLAGS", "-liconv -lgobject-2.0" # work around broken detection
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
