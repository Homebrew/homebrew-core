class Raine < Formula
  desc "680x0 arcade emulator"
  homepage "http://raine.1emulation.com/"
  url "https://github.com/zelurker/raine/archive/0.64.13.tar.gz"
  sha256 "0af13e67744ac81f987687a3f83703bc844897a6a1b828a19d82f96dfe8ab719"
  head "https://github.com/zelurker/raine.git"

  depends_on "gettext" => "universal"
  depends_on "libpng" => "universal"
  depends_on "sdl" => "universal"
  depends_on "sdl_image" => "universal"
  depends_on "sdl_sound" => ["universal", "with-flac", "with-libogg", "with-libvorbis"]
  depends_on "sdl_ttf" => "universal"
  depends_on "muparser" => "universal"
  depends_on "nasm" => :build

  depends_on "flac" => "universal" # for sdl_sound
  depends_on "freetype" => "universal" # for sdl_ttf
  depends_on "xz" => "universal" # for sdl_sound, etc.

  def install
    ENV.m32
    inreplace "makefile" do |s|
      s.gsub! /-framework (SDL|SDL_image|SDL_ttf)/, "-l\\1"
      s.gsub! %r{/usr/local/lib/libSDL_sound\.a}, "-lSDL_sound"
      s.gsub! %r{/usr/local/lib/libintl\.a}, "-lintl"
      s.gsub! %r{/usr/local/lib/libmuparser\.a}, "-lmuparser"
    end
    system "make"
    system "make", "install"
    prefix.install "Raine.app"
    bin.write_exec_script "#{prefix}/Raine.app/Contents/MacOS/raine"
  end

  test do
    assert_match /RAINE \(680x0 Arcade Emulation\) #{version} /, shell_output("#{bin}/raine -n")
  end
end
