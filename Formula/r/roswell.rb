class Roswell < Formula
  desc "Lisp installer and launcher for major environments"
  homepage "https://github.com/roswell/roswell"
  url "https://github.com/roswell/roswell/archive/refs/tags/v26.02.116.tar.gz"
  sha256 "edece1aa4a807ee36f44061aa802354c722cb5bd80b5056b19aa982c14709a6c"
  license "MIT"
  head "https://github.com/roswell/roswell.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "a2dd66e40a708c94ba62a6e58bb4f284d991105988ab296148115d063feacc28"
    sha256 arm64_sequoia: "83f487ad84514a7298eaec541972da65ca72dc834de6357ee35f986096a77346"
    sha256 arm64_sonoma:  "82039a4f889030eccfacd55ec69ee9b83dd0c04981b41129839f9b2c7400c801"
    sha256 sonoma:        "8ecfdc665c4faef705304c09f9ed1a0089a8e1054b633c39b81bc9a10e898221"
    sha256 arm64_linux:   "5bd3a28804d8c0b377d3fad621702d625c78417c1ec11e94d42cda1aaf74d0a8"
    sha256 x86_64_linux:  "5f3be9a1d104a2861823c5879273c94dbe04ee24a0e15830f602c27f89d83100"
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
    assert_path_exists testpath/"config"
  end
end
