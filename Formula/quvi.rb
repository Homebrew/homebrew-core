class Quvi < Formula
  desc "Parse video download URLs"
  homepage "https://quvi.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/quvi/0.4/quvi/quvi-0.4.2.tar.bz2"
  sha256 "1f4e40c14373cb3d358ae1b14a427625774fd09a366b6da0c97d94cb1ff733c3"
  license "LGPL-2.1"

  livecheck do
    url :stable
    regex(%r{url=.*?/quvi[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5507b545d2705556712e4548c8cb6a62777163a7b496fc69cbc6974845c5fe28"
    sha256 cellar: :any,                 arm64_big_sur:  "195d1401be4ab2b454d97e611163251bb4ed1986cab9c39b089268969fe67ff1"
    sha256 cellar: :any,                 monterey:       "59f9173d6feff6af456d1e08008feaa8eb1c946508ab9e6ed9ffa1ce3093b647"
    sha256 cellar: :any,                 big_sur:        "1b3252441e8eac802fcd016b09149004b86288c79916e2204be210478af2e185"
    sha256 cellar: :any,                 catalina:       "4dd1859cd18aa0e4bdf2286c31dc80c74d572b8d3b3dd7cea89c9042ec73ac23"
    sha256 cellar: :any,                 mojave:         "403d1157a64341c76067353225c6acbe1c0f3e9c0b69634ed80f0bb6400c4c7c"
    sha256 cellar: :any,                 high_sierra:    "10fe26a54bcdf8e33e9798b399a3a72e8b571c9668e4398a3f8d1a7952f9c652"
    sha256 cellar: :any,                 sierra:         "9e3b86dff84297edec9c63ff1593136c2ce62e8a9f8d523e9d9137943da939bb"
    sha256 cellar: :any,                 el_capitan:     "c5a8c9b53432e15b4ec31a9c1374bde130d56f73f8ee43e392917a52f34ab945"
    sha256 cellar: :any,                 yosemite:       "944922426376a9962bb90f032e02ef2404d3155ed3bba81a0b4d349ba1f1aec8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bde81ca6c65e967a5f18c0552cbe4823bc393e5e943c24d809f55dbefc6ea59d"
  end

  depends_on "pkg-config" => :build
  depends_on "libquvi"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/quvi", "--version"
  end
end
