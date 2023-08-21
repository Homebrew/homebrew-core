class Rtaudio < Formula
  desc "API for realtime audio input/output"
  homepage "https://www.music.mcgill.ca/~gary/rtaudio/"
  url "https://www.music.mcgill.ca/~gary/rtaudio/release/rtaudio-6.0.1.tar.gz"
  sha256 "2161c8ba9e96ea64cc855724358bc5d90d9bbe13446e6e6b83ccdcbbb86789c0"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?rtaudio[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "95578725a7446c01127c43ca94846a13d5a23e868a34529d9cea1d51ce5d800b"
    sha256 cellar: :any,                 arm64_monterey: "a7feb64e0ef53ca67e2e8aa3b80af6636d808eb9aed47f639d7886af45114ea3"
    sha256 cellar: :any,                 arm64_big_sur:  "1a6e291e96dd7ce8b4efa2cf431a494d3f34a4d63a36fc7583621001acbb3a86"
    sha256 cellar: :any,                 ventura:        "179a0ce6061e5c93f63e814ca3e3bdb14dfcdd4a18f3e46ab9849d5a3d5a9141"
    sha256 cellar: :any,                 monterey:       "272e49ca4060c6770f4c4e994b397c8f4b96c6dc4c820ef9d91197fb91e5b14e"
    sha256 cellar: :any,                 big_sur:        "1eaa2f6e8f6774b5df0bd01f94574e5ffbf6a02f16d912c63b28c78cc567e7b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66f643b1a1dfc3b6b7c2caf5e29be98a0242a0fb9880f40d0c795ad074c68148"
  end

  head do
    url "https://github.com/thestk/rtaudio.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    ENV.cxx11
    system "./autogen.sh", "--no-configure" if build.head?
    system "./configure", *std_configure_args
    system "make", "install"
    doc.install %w[doc/release.txt doc/html doc/images] if build.stable?
    (pkgshare/"tests").install "tests/testall.cpp"
  end

  test do
    system ENV.cxx, pkgshare/"tests/testall.cpp", "-o", "test", "-std=c++11",
           "-I#{include}/rtaudio", "-L#{lib}", "-lrtaudio"
    system "./test"
  end
end
