class Unison < Formula
  desc "File synchronization tool"
  homepage "https://www.cis.upenn.edu/~bcpierce/unison/"
  url "https://github.com/bcpierce00/unison/archive/v2.53.3.tar.gz"
  sha256 "aaea04fc5bc76dcfe8627683c9659ee4c194d4f992cc8aaa15bbb2820fc8de46"
  license "GPL-3.0-or-later"
  head "https://github.com/bcpierce00/unison.git", branch: "master"

  # The "latest" release on GitHub sometimes points to unstable versions (e.g.,
  # release candidates), so we check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9a4aaac47014b8919a63ce4dc0bbf4e57e5c1b21c340b1697115dba51d76e5c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5961703017d485e433beee6cb0f5491b4d458c10b73f4275cb744b9349ac9844"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "88debb88e8993996711464785f00704af7aded6f94b611770105cb95bab25117"
    sha256 cellar: :any_skip_relocation, ventura:        "abbf64f4cc1b14597158f6a3b3e5d00afd5b41367ad9b54d45f061558c4d9f7a"
    sha256 cellar: :any_skip_relocation, monterey:       "152c6043f3d9247b865cc1f54a8557418951dc7f18ad35e9dc7cbb6f836ec798"
    sha256 cellar: :any_skip_relocation, big_sur:        "1ec6db49f80653fc02d1116168061d939cbe94f0f3a46b322438c21a99d44544"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ad0f8b8ef1637646212a7055229d6af2d050f19023ceedc1d65c7ac987bdcc1"
  end

  depends_on "ocaml" => :build

  def install
    ENV.deparallelize
    ENV.delete "CFLAGS" # ocamlopt reads CFLAGS but doesn't understand common options
    ENV.delete "NAME" # https://github.com/Homebrew/homebrew/issues/28642
    system "make", "UISTYLE=text"
    bin.install "src/unison"
    # unison-fsmonitor is built just for Linux targets
    bin.install "src/unison-fsmonitor" if OS.linux?
    prefix.install_metafiles "src"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/unison -version")
  end
end
