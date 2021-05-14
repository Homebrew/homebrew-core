class Txr < Formula
  desc "Original, new programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-259.tar.bz2"
  sha256 "a466672fd0eccf95f4e39cc7bbd08fe391e44f65db1411f844375b1157252eaa"
  license "BSD-2-Clause"

  livecheck do
    url "http://www.kylheku.com/cgit/txr"
    regex(/href=.*?txr[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "2fad9653c7b27c23c5460b95a5df90fbdb94a6858ad351750f9a38c40e8b2b60"
    sha256 cellar: :any, big_sur:       "0f5854cb29da14f1c5001eef0d4ed33f54061478176ce374e254b1f4040c0e08"
    sha256 cellar: :any, catalina:      "d15d69ba71841d7a82df819a51507930ecae825994ee3a6dd5f041b25126ccad"
    sha256 cellar: :any, mojave:        "20affda021cfa45909ece3a8871bb00c4dd2b2792c7ca63b3eb7dccf5e65427b"
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
