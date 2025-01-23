class Rsgain < Formula
  desc "ReplayGain 2.0 tagging utility"
  homepage "https://github.com/complexlogic/rsgain"
  url "https://github.com/complexlogic/rsgain/archive/refs/tags/v3.5.3.tar.gz"
  sha256 "4288ecec00b0d907af86779b38874a2c4dcd67005f1b7fe09f6767ac5dc8e7a6"
  license "BSD-2-Clause"
  head "https://github.com/complexlogic/rsgain.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "48be2533df68f7c851ac7905559c1f09527ce68e5f65a552067ac89a0b9e05d4"
    sha256 arm64_sonoma:  "c5d3fe5be1435575ae0553603dd39ac09f7afed3652423a46a0868c6e0b400d2"
    sha256 arm64_ventura: "f008912d20a4b46fd6a7d6c2ce3929dcaa2b7714028155dc406c29ff419349dd"
    sha256 sonoma:        "35c150b328dc2e788571be13e7d34db540d5232a0b61d982e0bb9035e48edf69"
    sha256 ventura:       "7f2f5e87c52c300e4cf71c7c344a5e64f45371565e2962a7686df0e957d69892"
    sha256 x86_64_linux:  "721602dddd2dd81d03b44be4655afb5def42600323571e0ab316a8b207fbc141"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "fmt"
  depends_on "inih"
  depends_on "libebur128"
  depends_on "taglib"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rsgain -v")

    assert_match "No files were scanned",
      shell_output("#{bin}/rsgain easy -S #{testpath}")
  end
end
