class Senpai < Formula
  desc "Modern terminal IRC client"
  homepage "https://sr.ht/~delthas/senpai/"
  url "https://git.sr.ht/~delthas/senpai/archive/v0.5.0.tar.gz"
  sha256 "1793259dca5321f1365cae9d24316d5d4cd01df648d895eaa03eacb49f433db8"
  license "MIT"
  head "https://git.sr.ht/~delthas/senpai", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5724cc8895caf1ae2551df3008691d90aebe3b2ea8101008116a0e93dd314d91"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6dd4c3925c12a40411fec2abf6eb9f7287fc8fdf941d2bb20bce3153b5926220"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac2209b8b407f6561ad23cb6126620c76155ee468d00a0a2ec14a3fc7b3d9be9"
    sha256 cellar: :any_skip_relocation, sonoma:        "c611bebb1863f41db55d470baba39d73a10c29c47e07b21f0363cd69d0550f3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f4136cbdeea29e109e05b058bfa2aa916da0f4e3bc2f5a9bb0ef7f0d2116296"
    sha256 cellar: :any,                 x86_64_linux:  "0fe721097a47263dfe04462d6d81fae32ef8fbdb29ad234d6c534e8944693d1a"
  end

  depends_on "go" => :build
  depends_on "scdoc" => :build

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    require "pty"

    stdout, _stdin, _pid = PTY.spawn bin/"senpai"
    _ = stdout.readline
    assert_equal "Configuration assistant: senpai will create a configuration file for you.\r\n", stdout.readline
  end
end
