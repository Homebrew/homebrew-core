class XercesC < Formula
  desc "Validating XML parser"
  homepage "https://xerces.apache.org/xerces-c/"
  url "https://www.apache.org/dyn/closer.cgi?path=xerces/c/3/sources/xerces-c-3.2.0.tar.gz"
  sha256 "d3162910ada85612f5b8cc89cdab84d0ad9a852a49577691e54bc7e9fc304e15"

  bottle do
    cellar :any
    sha256 "510f106c27ebd7d4202e87baaf2dfb3f2f3122ec5a3cf8bd28a2fc33e2f8cf04" => :high_sierra
    sha256 "466a04f315b38a3eada1e28267925b65dae10e2069e3b1d7b97b16523d28d3fa" => :sierra
    sha256 "b4847a9ba3b6b475ae6d55fc3f9f1c13d4e8a284f6c2ac0db3cce4c5be9c7bb7" => :el_capitan
    sha256 "e2af1d323b325a93ed3280cf5f7e5451c646d2e008b3474fd18e64ef6e78b7f1" => :yosemite
    sha256 "c7d461ebe0429d9a19e7e017af14a11435fc4f93ed83d2515b161e0f40c058b0" => :mavericks
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
    (testpath/"ducks.xml").write <<-EOS.undent
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
