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
    sha256 arm64_sonoma:   "bee0e0e75f65a85fb701a79908db33d94b348e9510ccf18cf852fe96453308a5"
    sha256 arm64_ventura:  "7ec1cf5daa4fa44ed05418e03450f6e9d1fa07405a9f3073adfc4140fbef365f"
    sha256 arm64_monterey: "08692ec3c42bcc930406e9567ccce7956c5c098269d99734097bce824c36b9e9"
    sha256 sonoma:         "a17cb19872f3982bf390b24daa1a7200f369339534089e7705ee9fcd5bfd64ec"
    sha256 ventura:        "461de0cc01e1cc92ab3136537830572a9397ff2846566e13a833bff43e31325d"
    sha256 monterey:       "53bf96c936a241d102cc7b6f0490215eea4b1e0277a07aab84c44964ed57f272"
    sha256 x86_64_linux:   "550d68c3aee11aa666dddaaa2bd1e448823bc514969a6f58393e232d51c9e1c3"
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
