class Sdl2Sound < Formula
  desc "Abstract soundfile decoder for SDL"
  homepage "https://icculus.org/SDL_sound/"
  url "https://github.com/icculus/SDL_sound/releases/download/v2.0.6/SDL2_sound-2.0.6.tar.gz"
  sha256 "63be57cc80bcd29aeed6c29700759871c44c90251a7508b8d0eacd8d9cece30c"
  license all_of: [
    "Zlib",
    any_of: ["Artistic-1.0-Perl", "LGPL-2.1-or-later"], # timidity
  ]

  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "043e49d5dd24b993e88ba11b15d339f43ce0a86109912eb1476a9464605a0848"
    sha256 cellar: :any, arm64_sequoia: "b322993196e931dd4fcce8e36f12c957246b039fef91322fffeadbd9654a7c62"
    sha256 cellar: :any, arm64_sonoma:  "97d62e44d53adfb1c1abc7e25bdfbe57ac0becb6a9971991b446fe6d59d94cfb"
    sha256 cellar: :any, sonoma:        "37d9acd0a11a6d9a13826a2557633b634dbd8398496c6a693ad13bc518dfcd88"
    sha256 cellar: :any, arm64_linux:   "6eafbbb7cebbb0f50739623661c4df2260d991c94307371cca150fa89bc86ebd"
    sha256 cellar: :any, x86_64_linux:  "a6b722aa0138e078f6c44781a4d963b6bcf731cced90108ea414a92bf7d488b4"
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
         https://modplug-xmms.sourceforge.net/

       * Microsoft WAVE audio format
         File extension "WAV"
         Written by Ryan C. Gordon <icculus@icculus.org>.
         https://icculus.org/SDL_sound/

       * Audio Interchange File Format
         File extension "AIFF"
         File extension "AIF"
         Written by Torbjörn Andersson <d91tan@Update.UU.SE>.
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

       * MPEG-1 Audio Layer I-III
         File extension "MP3"
         File extension "MP2"
         File extension "MP1"
         Written by Ryan C. Gordon <icculus@icculus.org>.
         https://icculus.org/SDL_sound/
    EOS
    if OS.mac?
      expected += <<~EOS

        \s* Decode audio through Core Audio through
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
