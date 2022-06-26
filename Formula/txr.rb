class Txr < Formula
  desc "Original, new programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-277.tar.bz2"
  sha256 "96958f80ee5293f29496b52a8bf2b1fb361a49d3cb13c3fe2b2087937016d4eb"
  license "BSD-2-Clause"

  livecheck do
    url "http://www.kylheku.com/cgit/txr"
    regex(/href=.*?txr[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "16bed41289c4c9f570611ccc2ea5fec2144da5832da63f927bd4536a4956e162"
    sha256 cellar: :any, arm64_big_sur:  "d79458f008f33ad3e3a2cfae22a27786b6deaf5b7fea3c97d22180af944eaa10"
    sha256 cellar: :any, monterey:       "22bbcc8155628a121634155598f49911e4b5002bc531e09cfa5535e21b94634d"
    sha256 cellar: :any, big_sur:        "a3ac817256295c2fc583658718f1998b71c0671ebdff9c7dd1e1c5c532484f1f"
    sha256 cellar: :any, catalina:       "645a5744b055ad4668116dc44f3423e17acc6027552da01f3b3550c091daba19"
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
