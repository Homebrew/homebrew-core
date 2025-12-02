class Zyre < Formula
  desc "Local Area Clustering for Peer-to-Peer Applications"
  homepage "https://github.com/zeromq/zyre"
  license "MPL-2.0"

  stable do
    url "https://github.com/zeromq/zyre/releases/download/v2.0.1/zyre-2.0.1.tar.gz"
    sha256 "0ba43fcdf70fa1f35b068843a90fdf50b34d65a9be7f2c193924a87a4031a98c"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "b97b8410e7d03d6c84387280d17c503707788453fa8016649bcac985509472dd"
    sha256 cellar: :any,                 arm64_sequoia:  "94ea60be41bac352236e7e0fe5dedaf16d53e985cb4bf7bc003df2d25565fa85"
    sha256 cellar: :any,                 arm64_sonoma:   "11ad219ac17051fbf7f1799a4dc8c371ab861a925639953c42a6879433210a38"
    sha256 cellar: :any,                 arm64_ventura:  "1bb9b571c0bc0c5026e0fc411f34f3dd3669c9366e83c7a10ccb64ad039b013e"
    sha256 cellar: :any,                 arm64_monterey: "97e9c9802ff4f1e0b329da1cbe426647bc55af13990e27e03e80dbd13e4a4838"
    sha256 cellar: :any,                 arm64_big_sur:  "3b1d36e1f9441e338916cbc75e8701386fbeaa4c23a231061c4d6d08bc35a3f1"
    sha256 cellar: :any,                 sonoma:         "5c6bb1deeeaa92251d717d7243e579f912073e0057b1880f793b1def41cd6b7c"
    sha256 cellar: :any,                 ventura:        "a1956c77c1c59efd1848f4bb2567163f9715b3d46a0b2bb274453b1b2f9b632a"
    sha256 cellar: :any,                 monterey:       "5a85a14ca28dc1d832545421e55cc4e5fc6e1007bbd3bcb8be36266904eacb35"
    sha256 cellar: :any,                 big_sur:        "490a76ad5536efec4b40234fd693f67f7f4b0222672e0b0f39c36d2581b0f4ee"
    sha256 cellar: :any,                 catalina:       "3fca3e3402fa228c40c3e2263520be64b59c414d1454b7799bb284d711a75d62"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "12b70df001f17c23de1b0650226e22391ea328ac495ec448b7dcfb407955012b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b873e7ea6e908ca4c97adcf840eaf865e1dc827716a99b2fe8d7b7ea56fc0991"
  end

  head do
    url "https://github.com/zeromq/zyre.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "czmq"
  depends_on "zeromq"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "check-verbose"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <assert.h>
      #include <zyre.h>

      int main()
      {
        uint64_t version = zyre_version ();
        assert(version >= 2);

        zyre_test(true);
        return 0;
      }
    C

    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-lzyre", "-o", "test"
    system "./test"
  end
end
