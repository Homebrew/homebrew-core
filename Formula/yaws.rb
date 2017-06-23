class Yaws < Formula
  desc "Webserver for dynamic content (written in Erlang)"
  homepage "http://yaws.hyber.org"
  url "http://yaws.hyber.org/download/yaws-2.0.4.tar.gz"
  sha256 "da6677c315aadc7c64c970ef74eaa29f61eba886c7d30c61806651ac38c1e6c5"
  revision 1

  bottle do
    sha256 "5ab4f7256486913bedd6bb616ca04b838fc317719539f71ee0da63abd0d9c1ab" => :sierra
    sha256 "1316bd5fa12370a03900867606c0598ad10b6fb802d24330fe93dfc9db7d5b64" => :el_capitan
    sha256 "9b3864fb45654bb48661c5a720cc7accb7b1be790e3485f8b8e3f2009c366f54" => :yosemite
  end

  head do
    url "https://github.com/klacke/yaws.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "without-yapp", "Omit yaws applications"

  # Incompatible with Erlang/OTP 20.0
  # See upstream issue from 9 Jun 2017 https://github.com/klacke/yaws/issues/309
  depends_on "erlang@19"

  # the default config expects these folders to exist
  skip_clean "var/log/yaws"
  skip_clean "lib/yaws/examples/ebin"
  skip_clean "lib/yaws/examples/include"

  def install
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
