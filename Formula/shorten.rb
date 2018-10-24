class Shorten < Formula
  desc "Waveform compression"
  homepage "https://web.archive.org/web/20180903155129/www.etree.org/shnutils/shorten/"
  url "https://web.archive.org/web/20180903155129/www.etree.org/shnutils/shorten/dist/src/shorten-3.6.1.tar.gz"
  sha256 "ce22e0676c93494ee7d094aed9b27ad018eae5f2478e8862ae1e962346405b66"

  bottle do
    cellar :any_skip_relocation
    sha256 "ed0a7482bebdc53827e6932bdc70d8897d00b4ce87ac2cf84bee7b0cec2229a5" => :mojave
    sha256 "2247094c6f41ad5ce941c84335a45aaaabe0bef43ffeb89a544793957c157ba9" => :high_sierra
    sha256 "a54b8263dfbd2aab185df1888193dc0ceb602d9df82758cf5ef31b3df52ae697" => :sierra
    sha256 "66cf7cabae065035e9c3c4a8c139439384fb9f26ea0ee433e336c18ba2f8383e" => :el_capitan
    sha256 "5f48b61ce709915830f433dd381fe531c1354b56619bbdb441dc19f985df7467" => :yosemite
    sha256 "a802da618fffa3eb292705140c882fcedbffae09017f0efdf69085004952a148" => :mavericks
    sha256 "ca55e37b24202c500a03dfe36a41dd06ebaa02b19ddf65c26cc440376149c5da" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/shorten", test_fixtures("test.wav"), "test"
    assert_predicate testpath/"test", :exist?
  end
end
