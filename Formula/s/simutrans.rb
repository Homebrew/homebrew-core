class Simutrans < Formula
  desc "Transport simulator"
  homepage "https://www.simutrans.com/"
  url "svn://servers.simutrans.org/simutrans/trunk/", revision: "11395"
  version "124.2.2"
  license "Artistic-1.0"
  revision 1
  head "https://github.com/simutrans/simutrans.git", branch: "master"

  livecheck do
    url "https://sourceforge.net/projects/simutrans/files/simutrans/"
    regex(%r{href=.*?/files/simutrans/(\d+(?:[.-]\d+)+)/}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match[0].tr("-", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "57b2b227bd0962278b76f4281e424be3ec7e94227963ec877b63bc438732c2b1"
    sha256 cellar: :any,                 arm64_sonoma:   "17e41bafcc374a208f3b8fee523624a11fae59833937424c73b1e95a46bd6a50"
    sha256 cellar: :any,                 arm64_ventura:  "10f6e3b0a13418087ef4279cf6e8bab8749bde9c7cb96ed3d77d6940d9628f1b"
    sha256 cellar: :any,                 arm64_monterey: "c4a92a1ec038f1e3e62b10eb65e0e924cd1a466a1f439bbdff5d188ed72e8ef0"
    sha256 cellar: :any,                 sonoma:         "7f5744c508f30e94606b7fa3b80538496a046aaee1ddfd1979a4dd96ec631233"
    sha256 cellar: :any,                 ventura:        "60fe1014db2324ad72cc22b3fac06e44e56ebaf7970b813dd8c548cd9c1b16d3"
    sha256 cellar: :any,                 monterey:       "07e5d7e2df39a706705cc6500ff0729f909e8f9a1cc0bea88e276cd868756eb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75422ede98ee42a856d407977731f4dd909a00a4d44f657e972800ec5f113111"
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
