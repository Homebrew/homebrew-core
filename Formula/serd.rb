class Serd < Formula
  desc "C library for RDF syntax"
  homepage "https://drobilla.net/software/serd.html"
  url "https://download.drobilla.net/serd-0.30.16.tar.xz"
  sha256 "f50f486da519cdd8d03b20c9e42414e459133f5a244411d8e63caef8d9ac9146"
  license "ISC"

  livecheck do
    url "https://download.drobilla.net/"
    regex(/href=.*?serd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ad22140ee5f263a0f0fac3b6bf9ba7166f1678cf2eb060fc1c2cdbec377c61bf"
    sha256 cellar: :any,                 arm64_monterey: "e72e4a3fbf4a93915d462e5c2a9d942bc17154ec06a88b71e19c76d9e4fa3672"
    sha256 cellar: :any,                 arm64_big_sur:  "ea9755059bd3d9d159c3768637b7fa65de0adf03c7ccf24c21e8e6894a43f62e"
    sha256 cellar: :any,                 ventura:        "80a21b975737e83827f174ff56fac17eb92b621bbe2c1c504e8df10b7fa88259"
    sha256 cellar: :any,                 monterey:       "dfb5856f93497bf7c137f96031a02d2e0f6a4d2bdc363d2d1e6e605f32c9e83e"
    sha256 cellar: :any,                 big_sur:        "e7974773f196596a6f57b8200ec8678b8b52d2d8f4e053bd61bb57591ad2f2fe"
    sha256 cellar: :any,                 catalina:       "5900f1d60c5f2aa684e996793fe1ba35fd1e21e3c11e8ac3959ff1cb8146bf61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67f216bd3fb20ef5b9cab23bb734fd25b111b4d66fcbca3801f48bc581a67753"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    rdf_syntax_ns = "http://www.w3.org/1999/02/22-rdf-syntax-ns"
    re = %r{(<#{Regexp.quote(rdf_syntax_ns)}#.*>\s+)?<http://example.org/List>\s+\.}
    assert_match re, pipe_output("serdi -", "() a <http://example.org/List> .")
  end
end
