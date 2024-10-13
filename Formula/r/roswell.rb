class Roswell < Formula
  desc "Lisp installer and launcher for major environments"
  homepage "https://github.com/roswell/roswell"
  url "https://github.com/roswell/roswell/archive/refs/tags/v23.10.14.114.tar.gz"
  sha256 "02c8323341357a451c6963aec7ca17a6ddc9c979c8943560eea5762ff6fbbfe6"
  license "MIT"
  head "https://github.com/roswell/roswell.git", branch: "master"

  bottle do
    sha256 arm64_sequoia:  "f7fbc3df0de456b33dcce49179fad79210c6546b22af207b83f37c33f54cf9c9"
    sha256 arm64_sonoma:   "16c4f341cbc050b87bfdf50f9e954bfcc9731b71ef27f5851fbc949c1fd2a5ea"
    sha256 arm64_ventura:  "958b418eaa627ef2b5070db893254c708893abfe6c377769e13a6b151391c30e"
    sha256 arm64_monterey: "e6dc6f1dbffb125577b35ffd8eafc2ef6e91fc1371cbdc9b3cd66620a888f345"
    sha256 sonoma:         "e5d79e12fc36cf8bd5c108a6b4657b1fd3f212bf45dbde812e274b156971a049"
    sha256 ventura:        "32dae8fce3f7b99d3ba3dfb8dce89d724c6d44ba0c1d250431314a46b1de583f"
    sha256 monterey:       "2b99d4dcd3391c4be71008762f24787610b9205edec440e147b6c84b6ca6abeb"
    sha256 x86_64_linux:   "b4ab5aec69d08f17cec4f5d14733509c8290ab99fa181075495b36077e15417d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  uses_from_macos "curl"

  def install
    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    ENV["ROSWELL_HOME"] = testpath
    system bin/"ros", "init"
    assert_predicate testpath/"config", :exist?
  end
end
