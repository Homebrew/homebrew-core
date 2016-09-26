class UnittestCpp < Formula
  desc "Unit testing framework for C++"
  homepage "https://github.com/unittest-cpp/unittest-cpp"
  url "https://github.com/unittest-cpp/unittest-cpp/releases/download/v1.6.1/unittest-cpp-1.6.1.tar.gz"
  sha256 "5b00a217f90fe262d91d09405ef5a8b5d28063da2f701cc58af48d560c4792af"

  bottle do
    cellar :any
    sha256 "43d42caad773473e78847ffb97f93b2c7a4fff2b94d52a3700da1b6d89bbc5d5" => :sierra
    sha256 "24ae7b6a59f283660236285c97294b17bdb4df5065a46159ab76da7b9625efb9" => :el_capitan
    sha256 "da75452074e35af86a5ebdfc435281d8275fcee69330c961b2fc62c2fc619855" => :yosemite
    sha256 "ad9ff4bcf44a13712137daa2714e5cc215899667517edb462d4262836b12a783" => :mavericks
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
