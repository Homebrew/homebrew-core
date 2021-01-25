class Tmpwatch < Formula
  desc "Find and remove files not accessed in a specified time"
  homepage "https://pagure.io/tmpwatch"
  url "https://releases.pagure.org/tmpwatch/tmpwatch-2.11.tar.bz2"
  sha256 "93168112b2515bc4c7117e8113b8d91e06b79550d2194d62a0c174fe6c2aa8d4"
  license "GPL-2.0-only"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "990ba2839f3c2ddf69e280e976463969d3274410f1a84a90e00a6a9b0f5cef35" => :big_sur
    sha256 "b5f38895989ced860baaac4a22ed677b6adc7e3eaf07ecea5e65325b3a090071" => :arm64_big_sur
    sha256 "acd49e52b73f82c2cab4a77f46e99e0f69f856dc43cbf03f775ab58b44e78d6b" => :catalina
    sha256 "800714b1d0f11a8fc52b070046aa3a5aaf99883f9320d9a233ffabf801ae2996" => :mojave
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    mkdir "test" do
      touch %w[a b c]
      ten_minutes_ago = Time.new - 600
      File.utime(ten_minutes_ago, ten_minutes_ago, "a")
      system "#{sbin}/tmpwatch", "2m", Pathname.pwd
      assert_equal %w[b c], Dir["*"].sort
    end
  end
end
