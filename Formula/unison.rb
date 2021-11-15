class Unison < Formula
  desc "File synchronization tool for OSX"
  homepage "https://www.cis.upenn.edu/~bcpierce/unison/"
  url "https://github.com/bcpierce00/unison/archive/v2.51.4.tar.gz"
  sha256 "d1ecc7581aaf2ed0f3403d4960f468acd7b9f1d92838a17c96e6d1df79b802d5"
  license "GPL-3.0-or-later"
  head "https://github.com/bcpierce00/unison.git", branch: "master"

  # The "latest" release on GitHub sometimes points to unstable versions (e.g.,
  # release candidates), so we check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "260e6cedb0f4d926748585c96f3bb69ca1a1f4f4a25c921278d9fe860b9a8884"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "38e7fb0ba3af85a957f7680b349fdcfcad50c47f6bd5970bbff40c52435550e9"
    sha256 cellar: :any_skip_relocation, monterey:       "4ced783c06aece3da00ad95db945bb797d618bffc7d25a89723a5ce0961db36a"
    sha256 cellar: :any_skip_relocation, big_sur:        "4e0e92dbed77b5a10ccaf2ed146707fc92d1332d3063b7495f381aff79a312ee"
    sha256 cellar: :any_skip_relocation, catalina:       "c792e2e2a701edd6f6a4f855ec0053567d4cdc424e369fcb51a9659563e8bd43"
    sha256 cellar: :any_skip_relocation, mojave:         "f2df486827594d32b05b5ac1c1976aebd47938f7ea6d1c6ae6e70a19ab3e0588"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c336751c0cd7e7ec4c0a37c064033082ee8b7f2dc4fafa7c768c6aba2e75209"
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
