class Unpaper < Formula
  desc "Post-processing for scanned/photocopied books"
  homepage "https://www.flameeyes.com/projects/unpaper"
  url "https://www.flameeyes.com/files/unpaper-7.0.0.tar.xz"
  sha256 "2575fbbf26c22719d1cb882b59602c9900c7f747118ac130883f63419be46a80"
  license "GPL-2.0-or-later"
  revision 4
  head "https://github.com/unpaper/unpaper.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "fc585f781ec6ab7ec82afc6630731152c6de6f9ff74c491f01716f4355fbc22a"
    sha256 cellar: :any, arm64_sequoia: "5c156bd4eb872947e7428e68101dc2043c8e3d08c51b4bbedb35c9e71cd2365f"
    sha256 cellar: :any, arm64_sonoma:  "4beb67537e15ec17777b47388b04435ecd4f58b2c0bc16f4ab431cde86824001"
    sha256 cellar: :any, sonoma:        "6748c3ed4a7a2c3af694385ce7bdf0d7e1ec1ac77a9f5f5ae3a9cf32cdc48035"
    sha256               arm64_linux:   "27c33908935f73781dafa5fe57bdfee2e197325537df541882141e8502ced4e0"
    sha256               x86_64_linux:  "4ab7e7baa52f728047d0f8e03a9c64ea3415b5dd36d64942f5df41df27f2dd19"
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
