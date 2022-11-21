class Xorriso < Formula
  desc "ISO9660+RR manipulation tool"
  homepage "https://www.gnu.org/software/xorriso/"
  url "https://ftp.gnu.org/gnu/xorriso/xorriso-1.5.4.tar.gz"
  mirror "https://ftpmirror.gnu.org/xorriso/xorriso-1.5.4.tar.gz"
  sha256 "3ac155f0ca53e8dbeefacc7f32205a98f4f27d2d348de39ee0183ba8a4c9e392"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34c3f5f4e2083387b0b98c8b33cc360070ad04a81fcc0357ca0146b2b0557edb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "521d0487cdb0635a13a2c44014518db085743a03d9ef19b4cd09ddd7d1ac4ed1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad2d5c7472a70aedf02d2bb91f518b72ab2f3df0068eec13b2edf0ba2ab5af50"
    sha256 cellar: :any_skip_relocation, ventura:        "b4a25bea1608c3794a364dc61cd5a4adbb44293e5ff654907d69a6d0e4377efe"
    sha256 cellar: :any_skip_relocation, monterey:       "ac9ad05ef928432e181b339881782678864108f1421ef5a66d01f3cfbc70646c"
    sha256 cellar: :any_skip_relocation, big_sur:        "b54ce0eca9d92f9ffa571edf065baf3212cc1584ca20dbf1cbbf23f51f4ce5f7"
    sha256 cellar: :any_skip_relocation, catalina:       "e8282de999460c934b95defa41efd358c93da2d62ca38ce2829c8185eb49b4db"
    sha256 cellar: :any_skip_relocation, mojave:         "dc5357e7efc3bd95ef0c5e69c8320bd6bbfdf24fad9314beda71cce5445a5b7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5435d8e359d0a0de51cf398a53322d1de3d9f86d8e836564323c9719da171fea"
  end

  uses_from_macos "zlib"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"

    # `make install` has to be deparallelized due to the following error:
    #   mkdir: /usr/local/Cellar/xorriso/1.4.2/bin: File exists
    #   make[1]: *** [install-binPROGRAMS] Error 1
    # Reported 14 Jun 2016: https://lists.gnu.org/archive/html/bug-xorriso/2016-06/msg00003.html
    ENV.deparallelize { system "make", "install" }
  end

  test do
    system bin/"xorriso", "--help"
  end
end
