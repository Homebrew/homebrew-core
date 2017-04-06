class Transcrypt < Formula
  desc "Configure transparent encryption of files in a Git repo"
  homepage "https://github.com/elasticdog/transcrypt"
  url "https://github.com/elasticdog/transcrypt/archive/v1.0.2.tar.gz"
  sha256 "4350829b85d267d0b10e913ca6e4ad11c86dca842b99d6cb63b74967c54ebd49"
  head "https://github.com/elasticdog/transcrypt.git"

  bottle :unneeded

  def install
    bin.install "transcrypt"
    man.install "man/transcrypt.1"
    bash_completion.install "contrib/bash/transcrypt"
    zsh_completion.install "contrib/zsh/_transcrypt"
  end

  test do
    system "git", "init"
    system bin/"transcrypt", "--password", "guest", "--yes"

    (testpath/".gitattributes").atomic_write <<-EOS.undent
      sensitive_file  filter=crypt diff=crypt
    EOS
    (testpath/"sensitive_file").write "secrets"
    system "git", "add", ".gitattributes", "sensitive_file"
    system "git", "commit", "--message", "Add encrypted version of file"

    assert_equal `git show HEAD:sensitive_file --no-textconv`.chomp,
                 "U2FsdGVkX1/BC5TmOtJ9kCgCq4EmYX0crGU7mAIhDEA="
  end
end
