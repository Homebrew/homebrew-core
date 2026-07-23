class Transcrypt < Formula
  desc "Configure transparent encryption of files in a Git repo"
  homepage "https://github.com/elasticdog/transcrypt"
  url "https://github.com/elasticdog/transcrypt/archive/refs/tags/v2.3.2.tar.gz"
  sha256 "e28676a8ef781046c16b6c34acdb44b66b6d382d9c20cb810c883cc5be20dd28"
  license "MIT"
  head "https://github.com/elasticdog/transcrypt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6d5f9dcdb81fe65ac02f51170775e05937a44dd52f44c394e889df56c79cc1da"
  end

  on_linux do
    depends_on "util-linux"
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
