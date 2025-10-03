class Xcv < Formula
  desc "Cut, copy and paste files with Bash"
  homepage "https://github.com/busterc/xcv"
  url "https://github.com/busterc/xcv/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "f2898f78bb05f4334073adb8cdb36de0f91869636a7770c8e955cee8758c0644"
  license "ISC"
  head "https://github.com/busterc/xcv.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "d9e0dfc790cbc0a90240e2964f439260ea656a826d7688730bd9c304232e733d"
  end

  def install
    bin.install "xcv"
  end

  test do
    system bin/"xcv"
  end
end
