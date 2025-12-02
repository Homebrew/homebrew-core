class XercesC < Formula
  desc "Validating XML parser"
  homepage "https://xerces.apache.org/xerces-c/"
  url "https://www.apache.org/dyn/closer.lua?path=xerces/c/3/sources/xerces-c-3.3.0.tar.gz"
  mirror "https://archive.apache.org/dist/xerces/c/3/sources/xerces-c-3.3.0.tar.gz"
  sha256 "9555f1d06f82987fbb4658862705515740414fd34b4db6ad2ed76a2dc08d3bde"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7ab8833ee127bece071bc754e4865e181a1d77cba6351b71f6bd9a87f3765434"
    sha256 cellar: :any,                 arm64_sequoia: "8b648a8f8375fa85bf3bbdcbe82ac8b9f362fbc53303e9832f24f8afbe683eec"
    sha256 cellar: :any,                 arm64_sonoma:  "3be22ab76376131bdc5534556eb209ad1a63a9e67d0feeb5adde1746e3af455c"
    sha256 cellar: :any,                 arm64_ventura: "925ebabdd24526e5e9e91ced09983deb480189eae3e1fce43aef08204fcc21c3"
    sha256 cellar: :any,                 sonoma:        "eed44cffc9b1ab90c33025a5c3c6b30905bf1d97c290ffa18d4bdfe1233a718e"
    sha256 cellar: :any,                 ventura:       "9ed96c4d74c313eb545ea3d04c6f1973fc81cbf5001bf8707c89a48dcbfb93d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f069b3149aedf577b3e2e766d242c7167ce472390335dd8b2a2722ec527f9d13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "992f70652b3a78f54ed931bdb482c88a2fb32422cc13aacc0e09975ca8cd6e38"
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
    (testpath/"ducks.xml").write <<~XML
      <?xml version="1.0" encoding="iso-8859-1"?>

      <ducks>
        <person id="Red.Duck" >
          <name><family>Duck</family> <given>One</given></name>
          <email>duck@foo.com</email>
        </person>
      </ducks>
    XML

    output = shell_output("#{bin}/SAXCount #{testpath}/ducks.xml")
    assert_match "(6 elems, 1 attrs, 0 spaces, 37 chars)", output
  end
end
