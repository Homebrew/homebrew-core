class Txr < Formula
  desc "Original, new programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-271.tar.bz2"
  sha256 "3bebba794e4f3b2f839ceb011714e8a1e9d729cc9ae127a8daccc2b25b5e675c"
  license "BSD-2-Clause"
  revision 1

  livecheck do
    url "http://www.kylheku.com/cgit/txr"
    regex(/href=.*?txr[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "ac7923ccf5ffde9633e50594fa2ae0115dbde704bb14897bb3e1f268aca59cd2"
    sha256 cellar: :any, big_sur:       "8a7c80abc84909a7b5e3a9f425cf8d44b91da43cf0de224d8ac33fbbbd6ac3d9"
    sha256 cellar: :any, catalina:      "723f72aa2392fe9b0ba78592269363d288846357be57524a3fbacaf9379a25b2"
    sha256 cellar: :any, mojave:        "43089c64ba79f3ec5dfc095ddaac58cb8832554be3e7fbf6ed9ccebcaa9a14df"
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
