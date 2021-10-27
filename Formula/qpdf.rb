class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://github.com/qpdf/qpdf"
  url "https://github.com/qpdf/qpdf/releases/download/release-qpdf-10.3.2/qpdf-10.3.2.tar.gz"
  sha256 "062808c40ef8741ec8160ae00168638a712cfa1d4bf673e8e595ab5eba1da947"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3e204ee0556e243f051a358e37cda87b6b3302a3a957f59595519429a8b37728"
    sha256 cellar: :any,                 arm64_big_sur:  "705a38342dd732f78053f1bbeee0fdcabc7907db7451a15616d12d0ea0015894"
    sha256 cellar: :any,                 monterey:       "0f3291d569fe58fa80c1a9fe803f901c85ebdadf9586e282333d18e751987760"
    sha256 cellar: :any,                 big_sur:        "d58a95848a41828fd8a8cf0f1bbc2965f7d5c4b253a359d99750e53c01777c63"
    sha256 cellar: :any,                 catalina:       "2896a1a0b6edd8b19b1f596439d60081325f63a4d6ed6cfd859f28790ca8f4d7"
    sha256 cellar: :any,                 mojave:         "d017c72291915e439affa7000b113169fd3e48bdd1b2d31760fdfe2f3d1950fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b856a4f28b9a0377c40251172c09763548faff2aacd50c5f1e03f9c680434eb"
  end

  depends_on "jpeg"

  uses_from_macos "zlib"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/qpdf", "--version"
  end
end
