class Siege < Formula
  desc "HTTP regression testing and benchmarking utility"
  homepage "https://www.joedog.org/siege"
  url "https://download.joedog.org/siege/siege-4.1.7.tar.gz"
  sha256 "ec140cedd159979383d60dbe87a0151c2c12ada78791095a8fa84ae635b93026"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://download.joedog.org/siege/?C=M&O=D"
    regex(/href=.*?siege[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 arm64_tahoe:   "99fd3c249f08543fe28e2ce0feacad9d3f39dfaaab5426353db4556354b48343"
    sha256 arm64_sequoia: "b3e45c347c9a8357cdd9ec6710f68877902cbe1341c14069fedf90f8d41d2fff"
    sha256 arm64_sonoma:  "e49efe214fad929f1ecc271233082e9b01cc72ea14f0efd7b934ed2eccc08b68"
    sha256 sonoma:        "cf8869d12d391139c614e555a0cd38c0b2a55fa04f6b86a441cfbcd8a9f41fd3"
    sha256 arm64_linux:   "78357dc676f30199d8d7c12e543e9950d89db5a5cfe851d1a6f086f073c453e5"
    sha256 x86_64_linux:  "8cbf3e2d2cc75149b5940c4148d0e96e5b1a3eb5472b0aaab50c10ec34e787fb"
  end

  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # workaround for newer clang
    # notified upstream on the site on 2024-09-10
    ENV.append_to_cflags "-Wno-int-conversion" if DevelopmentTools.clang_build_version >= 1403

    # To avoid unnecessary warning due to hardcoded path, create the folder first
    (prefix/"etc").mkdir

    zlib = OS.mac? ? "#{MacOS.sdk_path}/usr" : Formula["zlib-ng-compat"].opt_prefix
    args = %W[
      --localstatedir=#{var}
      --with-ssl=#{Formula["openssl@4"].opt_prefix}
      --with-zlib=#{zlib}
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  def caveats
    <<~EOS
      macOS has only 16K ports available that won't be released until socket
      TIME_WAIT is passed. The default timeout for TIME_WAIT is 15 seconds.
      Consider reducing in case of available port bottleneck.

      You can check whether this is a problem with netstat:

          # sysctl net.inet.tcp.msl
          net.inet.tcp.msl: 15000

          # sudo sysctl -w net.inet.tcp.msl=1000
          net.inet.tcp.msl: 15000 -> 1000

      Run siege.config to create the ~/.siegerc config file.
    EOS
  end

  test do
    system bin/"siege", "--concurrent=1", "--reps=1", "https://www.google.com/"
  end
end
