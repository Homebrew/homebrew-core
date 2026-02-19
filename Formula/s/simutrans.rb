class Simutrans < Formula
  desc "Transport simulator"
  homepage "https://www.simutrans.com/"
  url "svn://servers.simutrans.org/simutrans/trunk/", revision: "11671"
  version "124.3.1"
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

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "1fd7de0f2f6d759224c301571e17f5057755b13ad09ead31dbc2589c6ea0c4f8"
    sha256 cellar: :any,                 arm64_sequoia: "5534b80d0083a84792de4c454e8856c96101d3d932bfa04c2b413731119d9530"
    sha256 cellar: :any,                 arm64_sonoma:  "f5b0dcbb5ee3432922b76039f1f7a8ebd935abb9cab334986a50405e1b172640"
    sha256 cellar: :any,                 sonoma:        "54bcf8151b603d18cdb4b2c50d627289797bc65b21d58282e41567a601c0bce9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "365b26012ec707690ec42834ab7ac2753d8547246fde48f13bf8e66274f328ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba5871955287bcbe8520ed25d63be1c4ce7c9b797caab0c2cac970676f9b4c44"
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

  on_linux do
    depends_on "zlib-ng-compat"
  end

  resource "pak64" do
    url "https://downloads.sourceforge.net/project/simutrans/pak64/124-3/simupak64-124-3.zip"
    sha256 "ecde0e15301320549e92a9113fcdd1ada3b7f9aa1fce3d59a5dc98d56d648756"
  end
  resource "soundfont" do
    url "https://src.fedoraproject.org/repo/pkgs/PersonalCopy-Lite-soundfont/PCLite.sf2/629732b7552c12a8fae5b046d306273a/PCLite.sf2"
    sha256 "ba3304ec0980e07f5a9de2cfad3e45763630cbc15c7e958c32ce06aa9aefd375"
  end

  def install
    # fixed in 9aa819, remove in next release
    inreplace "cmake/MacBundle.cmake", "SOURCE_DIR}src", "SOURCE_DIR}/src"

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
