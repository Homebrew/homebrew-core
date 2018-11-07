class SoundTouch < Formula
  desc "Audio processing library"
  homepage "https://www.surina.net/soundtouch/"
  url "https://www.surina.net/soundtouch/soundtouch-2.0.0.tar.gz"
  sha256 "d224f7d1421b5f8e74a74c85741345bd9802618a40ae30ce5b427a5705c89d25"

  bottle do
    cellar :any
    rebuild 1
    sha256 "f082ce515895d8cb5230e4afb0778731febf47800c93e62f4cafad9b14547852" => :mojave
    sha256 "d3b8c7fc1c53208d848c810f0f15d4f2da334e602ca8e5ffd373630233546d36" => :high_sierra
    sha256 "b17dfb640d87dcc75b1c9676e4be249ae6536739aafd4d55869f941ce43f4b86" => :sierra
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
    assert_match /SoundStretch v#{version} -/, shell_output("#{bin}/soundstretch 2>&1", 255)
  end
end
