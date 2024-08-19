class Simutrans < Formula
  desc "Transport simulator"
  homepage "https://www.simutrans.com/"
  url "svn://servers.simutrans.org/simutrans/trunk/", revision: "11365"
  version "124.2.1"
  license "Artistic-1.0"
  head "https://github.com/simutrans/simutrans.git", branch: "master"

  livecheck do
    url "https://sourceforge.net/projects/simutrans/files/simutrans/"
    regex(%r{href=.*?/files/simutrans/(\d+(?:[.-]\d+)+)/}i)
    strategy :page_match
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2fc8ad6a2d69483848675ded8a58190d58dc40085e7c104f9d6c00f6ebf0861a"
    sha256 cellar: :any,                 arm64_ventura:  "e3947b011f4740d842ff911114ef847c10902a5cbb973a0222af9e7e93f863ff"
    sha256 cellar: :any,                 arm64_monterey: "90936a62a2a94ede7fa7751c03cba2114220cf4d34e8c91fcea9fe02d93abff7"
    sha256 cellar: :any,                 sonoma:         "913ca3fdecc46ad53fa30d895c6afed2afce525dfe3bbd45fe979fd957b7e99b"
    sha256 cellar: :any,                 ventura:        "ca3d98629dd6ee12fc7cb76529dde2a3ce9656646eba19a8d4738c004a2109a7"
    sha256 cellar: :any,                 monterey:       "b3518394f760e65d9559ce73c30c68491c815d50809ada101a40b915ba152b10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3bbb9c626150451aa7efcfa646c8e677ed2dc8f9f553a18217c3b3d7c5d58abd"
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
    url "https://downloads.sourceforge.net/project/simutrans/pak64/124-2/simupak64-124-2.zip"
    sha256 "e690e4647a1a617032a3778a2457c8812cc4510afad0f5bf8524999468146d86"
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
    system bin/"simutrans", "--help"
  end
end
