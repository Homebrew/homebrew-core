class Supermodel < Formula
  desc "Sega Model 3 arcade emulator"
  homepage "https://www.supermodel3.com/"
  url "https://www.supermodel3.com/Files/Supermodel_0.2a_Src.zip"
  sha256 "ecaf3e7fc466593e02cbf824b722587d295a7189654acb8206ce433dcff5497b"
  license "GPL-3.0-or-later"
  revision 1
  head "https://svn.code.sf.net/p/model3emu/code/trunk"

  livecheck do
    url "https://www.supermodel3.com/Download.html"
    regex(/href=.*?Supermodel[._-]v?(\d+(?:\.\d+)+[a-z]?)[._-]Src\.zip/i)
  end

  bottle do
    sha256 arm64_ventura:  "cce8095f8cc08e5688537edbc9e77641805d6230f1cabf064437670aeec34ea9"
    sha256 arm64_monterey: "a4b9894c3b40d398cd55ec7a80dc6573fd4f69a063ad1053df35e629be9512e9"
    sha256 arm64_big_sur:  "a885561dcf107c129b845f6b6ed74af3a77c3316dae3b764c1a330e604eb94aa"
    sha256 ventura:        "4820fa35df55ad3da2514e3f2de96f28fc522335ab62446749b12b8e96e5875b"
    sha256 monterey:       "339da803650d68029618c577e5c57a374af2da9521badd82d0de76897c51eeef"
    sha256 big_sur:        "37277a5568532cf6deb7ec130c67f5f66c7f9538d96cfdf59c3117eb91a4a18d"
    sha256 catalina:       "8978ed55cf9121291601384e24462932fed8fd12a59ad815384edd200b860e75"
    sha256 x86_64_linux:   "da80611e54278fe44c3869c876fbe0d7955901e5bd0df86e99c67b358d60172d"
  end

  depends_on "sdl12-compat"

  uses_from_macos "zlib"

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def install
    makefile_dir = build.head? ? "Makefiles/Makefile.OSX" : "Makefiles/Makefile.SDL.OSX.GCC"
    if OS.mac?
      inreplace makefile_dir do |s|
        # Set up SDL library correctly
        s.gsub! "-framework SDL", "`sdl-config --libs`"
        s.gsub!(/(\$\(COMPILER_FLAGS\))/, "\\1 -I#{Formula["sdl12-compat"].opt_prefix}/include")
      end
    else
      makefile_dir = "Makefiles/Makefile.SDL.UNIX.GCC"
    end

    inreplace makefile_dir do |s|
      # Fix missing label issue for auto-generated code
      s.gsub! %r{(\$\(OBJ_DIR\)/m68k\w+)\.o: \1.c (.*)\n(\s*\$\(CC\)) \$<}, "\\1.o: \\2\n\\3 \\1.c"
      # Add -std=c++14
      s.gsub! "$(CPPFLAGS)", "$(CPPFLAGS) -std=c++14" if OS.linux?
    end

    # Use /usr/local/var/supermodel for saving runtime files
    inreplace "Src/OSD/SDL/Main.cpp" do |s|
      s.gsub! %r{(Config|Saves|NVRAM)/}, "#{var}/supermodel/\\1/"
      s.gsub!(/(\w+\.log)/, "#{var}/supermodel/Logs/\\1")
    end

    system "make", "-f", makefile_dir
    bin.install "bin/Supermodel" => "supermodel"
    (var/"supermodel/Config").install "Config/Supermodel.ini"
    (var/"supermodel/Saves").mkpath
    (var/"supermodel/NVRAM").mkpath
    (var/"supermodel/Logs").mkpath
  end

  def caveats
    <<~EOS
      Config, Saves, and NVRAM are located in the following directory:
        #{var}/supermodel/
    EOS
  end

  test do
    system "#{bin}/supermodel", "-print-games"
  end
end
