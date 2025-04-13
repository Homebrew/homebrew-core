class Supermodel < Formula
  desc "Sega Model 3 arcade emulator"
  homepage "https://www.supermodel3.com/"
  license "GPL-3.0-or-later"
  revision 1

  stable do
    url "https://www.supermodel3.com/Files/Supermodel_0.2a_Src.zip"
    sha256 "ecaf3e7fc466593e02cbf824b722587d295a7189654acb8206ce433dcff5497b"

    depends_on "sdl12-compat"
  end

  livecheck do
    url "https://www.supermodel3.com/Download.html"
    regex(/href=.*?Supermodel[._-]v?(\d+(?:\.\d+)+[a-z]?)[._-]Src\.zip/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "55806d70707f24311eac885aa6ec3963cc508dbd397b159a7a80611392bb9c9f"
    sha256 arm64_sonoma:  "7c5571842431f0b73847af493d4fe4d79ae4a834954a567f7c6732e3e83c387b"
    sha256 arm64_ventura: "60d857bc4b057fdb6950645b22eb04970bca9e21e5065f44486bbf5dfd4b4754"
    sha256 sonoma:        "8a730dcfcf67bd5091d7b589f9111ae735ec35c939caf14e4e8469be35c2611a"
    sha256 ventura:       "c3d65f9c8c50660fb2f6fe7cdc3cf6e641f6acefdb396088328ec6c103258d11"
    sha256 arm64_linux:   "9a8fbf1e975303f9c7858caa8d2829cf0cce382971ffa6035576bf9fae7b8e71"
    sha256 x86_64_linux:  "9bffc6af81706a65a8355fe1618d9a4062e48ae2ae969d24888d0802434ca38d"
  end

  head do
    url "https://github.com/trzy/Supermodel.git", branch: "master"

    depends_on "sdl2"
  end

  uses_from_macos "zlib"

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def install
    os = OS.mac? ? "OSX" : "UNIX"
    makefile_dir = build.head? ? "Makefiles/Makefile.#{os}" : "Makefiles/Makefile.SDL.#{os}.GCC"

    if build.stable?
      inreplace makefile_dir do |s|
        if OS.mac?
          # Set up SDL library correctly
          s.gsub! "-framework SDL", "`sdl-config --libs`"
          s.gsub!(/(\$\(COMPILER_FLAGS\))/, "\\1 -I#{Formula["sdl12-compat"].opt_prefix}/include")
        end
        # Fix missing label issue for auto-generated code
        s.gsub! %r{(\$\(OBJ_DIR\)/m68k\w+)\.o: \1.c (.*)\n(\s*\$\(CC\)) \$<}, "\\1.o: \\2\n\\3 \\1.c"
        # Add -std=c++14
        s.gsub! "$(CPPFLAGS)", "$(CPPFLAGS) -std=c++14" if OS.linux?
        # Fix compile with newer Clang.
        if DevelopmentTools.clang_build_version >= 1403
          s.gsub!(/^COMPILER_FLAGS = /, "\\0 -Wno-implicit-function-declaration ")
        end
      end
      # Use /usr/local/var/supermodel for saving runtime files
      inreplace "Src/OSD/SDL/Main.cpp" do |s|
        s.gsub! %r{(Config|Saves|NVRAM)/}, "#{var}/supermodel/\\1/"
        s.gsub!(/(\w+\.log)/, "#{var}/supermodel/Logs/\\1")
      end
    else
      ENV.deparallelize
      # Set up SDL2 library correctly
      inreplace makefile_dir, "-framework SDL2", "`sdl2-config --libs`" if OS.mac?
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
    system bin/"supermodel", "-print-games"
  end
end
