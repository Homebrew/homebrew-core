class Rhash < Formula
  desc "Utility for computing and verifying hash sums of files"
  homepage "https://sourceforge.net/projects/rhash/"
  url "https://downloads.sourceforge.net/project/rhash/rhash/1.4.6/rhash-1.4.6-src.tar.gz"
  sha256 "9f6019cfeeae8ace7067ad22da4e4f857bb2cfa6c2deaa2258f55b2227ec937a"
  license "0BSD"
  head "https://github.com/rhash/RHash.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "8381d2e7c93d8e50d3c1f6e70af34ee844a3bd07c6cf7a5882ed07cf073f5600"
    sha256 arm64_sequoia: "7cfeaa013d6bc5fc89cad3d34349ebfbc38f65da844f6eda92e55f91d42144ec"
    sha256 arm64_sonoma:  "10388639684b13fe90f7ac889e1023a7823e01087d04d4725068aca25207387e"
    sha256 arm64_ventura: "757848383261b7e991ba04ecd5a3310bc263c8d259ee6ee98a8c82822b1f8ae3"
    sha256 sonoma:        "d0ebe3819cd610352c788258e8b6e9d1e04941a598cc9e4e141b24e25caf6eab"
    sha256 ventura:       "39760c4816095b7abc836fb065c2e5d7ae0e540d6dff9720e675c476a212851e"
    sha256 arm64_linux:   "de58dca8a85542060574b3263b18556bc90adcacfb41710083ebd342a33ff5ba"
    sha256 x86_64_linux:  "924accaa51ffbf427905f37750a5aae05bb8fd7b22190653560b90d8e3388108"
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
