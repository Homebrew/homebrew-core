class SoundTouch < Formula
  desc "Audio processing library"
  homepage "https://www.surina.net/soundtouch/"
  url "https://gitlab.com/soundtouch/soundtouch/-/archive/2.2/soundtouch-2.2.tar.gz"
  sha256 "525478c745a51dadaf7adb8e5386ec1f903d47196fab5947dc37414344684560"
  license "LGPL-2.1"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "3f1a856a43235f03b83369a1edf8e29cedc4457129c74147433deb48ad102fbf"
    sha256 cellar: :any, big_sur:       "00c6ee28e38c679ca677309863fab484f20eef02d05fda58fd594b4a13b6b65f"
    sha256 cellar: :any, catalina:      "514181f2783b615a363bb51c4dcf9edc320850d9a4d1effa17b681e2d47736af"
    sha256 cellar: :any, mojave:        "f990e0d947c1026c51a83471b4466b5e6955c8f7a599d6ecb7da5c8466dcce8f"
    sha256 cellar: :any, high_sierra:   "34e3a02dd0906028a4b7acd7b1ecd26d24df0002fe3e765fb49d24afa3f6a9fb"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "/bin/sh", "bootstrap"
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match "SoundStretch v#{version} -", shell_output("#{bin}/soundstretch 2>&1", 255)
  end
end
