class Smpeg2 < Formula
  desc "SDL MPEG Player Library"
  homepage "https://icculus.org/smpeg/"
  url "svn://svn.icculus.org/smpeg/tags/release_2_0_0/", :revision => "408"
  head "svn://svn.icculus.org/smpeg/trunk"

  bottle do
    cellar :any
    sha256 "97d4ca204752184752822f6c4bbbff2e044d110917f6a0ce30c3c472d6cb622c" => :catalina
    sha256 "4ecef89d7ee22d5d23703a5ac29fb6b4fc0cd025e249219a194ca325d79dfa85" => :mojave
    sha256 "927cb1d5dd58481afd16e893868a0794b42d56588e7fe9d51b881812e2f26eb6" => :high_sierra
    sha256 "05ea6a84c6ff07c3c88e89f0ecd153c5cd92866d3edb8cc4b4dfd06f445971b7" => :sierra
    sha256 "52aba7403eee04f66c9184a741354b747dfcd0994fa3bd7de9058b65a30fcf19" => :el_capitan
    sha256 "6031bf704fd0508bb90322dbe77f62580708e3fe77362e3dea6b0691360b686b" => :yosemite
    sha256 "fa5760a0f8ff18f596b0044a0da7562a361904f2520a7406c3681ace8a705950" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "sdl2"

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--with-sdl-prefix=#{Formula["sdl2"].opt_prefix}",
                          "--disable-dependency-tracking",
                          "--disable-debug",
                          "--disable-sdltest"
    system "make"
    system "make", "install"

    # To avoid a possible conflict with smpeg 0.x
    mv "#{bin}/plaympeg", "#{bin}/plaympeg2"
    mv "#{man1}/plaympeg.1", "#{man1}/plaympeg2.1"
  end

  test do
    system "#{bin}/plaympeg2", "--version"
  end
end
