class Rsgain < Formula
  desc "ReplayGain 2.0 tagging utility"
  homepage "https://github.com/complexlogic/rsgain"
  url "https://github.com/complexlogic/rsgain/archive/refs/tags/v3.8.tar.gz"
  sha256 "6fb484d9af613167d54fbea60ae647ac1e7baa28b3a9ee4fdfe421601878dfea"
  license "BSD-2-Clause"
  head "https://github.com/complexlogic/rsgain.git", branch: "master"

  bottle do
    sha256               arm64_golden_gate: "f045e22f8ccd6a14e0009433317dcdd86c4e84d07ed6007c07cde5cc21716eea"
    sha256               arm64_tahoe:       "41a574f2dfab8c882de7d84a70590036aa529ca1c4c7dc48c227c715e8049589"
    sha256               arm64_sequoia:     "0470e68a04fe0bfbefdcaef840270b545f326bf4696f471dbc71cc39f3a77caa"
    sha256               arm64_sonoma:      "74f08fa56fed157e75841a1f096e762488ccb7ed265a0a9696a20e5516b37b2d"
    sha256               arm64_linux:       "16f4e3bcf9d5194304640023e6363b4071d41e409c08c4702ae07320f7730f40"
    sha256 cellar: :any, x86_64_linux:      "51a4178344c7a68a466fbba2d510822de8cff13254282d50eb3a3c5b7f83ddef"
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
