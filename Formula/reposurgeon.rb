class Reposurgeon < Formula
  desc "Edit version-control repository history"
  homepage "http://www.catb.org/esr/reposurgeon/"
  url "https://gitlab.com/esr/reposurgeon.git",
      tag:      "4.29",
      revision: "1b708dceed752d16dbe6ea095a4928a7231e5bbc"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/reposurgeon.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b98cc8b69dc7952fc935fe26d7dbbbd2dad705207181a86b3423e108fc317de"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c7f30cf4589429feb7bd480ebe7f57c627e2ac9e16c5946ad3939e739c5e4ae8"
    sha256 cellar: :any_skip_relocation, monterey:       "bda19f7c15e15ef6766e80a7e9e2dc580dbe822796a183e5376d4bff98720f71"
    sha256 cellar: :any_skip_relocation, big_sur:        "60748bd31b737f5da19048f67d8db22113a912b937fc013272af329155f86b8e"
    sha256 cellar: :any_skip_relocation, catalina:       "45bee33e5c8e35fe15257333aef0ac31fbfff7c868b0fcaf97232155ab087822"
    sha256 cellar: :any_skip_relocation, mojave:         "85988d5f6ffd08dcedeb706a566d8123869840ab61f0eb0d7fe8ce1ae0207b41"
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
