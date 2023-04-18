class Unison < Formula
  desc "File synchronization tool"
  homepage "https://www.cis.upenn.edu/~bcpierce/unison/"
  url "https://github.com/bcpierce00/unison/archive/v2.53.2.tar.gz"
  sha256 "fb337c221722e496916b385e50e99a49604b8aed3f5fafcc45029c1d2aa1232b"
  license "GPL-3.0-or-later"
  head "https://github.com/bcpierce00/unison.git", branch: "master"

  # The "latest" release on GitHub sometimes points to unstable versions (e.g.,
  # release candidates), so we check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79a1bb6802db87bdeac3624e00bba440110b8c42debfa2df5da7c9082129d62e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b573b165ac2d9e1c2cc8426913028bccc0c9756937854a6a3eb9628a5e2659d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2491ac393ce06e0eb5f7c0c62375cdf2c13913f2b5161600f4135e73b43fe0b6"
    sha256 cellar: :any_skip_relocation, ventura:        "f05093b253ad071c4310b9604540c788855e2e3bd5c196220e04bbe7be29775e"
    sha256 cellar: :any_skip_relocation, monterey:       "ae890e264a2fecdc32f904d24a629d003b71bd9e5b1290c4665712e808358309"
    sha256 cellar: :any_skip_relocation, big_sur:        "56c51d092341617459be8ab014510594664697f6f2698d09a89a19792bbc2b53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "129a226fd9dc78a2c70a6d6fd4712619591d167f3bf3c3a97c71788ec6fdef33"
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
