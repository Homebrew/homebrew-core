class Verovio < Formula
  desc "Command-line MEI music notation engraver"
  homepage "https://www.verovio.org"
  url "https://github.com/rism-digital/verovio/archive/refs/tags/version-3.12.1.tar.gz"
  sha256 "7f69b39e25f9662185906c9da495437e09539a520b9dda80f1bef818e905881b"
  license "LGPL-3.0-only"
  head "https://github.com/rism-digital/verovio.git", branch: "develop"

  depends_on "cmake" => :build

  def install
    cd "tools" do
      system "cmake", "../cmake", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    system bin/"verovio", "--version"
  end
end
