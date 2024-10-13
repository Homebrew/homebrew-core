class XercesC < Formula
  desc "Validating XML parser"
  homepage "https://xerces.apache.org/xerces-c/"
  url "https://www.apache.org/dyn/closer.lua?path=xerces/c/3/sources/xerces-c-3.2.5.tar.gz"
  mirror "https://archive.apache.org/dist/xerces/c/3/sources/xerces-c-3.2.5.tar.gz"
  sha256 "545cfcce6c4e755207bd1f27e319241e50e37c0c27250f11cda116018f1ef0f5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "72963fa9ad46485f69d071e830673cd5ac28a2a805150b900de1e0f5cace898e"
    sha256 cellar: :any,                 arm64_sonoma:   "a26275a2f9fb80b6938e522071d1bd1b5d1e46c36bbb7e6af368286a27457113"
    sha256 cellar: :any,                 arm64_ventura:  "28ade3ffe3387dfeaf0420fe0bf6f3fea7615793f5fdb6f2b3920c4d7b5e5d24"
    sha256 cellar: :any,                 arm64_monterey: "ba27a1430c24b61f10f5660149a89061ecca3225ba5c3ae8ccc0ef3c8784f5a7"
    sha256 cellar: :any,                 sonoma:         "4a67f89fccf548313808a40407b6f9c034d14436359d1f5f9d2ac3773ee1ffbb"
    sha256 cellar: :any,                 ventura:        "1027fac48bca1648f9ece084ace094955d5066fb522fe2ef5e821bb966f87a74"
    sha256 cellar: :any,                 monterey:       "06882e1833c7ee61e5ba9648b7a99447c32ba37c0883cf5f40a5f35f198efd64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ee7dc39ef34798ae011bb8955a68c324f0bc2b9d827858129ff079fae016def"
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
