class Ser2net < Formula
  desc "Allow network connections to serial ports"
  homepage "https://ser2net.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ser2net/ser2net/ser2net-4.5.0.tar.gz"
  sha256 "6ee1b217aad026948fd17ea00c5ecf6e982de822384c4349118461ad83caa0da"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/ser2net[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_ventura:  "583fbb6ffe6cc7dd58639ac1a6f5b14ba75541ef9c2ed066d5f740c84e8473d1"
    sha256 arm64_monterey: "4b900e82626e24c157084304615a868c0ecbffa3fb8abda876833a70f98d2a36"
    sha256 arm64_big_sur:  "3b70f3d7144922876879130b05dbf47350e00e30469d11fe50f6e6b0e8ab84ca"
    sha256 ventura:        "e41d11911d6775f88f3a09fa2f3f014469d701353f4e0d5039ca16953ca66b7a"
    sha256 monterey:       "b910fca757159622dd5d15cffd0273218f828cc84e054b9fe35dd0e72c5e530b"
    sha256 big_sur:        "007510adffa38bda93f2c357e8a262ab3fca31125479f0f005d6de0cac008e22"
    sha256 x86_64_linux:   "d164194ac933f0828696ae3eaff539aea03ce8fd80f35cb1a6d51c64ccac80a7"
  end

  depends_on "libyaml"

  # pin to use gensio 2.4.1 due to arm build issue with 2.6.7
  resource "gensio" do
    url "https://downloads.sourceforge.net/project/ser2net/ser2net/gensio-2.4.1.tar.gz"
    sha256 "949438b558bdca142555ec482db6092eca87447d23a4fb60c1836e9e16b23ead"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  def install
    resource("gensio").stage do
      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{libexec}/gensio",
                            "--with-python=no",
                            "--with-tcl=no"
      system "make", "install"
    end

    ENV.append_path "PKG_CONFIG_PATH", "#{libexec}/gensio/lib/pkgconfig"
    ENV.append_path "CFLAGS", "-I#{libexec}/gensio/include"
    ENV.append_path "LDFLAGS", "-L#{libexec}/gensio/lib"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"

    (etc/"ser2net").install "ser2net.yaml"
  end

  def caveats
    <<~EOS
      To configure ser2net, edit the example configuration in #{etc}/ser2net/ser2net.yaml
    EOS
  end

  service do
    run [opt_sbin/"ser2net", "-p", "12345"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/ser2net -v", 1)
  end
end
