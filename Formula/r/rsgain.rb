class Rsgain < Formula
  desc "ReplayGain 2.0 tagging utility"
  homepage "https://github.com/complexlogic/rsgain"
  url "https://github.com/complexlogic/rsgain/archive/refs/tags/v3.7.tar.gz"
  sha256 "ef383af1adbc01a6e858b45b67b632168ef7c1ee8c2f8267630cbd0f9bf8498e"
  license "BSD-2-Clause"
  head "https://github.com/complexlogic/rsgain.git", branch: "master"

  bottle do
    sha256                               arm64_tahoe:   "d7dd8c1b32ed33a19ad72eca9c4165d9ad178271c838410f3e04c954dbe6976c"
    sha256                               arm64_sequoia: "259714a012e38c92b4d4a03bb774b61f8abbabcc297c2438871e8a26b13627a3"
    sha256                               arm64_sonoma:  "96465f5f7919d004781f8e218ae75c8e6b0cc1415b7f035690c38ecb9ba8bd3f"
    sha256                               sonoma:        "12f667a741ea136b0317971f90de1ef5f51f7a3a9f02711441b86365d2605793"
    sha256                               arm64_linux:   "c31ef468ac95b1de16149fead85fedb0876036eaf449b746abc6b7d6cd897fe3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c79cdae683537f6cc24fb7d42d391c69356164732cf8e2004e2924114adeaa8e"
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
