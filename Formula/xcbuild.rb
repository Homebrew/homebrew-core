class Xcbuild < Formula
  desc "Xcode-compatible build tool"
  homepage "https://github.com/facebook/xcbuild"
  url "https://github.com/facebook/xcbuild.git", :tag => "0.1.0"
  head "https://github.com/facebook/xcbuild.git", :shallow => false

  depends_on "ninja" => :recommended
  depends_on "cmake"
  depends_on "libpng"
  depends_on "libxml2"
  depends_on "pkg-config"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
    bin.install_symlink "#{prefix}/usr/bin/xcbuild"
  end

  test do
    system "#{bin}/xcbuild", "-showsdks"
  end
end
