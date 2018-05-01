class Txr < Formula
  desc "Original, new programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-194.tar.bz2"
  sha256 "56b2595db8e739a92fdfe73f80b5f8d2ae186fb5326986a9d5e940841ed38198"
  head "http://www.kylheku.com/git/txr", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "04075496eb349650f5dafc6f1a741967c5655820bf601dc80138bed3cc32e9e3" => :high_sierra
    sha256 "b4d8396adcd83169c6c4de97a599537f81ce2d8a3ca5a9e1a4e8a5c7bb04b755" => :sierra
    sha256 "ba97249f33f8974503d2270da462b12b374f3db7c65ee3d732f432b4a8c0c52d" => :el_capitan
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
