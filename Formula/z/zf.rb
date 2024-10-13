class Zf < Formula
  desc "Command-line fuzzy finder that prioritizes matches on filenames"
  homepage "https://github.com/natecraddock/zf"
  url "https://github.com/natecraddock/zf/archive/refs/tags/0.10.0.tar.gz"
  sha256 "a90b2fff1d552910897487d177eaf92176e421f097ad61c70b8f8b127deef160"
  license "MIT"
  head "https://github.com/natecraddock/zf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c824a72623a674d8dbe50d80ee58fc4d8bb272ef16a05a94e578a2ec5be748d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3016fd4bf9b8a183a887bb161cf145eb652ec4abb549bb64e69dbf5c933c1cab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fe3352412d017d5f0e9dd198b966992d052186c571217043f67b9d5992b0911a"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b72ba9015474fcbf3311f1d37156b33e22852ceafd4905ba6a9297b74e85ae7"
    sha256 cellar: :any_skip_relocation, ventura:       "ce4cf093fbbdbbb268b012d6101eb425033c3384fc7ede3dc134d835cb42522b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcccdbf61136c05f27b9f445bf688fb0580de144e675b824a428455496762531"
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
