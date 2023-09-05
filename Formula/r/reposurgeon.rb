class Reposurgeon < Formula
  desc "Edit version-control repository history"
  homepage "http://www.catb.org/esr/reposurgeon/"
  url "https://gitlab.com/esr/reposurgeon/-/archive/4.38/reposurgeon-4.38.tar.gz"
  sha256 "6849cad6f0a3bb5d627af5f65de0ce6a3185c224f80d0c0b2189636c41c7e168"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/reposurgeon.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf43566c72e4afef9d463896b93e232ad8c9d91221c9b8de9e4dd7d92dbfd212"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4fecc94b0c345aeddc6a9a19080536e531df272ff1bc2adb729daf3d83ba7cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e10ae7fba30a3da96822f5ffd4500f1e49113dcb34fc75a856e16510071f2561"
    sha256 cellar: :any_skip_relocation, ventura:        "3ff2f3f71730d1ca283c11dcef8bdb094d7b53375e8f9d4e0c398b57d829851a"
    sha256 cellar: :any_skip_relocation, monterey:       "3aae9f9aea21147e89abaa57bc9fd2348e63b86d135cfaf15fde53976cb74dcd"
    sha256 cellar: :any_skip_relocation, big_sur:        "62bfd2a64621671a873851a1ab0389d3b923418df2270fd8141bbf5e8c293a38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b33736ea8edebc892923ca37aa2fdd61373bb7d3fbfc2bfb866473aa82697cfc"
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
