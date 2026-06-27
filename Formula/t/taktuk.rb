class Taktuk < Formula
  desc "Deploy commands to (a potentially large set of) remote nodes"
  homepage "https://taktuk.gitlabpages.inria.fr/"
  url "https://deb.debian.org/debian/pool/main/t/taktuk/taktuk_3.7.8.orig.tar.gz"
  sha256 "f674edd33d27760b1ee6d41abf4542e07061d049405f0203d151e1af74be9b5c"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/t/taktuk/"
    regex(/href=.*?taktuk[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9b7af9bb1751fc08c3a0c738daa15c25213bd52e741330334386bb13f407c7a8"
    sha256 cellar: :any,                 arm64_sequoia: "01c8d15035ec43b420659f736333289b8c1562d8ac5f9d92e2cc4f4fde62859f"
    sha256 cellar: :any,                 arm64_sonoma:  "1c0669bf7050dad9bb1f3d0e237d240f21e28453c76985fcfd8294d58e488f94"
    sha256 cellar: :any,                 sonoma:        "6a0d53be5717eb2f8df21692d10fdd0adb02a409986905a0b68848df8ea99ecd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06b5805260616eda515108c0ecce2dd476e4b01efd5cb16101f069bb8534778b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "324acdbdacf274b1b1ac362d386d010b5c4cbc84a534ee5f7a7717a8c20f5692"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  uses_from_macos "perl"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args
    system "make"
    ENV.deparallelize
    system "make", "install", "INSTALLSITEMAN3DIR=#{man3}"
  end

  test do
    system bin/"taktuk", "quit"
  end
end
