class Simutrans < Formula
  desc "Transport simulator"
  homepage "https://www.simutrans.com/"
  url "svn://servers.simutrans.org/simutrans/trunk/", revision: "11590"
  version "124.3"
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
    sha256 cellar: :any,                 arm64_sequoia: "f195ba8e5f9415de40880f9f4f9bf1f09c549942918dfe7f3ae2ff2b77912d8b"
    sha256 cellar: :any,                 arm64_sonoma:  "7d5e16db8a9de64d87019d0baeb7527a6fc5f9b63fa492b45c80593c9d9952d3"
    sha256 cellar: :any,                 arm64_ventura: "30baf17577b6913f0550224427ca8ad05719c8d65280796702081de8b9676b75"
    sha256 cellar: :any,                 sonoma:        "3ba71d009c07ffe94aa6558b6a6b6a30e5935da52a41461e96aaaf3bdca48ee8"
    sha256 cellar: :any,                 ventura:       "f0c4952bda42254d80f6ebdca79f1bec31bd47f1e29d19719ad0c40e250ef41b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4080eb0e51cc520fd599a9b5846bb88f8957c377b3f6e312289628af2ed57e1b"
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
