class Yash < Formula
  desc "Yet another shell: a POSIX-compliant command-line shell"
  homepage "https://magicant.github.io/yash/"
  url "https://github.com/magicant/yash/releases/download/2.56.1/yash-2.56.1.tar.xz"
  sha256 "f7f5a1ffd246692568e4823a59b20357317d92663573bd1099254c0c89de71f5"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "b68163e22eaece03440b9c34a86881d22560138a66b910ccd06931fdec08f65b"
    sha256 arm64_ventura:  "88ae07ec0fa00335deec7a178ba1eeb28bfd9fd759e3f56c9ce9723614d5c3fb"
    sha256 arm64_monterey: "8c6a9640d4815081c84348a51faa3d92f8dbb8ceb44f707e7c2c26c0b9a861c2"
    sha256 sonoma:         "645b3d48f71762977f3adfb6debea14c0d52a15e2b3b753c80424fc285b2ab6b"
    sha256 ventura:        "d63e6d3b39507857685ef86bd07d6d29c2abe74fa29ae3ef94729795d2a9d397"
    sha256 monterey:       "c434dc6f7806d6838c75709381e7b6432914fd461ecb484c17510f894b7df76a"
    sha256 x86_64_linux:   "ffacbc77cdb3b5f0b25be881c2cc4eadca7ac7aef8bce2d57ef99d19a6a516f1"
  end

  head do
    url "https://github.com/magicant/yash.git", branch: "trunk"

    depends_on "asciidoc" => :build
  end

  depends_on "gettext"

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog" if build.head?

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"yash", "-c", "echo hello world"
    assert_match version.to_s, shell_output("#{bin}/yash --version")
  end
end
