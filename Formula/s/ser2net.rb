class Ser2net < Formula
  desc "Allow network connections to serial ports"
  homepage "https://ser2net.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ser2net/ser2net/ser2net-4.6.1.tar.gz"
  sha256 "78ffee19d9b97e93ae65b5cec072da2b7b947fc484e9ccb3f535702f36f6ed19"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/ser2net[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:   "d932a8ec5ebaaaf4bf7a552dbde9783c12747fc86cfca5d036e90993b5590411"
    sha256 arm64_ventura:  "7a5e34aa0fba155424807e25ff6659ef6d62cc59c8654d8ba6b17ed9fd0ff1a9"
    sha256 arm64_monterey: "14360fb79dc50fbc0ef9492a50eaaf6a53e9ed301a0acad95e81545adc4238a4"
    sha256 sonoma:         "311d3f76276deb2554067cea60d125ed0b59210683f76f3d4f16f18a9727477a"
    sha256 ventura:        "f8650c01489dc4b65a301d13d878eea120a8ea49d81e9983738021f45835626f"
    sha256 monterey:       "93b89d61b8ff61e49eaf30c8149d8ad3f8a9c1446a23a3e43071da003c79946c"
    sha256 x86_64_linux:   "48da2840a377edc26d5eafac8b771468143b45dc73fdcd57b0c5721160c002c3"
  end

  depends_on "gensio"
  depends_on "libyaml"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--datarootdir=#{HOMEBREW_PREFIX}/share",
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
    run [opt_sbin/"ser2net", "-n"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/ser2net -v", 1)
  end
end
