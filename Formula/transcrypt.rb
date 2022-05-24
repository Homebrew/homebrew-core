class Transcrypt < Formula
  desc "Configure transparent encryption of files in a Git repo"
  homepage "https://github.com/elasticdog/transcrypt"
  url "https://github.com/elasticdog/transcrypt/archive/v2.1.0.tar.gz"
  sha256 "0075a25f7fb48ddfcfb33dd834a5f12fe0644ed4fb5ab0a5f2f7dca06e9ed48c"
  license "MIT"
  head "https://github.com/elasticdog/transcrypt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a5cfd2ec236ba342258bf5119e96dd721c5669370094192ef3389146a62ae53b"
  end

  def install
    bin.install "transcrypt"
    man.install "man/transcrypt.1"
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
