class XercesC < Formula
  desc "Validating XML parser"
  homepage "https://xerces.apache.org/xerces-c/"
  url "https://www.apache.org/dyn/closer.cgi?path=xerces/c/3/sources/xerces-c-3.2.1.tar.gz"
  sha256 "6dd4602b8844a9e1ab206e0270935d0c9b5f9d88771026e7f350e429bd2d04a0"

  bottle do
    cellar :any
    sha256 "07d25ac5fbb7098f1e75d05495318fa5b24b36c5ab4ebf6b3563c662d6d7a90a" => :high_sierra
    sha256 "ef2a0aa801a451609b04f930da52b87a32fb935320c2612281aa68db800392c9" => :sierra
    sha256 "f841fc6be793694985b59073fee51e1339368083094c712022deed51c8cd5cda" => :el_capitan
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
