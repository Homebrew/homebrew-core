class XercesC < Formula
  desc "Validating XML parser"
  homepage "https://xerces.apache.org/xerces-c/"
  url "https://www.apache.org/dyn/closer.cgi?path=xerces/c/3/sources/xerces-c-3.2.1.tar.gz"
  sha256 "6dd4602b8844a9e1ab206e0270935d0c9b5f9d88771026e7f350e429bd2d04a0"

  bottle do
    cellar :any
    sha256 "4573b8dc10a8a27fd7ec3f90b8461d24374b0e7b6edf0de1320b838e71b857a5" => :high_sierra
    sha256 "41b0b011bba42bcf10aff5b6eb675d6c43e273cd07ab45487b9fbc8d34358e63" => :sierra
    sha256 "c57035c626055d274e947b2bb338389d1100951e1545c4f933c74d2ac52dda32" => :el_capitan
  end

  depends_on "cmake" => :build

  needs :cxx11

  def install
    ENV.cxx11

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "ctest", "-V"
      system "make", "install"
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
