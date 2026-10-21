class Topgit < Formula
  desc "Git patch queue manager"
  homepage "https://repo.or.cz/topgit/pro.git"
  url "https://github.com/mackyle/topgit/archive/refs/tags/topgit-0.19.14.tar.gz"
  sha256 "0556485ca8ddf0cf863de4da36b11351545aca74fbf71581ffe9f5a5ce0718cb"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "00f58e04cdec33f5f8b5a141443aeba8fd6ceb94bc43b834954dbd40eda37e73"
  end

  deny_network_access!

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    ENV["EDITOR"] = "true"
    system "git", "init", "--initial-branch=main"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "brew@test.bot"
    (testpath/"file").write "hello\n"
    system "git", "add", "file"
    system "git", "commit", "-m", "Initial commit"

    system bin/"tg", "--no-pager", "create", "-m", "t/feature: add feature", "t/feature", "main"
    assert_equal "main", (testpath/".topdeps").read.strip
    assert_match "Subject: [PATCH] t/feature", (testpath/".topmsg").read
  end
end
