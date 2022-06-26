class UnittestCpp < Formula
  desc "Unit testing framework for C++"
  homepage "https://github.com/unittest-cpp/unittest-cpp"
  license "MIT"

  stable do
    url "https://github.com/unittest-cpp/unittest-cpp/releases/download/v2.0.0/unittest-cpp-2.0.0.tar.gz"
    sha256 "1d1b118518dc200e6b87bbf3ae7bfd00a0cfc6be708255f98e5e3d627a7c9f98"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f2a8bed855277f7c67eb1c174b323cbac98d332db7cd30e69f6d4982eb9c4bd1"
    sha256 cellar: :any,                 arm64_big_sur:  "462837c9588ccf8f585d9d82af071bb91a59f2bf3ef155ccc863c416491cab68"
    sha256 cellar: :any,                 monterey:       "6689794273416bc2eaaf64753f76a1c6529bb8b859d7a58291d8aae03f5a4268"
    sha256 cellar: :any,                 big_sur:        "ea9e79c44e4bc95225504ea78baf0ae87b440f3a555239725672b3b5b205ebc5"
    sha256 cellar: :any,                 catalina:       "19a4cef9ba95b37528f2a88d280b0f4c77809d7553a8e5747cfd4e41363f2fce"
    sha256 cellar: :any,                 mojave:         "9837dfbba5a3014097d3b406bd48e174a6a788d0c0b3107bd1fabeeb0ce6b89e"
    sha256 cellar: :any,                 high_sierra:    "206f44c35a82fac519b64b8c4ae6bc397e360d8404e8279a24b906d7729efed2"
    sha256 cellar: :any,                 sierra:         "91d028b464f32fcf6edda6b791be2b70d9b770934edd7af7d2b8ff24e9c5eb06"
    sha256 cellar: :any,                 el_capitan:     "6136d8cdc420681130c59d9f77327ddad6b46a35d29da5be760b522c7456e2a2"
    sha256 cellar: :any,                 yosemite:       "573f6f3a83ba0d2d0e3b54314a5eb93affd11f03bcc409d381ef8253d7e03c4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b00aa2974e4ab2714fb6d98ada6b1dc127a20641f05170196ecf58beea63d6a7"
  end

  head do
    url "https://github.com/unittest-cpp/unittest-cpp.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--prefix=#{prefix}", "--disable-silent-rules"
    system "make", "install"
  end

  test do
    assert_match version.to_s, File.read(lib/"pkgconfig/UnitTest++.pc")
  end
end
