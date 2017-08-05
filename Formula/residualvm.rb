class Residualvm < Formula
  desc "3D graphic adventure game interpreter"
  homepage "http://residualvm.org"
  url "https://downloads.sourceforge.net/project/residualvm/residualvm/0.2.1/residualvm-0.2.1-sources.tar.bz2"
  sha256 "cd2748a665f80b8c527c6dd35f8435e718d2e10440dca10e7765574c7402d924"
  head "https://github.com/residualvm/residualvm.git"

  bottle do
    sha256 "92efc0e5090dc459c1a5b4b79c59e737a3f0c42548d4aeea6c93b6fe695340df" => :sierra
    sha256 "74cdadcb02c40721d16aa613ba70fcd09d137cbcc69259444c1cf3cceb924419" => :el_capitan
    sha256 "b1aa19050c3ee60834ebcf49f40dc1ec90d246e4d0ca70343218e0f08c3b5e96" => :yosemite
  end

  depends_on "faad2"
  depends_on "flac"
  depends_on "fluid-synth"
  depends_on "freetype"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "sdl"
  depends_on "theora"

  def install
    system "./configure", "--prefix=#{prefix}", "--enable-release"
    system "make"
    system "make", "install"
    (share+"icons").rmtree
    (share+"pixmaps").rmtree
  end

  test do
    system "#{bin}/residualvm", "-v"
  end
end
