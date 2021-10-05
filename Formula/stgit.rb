class Stgit < Formula
  desc "Manage Git commits as a stack of patches"
  homepage "https://stacked-git.github.io"
  url "https://github.com/stacked-git/stgit/releases/download/v1.3/stgit-1.3.tar.gz"
  sha256 "44819a9809dba10ee9664f59f43fd40e5a338c99cb1181667b0a1e6428157e2b"
  license "GPL-2.0-only"
  head "https://github.com/stacked-git/stgit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e3bdca3fa2b8dfd10dd3e89dd08aa7c5760d7fb9159c1abecbb56b53c9241731"
    sha256 cellar: :any_skip_relocation, big_sur:       "ae08af52ebd73ea02f596294454b6bda5c9efc360e2b03c9806d0f508f4a5282"
    sha256 cellar: :any_skip_relocation, catalina:      "ae08af52ebd73ea02f596294454b6bda5c9efc360e2b03c9806d0f508f4a5282"
    sha256 cellar: :any_skip_relocation, mojave:        "ae08af52ebd73ea02f596294454b6bda5c9efc360e2b03c9806d0f508f4a5282"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3bdca3fa2b8dfd10dd3e89dd08aa7c5760d7fb9159c1abecbb56b53c9241731"
  end

  depends_on "asciidoc" => :build
  depends_on "xmlto" => :build
  depends_on "python@3.9"

  def install
    ENV["PYTHON"] = Formula["python@3.9"].opt_bin/"python3"
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
