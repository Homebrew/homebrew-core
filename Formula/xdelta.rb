class Xdelta < Formula
  desc "Binary diff, differential compression tools"
  homepage "http://xdelta.org"
  url "https://github.com/jmacd/xdelta/archive/v3.1.0.tar.gz"
  sha256 "7515cf5378fca287a57f4e2fee1094aabc79569cfe60d91e06021a8fd7bae29d"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "18018770f5aec11098c6a02b6a88eb7db07edffb5e04d947b3e82de41925af8a"
    sha256 cellar: :any,                 arm64_big_sur:  "4bf8a2d96c0ee4e20beafd81762a80e21bbb9fe400796e02392cb18777f0c6a9"
    sha256 cellar: :any,                 monterey:       "cead50bfce3fa3e6dba28a28804b2741748f30f1baafd1bf3fe192bb4d34e6c2"
    sha256 cellar: :any,                 big_sur:        "98fa35dfab2175bb199d3878788734096430e118f3f17cdde9c74ea99af62538"
    sha256 cellar: :any,                 catalina:       "5b5eae08cf9d1d5e37dc42f0d557670477bae10adf28278bbb4f88ec83a5a2c3"
    sha256 cellar: :any,                 mojave:         "29a63934406537a96b023609a87998574d41943ed2cfe816b3febc24b7cc7db1"
    sha256 cellar: :any,                 high_sierra:    "a65a726ce73eeebb9abfdf8069b08658dc4fad13527d4d162d1119cc32702b11"
    sha256 cellar: :any,                 sierra:         "7f51b76d06a6ac8aae36c10b41776a374d5fafa6b55c4908a885be7a88194676"
    sha256 cellar: :any,                 el_capitan:     "e07f928aadf6a9d8beb8a19fb72cb673cf0ae13c339ccd75c5df134cb3bc5c09"
    sha256 cellar: :any,                 yosemite:       "2581a9d0aabf6f6b34d35aae4d7ab07b6aaebdb70fd3b00ef14eff3bd96aa6c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4015bbc1061c1ac1ba9b56e9465b2b18bd22f1557e79651f1cf9feaf5e37c486"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "xz"

  def install
    cd "xdelta3" do
      system "autoreconf", "--install"
      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{prefix}",
                            "--with-liblzma"
      system "make", "install"
    end
  end

  test do
    system bin/"xdelta3", "config"
  end
end
