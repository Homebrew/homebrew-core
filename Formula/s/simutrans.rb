class Simutrans < Formula
  desc "Transport simulator"
  homepage "https://www.simutrans.com/"
  url "svn://servers.simutrans.org/simutrans/trunk/", revision: "11266"
  version "124.1"
  license "Artistic-1.0"
  head "https://github.com/simutrans/simutrans.git", branch: "master"

  livecheck do
    url "https://sourceforge.net/projects/simutrans/files/simutrans/"
    regex(%r{href=.*?/files/simutrans/(\d+(?:[.-]\d+)+)/}i)
    strategy :page_match
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5ee09f2998ff1a13a7a1b90708a4f491ecb935973b3d3f7a10da12795e99d173"
    sha256 cellar: :any,                 arm64_ventura:  "1993d78df04a796e3f1d1dde292b810b7c8b5627c6759889b0250857b9e9e5c9"
    sha256 cellar: :any,                 arm64_monterey: "597a046050a6fa7ab3b5942ba548c3dbb7515cd54fbbb6fb1e6f44a6f2c559b5"
    sha256 cellar: :any,                 sonoma:         "9896dcefe6f6c903b7e10a91230dc5ad5925a9e7b9d3a63681b9046bbe994e29"
    sha256 cellar: :any,                 ventura:        "7465491b6ce304ef556c64e50220b00fe5409bea7b92f296477cf380716a9468"
    sha256 cellar: :any,                 monterey:       "7ef629b1436433faf5677ed535559de0d41d2a3eb6931d40869f74c344cd760f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc80d348d1d73691f2622289b83c4e51c9dcd65550f0fd069d6eecea1804887b"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "fluid-synth"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "libpng"
  depends_on "miniupnpc"
  depends_on "sdl2"
  depends_on "zstd"

  uses_from_macos "unzip" => :build
  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "zlib"

  fails_with gcc: "5"

  resource "pak64" do
    url "https://downloads.sourceforge.net/project/simutrans/pak64/124-1/simupak64-124-1.zip"
    sha256 "5a70e8ad28c3fa25474388dd2a197e76d769f3f78f8a33052b32ad83fe1a4efd"
  end
  resource "soundfont" do
    url "https://src.fedoraproject.org/repo/pkgs/PersonalCopy-Lite-soundfont/PCLite.sf2/629732b7552c12a8fae5b046d306273a/PCLite.sf2"
    sha256 "ba3304ec0980e07f5a9de2cfad3e45763630cbc15c7e958c32ce06aa9aefd375"
  end

  def install
    # These translations are dynamically generated.
    system "./tools/get_lang_files.sh"

    system "cmake", "-B", "build", "-S", ".", *std_cmake_args, "-DSIMUTRANS_USE_REVISION=#{stable.specs[:revision]}"
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
    (libexec/"music").install resource("soundfont")
  end

  test do
    system "#{bin}/simutrans", "--help"
  end
end
