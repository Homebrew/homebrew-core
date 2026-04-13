class Tml < Formula
  desc "Tiny markup language for terminal output"
  homepage "https://github.com/liamg/tml"
  url "https://github.com/liamg/tml/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "45824c36e810c568365d7f04c69900a0ef1abb46644f94a054cfe2d160999320"
  license "Unlicense"
  head "https://github.com/liamg/tml.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10b34badd3fef44e0bf17c4b4c82a136d08f4ad72fb80037b5897f338a683464"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10b34badd3fef44e0bf17c4b4c82a136d08f4ad72fb80037b5897f338a683464"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10b34badd3fef44e0bf17c4b4c82a136d08f4ad72fb80037b5897f338a683464"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b24f741548871912f5a3528e28b5cc992e4ae75d194e4598c27d506f2700a4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9f31aae22bfb77db6c3d0541ebd2917baafcc96d2bbbf3937b5a482cfb0de47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e8917c0a83fd27f6c87020f2279523fefd4ebbcdc479802b6caac90a3e532c9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./tml"
  end

  test do
    output = pipe_output(bin/"tml", "<green>not red</green>", 0)
    assert_match "\e[0m\e[32mnot red\e[39m\e[0m", output
  end
end
