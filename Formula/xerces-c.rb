class XercesC < Formula
  desc "Validating XML parser"
  homepage "https://xerces.apache.org/xerces-c/"
  url "https://www.apache.org/dyn/closer.lua?path=xerces/c/3/sources/xerces-c-3.2.2.tar.gz"
  mirror "https://archive.apache.org/dist/xerces/c/3/sources/xerces-c-3.2.2.tar.gz"
  sha256 "dd6191f8aa256d3b4686b64b0544eea2b450d98b4254996ffdfe630e0c610413"

  bottle do
    cellar :any
    rebuild 1
    sha256 "8bcc9b20b0b3df89ec53900e0b3b09ea1bbc3159b4cffc4b8ef4f62413621924" => :catalina
    sha256 "fab62b22422c24b0218cae42f7f81ad736db316d9bde4218272cdf7b174c313f" => :mojave
    sha256 "e62fba2c06fd03edf0491b54f753d10c4ca9e73e97c24389b749e655f9199b50" => :high_sierra
    sha256 "8390cdf10fcc8b65a1f295eacf8b3fec34776d18219b8a8ce565592ee3b03372" => :sierra
  end

  depends_on "cmake" => :build

  def install
    ENV.cxx11

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "ctest", "-V"
      system "make", "install"
      system "make", "clean"
      system "cmake", "..", "-DBUILD_SHARED_LIBS=OFF", *std_cmake_args
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
