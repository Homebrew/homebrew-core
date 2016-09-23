class Yash < Formula
  desc "Yet another shell: a POSIX-compliant command-line shell"
  homepage "https://yash.osdn.jp/"
  url "http://dl.osdn.jp/yash/66471/yash-2.43.tar.xz"
  sha256 "eb75a2c3323514ed95f7c992336ca804e3a38c2ef316cfac76ce295b366b0283"

  bottle do
    cellar :any_skip_relocation
    sha256 "9b31936a60f2de87ee04f8c8be354d460c4806be7ef9384928c06e1b4c4af32b" => :el_capitan
    sha256 "e155165566942ee1bde9cd71ef246ef0454befb2e5b23e43ac1eaca007fc8b46" => :yosemite
    sha256 "469eacccbb09edd965b099476fb616e8e3ecd10071f24c654ac525bde2e65721" => :mavericks
    sha256 "93538457f7f06a70634be8d1242bae4adb99ff3aac2518ae14b903fd987755ca" => :mountain_lion
  end

  depends_on "gettext"

  def install
    system "sh", "./configure",
            "--prefix=#{prefix}",
            "--enable-array",
            "--enable-dirstack",
            "--enable-help",
            "--enable-history",
            "--enable-lineedit",
            "--enable-nls",
            "--enable-printf",
            "--enable-socket",
            "--enable-test",
            "--enable-ulimit"
    system "make", "install"
  end

  test do
    system "#{bin}/yash", "-c", "echo hello world"
  end
end
