class Xu4 < Formula
  desc "Remake of Ultima IV"
  homepage "https://xu4.sourceforge.io/"
  url "http://svn.code.sf.net/p/xu4/code/trunk/u4", :revision => "3088"
  version "1.0beta4+r3088"
  head "http://svn.code.sf.net/p/xu4/code/trunk/u4"

  bottle do
    cellar :any
    sha256 "0454e0ccdb0c16122e0acaaf34e7ff256d6f8fa8c5f3860c97d68217ad1d1aaf" => :mojave
    sha256 "e7aac43710b9180710c9af0dcd80a955aa095d6264f92eb482cbe2322c01146d" => :high_sierra
    sha256 "9d490768b07abfa8c105c88dc0d2a6be97e175f6535afcee0a4c63e37d976f6f" => :sierra
    sha256 "47700a341c1dc6a700d5a0f2925846b2457e3f470b25c2288c8c0c132202d027" => :el_capitan
    sha256 "aab6d22274a345209ff25516b2dd11b715088ccab2d31588b8253f65e29f0e96" => :yosemite
  end

  depends_on "libpng"
  depends_on "sdl"
  depends_on "sdl_mixer"

  resource "ultima4" do
    url "https://www.thatfleminggent.com/ultima/ultima4.zip", :using => :nounzip
    sha256 "94aa748cfa1d0e7aa2e518abebb994f3c18acf7edb78c3bd37cd0a4404e6ba74"
  end

  resource "u4upgrad" do
    url "https://downloads.sourceforge.net/project/xu4/Ultima%204%20VGA%20Upgrade/1.3/u4upgrad.zip",
      :using => :nounzip
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

      system "make", "bundle",
             "-f", "Makefile.macosx",
             "CC=#{ENV.cc}",
             "CXX=#{ENV.cxx}",
             "PREFIX=#{HOMEBREW_PREFIX}",
             "UILIBS=-framework Cocoa -L#{Formula["sdl"].lib} -lSDL " \
                    "-L#{Formula["sdl_mixer"].lib} -lSDL_mixer " \
                    "-L#{Formula["libpng"].lib} -lpng",
             "UIFLAGS=-I#{Formula["sdl"].include}/SDL " \
                     "-I#{Formula["sdl_mixer"].include}/SDL " \
                     "-I#{Formula["libpng"].include}"
      prefix.install "XU4.app"
      bin.write_exec_script "#{prefix}/XU4.app/Contents/MacOS/u4"
    end
  end

  test do
    system "#{bin}/u4", "-help"
  end
end
