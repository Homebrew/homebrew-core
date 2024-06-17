class Reposurgeon < Formula
  desc "Edit version-control repository history"
  homepage "http://www.catb.org/esr/reposurgeon/"
  url "https://gitlab.com/esr/reposurgeon/-/archive/5.0/reposurgeon-5.0.tar.gz"
  sha256 "2b2bc2a1ef4bca80802b99a8a9b5f20c1e8440a5d3bf5996d42d723df1d5ec81"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/reposurgeon.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "17c29de4bf9b31a9e432df017775ede4a41bf9c21cad89791f40f9e5701a39a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1268fdcbd875b2f7d0b91a14c10d0c5adb43ca9fa9cbf025ee1384bbba7671e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39c0f8406929c7ad39693b602755e7cee480127785afe74f90a28858a6e8a3fa"
    sha256 cellar: :any_skip_relocation, sonoma:         "bf34130a2cfe33dbec1f6f204cc25a338928bfbd39781e7b685d2302184fd776"
    sha256 cellar: :any_skip_relocation, ventura:        "273d5f4ba3fb7f228f7a011bf8601d84b1dc6d361e617d9b06622107a1753a0f"
    sha256 cellar: :any_skip_relocation, monterey:       "0a750cb078223570b9c0e7212ea0de35033f8eebbae0e61baaf30b860aacfb1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "caebaf6357416099f46a1221c63f7fd886b3b101fded4d4472741ddb6d9605dd"
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
