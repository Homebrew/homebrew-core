class Txr < Formula
  desc "Original, new programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-198.tar.bz2"
  sha256 "82f53cd14b2cd60a9d0faed49ca14d42f5e212d2f05310c54b8a041a9d28ebf4"
  head "http://www.kylheku.com/git/txr", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "896a215273823e5d0fc3a3169b85fa669f81e65e1a2e8a8d691896cdb73e3029" => :mojave
    sha256 "80a3df0768847b56f4d7f9e06db6ffe0e248f6d6be33aaaaaf305202bdbf1a7e" => :high_sierra
    sha256 "69ac09578a8a6e2aa8113b6795553b9be2266ee2f4803435d0904658992b8a7e" => :sierra
    sha256 "164024941a33530d80cfedf4f0b3f585863686dbe623036bcfde4d9112276b5e" => :el_capitan
  end

  def install
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "3", shell_output(bin/"txr -p '(+ 1 2)'").chomp
  end
end
