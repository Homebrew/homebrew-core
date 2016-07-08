class Yaws < Formula
  desc "Webserver for dynamic content (written in Erlang)"
  homepage "http://yaws.hyber.org"
  url "https://github.com/klacke/yaws/archive/yaws-2.0.3.tar.gz"
  sha256 "fbe54fe64455b447d0d44aed4d51402f42c81743ad5e1f1a09d888f2ef54de07"
  head "https://github.com/klacke/yaws.git"

  bottle do
    sha256 "1ee10be2188e6dc7c2e01def77e2e8201d4ebf4adf6ac8321569e12b6e1aa0c6" => :el_capitan
    sha256 "fa73b56f2fae2f2a6ffd988a846e16329d9e498738d39b2416830ba7373f2afc" => :yosemite
    sha256 "696fe509205bbc64331c3d6c83894d1b39ee996a42e5157b7a8a50bb10470458" => :mavericks
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
