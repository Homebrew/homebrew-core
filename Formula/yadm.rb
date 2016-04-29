class Yadm < Formula
  desc "Yet Another Dotfiles Manager"
  homepage "https://github.com/TheLocehiliosan/yadm"
  url "https://github.com/TheLocehiliosan/yadm/archive/1.04.tar.gz"
  sha256 "a73aa51245866ce67aeb4322a62995ebbb13f29dc35508f486819dceb534968a"

  def install
    bin.install "yadm"
    man1.install "yadm.1"
  end

  test do
    # init a new repo
    system "yadm", "init"
    unless File.exist?("#{testpath}/.yadm/repo.git/config")
      onoe "Failed to init repository"
      return false
    end

    # confirm worktree set to $HOME
    ohai "Verify repo worktree"
    worktree = `yadm gitconfig core.worktree`
    if worktree.chomp != testpath.to_s
      onoe "Repo worktree is set incorrectly"
      return false
    end

    # disable auto-alt
    system "yadm", "config", "yadm.auto-alt", "false"
    ohai "Verify auto-alt configuration"
    setting = `yadm config yadm.auto-alt`
    if setting.chomp != "false"
      onoe "auto-alt was not set"
      return false
    end

    # create a test file, and add it to the repo
    File.write("#{testpath}/testfile", "test")
    system "yadm", "add", "#{testpath}/testfile"

    # configure git identity
    system "yadm", "gitconfig", "user.email", "test@test.org"
    system "yadm", "gitconfig", "user.name", "Test User"

    # commit the test file to the repo
    system "yadm", "commit", "-m", "test commit"

    # verify the log
    ohai "Verify repo log"
    commit = `yadm log --pretty=oneline`
    unless commit.chomp =~ /test commit$/
      onoe "Repository log is not correct"
      return false
    end
  end
end
