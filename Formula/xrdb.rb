class Xrdb < Formula
  desc "X resource database utility"
  homepage "https://gitlab.freedesktop.org/xorg/app/xrdb"
  url "https://www.x.org/releases/individual/app/xrdb-1.2.1.tar.bz2"
  sha256 "4f5d031c214ffb88a42ae7528492abde1178f5146351ceb3c05f3b8d5abee8b4"
  license "MIT-open-group"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "20eaddd4a2cc97a18ab11bbb4a9a3bdbdcd9bdba4774132711e3e39ccd74165d"
    sha256 cellar: :any,                 arm64_monterey: "aaf2d43dc2e4568168801a497e542b25cb03f616c651c2206a494397d04873db"
    sha256 cellar: :any,                 arm64_big_sur:  "4b92f7c647bc44300dab5b8691022244dc0c2941aff0eba4e6ab3b71f9341163"
    sha256 cellar: :any,                 ventura:        "4d8d4f700b8a23d692f15c156479cb5a132921637a10250f709b8a9efe27a1b6"
    sha256 cellar: :any,                 monterey:       "d446c1ad4b7d5a7e016a3b85b87b7a8c65756e357d0ed00309e3b02214ed1442"
    sha256 cellar: :any,                 big_sur:        "b239c7c840e735dc60beb481e535dd96bc645d598ce9e893f1937274ce987cdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6472dfe4e759cf9a10e24687ea7061da7d78a6a8e1c5bcbadebaa926aef7c05c"
  end

  depends_on "pkg-config"  => :build
  depends_on "xorg-server" => :test

  depends_on "libxmu"

  def install
    configure_args = std_configure_args + %w[
      --with-cpp=/usr/bin/cpp
    ]
    system "./configure", *configure_args
    system "make"
    system "make", "install"
  end

  test do
    fork do
      exec Formula["xorg-server"].bin/"Xvfb", ":1"
    end
    ENV["DISPLAY"] = ":1"
    sleep 10
    system bin/"xrdb", "-query"
  end
end
