class SoundTouch < Formula
  desc "Audio processing library"
  homepage "https://www.surina.net/soundtouch/"
  url "https://codeberg.org/soundtouch/soundtouch/archive/2.3.1.tar.gz"
  sha256 "42633774f372d8cb0a33333a0ea3b30f357c548626526ac9f6ce018c94042692"
  license "LGPL-2.1-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "0d340cfb0bf1d17b2eea238b756e58cd0559a4e394394b0f5e2031114e75506e"
    sha256 cellar: :any,                 arm64_big_sur:  "1ccbe6750451a745654c3b00c8f14e1706381074254136278bb4cc1f7b88e009"
    sha256 cellar: :any,                 monterey:       "ecf1be5a1ff7d41f7346f32c238ae3f30f965e58252e994082c4f2c7dd7d2784"
    sha256 cellar: :any,                 big_sur:        "cbc1dd06e73d9712e1b1fa21c4767967f122a40e2cd92097c912084f002cc4d5"
    sha256 cellar: :any,                 catalina:       "650c953db2306d78bd309a24206c014037584c08a490e05a89ac5294cef36df4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af9833833154ab73181849ccdb563b1f4146848f69fd3cc4b386c9e46a31d8b8"
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
