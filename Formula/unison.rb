class Unison < Formula
  desc "File synchronization tool for OSX"
  homepage "https://www.cis.upenn.edu/~bcpierce/unison/"
  url "https://github.com/bcpierce00/unison/archive/v2.53.0.tar.gz"
  sha256 "9364477df4501b9c7377e2ca1a7c4b44c1f16fa7cbc12b7f5b543d08c3f0740a"
  license "GPL-3.0-or-later"
  head "https://github.com/bcpierce00/unison.git", branch: "master"

  # The "latest" release on GitHub sometimes points to unstable versions (e.g.,
  # release candidates), so we check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4876cf47609bab458e0471701db69e70324ec022cd59baec2b4792ac67afc47f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07eba0dce086b3c1bfeca8c24046f1744382d8c8b9d7ebb23960a9887e02a870"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f732d4bbeb53c7f2d8fd5f364e358eb63abd351df307f5e18d32e280a081ae2f"
    sha256 cellar: :any_skip_relocation, ventura:        "545fef29b1cdc4d5cd9b8df29fe6239f2fb504c84d6e0efb1896e767be7e6b3b"
    sha256 cellar: :any_skip_relocation, monterey:       "27d35992c23abb1c65c6c89d9d4b9e126725c0230f60c7b5d188954e42922800"
    sha256 cellar: :any_skip_relocation, big_sur:        "27bd65233cafcb9f8f8eb4f4ca8e9339ecc6fcc030a1b463a899a7889d9bc227"
    sha256 cellar: :any_skip_relocation, catalina:       "9ec0303933a284cde4bd5ffe76ad90b2eaba690c14cc36290d4171487c9374c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "732b9db81d32a663a8b3f9ec29bee276ded17abf8a2cddbee7adf51b314db42b"
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
