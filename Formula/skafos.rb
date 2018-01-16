class Skafos < Formula
  desc      "Command-line tool for working with the Metis Machine platform"
  homepage  "https://metismachine.com"
  url       "https://github.com/MetisMachine/skafos/archive/1.0.tar.gz"
  sha256    "ff62f76e8cbc9e3ccf4109a7f8cadc07bc8307ebe6d718f77de8481cef6bae31"
  head      "https://github.com/metismachine/skafos.git"

  bottle :unneeded

  depends_on "cmake" => :build
  depends_on "libgit2"
  depends_on "yaml-cpp"

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
