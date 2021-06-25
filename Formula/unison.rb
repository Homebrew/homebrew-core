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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "886bb7cc21d57ba77aa8fd33c316868f97c1a4a6e2912d29773d73f79b2cf902"
    sha256 cellar: :any_skip_relocation, big_sur:       "9e558f5f50d452b848b7a1720610e774f1fb3a866e24ee1d106e06f03ce1a24d"
    sha256 cellar: :any_skip_relocation, catalina:      "4c929941f77578e5d78f791078d71d5b8b6553118fa40b1738f433f7af81f486"
    sha256 cellar: :any_skip_relocation, mojave:        "ca5cfeddcf93825743a793623de463d64f393eddfc0740cd530779af782c07d7"
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
