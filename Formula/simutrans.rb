class Simutrans < Formula
  desc "Transport simulator"
  homepage "https://www.simutrans.com/"
  url "svn://servers.simutrans.org/simutrans/trunk/", revision: "9274"
  version "122.0"
  license "Artistic-1.0"
  head "https://github.com/aburch/simutrans.git", branch: "master"

  livecheck do
    url "https://sourceforge.net/projects/simutrans/files/simutrans/"
    regex(%r{href=.*?/files/simutrans/(\d+(?:[.-]\d+)+)/}i)
    strategy :page_match
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_monterey: "f64c704195199035ba23c3513c840bba63107c8193ad40e3c36b4a840922c5be"
    sha256 cellar: :any, arm64_big_sur:  "aa133be9c3b1e7f1e9bec13b185159fe92b55825968025443628d45352e2f759"
    sha256 cellar: :any, monterey:       "e36977d3be36d642d6ecd517f71b906018e00632bef4ed08ce50297776cc364f"
    sha256 cellar: :any, big_sur:        "70babab2113e9d818ef42dd1722f941ad0d70c2b368fea4de8a7122b18ed58e2"
    sha256 cellar: :any, catalina:       "b95f8a5609030c0acc54aa67a09296a1ffdc74d13f3150d297ef98c22b6db4dd"
    sha256 cellar: :any, mojave:         "1cbc8bb6590dcac8cef8b7894fa5fd607b1592f739a4fd5bbf69fda0c3684acf"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "libpng"
  depends_on "sdl2"

  uses_from_macos "curl"
  uses_from_macos "unzip"

  resource "pak64" do
    url "https://downloads.sourceforge.net/project/simutrans/pak64/122-0/simupak64-122-0.zip"
    sha256 "ce2ebf0e4e0c8df5defa10be114683f65559d5a994d1ff6c96bdece7ed984b74"
  end

  def install
    # These translations are dynamically generated.
    system "./get_lang_files.sh"

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
  end

  test do
    system "#{bin}/simutrans", "--help"
  end
end
