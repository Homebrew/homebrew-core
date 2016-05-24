class Yaws < Formula
  desc "Webserver for dynamic content (written in Erlang)"
  homepage "http://yaws.hyber.org"
  url "https://github.com/klacke/yaws/archive/yaws-2.0.2.tar.gz"
  sha256 "d2f5faf57b5087f3f0d8fc085a2342793db0f63007ddeb69e5c11935ef773729"
  head "https://github.com/klacke/yaws.git"

  bottle do
    sha256 "84a4cd500eac5ea8e79426dc286e805e8fd111e4ce10b946e55de3b08b663f3d" => :el_capitan
    sha256 "00521fe8163065f6486332d103f2fab37236e359ade42eec6ca7996d68a2d82d" => :yosemite
    sha256 "9014e19666883f9aa5e2cd103b3de9fbea2328055b0396917e9e23eace056d64" => :mavericks
    sha256 "8a26e3ef1807631a32935fe3013b0dd77328bff0d8075d7e0fa25ad40c6423c0" => :mountain_lion
  end

  option "without-yapp", "Omit yaws applications"
  option "32-bit"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "erlang"

  # the default config expects these folders to exist
  skip_clean "var/log/yaws"
  skip_clean "lib/yaws/examples/ebin"
  skip_clean "lib/yaws/examples/include"

  def install
    if build.build_32_bit?
      ENV.append %w[CFLAGS LDFLAGS], "-arch #{Hardware::CPU.arch_32_bit}"
    end

    system "autoreconf", "-fvi"
    system "./configure", "--prefix=#{prefix}",
                          # Ensure pam headers are found on Xcode-only installs
                          "--with-extrainclude=#{MacOS.sdk_path}/usr/include/security"
    system "make", "install"

    if build.with? "yapp"
      cd "applications/yapp" do
        system "make"
        system "make", "install"
      end
    end

    # the default config expects these folders to exist
    (lib/"yaws/examples/ebin").mkpath
    (lib/"yaws/examples/include").mkpath

    (var/"log/yaws").mkpath
    (var/"yaws/www").mkpath
  end

  test do
    system bin/"yaws", "--version"
  end
end
