class Txr < Formula
  desc "Original, new programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-268.tar.bz2"
  sha256 "ea376df756cd2c8c859a678d9b666bc21830fda1339bd05d474502f58bbe1c96"
  license "BSD-2-Clause"

  livecheck do
    url "http://www.kylheku.com/cgit/txr"
    regex(/href=.*?txr[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "836c1c2f1cd8f0984a0659f8d3a08f53c35216492af14ddf422df6d7e0f70ca5"
    sha256 cellar: :any, big_sur:       "bfa0ecb676757b39f7070ee005227b5b5454558ba06a542e50fa56a4a8d10086"
    sha256 cellar: :any, catalina:      "05cacd2f47b59c26fa52f96811cddbef06971446bad77578d8403122115b328c"
    sha256 cellar: :any, mojave:        "8ed96e565877f2053c1c6f798b8f45d6d65b4e9cd9692befa6f49fc5bfde8fad"
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
