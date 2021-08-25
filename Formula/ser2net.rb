class Ser2net < Formula
  desc "Allow network connections to serial ports"
  homepage "https://ser2net.sourceforge.io"
  url "https://downloads.sourceforge.net/project/ser2net/ser2net/ser2net-4.2.3.tar.gz"
  sha256 "d63448d10064419f1783fbb04d0a95461d54d6b17cf50c9d33a63cbf0c732f37"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/ser2net[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_big_sur: "1845d6644d7cd518e8b1c7f7abd4ab1d6515eb482690a062b8e17ddbc6eb7c4c"
    sha256 cellar: :any,                 big_sur:       "03feeb3d9e3049231fccb29a8ca8bc7d79c0e4839381d1340c45cf932ddaea68"
    sha256 cellar: :any,                 catalina:      "21a9c4c0a980b74a864c7db0782f71786e133cc2e3d62411fa9ea0f99c38e0b2"
    sha256 cellar: :any,                 mojave:        "a2abbe3f823de5e70a863f521e63fcb079801b22d653f4bdb26a775c97fa4289"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c4726875c7f661b925b6fbd7d82eeaf89fd4b91a28ba34377860c8ebbb3f999"
  end

  depends_on "libyaml"

  resource "gensio" do
    url "https://downloads.sourceforge.net/project/ser2net/ser2net/gensio-2.1.4.tar.gz"
    sha256 "1f5a29aabfb35886893cfda5cd78192db67e96de796dbf9758dbecd4077a3fd8"
  end

  def install
    resource("gensio").stage do
      system "./configure", "--with-python=no",
                            "--disable-dependency-tracking",
                            "--prefix=#{libexec}/gensio"
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
    assert_match version.to_s, shell_output("#{sbin}/ser2net -v")
  end
end
