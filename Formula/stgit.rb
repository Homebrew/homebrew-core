class Stgit < Formula
  desc "Manage Git commits as a stack of patches"
  homepage "https://stacked-git.github.io"
  url "https://github.com/stacked-git/stgit/releases/download/v0.23/stgit-0.23.tar.gz"
  sha256 "17c2b2e02341468f4d5f8d4d79c36f7fdb7febe18177277ca472502f673c50fd"
  license "GPL-2.0"
  head "https://github.com/stacked-git/stgit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a99d7f5ad5fbc099095f3579faa5f7356f180469aff11546c45caf37823afee9" => :catalina
    sha256 "a99d7f5ad5fbc099095f3579faa5f7356f180469aff11546c45caf37823afee9" => :mojave
    sha256 "a99d7f5ad5fbc099095f3579faa5f7356f180469aff11546c45caf37823afee9" => :high_sierra
  end

  depends_on "asciidoc" => :build
  depends_on "xmlto" => :build
  depends_on "python@3.8"

  def install
    ENV["PYTHON"] = Formula["python@3.8"].opt_bin/"python3"
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
