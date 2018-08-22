class Ttygif < Formula
  desc "Converts a ttyrec file into gif files"
  homepage "https://github.com/icholy/ttygif"
  url "https://github.com/icholy/ttygif/archive/1.4.0.tar.gz"
  sha256 "6ca3dc5dcade2bdcf8000068ae991eac518204960c157634d92f87248c3cee2a"

  bottle do
    cellar :any_skip_relocation
    sha256 "4e3e5a1116ac263b68ca7fb25b26b17d927a9135971de3340f44e4a9a4a2dc5e" => :mojave
    sha256 "c8dbee8441c56e4ade77fc6990a1336e6017519760e2719813bc92f8e10eaf69" => :high_sierra
    sha256 "f64ad6118dc421166dca05ac1ef2d146d545caddc49dcf1a17e06d3c9deee6fd" => :sierra
    sha256 "c32e7ce8c456e02c9b945e9cca6252a071b68b9cda84651877481b54a76f6c1c" => :el_capitan
    sha256 "6459139f3d5eb5a52aacf11d1774c0404a7947d0e87e674c2bba54724bc06bbf" => :yosemite
  end

  depends_on "imagemagick"
  depends_on "ttyrec"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    ENV["TERM_PROGRAM"] = "Something"
    assert_match version.to_s, shell_output("#{bin}/ttygif --version")
  end
end
