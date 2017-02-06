class Ufoai < Formula
  desc "UFO: Alien Invasion"
  homepage "http://ufoai.org/"
  url "git://git.code.sf.net/p/ufoai/code", :branch => "ufoai_2.5", :revision => "3e28f7cbf9f5e1cfd0fa7fdc852f833e498757c1"
  version "2.5.0+20150216"

  bottle do
    sha256 "b136b3592e549f5d8580667fda0619004141abae21efca53871d2da78f34103e" => :yosemite
    sha256 "47c913420a0f29c6766a4a8049c2ac721e510fdbdc0c7e04f47b098c315f9236" => :mavericks
    sha256 "ab723bb0f061635c079f82633b2c2dc707287bb993b200bf89312224eadb68a3" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "sdl2"
  depends_on "sdl2_ttf"
  depends_on "sdl2_mixer" => "with-libvorbis"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "xvid"
  depends_on "theora"
  depends_on "gettext"

  resource "data" do
    url "https://downloads.sourceforge.net/project/ufoai/UFO_AI%202.x/2.5/ufoai-2.5-data.tar"
    sha256 "5e706a424aff6a2ea30a4c798129d6304e897387eadf808528129b512b7dcdb0"
  end

  def install
    ENV.deparallelize
    ENV["TARGET_ARCH"] = MacOS.preferred_arch.to_s

    (buildpath/"base").install resource("data")

    inreplace "build/install_mac.mk" do |s|
      s.gsub! /.*\$\(BINARIES_BASE\).*/, ""
      s.gsub! /\s+copylibs-ufoai/, ""
      s.gsub! /.*hdiutil.*/, ""
    end
    inreplace "build/modes/release.mk", /-falign-(loops|jumps)=\d+/, "" unless ENV.compiler == :gcc

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-hardlinkedgame
      --enable-release
    ]
    system "./configure", *args
    system "make"
    system "make", "lang"
    system "make", "create-dmg-ufoai"
    prefix.install Dir["contrib/installer/mac/ufoai-**/UFOAI.app"]
    bin.write_exec_script "#{prefix}/UFOAI.app/Contents/MacOS/ufo"
  end

  def caveats; <<-EOS.undent
    Turn off GLSL shaders from video settings if you have graphics problem.
    EOS
  end

  test do
    system "#{bin}/ufo", "+set", "vid_fullscreen", "0", "+quit"
  end
end
