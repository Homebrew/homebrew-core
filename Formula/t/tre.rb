class Tre < Formula
  desc "Lightweight, POSIX-compliant regular expression (regex) library"
  homepage "https://github.com/laurikari/tre"
  url "https://github.com/laurikari/tre/releases/download/v0.9.0/tre-0.9.0.tar.gz"
  sha256 "f57f5698cafdfe516d11fb0b71705916fe1162f14b08cf69d7cf86923b5a2477"
  license "BSD-2-Clause"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0046ebce7ba173f666176e93abbb6d2079677d02e584f097d97f923d0c0ff0a3"
    sha256 cellar: :any, arm64_sequoia: "85fd4370b99c94723511074c06989cb4f9d4dadaac1678caac21d6796f931ee7"
    sha256 cellar: :any, arm64_sonoma:  "e0123ce5b530d27ff0df617882b040d17da215ff57a434ac2fdf0e8438536b8f"
    sha256 cellar: :any, arm64_ventura: "d0c9476251a0aacd0395c113b38b90ecd0f714e39a1581fc4ad1d253daa9481c"
    sha256 cellar: :any, sonoma:        "943904e06f61a77afa4d5ae7d50e6e8008bd32bd66f395ec43a2b58af06b840f"
    sha256 cellar: :any, ventura:       "79f195205a3d5296ace3a48a14d3beb763b906b7e0a0d674c9ac897dbb4e6329"
    sha256               arm64_linux:   "1d9d8bb6a5a094d7c9e9469f87bfb88cd0aefa9ac4c77b525b66d25b8e22373e"
    sha256               x86_64_linux:  "29ffb52469a70317b5c0b010b3af90d3f3cc804fb28e856c7f112f9b8049a0ef"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "brow", pipe_output("#{bin}/agrep -1 brew", "brow", 0)
  end
end
