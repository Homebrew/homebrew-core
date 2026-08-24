class Simutrans < Formula
  desc "Transport simulator"
  homepage "https://www.simutrans.com/"
  url "svn://servers.simutrans.org/simutrans/trunk/", revision: "11993"
  version "124.5"
  license "Artistic-1.0"
  head "https://github.com/simutrans/simutrans.git", branch: "master"

  livecheck do
    url "https://sourceforge.net/projects/simutrans/files/simutrans/"
    regex(%r{href=.*?/files/simutrans/(\d+(?:[.-]\d+)+)/}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match[0].tr("-", ".") }
    end
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9416e74ce4f562883c0ff06baaded29fd451a1287d1547823581f55cc1626742"
    sha256 cellar: :any, arm64_sequoia: "a6cd38e5e313c1cce8d93316f2fdd573752df936ee0587e272d80578156e2271"
    sha256 cellar: :any, arm64_sonoma:  "d0208918d7fb9691c3d04ecd169e3ae54e017b1455c84dca9f45ea07ec919729"
    sha256 cellar: :any, sonoma:        "a023cf4bbea6b5ca1eb15ba383c35ea3ab06d610edaea99e52ad74a0199482ac"
    sha256 cellar: :any, arm64_linux:   "2c73684b77cc59a82487de4e1b03f5a7c2696f483065b395cfcc33a961411ba1"
    sha256 cellar: :any, x86_64_linux:  "407b04e50236fb72b705df2ef9583618155c0d8dc452e7825ec43d4087674d9f"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "fluid-synth"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "libpng"
  depends_on "miniupnpc"
  depends_on "sdl2-compat"
  depends_on "zstd"

  uses_from_macos "unzip" => :build
  uses_from_macos "bzip2"
  uses_from_macos "curl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  resource "pak64" do
    url "https://downloads.sourceforge.net/project/simutrans/pak64/124-4/simupak64-124-4.zip"
    sha256 "edc6f9ca8d94af7bfcc9628ce1e7ddf468b07118cde0a50a8b5d0d30c22218ee"
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
