class Txr < Formula
  desc "Original, new programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-267.tar.bz2"
  sha256 "3cb2472b1cf0866169d2b29e4673ac34d8777edaff31527e5704141c12630149"
  license "BSD-2-Clause"

  livecheck do
    url "http://www.kylheku.com/cgit/txr"
    regex(/href=.*?txr[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "d7a2c47dab21aee8876f8610af82c4f879363a7db0c4d3699ac7fa1df5bc6ad7"
    sha256 cellar: :any, big_sur:       "3cb6f6073acdeda1d0f46768f16ca4158d6a7542dc4a36dd0494659620ff72a5"
    sha256 cellar: :any, catalina:      "61ce1d86c1b233fdd129c8dfe491b75a91a677d2ac2e2126471443920582ced7"
    sha256 cellar: :any, mojave:        "0a1ac9988abf6a154d1d472cc26ab7d1bed63c42475934ad39f5ca24ddf436fc"
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
