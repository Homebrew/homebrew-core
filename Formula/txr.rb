class Txr < Formula
  desc "Original, new programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-236.tar.bz2"
  sha256 "293c0f02b7553001392789cff5da727b1ca085f2a05fd5d3fda1f88b72a3b031"
  head "http://www.kylheku.com/git/txr", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "856ec1ebd50a257f86b6597e2d57aa415c43c302ddd49ccc1e88b09ac8ca3f58" => :catalina
    sha256 "87634391f7ec880b7ddfece88c694eed77d665fb4a55d834d1848d76304900fa" => :mojave
    sha256 "e501093b98d458c0681801b6d4e9b0f9833d077fcaba094f6b3afb40f1d5756d" => :high_sierra
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "3", shell_output(bin/"txr -p '(+ 1 2)'").chomp
  end
end
