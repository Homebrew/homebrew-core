class XercesC < Formula
  desc "Validating XML parser"
  homepage "https://xerces.apache.org/xerces-c/"
  url "https://www.apache.org/dyn/closer.cgi?path=xerces/c/3/sources/xerces-c-3.2.2.tar.gz"
  sha256 "dd6191f8aa256d3b4686b64b0544eea2b450d98b4254996ffdfe630e0c610413"

  bottle do
    cellar :any
    sha256 "771f01c9ce075308908902181a5e157f3b4d47d6844d619e2df81f6c936b89fe" => :mojave
    sha256 "a0e99437d0b12ce946b34a71ab008abeefa139a1abd7c7603c4fc5ad6829f414" => :high_sierra
    sha256 "3ea12573e166b772836cd4daa98810ba4ce785f8a988d0974aa44d5a08bd74fb" => :sierra
    sha256 "acbba9a978fd03c8fc23b015e6c1537ea7d411248cce14505aeb6ce30c0e1092" => :el_capitan
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
