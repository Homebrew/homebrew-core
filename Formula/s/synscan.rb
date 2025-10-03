class Synscan < Formula
  desc "Asynchronous half-open TCP portscanner"
  homepage "https://digit-labs.org/files/tools/synscan/"
  url "https://digit-labs.org/files/tools/synscan/releases/synscan-5.02.tar.gz"
  sha256 "c4e6bbcc6a7a9f1ea66f6d3540e605a79e38080530886a50186eaa848c26591e"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?synscan[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "377c4e84126ddf0320b437927b8c7274bf0429aa68862b4b46187b1572a11d6a"
    sha256 cellar: :any,                 arm64_sequoia:  "5c810311391581f8e9c6c8638d6e11c467198c36c9ebe08ee2f7a25da0d19636"
    sha256 cellar: :any,                 arm64_sonoma:   "42ea1012c638a378b12bd8966916393692e227186e424c06385cc32ed0f27680"
    sha256 cellar: :any,                 arm64_ventura:  "452098c37c8f4161baa099c7bdf5681453505c53a6b0cb08d2d84f4691fda6a4"
    sha256 cellar: :any,                 arm64_monterey: "a396a4340087cff3494d296c0134cb4089b02b181e6757e01c2428685d12a516"
    sha256 cellar: :any,                 arm64_big_sur:  "86677760d68a0a9efc11560003b4291ff8510b55a03f76a06916c989ec1aa428"
    sha256 cellar: :any,                 sonoma:         "afd77d2ccf5cd89e3143cfe7046ff6d17d1ec67629513a773a6f8969723ecad5"
    sha256 cellar: :any,                 ventura:        "d97475a0355c1b1a01c782fccbcd46c27ec12b622e8866d0137f02e5ed4a9166"
    sha256 cellar: :any,                 monterey:       "69aeb3d3c862761b228189eeed429dc25a5786f24cebe108cdc1dead01e0aeaf"
    sha256 cellar: :any,                 big_sur:        "df49f836a6552dfba8d127e53d4a87cf50030c63ab906dd1f5c40f549d32bf86"
    sha256 cellar: :any,                 catalina:       "0e99e8f964f270377bd7dc6c0ecfae64682f3b2831776d7723f200c159623ac6"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "a54e6111c8971ea407b04134141a081f98f69666757a961f211b6ebcedfce707"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f3f43c87b2ace513582f4ac1b91374ca102a2ab8d0cbcad314d71cafb3f0c62"
  end

  depends_on "libpcap"

  def install
    # Ideally we pass the prefix into --with-libpcap, but that option only checks "flat"
    # i.e. it only works if the headers and libraries are in the same directory.
    ENV.append_to_cflags "-I#{Formula["libpcap"].opt_include}"
    ENV.append "LIBS", "-L#{Formula["libpcap"].opt_lib} -lpcap"
    system "./configure", "--prefix=#{prefix}",
                          "--with-libpcap=yes"

    target = OS.mac? ? "macos" : OS.kernel_name.downcase
    system "make", target
    system "make", "install"
  end

  test do
    system bin/"synscan", "-V"
  end
end
