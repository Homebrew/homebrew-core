class Zlib < Formula
  desc "General-purpose lossless data-compression library"
  homepage "https://zlib.net/"
  url "https://zlib.net/zlib-1.3.tar.gz"
  mirror "https://downloads.sourceforge.net/project/libpng/zlib/1.3/zlib-1.3.tar.gz"
  mirror "http://fresh-center.net/linux/misc/zlib-1.3.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/zlib-1.3.tar.gz"
  sha256 "ff0ba4c292013dbc27530b3a81e1f9a813cd39de01ca5e0f8bf355702efa593e"
  license "Zlib"
  head "https://github.com/madler/zlib.git", branch: "develop"

  livecheck do
    url :homepage
    regex(/href=.*?zlib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1914dfb0224186123c1393562b4b02a87158f204733364830ebcb6a5a371017d"
    sha256 cellar: :any,                 arm64_ventura:  "1a62f85701ec1e370610f0b05bac3793ff643167798c9230c2f4da0ad16748d6"
    sha256 cellar: :any,                 arm64_monterey: "553a8a0911ecaef651508369151c62eb784b32b93b0ede90a168ad6b7499c69f"
    sha256 cellar: :any,                 arm64_big_sur:  "dc0d3b902f78f0af490b3eea17cbff5904b8b7e4313fa7b6455a2c8a8d84f5e0"
    sha256 cellar: :any,                 sonoma:         "e66dd421a51a0a548d3434ddce13ebae0f667ba8244ee8139db4695db95c655e"
    sha256 cellar: :any,                 ventura:        "983d1ad2ba678e1089302581e9fc10e1476558bd3c4eb13fa8cbea1d779829ad"
    sha256 cellar: :any,                 monterey:       "c719eb9fe669b6c50882270c92439b78e8015b778ed5f5f2fc14daeafec163ed"
    sha256 cellar: :any,                 big_sur:        "0e52add34c684273341a075fd241b28df1098511f1086612261eb8c2078d802c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a47a3b5c8ee68010ab374a3d395e7a39a2d08f4f0096386c884c04a6d2e9df1d"
  end

  keg_only :provided_by_macos

  # https://zlib.net/zlib_how.html
  resource "test_artifact" do
    url "https://zlib.net/zpipe.c"
    version "20051211"
    sha256 "68140a82582ede938159630bca0fb13a93b4bf1cb2e85b08943c26242cf8f3a6"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"

    # Avoid rebuilds of dependents that hardcode this path.
    inreplace lib/"pkgconfig/zlib.pc", prefix, opt_prefix
  end

  test do
    testpath.install resource("test_artifact")
    system ENV.cc, "zpipe.c", "-I#{include}", "-L#{lib}", "-lz", "-o", "zpipe"

    text = "Hello, Homebrew!"
    compressed = pipe_output("./zpipe", text)
    assert_equal text, pipe_output("./zpipe -d", compressed)
  end
end
