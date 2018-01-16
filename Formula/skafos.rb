class Skafos < Formula
  desc      "Command-line tool for working with the Metis Machine platform"
  homepage  "https://metismachine.com"
  url       "https://github.com/MetisMachine/skafos/archive/1.0.tar.gz"
  sha256    "254500f6a5bd4bee3cbfc8a7d1c8ceec1595430d5b14a69d859f9de80b8ebd16"
  head      "https://github.com/metismachine/skafos.git"

  bottle :unneeded

  depends_on "cmake" => :build
  depends_on "libgit2"
  depends_on "yaml-cpp"
  depends_on "libarchive" => :recommended

  def install
    ENV.deparallelize

    system "make", "homebrew"
    prefix.install Dir["_build/*"]
  end

  test do
    `system "#{bin}/skafos", "--version"`
    `system "#{bin}/skafos", "--help"`
  end
end
