class XercesC < Formula
  desc "Validating XML parser"
  homepage "https://xerces.apache.org/xerces-c/"
  url "https://www.apache.org/dyn/closer.lua?path=xerces/c/3/sources/xerces-c-3.2.4.tar.gz"
  mirror "https://archive.apache.org/dist/xerces/c/3/sources/xerces-c-3.2.4.tar.gz"
  sha256 "3d8ec1c7f94e38fee0e4ca5ad1e1d9db23cbf3a10bba626f6b4afa2dedafe5ab"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e858e931c939d044e591755091c6db66feb4c526e47279d02d430a7620e2eab7"
    sha256 cellar: :any,                 arm64_monterey: "55a07ff428b5caeafc5628df1af7b39ac340d3ec1130bbaf5474363a374c01db"
    sha256 cellar: :any,                 arm64_big_sur:  "20fc19025ac2b500e659dd8ec35136e13ac789c6f26d3a720a793e0ee7f2983b"
    sha256 cellar: :any,                 ventura:        "7fd7f60de40b53884d1fedb6fba70442ffc5a15128e441926b973cf584da1506"
    sha256 cellar: :any,                 monterey:       "52590592166754dff35051432cf0d5e8f656ecc4774e21d47dcf2ad936ef3f80"
    sha256 cellar: :any,                 big_sur:        "8238563eea46d61d137b62d3f4b7ef7e8184f06b5c89b140c7c657b724ea34ec"
    sha256 cellar: :any,                 catalina:       "2829258e76d45883ab076906aa1e3649a0d7775932353ea642e6ead0cc5e5371"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76d7da011335635adf76ec6ae5f48980174673effb6d6cfcb3ebb48db4eb5720"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"

  def install
    ENV.cxx11

    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
      system "make"
      system "ctest", "-V"
      system "make", "install"
      system "make", "clean"
      system "cmake", "..", "-DBUILD_SHARED_LIBS=OFF", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
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
