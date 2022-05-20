class Tradcpp < Formula
  desc "K&R-style C preprocessor"
  homepage "https://www.netbsd.org/~dholland/tradcpp"
  url "https://cdn.netbsd.org/pub/NetBSD/misc/dholland/tradcpp-0.5.3.tar.gz"
  sha256 "e17b9f42cf74b360d5691bc59fb53f37e41581c45b75fcd64bb965e5e2fe4c5e"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9584ff61e602fe8001d9c39dcaec1e348731955bd65583155953edc41ef989a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1ef32ad298a9059d8bfb8a9216d878b38c2f9283e04cdfba4f0a80d20302ea5a"
    sha256 cellar: :any_skip_relocation, monterey:       "7d111d68702a671f85be5da6f8b8022dd92ae8bf62dadbb5d3c40660b5b9d19a"
    sha256 cellar: :any_skip_relocation, big_sur:        "a9989ef6884603abbc66752b56adcf52ad8976b8c5cb0faa1904fdf8646d2725"
    sha256 cellar: :any_skip_relocation, catalina:       "23d6d5712e23e1467f95e432f223a6e088d3a94e5ca179c6ad48b40b200e8878"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8600b885c4d6fbcfb9014dda1a1b34818c1daf84522e6df5aca004f78f81ae1e"
  end

  depends_on "bmake" => :build

  def install
    system "bmake"
    system "bmake", "prefix=#{prefix}", "MK_INSTALL_AS_USER=yes", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #define FOO bar
      FOO
    EOS
    assert_match "bar", shell_output(bin/"tradcpp ./test.c")
  end
end
