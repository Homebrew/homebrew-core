class UnittestCpp < Formula
  desc "Unit testing framework for C++"
  homepage "https://github.com/unittest-cpp/unittest-cpp"
  license "MIT"

  stable do
    url "https://github.com/unittest-cpp/unittest-cpp/releases/download/v2.0.0/unittest-cpp-2.0.0.tar.gz"
    sha256 "1d1b118518dc200e6b87bbf3ae7bfd00a0cfc6be708255f98e5e3d627a7c9f98"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "2323ac44a3d90775803af02237bc15b7b3ea93c3fa0e7b1aadfb792e4fd29193"
    sha256 cellar: :any,                 arm64_sequoia:  "8477bf1fd9cd1f227c003d267c92492e60b169896c2e9e04b23ba7473b89201a"
    sha256 cellar: :any,                 arm64_sonoma:   "618082a8d57ee7c5a285bd1f2e8fffc2edc76ba703e0764baf13f34236d44813"
    sha256 cellar: :any,                 arm64_ventura:  "28ee0e0de478207bb7eedd6520545049ef6c56c7a552aca7c3376c57c1d7a51d"
    sha256 cellar: :any,                 arm64_monterey: "f2a8bed855277f7c67eb1c174b323cbac98d332db7cd30e69f6d4982eb9c4bd1"
    sha256 cellar: :any,                 arm64_big_sur:  "462837c9588ccf8f585d9d82af071bb91a59f2bf3ef155ccc863c416491cab68"
    sha256 cellar: :any,                 sonoma:         "28884982e1d90392cf66cc823860eda61d9bd4cb6b3946b05f7bb3f36d6115e1"
    sha256 cellar: :any,                 ventura:        "d925e9cb70b8846bdc1c8a5c7af8d0fcda5192ccb16c5b47a96bf22070f0d427"
    sha256 cellar: :any,                 monterey:       "6689794273416bc2eaaf64753f76a1c6529bb8b859d7a58291d8aae03f5a4268"
    sha256 cellar: :any,                 big_sur:        "ea9e79c44e4bc95225504ea78baf0ae87b440f3a555239725672b3b5b205ebc5"
    sha256 cellar: :any,                 catalina:       "19a4cef9ba95b37528f2a88d280b0f4c77809d7553a8e5747cfd4e41363f2fce"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "7d3f6916cc0b8b7006d3a5c5480ad23154ed7ab4ca58d187d1412b4655c12800"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b00aa2974e4ab2714fb6d98ada6b1dc127a20641f05170196ecf58beea63d6a7"
  end

  head do
    url "https://github.com/unittest-cpp/unittest-cpp.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, File.read(lib/"pkgconfig/UnitTest++.pc")
  end
end
