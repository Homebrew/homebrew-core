class Txr < Formula
  desc "Original, new programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-242.tar.bz2"
  sha256 "e03a6c7311912306abf393df5fa7c387707576d32af96dbbba3f9b80a29d8a41"
  license "BSD-2-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "78015b7f45f94f9c62907e054889547fbe77037af7b95502c677768a87716fbd" => :catalina
    sha256 "017f8844ad96af9b015b2b8dc664b5755167bf311a3bf072c417f8ea2df3afca" => :mojave
    sha256 "f3d5a65365480e383e084f4b83206fd4546cd86c10e6d1dabef75783903f2ff9" => :high_sierra
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "3", shell_output(bin/"txr -p '(+ 1 2)'").chomp
  end
end
