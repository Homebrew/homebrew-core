class Simutrans < Formula
  desc "Transport simulator"
  homepage "https://www.simutrans.com/"
  url "svn://servers.simutrans.org/simutrans/trunk/", revision: "11164"
  version "124.0"
  license "Artistic-1.0"
  head "https://github.com/aburch/simutrans.git", branch: "master"

  livecheck do
    url "https://sourceforge.net/projects/simutrans/files/simutrans/"
    regex(%r{href=.*?/files/simutrans/(\d+(?:[.-]\d+)+)/}i)
    strategy :page_match
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "39426ef14b391bcd7c63817c961da2988f541c1c3436ca5d8b94032c072cb1f0"
    sha256 cellar: :any,                 arm64_ventura:  "cfa9b9c74717245cb5f3add5a14186cdbf202cca56d2488cb5fadae60838659d"
    sha256 cellar: :any,                 arm64_monterey: "978f95bcfb824cc5c0c3bc8ec63e8ab4d4b0b8e947dacb45714984798298de21"
    sha256 cellar: :any,                 sonoma:         "3f8cc425d3434b62624a56e56038eabc71eccbc0f6fba5c1af2f478e6dc83f75"
    sha256 cellar: :any,                 ventura:        "4aed3ce8eaba72d72f2d97d8646c21c7192b3e4a1c5112693e065b11618a5c33"
    sha256 cellar: :any,                 monterey:       "dcd3ecb50bfa4cdc6830caeb9736f46545df30e569fe3209a1695f9b84948428"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "336b2d0a9743b56884d5c61c7da94daaf6b651a2dd30ba18d6330e63ab073696"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "libpng"
  depends_on "sdl2"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "unzip"

  fails_with gcc: "5"

  resource "pak64" do
    url "https://downloads.sourceforge.net/project/simutrans/pak64/124-0/simupak64-124-0.zip"
    sha256 "0defc5e7ce4c2c3620b621d94d0735dacc3ff13b1af24dee3a127ca76603b2a3"
  end

  def install
    # These translations are dynamically generated.
    system "./tools/get_lang_files.sh"

    system "cmake", "-B", "build", "-S", ".", *std_cmake_args, "-DSIMUTRANS_USE_REVISION=#{version}"
    system "cmake", "--build", "build"
    system "cmake", "--build", "build", "--target", "makeobj"
    system "cmake", "--build", "build", "--target", "nettool"

    simutrans_path = OS.mac? ? "simutrans/simutrans.app/Contents/MacOS" : "simutrans"
    libexec.install "build/#{simutrans_path}/simutrans" => "simutrans"
    libexec.install Dir["simutrans/*"]
    bin.write_exec_script libexec/"simutrans"
    bin.install "build/src/makeobj/makeobj"
    bin.install "build/src/nettool/nettool"

    libexec.install resource("pak64")
  end

  test do
    system "#{bin}/simutrans", "--help"
  end
end
