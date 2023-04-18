class Simutrans < Formula
  desc "Transport simulator"
  homepage "https://www.simutrans.com/"
  url "svn://servers.simutrans.org/simutrans/trunk/", revision: "10421"
  version "123.0.1"
  license "Artistic-1.0"
  head "https://github.com/aburch/simutrans.git", branch: "master"

  livecheck do
    url "https://sourceforge.net/projects/simutrans/files/simutrans/"
    regex(%r{href=.*?/files/simutrans/(\d+(?:[.-]\d+)+)/}i)
    strategy :page_match
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "7724a711b377c830aa0e47224a9ad947de30b6f5f5a53473815c67dcb3ec0979"
    sha256 cellar: :any,                 arm64_monterey: "07b96b69671a91db8a708c1052fbeaa6d1731ce3803026fdb6a15cefb398df82"
    sha256 cellar: :any,                 arm64_big_sur:  "576142b4340df99b5539eb8d1169be30809f34e993d9dd4e959e3bcd4d9ca730"
    sha256 cellar: :any,                 ventura:        "71d3083f4f6699aa4862d88839ef767f31c2a4575b8b8c7b8f4ec0a83695b2f2"
    sha256 cellar: :any,                 monterey:       "cf6297e4f98a2a7a65dcf8ebeb8dcfff8d7d5e8ff2520cde81e7e7bd4c2e9f85"
    sha256 cellar: :any,                 big_sur:        "57473a566814dfabb642bf5b0d27bfbe0763213438946034c8c09ab960d12f7a"
    sha256 cellar: :any,                 catalina:       "9b301316ba5bfcfbfdab0b5572dad74aca6b2e0620a7249a260a750222b997ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57be3936b3b49cd16550d50be872e1dd602af3a965dfc959419d27832299dd3b"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "libpng"
  depends_on "sdl2"

  uses_from_macos "curl"
  uses_from_macos "unzip"

  fails_with gcc: "5"

  resource "pak64" do
    url "https://downloads.sourceforge.net/project/simutrans/pak64/123-0/simupak64-123-0.zip"
    sha256 "b8a0a37c682d8f62a3b715c24c49bc738f91d6e1e4600a180bb4d2e9f85b86c1"
  end

  def install
    # These translations are dynamically generated.
    system "./get_lang_files.sh"

    system "cmake", "-B", "build", "-S", ".", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--build", "build", "--target", "makeobj"
    system "cmake", "--build", "build", "--target", "nettool"

    simutrans_path = OS.mac? ? "simutrans/simutrans.app/Contents/MacOS" : "simutrans"
    libexec.install "build/#{simutrans_path}/simutrans" => "simutrans"
    libexec.install Dir["simutrans/*"]
    bin.write_exec_script libexec/"simutrans"
    bin.install "build/makeobj/makeobj"
    bin.install "build/nettools/nettool"

    libexec.install resource("pak64")
  end

  test do
    system "#{bin}/simutrans", "--help"
  end
end
