class Ragel < Formula
  desc "State machine compiler"
  homepage "https://www.colm.net/open-source/ragel/"
  url "https://www.colm.net/files/ragel/ragel-6.11.tar.gz"
  sha256 "47653e376554adbb617d2f1da15394b6a163264e2410c2bff3581347a14890e3"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/Stable.*?href=.*?ragel[._-]v?(\d+(?:\.\d+)+)\.t/im)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ec7bcd332c95e0ce22b78cb2d6cfe376c09a2b6b84adbb85ef601b717a7629b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b47c717a0bec033d0acd6d0cbd28e237d353b91fdc0fbaee79cf78865dd58e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf103f38405d030952937a459b7d013f314be0aad9b598e17807208658ec12ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "eddfd8d0747348e05f495475f08f423a72b5fab660f021871234f31d29c6845e"
    sha256 cellar: :any,                 arm64_linux:   "5398365191dac2c977a7b656df4e754aa581732750e33a622cc9ce4c48844831"
    sha256 cellar: :any,                 x86_64_linux:  "3b891e0145e09eb372556857d77fe05733b0cc2edbcb74031238b07464a6da69"
  end

  resource "pdf" do
    url "https://www.colm.net/files/ragel/ragel-guide-6.11.pdf"
    sha256 "ea4850e48779b14f662c94d9d7bbf634b0860d2317c6996135b5b1cab2c5ded9"

    livecheck do
      formula :parent
    end
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
    doc.install resource("pdf")
  end

  test do
    testfile = testpath/"rubytest.rl"
    testfile.write <<~RL
      %%{
        machine homebrew_test;
        main := ( 'h' @ { puts "homebrew" }
                | 't' @ { puts "test" }
                )*;
      }%%
        data = 'ht'
        %% write data;
        %% write init;
        %% write exec;
    RL
    system bin/"ragel", "-Rs", testfile
  end
end
