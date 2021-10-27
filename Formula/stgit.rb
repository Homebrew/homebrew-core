class Stgit < Formula
  desc "Manage Git commits as a stack of patches"
  homepage "https://stacked-git.github.io"
  url "https://github.com/stacked-git/stgit/releases/download/v1.3/stgit-1.3.tar.gz"
  sha256 "44819a9809dba10ee9664f59f43fd40e5a338c99cb1181667b0a1e6428157e2b"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/stacked-git/stgit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cb37491ac4052c6153e35a1809ea7e54b3a31385112394dde1e56b40568bd720"
    sha256 cellar: :any_skip_relocation, big_sur:       "9232c43d2b1b93f7a39a292e2fa8c7f4dca5cac9516f1af5b4920728839bfcdb"
    sha256 cellar: :any_skip_relocation, catalina:      "9232c43d2b1b93f7a39a292e2fa8c7f4dca5cac9516f1af5b4920728839bfcdb"
    sha256 cellar: :any_skip_relocation, mojave:        "9232c43d2b1b93f7a39a292e2fa8c7f4dca5cac9516f1af5b4920728839bfcdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb37491ac4052c6153e35a1809ea7e54b3a31385112394dde1e56b40568bd720"
  end

  depends_on "asciidoc" => :build
  depends_on "xmlto" => :build
  depends_on "python@3.10"

  def install
    ENV["PYTHON"] = Formula["python@3.10"].opt_bin/"python3"
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    system "make", "prefix=#{prefix}", "all"
    system "make", "prefix=#{prefix}", "install"
    system "make", "prefix=#{prefix}", "install-doc"
    bash_completion.install "completion/stgit.bash"
    fish_completion.install "completion/stg.fish"
    zsh_completion.install "completion/stgit.zsh" => "_stgit"
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "brew@test.bot"
    (testpath/"test").write "test"
    system "git", "add", "test"
    system "git", "commit", "--message", "Initial commit", "test"
    system "#{bin}/stg", "--version"
    system "#{bin}/stg", "init"
    system "#{bin}/stg", "new", "-m", "patch0"
    (testpath/"test").append_lines "a change"
    system "#{bin}/stg", "refresh"
    system "#{bin}/stg", "log"
  end
end
