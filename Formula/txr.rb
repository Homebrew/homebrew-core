class Txr < Formula
  desc "Original, new programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-250.tar.bz2"
  sha256 "1e744da753e93aeae00d2dfefc858af4babb43e2ddd4e64c16de6bfca743b398"
  license "BSD-2-Clause"

  livecheck do
    url "http://www.kylheku.com/cgit/txr"
    regex(/href=.*?txr[._-]v?(\d+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, big_sur:  "8cb9ae1076900705ee3eddbb50b5646fbd1affc67ebc606fc4bd28132ea4fea3"
    sha256 cellar: :any, catalina: "2b79be2d9c59a225c5107fccf350b51c3f2fe976726c852f480406d352fb694c"
    sha256 cellar: :any, mojave:   "1bbecb5fc244f6051334e23b9777d67657debd026ffb6d5aa3132b87f0c7841c"
  end

  depends_on "libffi"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    system "./configure", "--prefix=#{prefix}", "--inline=static inline"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "3", shell_output(bin/"txr -p '(+ 1 2)'").chomp
  end
end
