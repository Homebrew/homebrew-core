class Rcm < Formula
  desc "RC file (dotfile) management"
  homepage "https://thoughtbot.github.io/rcm/rcm.7.html"
  url "https://thoughtbot.github.io/rcm/dist/rcm-1.3.4.tar.gz"
  sha256 "9b11ae37449cf4d234ec6d1348479bfed3253daba11f7e9e774059865b66c24a"
  license "BSD-3-Clause"

  # The first-party website doesn't appear to provide links to archive files, so
  # we check the Git repository tags instead.
  livecheck do
    url "https://github.com/thoughtbot/rcm.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a43a7792728bc4c441e997bc6e0879aecc237d1c95c7a47ff49093e33ad14979"
    sha256 cellar: :any_skip_relocation, big_sur:       "1ae14043eb53ab02db26a3bf33d15d817a09917788f0165bbcc538f77a9d38fd"
    sha256 cellar: :any_skip_relocation, catalina:      "86ac10a7254567afb24c9816f6a80dd90a81bc8cd8619c112e59c0950929ef14"
    sha256 cellar: :any_skip_relocation, mojave:        "44c9524d9d5ce8ea5310fe6681b040d6c685cec693446f617686f82929d83c6b"
    sha256 cellar: :any_skip_relocation, high_sierra:   "7130060f9a26eda6a704eb06bda4c04a4cc0b0980f1c9d3fc5dce876fa5a3fdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e25ac856a6b3705687bb8ddff4e53bfaa698aca2b87b0d478b7d613aa8cea748"
    sha256 cellar: :any_skip_relocation, all:           "e0fe84fa9771045e44879d079ba41a4e4cbab1f163c09898c98db37cbb367779"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/".gitconfig").write <<~EOS
      [user]
      	name = Test User
      	email = test@test.com
    EOS
    assert_match(/(Moving|Linking)\.\.\./x, shell_output("#{bin}/mkrc -v ~/.gitconfig"))
  end
end
