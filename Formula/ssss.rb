class Ssss < Formula
  desc "Shamir's secret sharing scheme implementation"
  homepage "http://point-at-infinity.org/ssss/"
  url "http://point-at-infinity.org/ssss/ssss-0.5.tar.gz"
  sha256 "5d165555105606b8b08383e697fc48cf849f51d775f1d9a74817f5709db0f995"

  bottle do
    cellar :any
    sha256 "d6c84cc81a0e079f55b32bf3bc35be3a70016226f5cb0e6d1862c9dca22aaa56" => :sierra
    sha256 "ffc9b4c320b50f3d093000f9cde8fff3e4f2869ff4111a7da25b0cf17a2bc065" => :el_capitan
    sha256 "8242a9583ca549f506c107ee1df51c19b04790a8f64605d67ffcd62de34c21ea" => :yosemite
    sha256 "695899e6e9fac80f8502362c9bb11811113f33373cfc1d0ea99467ac26035776" => :mavericks
  end

  depends_on "gmp"
  depends_on "xmltoman"

  def install
    inreplace "Makefile" do |s|
      # Compile with -DNOMLOCK to avoid warning on every run on OS X.
      s.gsub! /\-W /, "-W -DNOMLOCK $(CFLAGS) $(LDFLAGS)"
    end

    system "make"
    man1.install "ssss.1"
    bin.install %w[ssss-combine ssss-split]
  end
end
