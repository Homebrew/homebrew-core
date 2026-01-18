class Unison < Formula
  desc "File synchronization tool"
  homepage "https://www.cis.upenn.edu/~bcpierce/unison/"
  url "https://github.com/bcpierce00/unison/archive/refs/tags/v2.53.8.tar.gz"
  sha256 "d0d30ea63e09fc8edf10bd8cbab238fffc8ed510d27741d06b5caa816abd58b6"
  license "GPL-3.0-or-later"
  head "https://github.com/bcpierce00/unison.git", branch: "master"

  # The "latest" release on GitHub sometimes points to unstable versions (e.g.,
  # release candidates), so we check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e960ee6843d389ce54b269d5b0c3bce094c6bc88a7c11e2d7a6c681307921acc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1fb67a4b1ba39c81f40ea42ae106395d277f2f107d0b285768656e3e9f81661c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "511db162bbfe4c4b56630bc8708ff5830985a3c6495b4b81c153928a41115ee7"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1b1f719237894bf6b5225e28cff289327a0f5d006d19b77796bce4da66149d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25a927077afe54cfca1a4f9241575456e6dd5e8e8be8533334bc42280b76cf98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13617b296ef3577bffa235f06e94cb8c79789b7f55a6b6a5034dbb28e8679ecd"
  end

  depends_on "ocaml" => :build

  conflicts_with cask: "unison-app"

  def install
    system "make"
    system "make", "install", "prefix=#{prefix}"
    bin.install "src/unison"
    bin.install "src/unison-fsmonitor" if OS.linux?
    man1.install "man/unison.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/unison -version")
  end
end
