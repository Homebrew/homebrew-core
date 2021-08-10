class Reposurgeon < Formula
  desc "Edit version-control repository history"
  homepage "http://www.catb.org/esr/reposurgeon/"
  url "https://gitlab.com/esr/reposurgeon.git",
      tag:      "4.28",
      revision: "e2187a3d4a9200dba8726986762c868211ab06aa"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/reposurgeon.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "eba17e8a1089183edd74c77a5ea5bdfdf9a6fcbdb2e635b9e2f5c3a71817876c"
    sha256 cellar: :any_skip_relocation, big_sur:       "39edee4019e83fa40aad6882903d63f263fc79372b7e5c091c331b3dccf5a703"
    sha256 cellar: :any_skip_relocation, catalina:      "0ca0fe2611d1794509f8a1e3749d10689ab9bebbbbe6121b1245021a75781466"
    sha256 cellar: :any_skip_relocation, mojave:        "53a6eb93265db0a19b72adafc802bec5bbc70d85d23709931e9a6571821643dc"
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
