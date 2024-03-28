class Ruptime < Formula
  desc "poor man’s ruptime"
  homepage "https://wedonthaveaprivacyproblem.com"
  url "https://github.com/alexmyczko/ruptime/archive/refs/tags/1.8.tar.gz"
  sha256 "c7115c34e11d79d1d0e966516818f3e5f7a0417aadb6cdddfb415cb103f688eb"
  license "AGPL-3.0-or-later"

  depends_on "xz"
  depends_on "memtester"

  def install
    bin.install "ruptime"
    #bin.install "ruptimed"
    bin.install_symlink "ruptime" => "rsw"
    bin.install_symlink "ruptime" => "rhw"
    bin.install_symlink "ruptime" => "runame"
    bin.install_symlink "ruptime" => "rbench"
    bin.install_symlink "ruptime" => "rboot"
    bin.install_symlink "ruptime" => "rdisk"
    bin.install_symlink "ruptime" => "rload"
    bin.install_symlink "ruptime" => "rnet"
    bin.install_symlink "ruptime" => "rac"
    bin.install_symlink "ruptime" => "rwho"
    man1.install "man/ruptime.1"
    #man8.install "man/ruptimed.8"
  end

  test do
    system "false"
  end
end
