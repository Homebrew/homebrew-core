class Yaws < Formula
  desc "Webserver for dynamic content (written in Erlang)"
  homepage "http://yaws.hyber.org"
  url "http://yaws.hyber.org/download/yaws-2.0.5.tar.gz"
  sha256 "be82d1b5bcd9d32406244eb4f542e653a2d9d82cf34bc3c61e15d26e84db7601"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "ab5721cc9ab06a514c79620bcf61fb5fd728d7815bf66b3bb69543f020b5ecf8" => :high_sierra
    sha256 "e3a910676bed399eaa98a02ded3cdf1ba42bd5470a1f09f5e9ab9f13e63132d0" => :sierra
    sha256 "252fc874a319092c66cf032d31639674ad9298cf2664363542ba25e037612d44" => :el_capitan
  end

  head do
    url "https://github.com/klacke/yaws.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "without-yapp", "Omit yaws applications"

  depends_on "erlang@20"

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
