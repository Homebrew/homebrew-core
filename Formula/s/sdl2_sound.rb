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
    sha256 cellar: :any,                 arm64_sonoma:   "c0e08d7f39c6a105807852f51e101b5753929046f715a6a6c8908f4456374662"
    sha256 cellar: :any,                 arm64_ventura:  "78efdb69dd2f29646f6e4e13ebe2b73021b16c39be323c589a9076c89431f31d"
    sha256 cellar: :any,                 arm64_monterey: "fc10f79b0f7063898408b2256c67205bf4da1b64858534b605ee4d2502812884"
    sha256 cellar: :any,                 arm64_big_sur:  "bd8b8ebfe41a9635a97c6798eda4a584dc6ca4046fe5195d47d89c2bbc267205"
    sha256 cellar: :any,                 sonoma:         "c825a14430098f03bacb6186997e4860780f299ae85fd1a58acc764b6c30cfc1"
    sha256 cellar: :any,                 ventura:        "e7e2502eeadf23ca7327e087c6b7d7afeb12f75727a2ecbc2662bcacb0b951e1"
    sha256 cellar: :any,                 monterey:       "b4b2f9f1681928e4cc8dbe0fddbc40eb311de24144155d6b043dbb1415af3bd2"
    sha256 cellar: :any,                 big_sur:        "b7d96ba9534e1e3fbff4585f8994169c148c1e19da87b0bdd879bdca2211a5aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08026f0cdd8b3e6ff8cc66cb968a8107472fc9f6ca97ce0b9ef78e910dcbb206"
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
