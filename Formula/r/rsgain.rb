class Rsgain < Formula
  desc "ReplayGain 2.0 tagging utility"
  homepage "https://github.com/complexlogic/rsgain"
  url "https://github.com/complexlogic/rsgain/archive/refs/tags/v3.5.2.tar.gz"
  sha256 "c76ba0dfaafcaa3ceb71a3e5a1de128200d92f7895d8c2ad45360adefe5a103b"
  license "BSD-2-Clause"
  head "https://github.com/complexlogic/rsgain.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "e4c203a6c7ab07d27b3dcdf8466d296bb155be0b38c12eb429d0e1a79e0097e9"
    sha256 arm64_sonoma:  "66ee5294b464d968abc2847838f7da21175aa2fc3bd785fcf4f647457af14ebb"
    sha256 arm64_ventura: "85fc8c0aeb7b824e7c7b85b0b956a549b5d5498d247377d2d8e98f55842a41e5"
    sha256 sonoma:        "4db25f5d6f21d0ba16d4ba9efe9bac22f648959b7ee3ba8b7a515f1a392c512b"
    sha256 ventura:       "5a233790765bd76e9f5d9f2029c43045ee81a9921d3d67fa4f6c57f747943424"
    sha256 x86_64_linux:  "373aa6793709cb1d1ea760e08e56f80a8d2ced8d952d0e2aefedf53c40519c41"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
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
