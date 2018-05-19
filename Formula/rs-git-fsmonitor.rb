class RsGitFsmonitor < Formula
  desc "Git fsmonitor hook written in Rust"
  homepage "https://github.com/jgavris/rs-git-fsmonitor"

  url "https://github.com/jgavris/rs-git-fsmonitor/releases/download/v0.1.0/rs-git-fsmonitor"
  sha256 "4faf1723ea75a76e0dd6187d5a3e9074fd5e93dd13f1024843d4ed256ff689e8"

  depends_on "watchman"

  def install
    bin.install "rs-git-fsmonitor"
  end

  def post_install
    ohai "Run `git config --global core.fsmonitor rs-git-fsmonitor` to install!"
  end

  test do
    system "git init . && git config core.fsmonitor rs-git-fsmonitor && git status"
  end
end
