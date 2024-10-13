class Unison < Formula
  desc "File synchronization tool"
  homepage "https://www.cis.upenn.edu/~bcpierce/unison/"
  url "https://github.com/bcpierce00/unison/archive/refs/tags/v2.53.5.tar.gz"
  sha256 "330418ad130d93d0e13da7e7e30f9b829bd7c0e859355114bd4644c35fe08d23"
  license "GPL-3.0-or-later"
  head "https://github.com/bcpierce00/unison.git", branch: "master"

  # The "latest" release on GitHub sometimes points to unstable versions (e.g.,
  # release candidates), so we check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c47981d38850764fd73f81c80979b47ed66c25972e023cea0bf23ecdd8ca7616"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1bc7beb7c68255b1a96833771159b02a442420f5319ccc00e410769b3811cebc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "491b323c7ab54cbfa9869735318b6c50996088ca1be9baa21a3bccd4958d2d3b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "574e9f2b018206c744996507e5d9f28bfabdbd0eed6d24a4554620e48074ed42"
    sha256 cellar: :any_skip_relocation, sonoma:         "46c5b9bcf7d54254432ae5ae38a93ddbf0d6fbe13b2ecca1de754105e1d25399"
    sha256 cellar: :any_skip_relocation, ventura:        "97bee1f54eb7abcdd2815bcaf8dd529e8fa296e558c83ebd5415b507e0c79ed0"
    sha256 cellar: :any_skip_relocation, monterey:       "f2cfd8c07ec3d379ecba5a204dfc0bd7802191dedb2adda5ac8d8ab3dbccc75a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d27fcce8ad972cb3d8c678e3410d1ec41f0605504e7da5385f385b02015c05aa"
  end

  depends_on "ocaml" => :build

  def install
    system "make", "src/unison"
    bin.install "src/unison"
    # unison-fsmonitor is built just for Linux targets
    if OS.linux?
      system "make", "src/unison-fsmonitor"
      bin.install "src/unison-fsmonitor"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/unison -version")
  end
end
