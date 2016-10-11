class XmlCoreutils < Formula
  desc "Powerful interactive system for text processing"
  homepage "http://www.lbreyer.com/xml-coreutils.html"
  url "http://www.lbreyer.com/gpl/xml-coreutils-0.8.1.tar.gz"
  sha256 "7fb26d57bb17fa770452ccd33caf288deee1d757a0e0a484b90c109610d1b7df"

  bottle do
    cellar :any
    rebuild 1
    sha256 "5f7519c9be40f731b0dca6238b3bedf4070f0663fc47ab8e4b0eff02d187718c" => :sierra
    sha256 "19bdcacd49657e78f82fd7743a50266ff4945e644b069ac2c39a8787a57911a5" => :el_capitan
    sha256 "1342c807e5ddc23a72e750f07258864fdf2fc1a8ce9072cb7797955fdd0e3656" => :yosemite
    sha256 "6bada2b9690d698b77f9293cf7f1066e77d36c8c07ba2892b2869ddb0516bc6d" => :mavericks
  end

  depends_on "s-lang"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.xml").write <<-EOS.undent
      <hello>world!</hello>
    EOS
    assert_match /0\s+1\s+1/, shell_output("#{bin}/xml-wc test.xml")
  end
end
