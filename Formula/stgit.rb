class Stgit < Formula
  include Language::Python::Shebang

  desc "Manage Git commits as a stack of patches"
  homepage "https://stacked-git.github.io"
  url "https://github.com/stacked-git/stgit/releases/download/v1.5/stgit-1.5.tar.gz"
  sha256 "ce6f8a3536c8f09aa6b2f1b7c7546279c02c8beeb2ea1b296f29ae9fe0cf1ff3"
  license "GPL-2.0-only"
  head "https://github.com/stacked-git/stgit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "442b36b832407129281e66f933478a744a621bd2ac53db0dd7b9f5630c042884"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "442b36b832407129281e66f933478a744a621bd2ac53db0dd7b9f5630c042884"
    sha256 cellar: :any_skip_relocation, monterey:       "d3b1b43726c6ae9ba5c846e85bd187592199e539f220be0b4ed22d56a59c07c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "d3b1b43726c6ae9ba5c846e85bd187592199e539f220be0b4ed22d56a59c07c3"
    sha256 cellar: :any_skip_relocation, catalina:       "d3b1b43726c6ae9ba5c846e85bd187592199e539f220be0b4ed22d56a59c07c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "442b36b832407129281e66f933478a744a621bd2ac53db0dd7b9f5630c042884"
  end

  depends_on "asciidoc" => :build
  depends_on "xmlto" => :build
  depends_on "python@3.10"

  def install
    ENV["PYTHON"] = Formula["python@3.10"].opt_bin/"python3.10"

    site_packages = prefix/Language::Python.site_packages("python3.10")
    inreplace "Makefile", "$(PYTHON) setup.py install",
                          "$(PYTHON) setup.py install --install-lib=#{site_packages} --install-scripts=#{prefix}/bin"

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
