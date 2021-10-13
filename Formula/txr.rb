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
    sha256 cellar: :any, arm64_big_sur: "075aef49b3405bd3e5eb1198cc4cc855e8869cece96a3e3c70449091bd6b4f95"
    sha256 cellar: :any, big_sur:       "26bfd1e76168d6f2ad2c830ffd02e279c7748f928455bc18f25a4288dce683f2"
    sha256 cellar: :any, catalina:      "d995de85c281bf8af8cb32ac2f7d922174c3e0fa241c322b0f274208123eab93"
    sha256 cellar: :any, mojave:        "793139738a803ad1a1b62dee660aa5de084d69510b4fa8adbe04c4fa258cc14f"
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
