class XercesC < Formula
  desc "Validating XML parser"
  homepage "https://xerces.apache.org/xerces-c/"
  url "https://www.apache.org/dyn/closer.lua?path=xerces/c/3/sources/xerces-c-3.2.3.tar.gz"
  mirror "https://archive.apache.org/dist/xerces/c/3/sources/xerces-c-3.2.3.tar.gz"
  sha256 "fb96fc49b1fb892d1e64e53a6ada8accf6f0e6d30ce0937956ec68d39bd72c7e"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    rebuild 1
    sha256 "9707a1e03e5d7b38851d080b2248103ce1780b0ae76d8ad1579187b2178700c0" => :big_sur
    sha256 "482e14a0ff78e66b3f701a744411b2144479f69a7d4b876def7723d4683ae81a" => :arm64_big_sur
    sha256 "3591a0891b6796e46eb12c7ba5fdac497e96e624eae13f0596a3cc58e64d3f29" => :catalina
    sha256 "3ae5c637d059994fb5549ecd066a16f690a8974dd9284161fa5aa84854b4b9c3" => :mojave
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"

  def install
    ENV.cxx11

    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{lib}"
      system "make"
      system "ctest", "-V"
      system "make", "install"
      system "make", "clean"
      system "cmake", "..", "-DBUILD_SHARED_LIBS=OFF", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{lib}"
      system "make"
      lib.install Dir["src/*.a"]
    end
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
