class Uriparser < Formula
  desc "URI parsing library (strictly RFC 3986 compliant)"
  homepage "https://uriparser.github.io/"
  head "https://github.com/uriparser/uriparser.git"

  stable do
    url "https://github.com/uriparser/uriparser/releases/download/uriparser-0.9.3/uriparser-0.9.3.tar.bz2"
    sha256 "28af4adb05e811192ab5f04566bebc5ebf1c30d9ec19138f944963d52419e28f"
    patch do # uriparser/uriparser#67, required to run tests. Will be integrated in next release
      url "https://github.com/uriparser/uriparser/commit/f870e6c68696a6018702caa5c8a2feba9b0f99fa.diff?full_index=1"
      sha256 "c609224fc996b6231781e1beba4424c2237fc5e49e2de049b344d926db0630f7"
    end
  end

  bottle do
    cellar :any
    sha256 "69c5e0b1aad68761b9737618740c57339c06fa5b33ca42f8739af1e795cc6645" => :mojave
    sha256 "aecf626254251f0f3eecca369bf8cda28f530a14bdf2bb493063a8eb78b402bc" => :high_sierra
    sha256 "0657e76e94b481bc0b859ba68b8e31d460dce44e7ec3fcc573cb5bfd6bb89839" => :sierra
  end

  depends_on "cmake" => :build

  conflicts_with "libkml", :because => "both install `liburiparser.dylib`"

  resource "gtest" do
    url "https://github.com/google/googletest/archive/release-1.8.1.tar.gz"
    sha256 "9bf1fe5182a604b4135edc1a425ae356c9ad15e9b23f9f12a02e80184c3a249c"
  end

  def install
    (buildpath/"gtest").install resource("gtest")
    (buildpath/"gtest/googletest").cd do
      system "cmake", "."
      system "make"
    end
    system "cmake", ".", "-DGTEST_ROOT=#{buildpath}/gtest/googletest", "-DURIPARSER_BUILD_DOCS=OFF", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    expected = <<~EOS
      uri:          https://brew.sh
      scheme:       https
      hostText:     brew.sh
      absolutePath: false
                    (always false for URIs with host)
    EOS
    assert_equal expected, shell_output("#{bin}/uriparse https://brew.sh").chomp
  end
end
