class Unpaper < Formula
  desc "Post-processing for scanned/photocopied books"
  homepage "https://www.flameeyes.com/projects/unpaper"
  url "https://www.flameeyes.com/files/unpaper-7.0.0.tar.xz"
  sha256 "2575fbbf26c22719d1cb882b59602c9900c7f747118ac130883f63419be46a80"
  license "GPL-2.0-or-later"
  revision 3
  head "https://github.com/unpaper/unpaper.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "320c0664be9f441fb7a5f6bc021d37530845fa4ea4da99d3d8d401db90b2681d"
    sha256 cellar: :any, arm64_sequoia: "99d2fa75bbc4f530241ab2a64e5cbc1a5061fa96c5567faa70eca694b6228ef9"
    sha256 cellar: :any, arm64_sonoma:  "1d183d40ad7c4dfd89f52ca00311238722f2527a6a1a751e3efc6135e1354a3b"
    sha256 cellar: :any, arm64_ventura: "0e1846058cd13818ec2ce52723cede8c9623c31f27f0f9ec86f05c33340f8208"
    sha256 cellar: :any, sonoma:        "6777c3ff2dd38462fa6977af915316a930a157356ce0b9dd95a2fe99c80b54d2"
    sha256 cellar: :any, ventura:       "ff58caf46e5464a26fe3e79631296ded2c6372c0bc984ab1192942fe24841880"
    sha256               arm64_linux:   "dd466760c8a54553861474272a465e1a4460d48bd8dc6a0dd885e5cf39a06a63"
    sha256               x86_64_linux:  "4ee017ffb7c00c3573b669f7b87f17bca1faceb37ae72f43496d612c36700cc7"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "sphinx-doc" => :build
  depends_on "ffmpeg"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.pbm").write <<~EOS
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
    assert_path_exists testpath/"out.pbm"
  end
end
