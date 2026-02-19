class Rsgain < Formula
  desc "ReplayGain 2.0 tagging utility"
  homepage "https://github.com/complexlogic/rsgain"
  url "https://github.com/complexlogic/rsgain/archive/refs/tags/v3.6.tar.gz"
  sha256 "26f7acd1ba0851929dc756c93b3b1a6d66d7f2f36b31f744c8181f14d7b5c8a7"
  license "BSD-2-Clause"
  revision 3
  head "https://github.com/complexlogic/rsgain.git", branch: "master"

  bottle do
    sha256                               arm64_tahoe:   "ed5fac0db7cf76fcf45a96c7368f88f4a27b3e4ecbe46245b59d423fef69e9f2"
    sha256                               arm64_sequoia: "53f904faca8eed3f3cf3d18f724d949b95d9510ef4c1f3eefbc05fa5a4ff336a"
    sha256                               arm64_sonoma:  "11c395ff3d50fe450ee3ad723f2be10292b3527c6e46fb3c9a69bc8caf87448b"
    sha256                               sonoma:        "1822242ef3ea81df8679f2d74fd427a1b2bc26ffc44f77f11bab0f9aab9eb635"
    sha256                               arm64_linux:   "50093b0e7182001fba4ad902780316eaf9571320121a7d2a70af6934a5511786"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8dcff63acd3a4e02941fc4194f7008131d71e01364087e4f6f07979a8222624"
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
