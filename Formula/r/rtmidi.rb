class Rtmidi < Formula
  desc "API for realtime MIDI input/output"
  homepage "https://github.com/thestk/rtmidi"
  url "https://github.com/thestk/rtmidi/archive/refs/tags/6.1.0.tar.gz"
  sha256 "809ce56bfa67b80afcfa566927ce242a60b6f4c1bacc7e89486fbcf5624c5721"
  license "MIT"
  compatibility_version 1
  head "https://github.com/thestk/rtmidi.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6dea7bb61e9391f3a3ab65d0cdafcbaf7a4edf521b49bbfaea66aa385cc9c16a"
    sha256 cellar: :any, arm64_tahoe:       "dfcb4642bc30dc2c458c2f60999ec20ddd344bfc27c9601cb808ef9b02f081c4"
    sha256 cellar: :any, arm64_sequoia:     "c7cff7e6397c37c658322393b98996ae2795421f8d6cbed6b85b005977cdab75"
    sha256 cellar: :any, arm64_linux:       "fcb315cdb016204548009ee7b7c5d7bd9f62a568b0dac37075a31093fc20e8f8"
    sha256 cellar: :any, x86_64_linux:      "bcff5ce9d46166f6dc5528df1dd5344dc3255b559efe2cdb6c7ef54a4ffd8380"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "alsa-lib"
    depends_on "jack"
  end

  deny_network_access!

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
