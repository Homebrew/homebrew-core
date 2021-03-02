class Unison < Formula
  desc "File synchronization tool for OSX"
  homepage "https://www.cis.upenn.edu/~bcpierce/unison/"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/bcpierce00/unison.git", branch: "master"

  stable do
    url "https://github.com/bcpierce00/unison/archive/v2.51.3.tar.gz"
    sha256 "0c287d17f52729440b2bdc28edf4d19b2d5ea5869983d78e780d501c5866914b"

    # Patch to fix build with ocaml 4.12. Remove when one of
    # https://github.com/bcpierce00/unison/pull/480 or
    # https://github.com/bcpierce00/unison/pull/481
    # is merged and lands in a release.
    patch do
      url "https://github.com/bcpierce00/unison/compare/6d7a131bcf5e03cc7468d08c61379b350472c7e2..6dd7e7f96d4a7d7a356f3c2cff2baa6c14bf13af.patch?full_index=1"
      sha256 "7a6936c0ffda056521e433e5b9a5d1a8a45669869336a10203c339dc99dfb7f1"
    end
  end

  # The "latest" release on GitHub sometimes points to unstable versions (e.g.,
  # release candidates), so we check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0d8067436f39ee938090e49ccabbd11f038065a27db1f6ad7cefa695a14fc04d"
    sha256 cellar: :any_skip_relocation, big_sur:       "c9abac8ba99bb85b7b2cbadf76dedcf1d786f047dc4e37aecc0cd80751fd8ed2"
    sha256 cellar: :any_skip_relocation, catalina:      "cea7b5893ed3a5f39b599b98f244e8d6146cb7700fb19883667e61f9a4390b4c"
    sha256 cellar: :any_skip_relocation, mojave:        "3c49a17f14f649b88c1188e43a6f82b05e233b79ba567b1ca702c147ba1e5950"
    sha256 cellar: :any_skip_relocation, high_sierra:   "1cdf5ae09de5f39426ef22f01284d7b4a1a5a792812b5fa14f76ba188b33ed55"
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
