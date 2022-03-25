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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98cdf34ea44465871eb5338eb26b480b96ace1192e54d6c7db997bd2d486cc50"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3ac8d5f306f4079a4c148bc1bc93b32533b1e4d48144a04255896111e0361aa1"
    sha256 cellar: :any_skip_relocation, monterey:       "460e6a4e07b3ee795ca91f920064c223a4b68649c63abe3bd2d98f6b38cf4116"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad4e0217401e1790e575a5d78c118bcc0c0602d32e6c2f8569edf7ae6cb1efeb"
    sha256 cellar: :any_skip_relocation, catalina:       "82f848e724776d1dffc4f1ed6fa48500bb44714ed8096ab1a571c524ea6afcfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c89c81b1b16caf7fa1cd2feb8e7c77481aaa96dacaf0b1cda7d4ab0b6282af74"
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
