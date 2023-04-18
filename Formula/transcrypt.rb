class Transcrypt < Formula
  desc "Configure transparent encryption of files in a Git repo"
  homepage "https://github.com/elasticdog/transcrypt"
  url "https://github.com/elasticdog/transcrypt/archive/v2.2.3.tar.gz"
  sha256 "69cf95b2a4d7e89c1f5c84bc4c32aa35f78d08b8f457a003ab9e8be7361a24e5"
  license "MIT"
  head "https://github.com/elasticdog/transcrypt.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "9225e648b7de3cb419e614fba90da064d60da9e980d1e85556fe4a4985fc3e69"
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
