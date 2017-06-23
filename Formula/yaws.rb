class Yaws < Formula
  desc "Webserver for dynamic content (written in Erlang)"
  homepage "http://yaws.hyber.org"
  url "http://yaws.hyber.org/download/yaws-2.0.4.tar.gz"
  sha256 "da6677c315aadc7c64c970ef74eaa29f61eba886c7d30c61806651ac38c1e6c5"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "9e3633fab3d158e738391c020fb018f5991d340c7cf02ec585a81dbdfe4b9a6e" => :sierra
    sha256 "80bddcf13c0dd84bbec08f407fe2093c3989d12764aa8ddc6ffd29e41dc1cb09" => :el_capitan
    sha256 "0c3befb6a035e66f74536cef3db652d653233670c57476220c2314af6cbcd484" => :yosemite
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
