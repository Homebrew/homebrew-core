class X3270 < Formula
  desc "IBM 3270 terminal emulator for the X Window System and Windows"
  homepage "http://x3270.bgp.nu/"
  url "http://x3270.bgp.nu/download/04.03/suite3270-4.3ga7-src.tgz"
  sha256 "c0d325f35d7287b9e4a529f5cc4b8b6dba4f003a733cf0b90cd55071a898deb6"
  license "BSD-3-Clause"

  livecheck do
    url "https://x3270.miraheze.org/wiki/Downloads"
    regex(/href=.*?suite3270[._-]v?(\d+(?:\.\d+)+(?:ga\d+)?)(?:-src)?\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "03609021de73f7d170e0ee2611603170fafd2ffa4b06930dafde571fef88e56d"
    sha256 arm64_ventura:  "a6a1ae615ed612be8e3b07f669fff54e459d0a6cea9eae29ba03e846cf0001db"
    sha256 arm64_monterey: "1e2b7ee8b4e3247ce71f3451c808e4536f5817ec0f290d75874b90567780c891"
    sha256 sonoma:         "d61e34c5e15c2f1d4729122c4acc8b848fa8f54e7bb6351cd1e8360673b36e79"
    sha256 ventura:        "6cedc3210da4c336cbf102aa1d071f2b1266e92da544a38ecfcac7c68d2e6a73"
    sha256 monterey:       "796ec0adaf48d42c66aead78d3341d88738ab8026019f29af4af5088b3f12b03"
    sha256 x86_64_linux:   "302e1e47776005f2e89a9279a1f04e7f7ffe3611a3343300b48e57f195ceda6b"
  end

  depends_on "openssl@3"
  depends_on "readline"

  uses_from_macos "tcl-tk"

  def install
    ENV.append "CPPFLAGS", "-I#{Formula["tcl-tk"].opt_include}/tcl-tk" unless OS.mac?

    args = %w[
      --enable-c3270
      --enable-pr3287
      --enable-s3270
      --enable-tcl3270
    ]
    system "./configure", *std_configure_args, *args
    system "make", "install"
    system "make", "install.man"
  end

  test do
    system bin/"c3270", "--version"
  end
end
