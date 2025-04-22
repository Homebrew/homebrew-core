class Simutrans < Formula
  desc "Transport simulator"
  homepage "https://www.simutrans.com/"
  url "svn://servers.simutrans.org/simutrans/trunk/", revision: "11671"
  version "124.3.1"
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
    sha256 cellar: :any,                 arm64_sequoia: "3b9fd4e6ba4309127af63b8b2235cc85692074421bd8439f58504c0da54bb6fa"
    sha256 cellar: :any,                 arm64_sonoma:  "fd96b3fea3664838f1904736407321b836c391f510fa0eec90799922466d66da"
    sha256 cellar: :any,                 arm64_ventura: "3c284b3aee6632a0a09ad8589a8e25c96739f54c75b6c009ef59f6a105a8d2da"
    sha256 cellar: :any,                 sonoma:        "c685e4ac7e5896302331543c0d68d239d83f100be0d26e3ff5fffbb620d1a464"
    sha256 cellar: :any,                 ventura:       "0caad2fbd63d5f858309a3c33e422ab3b820a19de07abfad3582fddef20e2854"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe34f7c07cd37deb98e04284d86c493b6c4960ec34dccde334647113fbb2f86b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e46e0b9b4cfd60ddf8ba9f07ac9f80050712f7ecc416b607d63f8517cf248a94"
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
