class Unpaper < Formula
  desc "Post-processing for scanned/photocopied books"
  homepage "https://www.flameeyes.eu/projects/unpaper"
  revision 2

  stable do
    url "https://www.flameeyes.eu/files/unpaper-6.1.tar.xz"
    sha256 "237c84f5da544b3f7709827f9f12c37c346cdf029b1128fb4633f9bafa5cb930"

    resource "libav" do
      url "https://libav.org/releases/libav-11.7.tar.xz"
      sha256 "8c9a75c89c6df58dd5e3f6f735d1ba5448680e23013fd66a51b50b4f49913c46"
    end
  end

  bottle do
    cellar :any
    sha256 "7332b87cd5d0e087774f41fd0df69d5f26c616ca469a1d33cdfdcf4baa6153ff" => :el_capitan
    sha256 "c84f37be3e99fcf3d47bf4bbffba7192d451761a31056705f11d6a4a19dcd45a" => :yosemite
    sha256 "318d0e90644880ee357818a8d6d144d7ccc4873cca90a1ff77f1031f20994b93" => :mavericks
  end

  head do
    url "https://github.com/Flameeyes/unpaper.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build

    resource "libav" do
      url "https://github.com/libav/libav.git"
    end
  end

  depends_on "pkg-config" => :build
  depends_on "yasm" => :build

  def install
    resource("libav").stage do
      system "./configure", "--prefix=#{libexec}", "--enable-shared"
      system "make", "install"
    end

    ENV.append "CFLAGS", "-I#{libexec}/include"
    ENV.append "LDFLAGS", "-L#{libexec}/lib"
    ENV.append_path "PKG_CONFIG_PATH", "#{libexec}/lib/pkgconfig"

    system "autoreconf", "-i" if build.head?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.pbm").write <<-EOS.undent
      P1
      6 10
      0 0 0 0 1 0
      0 0 0 0 1 0
      0 0 0 0 1 0
      0 0 0 0 1 0
      0 0 0 0 1 0
      0 0 0 0 1 0
      1 0 0 0 1 0
      0 1 1 1 0 0
      0 0 0 0 0 0
      0 0 0 0 0 0
    EOS
    system bin/"unpaper", testpath/"test.pbm", testpath/"out.pbm"
    File.exist? testpath/"out.pbm"
  end
end
