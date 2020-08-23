class Tmpwatch < Formula
  desc "Find and remove files not accessed in a specified time"
  homepage "https://pagure.io/tmpwatch"
  url "https://releases.pagure.org/tmpwatch/tmpwatch-2.11.tar.bz2"
  sha256 "93168112b2515bc4c7117e8113b8d91e06b79550d2194d62a0c174fe6c2aa8d4"
  license "GPL-2.0"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d2e77af7339bd09c9b7352a1646c79e15db6b43c27537b4af59efbc51e23f114" => :catalina
    sha256 "4f7b1e540daebe79e1ad64b2e4e4b7214074c05150dcd9de7a5ffe9c12e6b9bb" => :mojave
    sha256 "24a734b4cf32ce5720e1c089060fa66dcc2d9dde437804a4dc147f81d9cd8512" => :high_sierra
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
      assert_equal %w[b c], Dir["*"]
    end
  end
end
