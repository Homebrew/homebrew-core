class Streem < Formula
  desc "Prototype of stream based programming language"
  homepage "https://github.com/matz/streem"
  url "https://github.com/matz/streem/archive/201611.tar.gz"
  sha256 "807a9ccf3162efb061a15a333943050b329f0232cceb55492e5cd582c09a7fb4"
  head "https://github.com/matz/streem.git"

  def install
    system "make"
    prefix.install "bin"
  end

  test do
    hello_text = shell_output("#{bin}/streem -e '[\"hello\"] | stdout'")
    assert_equal "hello\n", hello_text
  end
end
