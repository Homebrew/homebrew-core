class Reposurgeon < Formula
  desc "Edit version-control repository history"
  homepage "http://www.catb.org/esr/reposurgeon/"
  url "https://gitlab.com/esr/reposurgeon.git",
      tag:      "4.28",
      revision: "e2187a3d4a9200dba8726986762c868211ab06aa"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/reposurgeon.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "28135b31b2a2a3340107e0773c4edb46a58216131529f4ae5349c06df3e8d854"
    sha256 cellar: :any_skip_relocation, big_sur:       "b90757c1fa826ff66296c4b3150758448b5a7972e4688fe137583b5274f44d4a"
    sha256 cellar: :any_skip_relocation, catalina:      "7afe781fbea234675b80909026416003e5c39f27d1c32f16670bcb25182ce657"
    sha256 cellar: :any_skip_relocation, mojave:        "ec2899c973fac83e3b67ba5326b9c7b9d0f23bf381373ed4d0f3fac763586baf"
  end

  depends_on "asciidoctor" => :build
  depends_on "gawk" => :build if MacOS.version <= :catalina
  depends_on "go" => :build
  depends_on "git" # requires >= 2.19.2

  def install
    ENV.append_path "GEM_PATH", Formula["asciidoctor"].opt_libexec
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    system "make"
    system "make", "install", "prefix=#{prefix}"
    elisp.install "reposurgeon-mode.el"
  end

  test do
    (testpath/".gitconfig").write <<~EOS
      [user]
        name = Real Person
        email = notacat@hotmail.cat
    EOS
    system "git", "init"
    system "git", "commit", "--allow-empty", "--message", "brewing"

    assert_match "brewing",
      shell_output("script -q /dev/null #{bin}/reposurgeon read list")
  end
end
