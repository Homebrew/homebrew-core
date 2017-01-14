class Yaws < Formula
  desc "Webserver for dynamic content (written in Erlang)"
  homepage "http://yaws.hyber.org"
  url "http://yaws.hyber.org/download/yaws-2.0.4.tar.gz"
  sha256 "da6677c315aadc7c64c970ef74eaa29f61eba886c7d30c61806651ac38c1e6c5"

  bottle do
    rebuild 1
    sha256 "4726b73647fd72506616403e164851ea3713df88db93868f308fb20ea52cf3e6" => :sierra
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

  depends_on "erlang"

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
