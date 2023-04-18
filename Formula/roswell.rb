class Roswell < Formula
  desc "Lisp installer and launcher for major environments"
  homepage "https://github.com/roswell/roswell"
  url "https://github.com/roswell/roswell/archive/v22.12.14.113.tar.gz"
  sha256 "eb7e538e82822f857360d040b755e03ad2fdf87f151d34dafdae2a1180e7ec0b"
  license "MIT"
  head "https://github.com/roswell/roswell.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "7682378e1086857cd73d528f0e5a948b9d17cd5f1c8efcb88a7aa9df2f3e2304"
    sha256 arm64_monterey: "98879f5db19efa4771a5b9d8a4c1c7ed487149e4a6817212287bcd6810eda07c"
    sha256 arm64_big_sur:  "91e20c88367ef0ac04451b4b6c7df894f614a18b66afb4ed7ab07396237ff254"
    sha256 ventura:        "1d49e4a2e275e8ce3c541acb6b56f8cc1673c9428d2bb474d577ba5baeb536ed"
    sha256 monterey:       "26107b9602fdbc93cfca1994b28292d4083ee9e75058bdeb361e476f33311be5"
    sha256 big_sur:        "bc23952a87faae29c1f3a9d6cf0c1952b9e7d9e82379f38529790d6539579711"
    sha256 x86_64_linux:   "aa974d79c1db07401ea7c9c2d57ad539e339f6371ec0610017ca71ce09995fda"
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
