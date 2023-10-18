class XercesC < Formula
  desc "Validating XML parser"
  homepage "https://xerces.apache.org/xerces-c/"
  url "https://www.apache.org/dyn/closer.lua?path=xerces/c/3/sources/xerces-c-3.2.4.tar.gz"
  mirror "https://archive.apache.org/dist/xerces/c/3/sources/xerces-c-3.2.4.tar.gz"
  sha256 "3d8ec1c7f94e38fee0e4ca5ad1e1d9db23cbf3a10bba626f6b4afa2dedafe5ab"
  license "Apache-2.0"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "39dcc385d045838db203911a7d016b533505b97ef51ac706f0393b3aa6e1dcf0"
    sha256 cellar: :any,                 arm64_ventura:  "99006e9ad984212dc5016d5aa9f6ae8021d50f56fec9e13947d9779d9decc1de"
    sha256 cellar: :any,                 arm64_monterey: "55c380d3cda733199a22d294208fb6b552ae53373ebba6d1ca91737c99ea52eb"
    sha256 cellar: :any,                 arm64_big_sur:  "a932e185d8ddde919516e0c7cc24f6a98ed760369df9a1edf96db3969d929934"
    sha256 cellar: :any,                 sonoma:         "2979787f02b1796f3204357d4592657a37f15f3a6cc6743f5442d4983c889911"
    sha256 cellar: :any,                 ventura:        "529a48ca044cff1006c56e0ba471591d625c4f0efd7a117f98e0d928c3c2cbfc"
    sha256 cellar: :any,                 monterey:       "17f2a1e797058706fe947034ab4c912f196bf12195736e719c6953d3c418f0c3"
    sha256 cellar: :any,                 big_sur:        "c61f70bacc917fb00e378878265bc575d427d879148b320cabc14dc71bdca56c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7f4e544f614d90c303c47caa8630c6b8ac1a6e2f7f30cdd41137710a0a27f36"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"

  def install
    # Prevent opportunistic linkage to `icu4c`
    args = std_cmake_args + %W[
      -DCMAKE_DISABLE_FIND_PACKAGE_ICU=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build_shared", "-DBUILD_SHARED_LIBS=ON", *args
    system "cmake", "--build", "build_shared"
    system "ctest", "--test-dir", "build_shared", "--verbose"
    system "cmake", "--install", "build_shared"

    system "cmake", "-S", ".", "-B", "build_static", "-DBUILD_SHARED_LIBS=OFF", *args
    system "cmake", "--build", "build_static"
    lib.install Dir["build_static/src/*.a"]

    # Remove a sample program that conflicts with libmemcached
    # on case-insensitive file systems
    (bin/"MemParse").unlink
  end

  test do
    (testpath/"ducks.xml").write <<~EOS
      <?xml version="1.0" encoding="iso-8859-1"?>

      <ducks>
        <person id="Red.Duck" >
          <name><family>Duck</family> <given>One</given></name>
          <email>duck@foo.com</email>
        </person>
      </ducks>
    EOS

    output = shell_output("#{bin}/SAXCount #{testpath}/ducks.xml")
    assert_match "(6 elems, 1 attrs, 0 spaces, 37 chars)", output
  end
end
