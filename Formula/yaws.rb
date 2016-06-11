class Yaws < Formula
  desc "Webserver for dynamic content (written in Erlang)"
  homepage "http://yaws.hyber.org"
  url "https://github.com/klacke/yaws/archive/yaws-2.0.2.tar.gz"
  sha256 "d2f5faf57b5087f3f0d8fc085a2342793db0f63007ddeb69e5c11935ef773729"
  head "https://github.com/klacke/yaws.git"

  bottle do
    sha256 "c670ffd7b510fed39e73e7be38779b0115435893ea4553f24fe96f9767375b3b" => :el_capitan
    sha256 "f9c21dbaaff1b4abaf5e9375fde9d3c8c38754a9345d876951f7d18c28f6cbe8" => :yosemite
    sha256 "76885ddae6aafe18bb24c71ebd84f66fb8282e843a20076a4d06c8cf66bdea08" => :mavericks
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
