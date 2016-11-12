class Ttygif < Formula
  desc "Converts a ttyrec file into gif files"
  homepage "https://github.com/icholy/ttygif"
  url "https://github.com/icholy/ttygif/archive/1.4.0.tar.gz"
  sha256 "6ca3dc5dcade2bdcf8000068ae991eac518204960c157634d92f87248c3cee2a"

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
