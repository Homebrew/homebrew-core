class Slowhttptest < Formula
  desc "Simulates application layer denial of service attacks"
  homepage "https://github.com/shekyan/slowhttptest"
  url "https://github.com/shekyan/slowhttptest/archive/v1.8.2.tar.gz"
  sha256 "faa83dc45e55c28a88d3cca53d2904d4059fe46d86eca9fde7ee9061f37c0d80"
  license "Apache-2.0"
  head "https://github.com/shekyan/slowhttptest.git"

  bottle do
    cellar :any
    sha256 "baaffefacf315bcb7ae0d5a241e8f41e326c76a3ac67e119ced1c9139e198bde" => :catalina
    sha256 "77d5fe071eb0015008a405ffa3838060a186d6e6134ae6dcf8ee9498a995857c" => :mojave
    sha256 "c9b36ccf8aee0f6572e2eb1112caf25811c22f1500ad81c1277309c76bd6460b" => :high_sierra
  end

  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/slowhttptest", "-u", "https://google.com",
                                  "-p", "1", "-r", "1", "-l", "1", "-i", "1"
  end
end
