class Txr < Formula
  desc "Original, new programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-264.tar.bz2"
  sha256 "227e6e4c335f93eb0bea926785e8239b161df9d25e6fb966c7283f86fa2b8d00"
  license "BSD-2-Clause"

  livecheck do
    url "http://www.kylheku.com/cgit/txr"
    regex(/href=.*?txr[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "16bfa5e0aad6fe61e6985d4e730e7b08f7dc89bb69e9607c3d674f202cdcf4e6"
    sha256 cellar: :any, big_sur:       "d43adb13d7f667658726aac9dbec6a4c35d86869a1ed0c27ee82b7acb8922480"
    sha256 cellar: :any, catalina:      "5a840825bff28b2e3446d62a854031f3144913d1c7398ebd400f1b7b3e6118d0"
    sha256 cellar: :any, mojave:        "1d982ef1014461c672788df106a3cb96c9f7f42f7a62ad4150d8e89a7a7f03d6"
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
