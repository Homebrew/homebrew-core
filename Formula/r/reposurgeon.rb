class Reposurgeon < Formula
  desc "Edit version-control repository history"
  homepage "http://www.catb.org/esr/reposurgeon/"
  url "https://gitlab.com/esr/reposurgeon/-/archive/5.2/reposurgeon-5.2.tar.gz"
  sha256 "25c6386739be5bd304cded51d7a92440d8d1cbcbfa9d3c147d1c9b9a373e904e"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/reposurgeon.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f78605c847f5325f10e4f87add3eeb3059a1bb1400c433b3337cd9ba19e9ddc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1817a5d5f77af949e83c58217ff25f1527ff629b2b7e3ac47f82265c75c37cba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6b99edff141b3c552b9fb8aaa5b0256ba32b57f7cc8ee80beda391e6ecda531e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4c448dd0f5b3c86a35eb39ce280d86bfeb98931f0b47d2bed1cb2217a4facc7"
    sha256 cellar: :any_skip_relocation, ventura:       "a9adf2ca4d3266f218594e28b73c11c912313ba5a2fd9e71eaad8f0163aa534a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e41771387c7f1220d82c9e77e4174e1cc5428d68d39b630b692f9bb0c147fa8a"
  end

  depends_on "asciidoctor" => :build
  depends_on "go" => :build
  depends_on "git" # requires >= 2.19.2

  uses_from_macos "ruby"

  on_system :linux, macos: :catalina_or_older do
    depends_on "gawk" => :build
  end

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
      shell_output("#{bin}/reposurgeon read list")
  end
end
