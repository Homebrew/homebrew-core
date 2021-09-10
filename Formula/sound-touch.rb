class SoundTouch < Formula
  desc "Audio processing library"
  homepage "https://www.surina.net/soundtouch/"
  url "https://gitlab.com/soundtouch/soundtouch/-/archive/2.3.1/soundtouch-2.3.1.tar.gz"
  sha256 "4b27e2220122d03945b7cdd0041d33d863df4820d459544afb80d9fa33821740"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "f2d7d7c48c12adf23e850993255260d2aa032a154198fce899a3532a27391ba6"
    sha256 cellar: :any,                 big_sur:       "02cdba33995e5430c1ac8d8c1acb3caa7d512602b8a41c6af472dab4e231a6a1"
    sha256 cellar: :any,                 catalina:      "f5a5f6ab5b92850d863655568dd33f324fed7c368f5b7ac208e48002aed5eb94"
    sha256 cellar: :any,                 mojave:        "084549b3a3dcbda208ab26a0ed80c68d71382d17d45ea9ed76dc9f7d56bd21b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26b99ba4a7df4e3acf020206cbd5e7c2f26bf7d3203c3da4d3eb0d54b1d63e2f"
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
