class Unison < Formula
  desc "File synchronization tool for OSX"
  homepage "https://www.cis.upenn.edu/~bcpierce/unison/"
  url "https://github.com/bcpierce00/unison/archive/v2.52.0.tar.gz"
  sha256 "a11389971212915328fe69101c92737b17664595c4318ebcb8da367e5ba63540"
  license "GPL-3.0-or-later"
  head "https://github.com/bcpierce00/unison.git", branch: "master"

  # The "latest" release on GitHub sometimes points to unstable versions (e.g.,
  # release candidates), so we check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6708703bc473fec70991986b29995fe5b5f16108c1daa6dbf8fc5773881c11b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c47453424e949fb1369488d0f7b80a396eaeedb97acd18b93e74511af9d3599f"
    sha256 cellar: :any_skip_relocation, monterey:       "d93c4b01a596ec212fffc305f85d3936b2813dc2c1fdb4255c240d817af8f3f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "15858ff4db4275fc86dc3beaa7a6385da17ec3a4cc658a3a9925a1b12f2dfb59"
    sha256 cellar: :any_skip_relocation, catalina:       "0c8b38ba29e04247cd884c721e3ab3400d8cbbe461f8c1bf1d971e7a9ba4a758"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a970a746e60e844ec603e136df485f4748f9089dc31df72242dbcfaa8b8a1c23"
  end

  depends_on "ocaml" => :build

  def install
    ENV.deparallelize
    ENV.delete "CFLAGS" # ocamlopt reads CFLAGS but doesn't understand common options
    ENV.delete "NAME" # https://github.com/Homebrew/homebrew/issues/28642
    system "make", "UISTYLE=text"
    bin.install "src/unison"
    prefix.install_metafiles "src"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/unison -version")
  end
end
