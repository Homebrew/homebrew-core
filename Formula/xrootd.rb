class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "https://xrootd.slac.stanford.edu/"
  url "https://xrootd.slac.stanford.edu/download/v4.11.1/xrootd-4.11.1.tar.gz"
  sha256 "87fa867168e5accc36a37cfe66a3b64f2cf2a91e2975b85adbf5efda6c9d7029"
  head "https://github.com/xrootd/xrootd.git"

  bottle do
    cellar :any
    sha256 "d29cb551e03ec90aa36831aa84cb2d28ad99face2d169feb7f4a3eafd9f17c7b" => :catalina
    sha256 "271295a2f20f4f1cc34644078a0f3d95b2a7353fcae19eefb8bcf78212cafff8" => :mojave
    sha256 "5c02484e8eef5000acad850087bbdd06e6ea995b2ce83e5c317e42ca64fba442" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"
  depends_on "readline"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DENABLE_PYTHON=OFF"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/xrootd", "-H"
  end
end
