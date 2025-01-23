class Simutrans < Formula
  desc "Transport simulator"
  homepage "https://www.simutrans.com/"
  url "svn://servers.simutrans.org/simutrans/trunk/", revision: "11590"
  version "124.3"
  license "Artistic-1.0"
  head "https://github.com/simutrans/simutrans.git", branch: "master"

  livecheck do
    url "https://sourceforge.net/projects/simutrans/files/simutrans/"
    regex(%r{href=.*?/files/simutrans/(\d+(?:[.-]\d+)+)/}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match[0].tr("-", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3f9c6d7711d4976b92e05145507040d346f2978034d7ca5a5b61e414d999b068"
    sha256 cellar: :any,                 arm64_sonoma:  "42c667839ecca0997d30c63c7b526a1a6f3f96b413ab4261a766f126f675c0b9"
    sha256 cellar: :any,                 arm64_ventura: "7c0944bf663ae1680e8e2f9d1ba6cd8f1677b146ec256bd13af78fd9b2af7d18"
    sha256 cellar: :any,                 sonoma:        "7be0458959385cadef82e78e86f99ed75da840a9d489385253fdf443c8fb9cb7"
    sha256 cellar: :any,                 ventura:       "f80126e8e2c8cc0c3b9931b38ccb685b46be7a52048c10a7667d72d17aca031f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e22771b0bbc812679922b9519de585ef6973bf4d006d46d5c3a4c73ffb846b1"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
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

  resource "pak64" do
    url "https://downloads.sourceforge.net/project/simutrans/pak64/124-3/simupak64-124-3.zip"
    sha256 "ecde0e15301320549e92a9113fcdd1ada3b7f9aa1fce3d59a5dc98d56d648756"
  end
  resource "soundfont" do
    url "https://src.fedoraproject.org/repo/pkgs/PersonalCopy-Lite-soundfont/PCLite.sf2/629732b7552c12a8fae5b046d306273a/PCLite.sf2"
    sha256 "ba3304ec0980e07f5a9de2cfad3e45763630cbc15c7e958c32ce06aa9aefd375"
  end

  def install
    # These translations are dynamically generated.
    system "./tools/get_lang_files.sh"

    system "cmake", "-B", "build", "-S", ".", "-DSIMUTRANS_USE_REVISION=#{stable.specs[:revision]}", *std_cmake_args
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
