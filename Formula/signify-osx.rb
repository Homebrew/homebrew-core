class SignifyOsx < Formula
  desc "Cryptographically sign and verify files"
  homepage "https://man.openbsd.org/OpenBSD-current/man1/signify.1"
  url "https://github.com/jpouellet/signify-osx/archive/1.3.tar.gz"
  sha256 "c67090135a55478a6a6c11d507d9c3865a11de665c010a8a5f2457737f277f89"
  head "https://github.com/jpouellet/signify-osx.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7d93c571899b86e2ba05ea896f8146e787186543aa85c1131132dcf66d047293" => :mojave
    sha256 "1ddb3ee41740dfbca30a16b995c6cff1fc6e05c5eb78639c5a22ec5a33719aa1" => :high_sierra
    sha256 "523e702b06aca5635673ab05bbd65ac65533112a9395d5c33079ec53aeb8dda4" => :sierra
    sha256 "afb0b2d64d3cf49d5e39a56f1d35245dd9f059845bab6c4872b6119985d6f801" => :el_capitan
    sha256 "026e3a3c729fcaf41bd70041edec504c59981abb9b1b9018025ecd3467d12639" => :yosemite
  end

  def install
    system "make"
    system "make", "test"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/signify", "-G", "-n", "-p", "pubkey", "-s", "seckey"
  end
end
