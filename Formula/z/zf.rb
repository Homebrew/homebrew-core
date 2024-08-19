class Zf < Formula
  desc "Command-line fuzzy finder that prioritizes matches on filenames"
  homepage "https://github.com/natecraddock/zf"
  url "https://github.com/natecraddock/zf/archive/refs/tags/0.9.2.tar.gz"
  sha256 "61a4db245213f0319dfb34758f5c9c00d4945d7ae6187a6220e88ebef95e4494"
  license "MIT"
  head "https://github.com/natecraddock/zf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9fb3944d6fb6defa3210dd591eff538907deacd378c1f9860e187ef583be70c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9cbb27192181a06a7e321d69fe6ba0807a52fff1b976f425ec7f837b82d1996b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bbf62578bf402b17a2a301147279c8a506caf3a49bc866cb80f9d7c4318a819e"
    sha256 cellar: :any_skip_relocation, sonoma:         "3067a59bc1cf96fb4c23e9e7e979e718fb6433ff7af5546999aaa68f6854caf7"
    sha256 cellar: :any_skip_relocation, ventura:        "ec30ca6b342eaa6f60d58c4e08a9c17e15a067ac64be64ff89002afa0c17db66"
    sha256 cellar: :any_skip_relocation, monterey:       "7f0b243a445a5b1f6f8b50dce59d90d2ad1eecedcc7336b4ef79bb15850b2536"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80d814cfbec3960bded5362897a70add2b14500c60e8e33384fd92d1672937c6"
  end

  depends_on "zig" => :build

  def install
    system "zig", "build", "-Doptimize=ReleaseSafe"

    bin.install "zig-out/bin/zf"
    man1.install "doc/zf.1"
    bash_completion.install "complete/zf"
    fish_completion.install "complete/zf.fish"
    zsh_completion.install "complete/_zf"
  end

  test do
    assert_equal "zig", pipe_output("#{bin}/zf -f zg", "take\off\every\nzig").chomp
  end
end
