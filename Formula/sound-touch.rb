class SoundTouch < Formula
  desc "Audio processing library"
  homepage "https://www.surina.net/soundtouch/"
  url "https://gitlab.com/soundtouch/soundtouch/-/archive/2.3.0/soundtouch-2.3.0.tar.gz"
  sha256 "b0f38497c72bb545d5d5c505243c5daa3598567641d25728d015b27678a68ad8"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "581e081a3ec7a833ac65c6275fd235849b5f15f5436487ab2e0e13b5664d4cb5"
    sha256 cellar: :any,                 big_sur:       "3e93fe618dfa7ab0a5cd7d5d240f3e93e8e94f2deac41968ee07d88dabef4b78"
    sha256 cellar: :any,                 catalina:      "3b640770fce02c9c0b3ce38d622607f4c3618b65aeaa9c6da331ea92f0acfc8c"
    sha256 cellar: :any,                 mojave:        "d436643cbe36c3f51f23d68a1ed03267d89a9cee2d2e724710051fcb7d2ceec0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2dd6e80b00d188723f05aeebf23483bca8921ed8158e7c2025e59034c786233f"
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
