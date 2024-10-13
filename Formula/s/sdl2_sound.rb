class Sdl2Sound < Formula
  desc "Abstract soundfile decoder for SDL"
  homepage "https://icculus.org/SDL_sound/"
  url "https://github.com/icculus/SDL_sound/releases/download/v2.0.2/SDL2_sound-2.0.2.tar.gz"
  sha256 "465a81d6004af731768b881b2f50383150cc58a8d346653bad85e2375829cc3a"
  license all_of: [
    "Zlib",
    any_of: ["Artistic-1.0-Perl", "LGPL-2.1-or-later"], # timidity
  ]
  head "https://github.com/icculus/SDL_sound.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "e476f5df233026e8ca3d907f95d22b70131a4f104cfe5793c7db9c14d9a96a59"
    sha256 cellar: :any,                 arm64_sonoma:   "b5dbb3211b7148b6db375929569eb077f38073e870263aec7ce1a0350728cc3c"
    sha256 cellar: :any,                 arm64_ventura:  "8eea51b732b96e20c63322757b3b75d6b56e47b20a5431b9167c3a51c77108ad"
    sha256 cellar: :any,                 arm64_monterey: "716eacab5e22fae2b8fa9319408099115d9b248a0d1106ca42b2066324a6b8c3"
    sha256 cellar: :any,                 sonoma:         "7f6da7961795af5407b4647dffea3225d64b26b820a3b9f48887e0d3d99ccff0"
    sha256 cellar: :any,                 ventura:        "59c050c5363b877bc2359c9c05ff279ab369c1d05db4a6dcc191e42ef593408b"
    sha256 cellar: :any,                 monterey:       "1610ef569e7dd41e1049f0b8dc795c16532fd94bd4c2f3690b428826dd88ca66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1239f72dacd41eba7fb03d0f5eafc640ae44a1e2a937f4ebfe7aca1340ad7c0"
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
