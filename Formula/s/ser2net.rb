class Ser2net < Formula
  desc "Allow network connections to serial ports"
  homepage "https://ser2net.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ser2net/ser2net/ser2net-4.6.8.tar.gz"
  sha256 "e651adcc4cc0d0ceaa36e5997dab9ea7f8aea732b4c87ba6018d2dcc88fbe8e3"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/ser2net[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256               arm64_tahoe:   "3c214f961d732a82ac62fe977dde82c7912de54d826b1e23990fc035572f4e02"
    sha256               arm64_sequoia: "fd7227618e0430537da799a8e4dae00cd08c880aba27dfaf727f5df16d6faf39"
    sha256               arm64_sonoma:  "9850a09ea9910b84cb9879ab4b7df9d77ca1e76b4315a7d863ea6ea8c303cf02"
    sha256 cellar: :any, sonoma:        "ba8e0b026ac4be7f8e6db552172841afda4d5f4d14e75bc513b42d5ac97dd883"
    sha256               arm64_linux:   "bbe0fa0064edb0b44ecec3d77ef667880961eadd37b10183f0f7b3d309b3622b"
    sha256               x86_64_linux:  "29357f49e5e690898ace616231506a8dbfa9972d2f60385d67767f2170a371cc"
  end

  depends_on "gensio"
  depends_on "libxcrypt" # for `crypt_r`
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
