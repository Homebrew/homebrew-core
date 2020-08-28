class Txr < Formula
  desc "Original, new programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-242.tar.bz2"
  sha256 "e03a6c7311912306abf393df5fa7c387707576d32af96dbbba3f9b80a29d8a41"
  license "BSD-2-Clause"

  livecheck do
    url "http://www.kylheku.com/cgit/txr"
    regex(/href=.*?txr[._-]v?(\d+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "777da7fdcbfd3949b8766044bb41ca2d182585eaded277fc8f5fc033957c3529" => :catalina
    sha256 "9da932d4072f0d99436ac35497152baf060ba704bb048e1a879e89a1108d7694" => :mojave
    sha256 "2ef864ce866ab6ad510c2ae326be468c676c4e318d5cdb709276f310626c2206" => :high_sierra
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
