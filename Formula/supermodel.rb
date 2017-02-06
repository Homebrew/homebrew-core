class Supermodel < Formula
  desc "Sega Model 3 arcade emulator"
  homepage "http://www.supermodel3.com/"
  url "http://www.supermodel3.com/Files/Supermodel_0.2a_Src.zip"
  sha256 "ecaf3e7fc466593e02cbf824b722587d295a7189654acb8206ce433dcff5497b"
  head "https://svn.code.sf.net/p/model3emu/code/trunk"

  bottle do
    cellar :any
    sha256 "22b954de0fec618766e906c66ea6ec1db6c0e7d85a169f0aae7c7992f4d30c45" => :yosemite
    sha256 "f045680f22f303cb961766043167f14eb18d35c0e457bafa3fef0c7955676567" => :mavericks
    sha256 "ead509808d61964e21798b91c88b106035c816d59ff9b8e03685d0acaab5f52b" => :mountain_lion
  end

  depends_on "sdl"

  def install
    inreplace "Makefiles/Makefile.SDL.OSX.GCC" do |s|
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

    system "make", "-f", "Makefiles/Makefile.SDL.OSX.GCC"
    bin.install "bin/Supermodel" => "supermodel"
    (var/"supermodel/Config").install "Config/Supermodel.ini"
    (var/"supermodel/Saves").mkpath
    (var/"supermodel/NVRAM").mkpath
    (var/"supermodel/Logs").mkpath
  end

  def caveats; <<-EOS.undent
    Config, Saves, and NVRAM are located in the following directory:
      #{var}/supermodel/
    EOS
  end

  test do
    system "#{bin}/supermodel", "-print-games"
  end
end
