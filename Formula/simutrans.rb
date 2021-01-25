class Simutrans < Formula
  desc "Transport simulator"
  homepage "https://www.simutrans.com/"
  url "svn://servers.simutrans.org/simutrans/trunk/", revision: "9274"
  version "122.0"
  license "Artistic-1.0"
  head "https://github.com/aburch/simutrans.git"

  livecheck do
    url "https://sourceforge.net/projects/simutrans/files/simutrans/"
    strategy :page_match
    regex(%r{href=.*?/files/simutrans/(\d+(?:[-_.]\d+)+)/}i)
  end

  bottle do
    cellar :any
    sha256 "6684c3e916b6566a770f7239b5df397a2216ed0522a0df7e96a204a6e49164a0" => :big_sur
    sha256 "ea6599b33bd87ece631672772db23a583fb7ca3bbd2a99c0364add9302196e9d" => :arm64_big_sur
    sha256 "50aa64655688d3768238ac9878307d252fbaafd5c8dd6af3bfaa5f9874b53a97" => :catalina
    sha256 "3dbf340c91f3e97998b2b0b9e2c064c21a2e9fc656d73ccb25e558175350ada6" => :mojave
    sha256 "fea3c9fde01b95445d1eb02749f8ed3621e9e5a59f70c5a2f962e9360696a797" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "libpng"
  depends_on "sdl2"

  resource "pak64" do
    url "https://downloads.sourceforge.net/project/simutrans/pak64/122-0/simupak64-122-0.zip"
    sha256 "ce2ebf0e4e0c8df5defa10be114683f65559d5a994d1ff6c96bdece7ed984b74"
  end

  resource "text" do
    url "https://simutrans-germany.com/translator/data/tab/language_pack-Base+texts.zip"
    sha256 "a2078e40a96afbdaff4e192fd8cdfcb5b9c367f1b135e926335023abd9280152"
  end

  def install
    args = %w[
      BACKEND=sdl2
      MULTI_THREAD=1
      OPTIMISE=1
      OSTYPE=mac
      USE_FREETYPE=1
      USE_UPNP=0
      USE_ZSTD=0
    ]
    args << "AV_FOUNDATION=1" if MacOS.version >= :sierra
    system "autoreconf", "-ivf"
    system "./configure", "--prefix=#{prefix}", "CC=#{ENV.cc}"
    system "make", "all", *args
    cd "themes.src" do
      ln_s "../makeobj/makeobj", "makeobj"
      system "./build_themes.sh"
    end

    libexec.install "sim" => "simutrans"
    libexec.install Dir["simutrans/*"]
    bin.write_exec_script libexec/"simutrans"
    bin.install "makeobj/makeobj"
    bin.install "nettools/nettool"

    libexec.install resource("pak64")
    (libexec/"text").install resource("text")
  end

  test do
    system "#{bin}/simutrans", "--help"
  end
end
