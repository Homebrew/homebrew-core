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
    sha256 cellar: :any,                 arm64_tahoe:   "a8349c878a8f212a11c5a387eb9d07178e5d4ea8715b02c937d5114ba2f7a900"
    sha256 cellar: :any,                 arm64_sequoia: "7882263a911cbabe05edc77dd7184ea1b7f85c38097d7b932f1899b97bbb5966"
    sha256 cellar: :any,                 arm64_sonoma:  "58f3f1132d0dc17ddeb8528b300995b1ea2d350773d7e7b29e066f6f3a13e6be"
    sha256 cellar: :any,                 arm64_ventura: "f40a7b52c289c9f503d2dddf1661e8283715199387345ce250262fb272f7083d"
    sha256 cellar: :any,                 sonoma:        "38a48ab9d571ff46144a5c027029d075844501836ba13630ed6fa4da8b586ca2"
    sha256 cellar: :any,                 ventura:       "d10461a9ad6bf0ecdaee60455a7aeae1caf103769bc4c4cf57a994a4055d1671"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f026f6d07f49d4b7c6e2a35b2390f9c3563d7c49f485b37a1632e356606aae2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "732b3387dd1c5962f52d12044421c4139ae6d654bd003670ec541fa6e762b484"
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
