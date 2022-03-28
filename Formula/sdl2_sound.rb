class Sdl2Sound < Formula
  desc "Abstract soundfile decoder for SDL"
  homepage "https://icculus.org/SDL_sound/"
  # Includes fixes for CMake, just ahead of the release tag
  url "https://github.com/icculus/SDL_sound/archive/06c8946983ca9b9ed084648f417f60f21c0697f1.tar.gz"
  version "2.0.1"
  sha256 "41f4d779192dea82086c8da8b8cbd47ba99b52cd45fdf39c96b63f75f51293e1"
  license "Zlib"
  head "https://github.com/icculus/SDL_sound.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "libmodplug"
  depends_on "sdl2"
  depends_on "timidity"

  def install
    args = std_cmake_args
    args += [
      "-DCMAKE_INSTALL_RPATH=#{rpath}",
      "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-rpath,#{rpath}",
      "-DSDLSOUND_DECODER_WAV=TRUE",
      "-DSDLSOUND_DECODER_AIFF=TRUE",
      "-DSDLSOUND_DECODER_AU=TRUE",
      "-DSDLSOUND_DECODER_VOC=TRUE",
      "-DSDLSOUND_DECODER_FLAC=TRUE",
      "-DSDLSOUND_DECODER_VORBIS=TRUE",
      "-DSDLSOUND_DECODER_RAW=TRUE",
      "-DSDLSOUND_DECODER_SHN=TRUE",
      "-DSDLSOUND_DECODER_MODPLUG=TRUE",
      "-DSDLSOUND_DECODER_MP3=TRUE",
      "-DSDLSOUND_DECODER_MIDI=TRUE",
    ]
    args << "-DSDLSOUND_DECODER_COREAUDIO=TRUE" if OS.mac?
    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
  end
end
