class Rtmidi < Formula
  desc "API for realtime MIDI input/output"
  homepage "https://github.com/thestk/rtmidi"
  url "https://github.com/thestk/rtmidi/archive/refs/tags/6.0.0.tar.gz"
  sha256 "ef7bcda27fee6936b651c29ebe9544c74959d0b1583b716ce80a1c6fea7617f0"
  license "MIT"
  revision 1
  head "https://github.com/thestk/rtmidi.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "0312be54d2fa1f3b2276285fc2fa877913761fc2eddd4592916f91138bc30ef3"
    sha256 cellar: :any, arm64_tahoe:       "5b514e132976094c956351e5f7c3d12a40e67b007d027cc1dae32c526e4231e8"
    sha256 cellar: :any, arm64_sequoia:     "e575e9ccadbf67966dc23d94135d12403c70f18f0e4fdfc01f7901211663ad5b"
    sha256 cellar: :any, arm64_linux:       "ad3c2d9efb4fb496dd38f0cf82aa9f4167fd40c1d2e1b059edf064efacc5caec"
    sha256 cellar: :any, x86_64_linux:      "a4765854e5c0e4419ccb9c95fa8943f021a0e8a09f5cc70e5efb7600720d9207"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "alsa-lib"
    depends_on "jack"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DRTMIDI_BUILD_TESTING=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include "RtMidi.h"
      #include <iostream>
      #include <vector>
      int main() {
        std::vector<RtMidi::Api> apis;
        RtMidi::getCompiledApi(apis);
        for (auto api : apis) std::cout << RtMidi::getApiName(api) << "\\n";
      }
    CPP
    system ENV.cxx, "test.cpp", "-o", "test", "-std=c++11", "-I#{include}/rtmidi", "-L#{lib}", "-lrtmidi"
    # Creating a MIDI client needs a reachable MIDIServer, which headless macOS 27 CI lacks (kMIDINoConnection)
    assert_match OS.mac? ? "core" : "alsa", shell_output("./test")
  end
end
