class Siege < Formula
  desc "HTTP regression testing and benchmarking utility"
  homepage "https://www.joedog.org/siege-home/"
  url "https://download.joedog.org/siege/siege-4.1.7.tar.gz"
  sha256 "ec140cedd159979383d60dbe87a0151c2c12ada78791095a8fa84ae635b93026"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://download.joedog.org/siege/?C=M&O=D"
    regex(/href=.*?siege[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "001bc8d61b3da2e018fe736581c85cb66c27d511247f835507e8b5ce193a4c2e"
    sha256 arm64_sequoia: "08fabb8f6c318f991ed06f36d95d8f3734d4444bad46d886fb6fec1813b1e791"
    sha256 arm64_sonoma:  "2e4bd0d640a16f1b797e1d42706fa4e1eefb949f18135ce00abd1f8824b2b1a9"
    sha256 arm64_ventura: "2e23a74480a04cfcba9aa6cab0d1f50cb5d6bfd048875c08f639dfce8b0f95da"
    sha256 sonoma:        "f76ae74125c7a43c4750a53af619149d76b80ddf3db0d49bfd0fcdaa44325796"
    sha256 ventura:       "2f96c850f0183940d41a32597e3eade26482d3c1e976c3655792867da71d5aef"
    sha256 arm64_linux:   "4d52a6c4509c34b372dfa5ed3766252be8890b517ce7041134137aa86a94c4b7"
    sha256 x86_64_linux:  "eebf365d3688b6e2d26a82deac2260ea8f1f7049b4fe602ade5d3c287631a341"
  end

  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    # workaround for newer clang
    # notified upstream on the site on 2024-09-10
    ENV.append_to_cflags "-Wno-int-conversion" if DevelopmentTools.clang_build_version >= 1403

    # To avoid unnecessary warning due to hardcoded path, create the folder first
    (prefix/"etc").mkdir

    args = [
      "--disable-dependency-tracking",
      "--prefix=#{prefix}",
      "--mandir=#{man}",
      "--localstatedir=#{var}",
      "--with-ssl=#{Formula["openssl@3"].opt_prefix}",
    ]
    args << "--with-zlib=#{MacOS.sdk_path_if_needed}/usr" if OS.mac?

    system "./configure", *args
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
