class Rfcmarkup < Formula
  desc "Add HTML markup and links to internet-drafts and RFCs"
  homepage "https://tools.ietf.org/tools/rfcmarkup/"
  url "https://tools.ietf.org/tools/rfcmarkup/rfcmarkup-1.119.tgz"
  sha256 "46c5522f3cba0d430019a60de0e995adbc12f055970b6b341f45181cf8deed8e"

  bottle do
    cellar :any_skip_relocation
    sha256 "ceabc26299da811359ca9e1a410e06e9fd3a676249d0501c2436976af1e95462" => :sierra
    sha256 "a15f3c6be0c5eb4b38c4801c6151d4a12b2f206ab6e9c7f11dd0cd94ba7f9e9d" => :el_capitan
    sha256 "5eaeed274aca3e64cbc2407a6b9b531efed736fec325d15109b308bdbea971b4" => :yosemite
    sha256 "5eaeed274aca3e64cbc2407a6b9b531efed736fec325d15109b308bdbea971b4" => :mavericks
  end

  def install
    bin.install "rfcmarkup"
  end

  test do
    system bin/"rfcmarkup", "--help"
  end
end
