class Ser2net < Formula
  desc "Allow network connections to serial ports"
  homepage "https://ser2net.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ser2net/ser2net/ser2net-4.6.7.tar.gz"
  sha256 "6b921bc7efb1b9a8a78268d63332701902cc1c8dbac51842d46ede6ffb5fa2a4"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/ser2net[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256               arm64_tahoe:   "826a5c4d76bc78574fbf69dc9fba7c15bcd24efc78a2db3749389b3ba25a662e"
    sha256               arm64_sequoia: "b2a4a4a84f7dd3011ba5a9c7ac1817bf725f847241b951edc7baa0fb26949fac"
    sha256               arm64_sonoma:  "905a3d6cb27b9ee2eb89bde470232112695067f626fb5d623c9fdc93f76ed8c3"
    sha256 cellar: :any, sonoma:        "956a9630a71d18386912c344979746f842c234c05919cd8959a00c70a7c31677"
    sha256               arm64_linux:   "a6a11cc4e843769d9c58aff84407bbf482443fb8bfcad51f209d178bd9f38847"
    sha256               x86_64_linux:  "e151fb33658fdea88474c879275d6b4fa26caf8f97a12600a00b4ce3fcb71807"
  end

  depends_on "gensio"
  depends_on "libyaml"

  on_linux do
    depends_on "linux-pam"
  end

  def install
    system "./configure", "--sysconfdir=#{etc}",
                          "--datarootdir=#{HOMEBREW_PREFIX}/share",
                          "--mandir=#{man}",
                          *std_configure_args
    system "make", "install"

    (etc/"ser2net").install "ser2net.yaml"
  end

  def caveats
    <<~EOS
      To configure ser2net, edit the example configuration in #{etc}/ser2net/ser2net.yaml
    EOS
  end

  service do
    run [opt_sbin/"ser2net", "-n"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/ser2net -v")
  end
end
