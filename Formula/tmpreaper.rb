class Tmpreaper < Formula
  desc "Clean up files in directories based on their age"
  homepage "https://packages.debian.org/sid/tmpreaper"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/t/tmpreaper/tmpreaper_1.6.13+nmu1.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/t/tmpreaper/tmpreaper_1.6.13+nmu1.tar.gz"
  version "1.6.13_nmu1"
  sha256 "c88f05b5d995b9544edb7aaf36ac5ce55c6fac2a4c21444e5dba655ad310b738"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "cd7fa68eb0292ea2831b7792b7319ac29dfe005c1a1ec868877b7a04d1ad6490" => :mojave
    sha256 "be0cf74a352a88dc2c6f616ad1bd695e37ff0736826f20007a1727e48ce16b84" => :high_sierra
    sha256 "44d3eb40f2c063642d57ccd7d65460901e7240abda5bda8b54721d77f731d755" => :sierra
    sha256 "e9992640d7c0e139caef8ccb130af90548f6435b3789b61c8c873f619e55ade9" => :el_capitan
    sha256 "a027f222a96bde98ae5f3e271d990871884a89fab8578066cc6b1cdb3a01aa2c" => :yosemite
    sha256 "31519a6cd52a36c1eb9f5a65b67b6f893d3a9f3c9d4601051cc6f33061bc8bf5" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    system "make", "install"
  end

  test do
    touch "removed"
    sleep 3
    touch "not-removed"
    system "#{sbin}/tmpreaper", "2s", "."
    refute_predicate testpath/"removed", :exist?
    assert_predicate testpath/"not-removed", :exist?
  end
end
