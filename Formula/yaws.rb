class Yaws < Formula
  desc "Webserver for dynamic content (written in Erlang)"
  homepage "http://yaws.hyber.org"
  url "http://yaws.hyber.org/download/yaws-2.0.5.tar.gz"
  sha256 "be82d1b5bcd9d32406244eb4f542e653a2d9d82cf34bc3c61e15d26e84db7601"

  bottle do
    cellar :any_skip_relocation
    sha256 "0c21fbdde094c31460c5046c1d0e0a0633c8ddb49d934b1eb8edae396a5e765e" => :high_sierra
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
