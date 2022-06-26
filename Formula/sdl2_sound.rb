class Sdl2Sound < Formula
  desc "Abstract soundfile decoder for SDL"
  homepage "https://icculus.org/SDL_sound/"
  # Includes fixes for CMake, just ahead of the release tag
  url "https://github.com/icculus/SDL_sound/archive/06c8946983ca9b9ed084648f417f60f21c0697f1.tar.gz"
  version "2.0.1"
  sha256 "41f4d779192dea82086c8da8b8cbd47ba99b52cd45fdf39c96b63f75f51293e1"
  license "Zlib"
  head "https://github.com/icculus/SDL_sound.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "864f5e487ac6b2e0f52f6c52ff49079f01ac90f57fb64469a09f2ba752f77653"
    sha256 cellar: :any,                 arm64_big_sur:  "fd95136bc274c7167a8c0267f38c98f498793c55c13b6506e73e45a1bc8ff173"
    sha256 cellar: :any,                 monterey:       "4cba85df40d35f257be849a1c87b85e43c737af0dc359839a7fcbcfb87183622"
    sha256 cellar: :any,                 big_sur:        "b2ceb3889c9ecb7ca5bf1fdbe008bc65c99081770d226ac6074973b87df107a5"
    sha256 cellar: :any,                 catalina:       "b1f1063b6fbf9f4d9a4acf52a95e5f5f446ec28f19d542139ae9cb4965edca13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ddb206fa532665701041f2d99486e9ebc0c7827fc6aab447e14a44e8137faa0a"
  end

  depends_on "cmake" => :build
  depends_on "libmodplug"
  depends_on "sdl2"
  depends_on "timidity"

  def install
    args = std_cmake_args
    args += [
      "-DCMAKE_INSTALL_RPATH=#{rpath}",
      "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-rpath,#{rpath}",
      "-DSDLSOUND_DECODER_MIDI=TRUE",
    ]
    args << "-DSDLSOUND_DECODER_COREAUDIO=TRUE" if OS.mac?
    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "examples"
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
