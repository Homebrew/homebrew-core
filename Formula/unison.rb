class Unison < Formula
  desc "File synchronization tool for OSX"
  homepage "https://www.cis.upenn.edu/~bcpierce/unison/"
  url "https://github.com/bcpierce00/unison/archive/v2.51.3.tar.gz"
  sha256 "0c287d17f52729440b2bdc28edf4d19b2d5ea5869983d78e780d501c5866914b"
  license "GPL-3.0-or-later"
  head "https://github.com/bcpierce00/unison.git", branch: "master"

  # The "latest" release on GitHub sometimes points to unstable versions (e.g.,
  # release candidates), so we check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "c9abac8ba99bb85b7b2cbadf76dedcf1d786f047dc4e37aecc0cd80751fd8ed2" => :big_sur
    sha256 "cea7b5893ed3a5f39b599b98f244e8d6146cb7700fb19883667e61f9a4390b4c" => :catalina
    sha256 "3c49a17f14f649b88c1188e43a6f82b05e233b79ba567b1ca702c147ba1e5950" => :mojave
    sha256 "1cdf5ae09de5f39426ef22f01284d7b4a1a5a792812b5fa14f76ba188b33ed55" => :high_sierra
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
