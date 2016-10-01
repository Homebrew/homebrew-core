class Yaws < Formula
  desc "Webserver for dynamic content (written in Erlang)"
  homepage "http://yaws.hyber.org"
  url "http://yaws.hyber.org/download/yaws-2.0.3.tar.gz"
  sha256 "450a4b2b2750a6feb34238c0b38bc9801de80b228188a22d85dccbb4b4e049f6"

  bottle do
    rebuild 1
    sha256 "81def8e721a0002e565065f69b2ae46ad4a7b2c52d644d95cff6c7c55237808d" => :el_capitan
    sha256 "009bcd0dc46019343ab543607e427d899fc814129ee8428735cae958a88778c1" => :yosemite
    sha256 "b49589e1fe5bd673e3ca035ff2626fe7055d4326d7cf61911a314aaa9cdc8074" => :mavericks
  end

  head do
    url "https://github.com/klacke/yaws.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "without-yapp", "Omit yaws applications"
  option "32-bit"

  depends_on "erlang"

  # the default config expects these folders to exist
  skip_clean "var/log/yaws"
  skip_clean "lib/yaws/examples/ebin"
  skip_clean "lib/yaws/examples/include"

  def install
    if build.build_32_bit?
      ENV.append %w[CFLAGS LDFLAGS], "-arch #{Hardware::CPU.arch_32_bit}"
    end

    system "autoreconf", "-fvi" if build.head?
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
  end

  def post_install
    (var/"log/yaws").mkpath
    (var/"yaws/www").mkpath
  end

  test do
    system bin/"yaws", "--version"
  end
end
