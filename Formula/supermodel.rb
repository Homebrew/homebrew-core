class Supermodel < Formula
  desc "Sega Model 3 arcade emulator"
  homepage "https://www.supermodel3.com/"
  url "https://www.supermodel3.com/Files/Supermodel_0.2a_Src.zip"
  sha256 "ecaf3e7fc466593e02cbf824b722587d295a7189654acb8206ce433dcff5497b"
  head "https://svn.code.sf.net/p/model3emu/code/trunk"

  bottle do
    rebuild 1
    sha256 "16ce3b8995d5c9036111032cdbbde5dfc2fefc18c6f841e722242c9b791c92ac" => :catalina
    sha256 "85678e40606c4bff6ff454ec15bafd2ab317887b2fb48865433d8cb0cdae7a3a" => :mojave
    sha256 "83c0dbca7a5c28564eba4e7a73894746004aab5025071b350c3c47271fc42625" => :high_sierra
    sha256 "1203bb3d289e36e1ca15720dbcd4e63ffcf4fa4d09588cb4fb81092cb72399ec" => :sierra
    sha256 "78cf8e9fb973e3cd136a212936bdc8003d9897a1bb8a6a1eba3cc7ff0fba3c88" => :el_capitan
  end

  depends_on "sdl"

  def install
    makefile_dir = build.head? ? "Makefiles/Makefile.OSX" : "Makefiles/Makefile.SDL.OSX.GCC"
    inreplace makefile_dir do |s|
      # Set up SDL library correctly
      s.gsub! "-framework SDL", "`sdl-config --libs`"
      s.gsub! /(\$\(COMPILER_FLAGS\))/, "\\1 -I#{Formula["sdl"].opt_prefix}/include"
      # Fix missing label issue for auto-generated code
      s.gsub! %r{(\$\(OBJ_DIR\)/m68k\w+)\.o: \1.c (.*)\n(\s*\$\(CC\)) \$<}, "\\1.o: \\2\n\\3 \\1.c"
    end

    # Use /usr/local/var/supermodel for saving runtime files
    inreplace "Src/OSD/SDL/Main.cpp" do |s|
      s.gsub! %r{(Config|Saves|NVRAM)/}, "#{var}/supermodel/\\1/"
      s.gsub! /(\w+\.log)/, "#{var}/supermodel/Logs/\\1"
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
