class Sdl2Sound < Formula
  desc "Abstract soundfile decoder for SDL"
  homepage "https://icculus.org/SDL_sound/"
  url "https://github.com/icculus/SDL_sound/releases/download/v2.0.4/SDL2_sound-2.0.4.tar.gz"
  sha256 "f73f6720dba2e677c0bf70d0c76ca3c96d865d04025e49a8b161711685961931"
  license all_of: [
    "Zlib",
    any_of: ["Artistic-1.0-Perl", "LGPL-2.1-or-later"], # timidity
  ]
  head "https://github.com/icculus/SDL_sound.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e926f2202a49bfb323a9e603e308e44f5eae6d76a5f60dd867e00b03cd0cf6dd"
    sha256 cellar: :any,                 arm64_sequoia: "ebf816ab8b81d1c57a8fa8464015be9e6e7c1bb59e6756cb1ab955193468933d"
    sha256 cellar: :any,                 arm64_sonoma:  "1a336df9cbf4dbecdf17c4bd11f1d4fa86a8f8d7b4e31f90e2cd61f80d12b211"
    sha256 cellar: :any,                 arm64_ventura: "92094e5c2c9ec2fd6962e76d3c61be76c1f87789052a30dfed282ebf268163d5"
    sha256 cellar: :any,                 sonoma:        "91a1de8932cf5e4dc446e771044d807f000101c18dcbd5f421d5ac0b3d78160d"
    sha256 cellar: :any,                 ventura:       "fa892b1c33146ebd0a36d74065f18100a787cd4d59d76db28e907ccf8b53a543"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05781d5093994a57c5634764fda5a783aabb96b4a81bf39c4e1ce91d455eb450"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2e558d66a31ac41604bab87abc6c42b41c8a7624bcc4c64ecb75c614b4916d3"
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
