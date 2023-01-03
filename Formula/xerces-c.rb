class XercesC < Formula
  desc "Validating XML parser"
  homepage "https://xerces.apache.org/xerces-c/"
  url "https://www.apache.org/dyn/closer.lua?path=xerces/c/3/sources/xerces-c-3.2.4.tar.gz"
  mirror "https://archive.apache.org/dist/xerces/c/3/sources/xerces-c-3.2.4.tar.gz"
  sha256 "3d8ec1c7f94e38fee0e4ca5ad1e1d9db23cbf3a10bba626f6b4afa2dedafe5ab"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6d5d2ab9215f5d716c2d714f2cfd85f57c5c263b782d92a657b61a2eceacabb9"
    sha256 cellar: :any,                 arm64_monterey: "8a412a239af33b893ea1c5bef13650f5d2cd074c1c1dca368579120efdd2f366"
    sha256 cellar: :any,                 arm64_big_sur:  "5e44f510463f401a0c50d7ce136f8073e3ff0a3cdaa59f1640d9b2c99585e0fc"
    sha256 cellar: :any,                 ventura:        "108e04af86f1049a210cd4c2255c6891578468c6d9ac53ac5b9552d1cff41598"
    sha256 cellar: :any,                 monterey:       "2222908e9bbcaddf3db710e4b5034c999bd4c42d31cb1e58cfa59e9039b2f2ee"
    sha256 cellar: :any,                 big_sur:        "924efc9ed9d26683ba2639b0714e191ab2f397bfc812be5370dcbbacf053e1df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92fb7b227025549bdb51f35d41762ee08cff52ce6b52882e4bb947feff1ef23d"
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
