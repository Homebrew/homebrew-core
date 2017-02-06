class Xu4 < Formula
  desc "Remake of Ultima IV"
  homepage "http://xu4.sourceforge.net/"
  url "http://xu4.svn.sourceforge.net/svnroot/xu4/trunk/u4", :revision => "3088"
  version "1.0beta4+r3088"
  head "http://xu4.svn.sourceforge.net/svnroot/xu4/trunk/u4"

  bottle do
    cellar :any
    sha256 "f16e6b85d800aeb69636b5c63144505572e20bd21205defb8d3d5a7288904e52" => :yosemite
    sha256 "e82e64b77ba616ba3d50367fd12d154aee709710682523039032257979384272" => :mavericks
    sha256 "e686a6ed031cd79462ced50885703b0872ce8a96bb02549598d7a1354fa5d491" => :mountain_lion
  end

  depends_on "sdl"
  depends_on "sdl_mixer"
  depends_on "libpng"

  resource "ultima4" do
    url "http://www.thatfleminggent.com/ultima/ultima4.zip", :using => :nounzip
    sha256 "94aa748cfa1d0e7aa2e518abebb994f3c18acf7edb78c3bd37cd0a4404e6ba74"
  end

  resource "u4upgrad" do
    url "https://downloads.sourceforge.net/project/xu4/Ultima%204%20VGA%20Upgrade/1.3/u4upgrad.zip", :using => :nounzip
    sha256 "400ac37311f3be74c1b2d7836561b2ead2b146f5162586865b0f4881225cca58"
  end

  def install
    (buildpath/"src").install resource("ultima4")
    (buildpath/"src").install resource("u4upgrad")

    cd "src" do
      # Include ultima4.zip in the bundle
      inreplace "Makefile.macosx", /# (cp \$\(ULTIMA4\))/, '\1'

      # Copy over SDL's ObjC main files
      cp_r Dir[Formula["sdl"].libexec/"*"], "macosx"

      system "make", "bundle", "-f", "Makefile.macosx",
                               "CC=#{ENV.cc}",
                               "CXX=#{ENV.cxx}",
                               "PREFIX=#{HOMEBREW_PREFIX}",
                               "UILIBS=-framework Cocoa -L#{Formula["sdl"].lib} -lSDL -L#{Formula["sdl_mixer"].lib} -lSDL_mixer -L#{Formula["libpng"].lib} -lpng",
                               "UIFLAGS=-I#{Formula["sdl"].include}/SDL -I#{Formula["sdl_mixer"].include}/SDL -I#{Formula["libpng"].include}"
      prefix.install "XU4.app"
      bin.write_exec_script "#{prefix}/XU4.app/Contents/MacOS/u4"
    end
  end

  test do
    system "#{bin}/u4", "-help"
  end
end
