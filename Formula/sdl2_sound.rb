class Sdl2Sound < Formula
  desc "Abstract soundfile decoder for SDL"
  homepage "https://icculus.org/SDL_sound/"
  # Includes fixes for CMake, just ahead of the release tag
  url "https://github.com/icculus/SDL_sound/archive/06c8946983ca9b9ed084648f417f60f21c0697f1.tar.gz"
  version "2.0.1"
  sha256 "41f4d779192dea82086c8da8b8cbd47ba99b52cd45fdf39c96b63f75f51293e1"
  license all_of: [
    "Zlib",
    any_of: ["Artistic-1.0-Perl", "LGPL-2.1-or-later"], # timidity
  ]
  head "https://github.com/icculus/SDL_sound.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "e0af8ec626664ff96880901346e333d02f299329481d02b48f7f859106bd8223"
    sha256 cellar: :any,                 arm64_monterey: "9f7361925cc4e541a3293a00110b3c83516794fe075ac98c49880d86acc5484d"
    sha256 cellar: :any,                 arm64_big_sur:  "8fa2ec4cb066676973921f8dab5ffb1e5bc2acc4e0d37faffc83978e512c2688"
    sha256 cellar: :any,                 ventura:        "929916d87f9459ea27931c3c565f8df463b395e2865730f059770cb30ce0a045"
    sha256 cellar: :any,                 monterey:       "8dff25f947a0c5ba5e6d2a78070f4aa7433385221df4c327deece950db99c2e3"
    sha256 cellar: :any,                 big_sur:        "792d335d07a8b6352f8a6b3099ca32f7a706e1a1217cbf12f5f961bb638d7338"
    sha256 cellar: :any,                 catalina:       "1bf080610b4296c73f127d02bfa3cc6f5582be84f7499e282f015bc17fc042f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f41eb7b4bc0611d0d0732d175993cf06b7147a2ec70aa788e2a98110d3c4d95"
  end

  depends_on "cmake" => :build
  depends_on "sdl2"

  def install
    args = [
      "-DCMAKE_INSTALL_RPATH=#{rpath}",
      "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-rpath,#{rpath}",
      "-DSDLSOUND_DECODER_MIDI=TRUE",
    ]
    args << "-DSDLSOUND_DECODER_COREAUDIO=TRUE" if OS.mac?
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "examples"
    prefix.install Dir["src/timidity/COPYING*"]
  end

  test do
    expected = <<~EOS
      Supported sound formats:
       * Play modules through ModPlug
         File extension "669"
         File extension "AMF"
         File extension "AMS"
         File extension "DBM"
         File extension "DMF"
         File extension "DSM"
         File extension "FAR"
         File extension "GDM"
         File extension "IT"
         File extension "MDL"
         File extension "MED"
         File extension "MOD"
         File extension "MT2"
         File extension "MTM"
         File extension "OKT"
         File extension "PTM"
         File extension "PSM"
         File extension "S3M"
         File extension "STM"
         File extension "ULT"
         File extension "UMX"
         File extension "XM"
         Written by Torbjörn Andersson <d91tan@Update.UU.SE>.
         http://modplug-xmms.sourceforge.net/

       * MPEG-1 Audio Layer I-III
         File extension "MP3"
         File extension "MP2"
         File extension "MP1"
         Written by Ryan C. Gordon <icculus@icculus.org>.
         https://icculus.org/SDL_sound/

       * Microsoft WAVE audio format
         File extension "WAV"
         Written by Ryan C. Gordon <icculus@icculus.org>.
         https://icculus.org/SDL_sound/

       * Audio Interchange File Format
         File extension "AIFF"
         File extension "AIF"
         Written by TorbjÃ¶rn Andersson <d91tan@Update.UU.SE>.
         https://icculus.org/SDL_sound/

       * Sun/NeXT audio file format
         File extension "AU"
         Written by Mattias EngdegÃ¥rd <f91-men@nada.kth.se>.
         https://icculus.org/SDL_sound/

       * Ogg Vorbis audio
         File extension "OGG"
         Written by Ryan C. Gordon <icculus@icculus.org>.
         https://icculus.org/SDL_sound/

       * Creative Labs Voice format
         File extension "VOC"
         Written by Ryan C. Gordon <icculus@icculus.org>.
         https://icculus.org/SDL_sound/

       * Raw audio
         File extension "RAW"
         Written by Ryan C. Gordon <icculus@icculus.org>.
         https://icculus.org/SDL_sound/

       * Shorten-compressed audio data
         File extension "SHN"
         Written by Ryan C. Gordon <icculus@icculus.org>.
         https://icculus.org/SDL_sound/

       * Free Lossless Audio Codec
         File extension "FLAC"
         File extension "FLA"
         Written by Ryan C. Gordon <icculus@icculus.org>.
         https://icculus.org/SDL_sound/
    EOS
    if OS.mac?
      expected += <<~EOS

        \ * Decode audio through Core Audio through
           File extension "aif"
           File extension "aiff"
           File extension "aifc"
           File extension "wav"
           File extension "wave"
           File extension "mp3"
           File extension "mp4"
           File extension "m4a"
           File extension "aac"
           File extension "caf"
           File extension "Sd2f"
           File extension "Sd2"
           File extension "au"
           File extension "next"
           File extension "mp2"
           File extension "mp1"
           File extension "ac3"
           File extension "3gpp"
           File extension "3gp2"
           File extension "amrf"
           File extension "amr"
           File extension "ima4"
           File extension "ima"
           Written by Eric Wing <ewing . public @ playcontrol.net>.
           https://playcontrol.net
      EOS
    end
    assert_equal expected.strip, shell_output("#{bin}/playsound --decoders").strip

    flags = %W[
      -I#{include}/SDL2
      -I#{Formula["sdl2"].include}/SDL2
      -L#{lib}
      -L#{Formula["sdl2"].lib}
      -lSDL2_sound
      -lSDL2
    ]
    flags << "-DHAVE_SIGNAL_H=1" if OS.linux?
    cp pkgshare/"examples/playsound.c", testpath

    system ENV.cc, "playsound.c", "-o", "playsound", *flags
    assert_match "help", shell_output("./playsound --help 2>&1", 42)
  end
end
