class Rhash < Formula
  desc "Utility for computing and verifying hash sums of files"
  homepage "https://sourceforge.net/projects/rhash/"
  url "https://downloads.sourceforge.net/project/rhash/rhash/1.4.5/rhash-1.4.5-src.tar.gz"
  sha256 "6db837e7bbaa7c72c5fd43ca5af04b1d370c5ce32367b9f6a1f7b49b2338c09a"
  license "0BSD"
  head "https://github.com/rhash/RHash.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "53f99cd369b33f89ba49c4122d10f3e9e8c421a4b9c4530d06e7f96cc0f5fb46"
    sha256 arm64_sonoma:  "2eeb5d8573c34348a04915488058f887b5e3d5c5067d2c8be651ce9661b99b75"
    sha256 arm64_ventura: "6a42309ef3de45c60cc5bb2ced37507797d0bd75e0fa4fd3f0aa13477e6c16bf"
    sha256 sonoma:        "e2c0137282fb8334dd1757707e1cecb91b443ee0d63a4d465a36b70993e23d4b"
    sha256 ventura:       "16f11306b675cc5b0d0455d735d2752d904f5848d787331cd97d04ffb3afc48c"
    sha256 x86_64_linux:  "c9cc7cc1aa66f97050f79712054f5689b08e5579657b4d3249f058d09b4169b1"
  end

  def install
    # Exclude unrecognized options
    args = std_configure_args.reject { |s| s["--disable-dependency-tracking"] } + %W[
      --disable-lib-static
      --disable-gettext
      --sysconfdir=#{etc}
    ]

    system "./configure", *args
    system "make"
    # Avoid race during installation.
    ENV.deparallelize { system "make", "install" }
    system "make", "install-lib-headers", "install-pkg-config"
    lib.install_symlink (lib/shared_library("librhash", version.major.to_s).to_s) => shared_library("librhash")
  end

  test do
    (testpath/"test").write("test")
    (testpath/"test.sha1").write("a94a8fe5ccb19ba61c4c0873d391e987982fbbd3 test")
    system bin/"rhash", "-c", "test.sha1"
  end
end
