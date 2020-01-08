class Zdelta < Formula
  desc "Lossless delta compression library"
  homepage "https://web.archive.org/web/20150804051750/cis.poly.edu/zdelta/"
  url "https://web.archive.org/web/20150804051752/cis.poly.edu/zdelta/downloads/zdelta-2.1.tar.gz"
  sha256 "03e6beb2e1235f2091f0146d7f41dd535aefb6078a48912d7d11973d5306de4c"
  head "https://github.com/snej/zdelta.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c7d235578c62851ad7639ced736eb94ce833e9afb172fe65a37869bac1a80da4" => :catalina
    sha256 "d98c1b4f7a6b63238bacd06d0a5640e7f0d07838bb4b3e15ac7dc9d699a5835a" => :mojave
    sha256 "12c977074ebb388cb671b3a996cacda4c5c47fbf96100f73ffddcbf83976824d" => :high_sierra
    sha256 "49b891fbf6b6f93796cb3080dcbefc1d873000e84d74a4bf2dd851b625e6a698" => :sierra
    sha256 "3a186612374b9b2aca2e56f5dd68049c0b1ef952e4cb0b07263faf2ea62f136a" => :el_capitan
    sha256 "2ade2838217be1b9f6bc55be6bf05fa5046ae09a42d17b714b9f2a73f934c993" => :yosemite
    sha256 "86f93c2e260d321d3bf30b34c2313d2cec5bc6d23bfb5a86cf99ab6b5f64f157" => :mavericks
  end

  def install
    system "make", "test", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    system "make", "install", "prefix=#{prefix}"
    bin.install "zdc", "zdu"
  end

  test do
    msg = "Hello this is Homebrew"
    (testpath/"ref").write "Hello I'm a ref file"

    compressed = pipe_output("#{bin}/zdc ref", msg, 0)

    assert_equal msg, pipe_output("#{bin}/zdu ref", compressed, 0)
  end
end
