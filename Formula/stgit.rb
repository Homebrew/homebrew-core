class Stgit < Formula
  desc "Manage Git commits as a stack of patches"
  homepage "https://stacked-git.github.io"
  url "https://github.com/stacked-git/stgit/releases/download/v1.0/stgit-1.0.tar.gz"
  sha256 "c2a26b2e6a8fe2eb9c8aa4ade6d6dd35858137c381448b6142c4d2c142b47b94"
  license "GPL-2.0"
  head "https://github.com/stacked-git/stgit.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c5a53278cd1f922a7f28291f9042ba639213ecbed89cb9359559909e3ef52256"
    sha256 cellar: :any_skip_relocation, big_sur:       "0d1c580a5b1f6c8e0019bcad1455dc7cc80dc7cf7652ecbaf8830553f5576a6e"
    sha256 cellar: :any_skip_relocation, catalina:      "c053e3cf370231d34d8f86d4976187abaf7d85005581d385aef03c6a63915257"
    sha256 cellar: :any_skip_relocation, mojave:        "655ab25a88fe3f0810affa25bee1f0e7cd7f0f96866952fa40156780f165a22b"
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
