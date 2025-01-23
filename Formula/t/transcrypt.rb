class Transcrypt < Formula
  desc "Configure transparent encryption of files in a Git repo"
  homepage "https://github.com/elasticdog/transcrypt"
  url "https://github.com/elasticdog/transcrypt/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "9779f5cc972d7e6e83de0770e5391aca95881bc75e101095a6dede4620a8cd28"
  license "MIT"
  head "https://github.com/elasticdog/transcrypt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "74509c09ac771418d78666690abdcf59fccdf6f78b4fb3c3c37229a6911b607c"
  end

  on_linux do
    depends_on "util-linux"
    depends_on "vim" # needed for xxd
  end

  def install
    bin.install "transcrypt"
    man1.install "man/transcrypt.1"
    bash_completion.install "contrib/bash/transcrypt"
    zsh_completion.install "contrib/zsh/_transcrypt"
  end

  test do
    system "git", "init"
    system bin/"transcrypt", "--password", "guest", "--yes"

    (testpath/".gitattributes").atomic_write <<~EOS
      sensitive_file  filter=crypt diff=crypt merge=crypt
    EOS
    (testpath/"sensitive_file").write "secrets"
    system "git", "add", ".gitattributes", "sensitive_file"
    system "git", "commit", "--message", "Add encrypted version of file"

    assert_equal `git show HEAD:sensitive_file --no-textconv`.chomp,
                 "U2FsdGVkX198ELlOY60n2ekOK1DiMCLS1dRs53RGBeU="
  end
end
