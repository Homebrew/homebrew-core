class Unison < Formula
  desc "File synchronization tool for OSX"
  homepage "https://www.cis.upenn.edu/~bcpierce/unison/"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/bcpierce00/unison.git", branch: "master"

  stable do
    url "https://github.com/bcpierce00/unison/archive/v2.51.3.tar.gz"
    sha256 "0c287d17f52729440b2bdc28edf4d19b2d5ea5869983d78e780d501c5866914b"

    # Patch to fix build with ocaml 4.12. Remove in 2.51.4
    # https://github.com/bcpierce00/unison/pull/481
    patch do
      url "https://github.com/bcpierce00/unison/commit/14b885316e0a4b41cb80fe3daef7950f88be5c8f.patch?full_index=1"
      sha256 "6d498d5e21d77cbc83ffc533c93cfa2f2ea30ab1b991b16e612e1d09a20efc8e"
    end
  end

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
