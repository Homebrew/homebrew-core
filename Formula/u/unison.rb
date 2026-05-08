class Unison < Formula
  desc "File synchronization tool"
  homepage "https://www.cis.upenn.edu/~bcpierce/unison/"
  url "https://github.com/bcpierce00/unison/archive/refs/tags/v2.54.0.tar.gz"
  sha256 "0f14154611a2dfebb8c229be85ceda29a750eace4fb75d06e0d43fe5b58a6e87"
  license "GPL-3.0-or-later"
  head "https://github.com/bcpierce00/unison.git", branch: "master"

  # The "latest" release on GitHub sometimes points to unstable versions (e.g.,
  # release candidates), so we check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a0f9bceeead6c636d254f70e640f5127a8f81604bae15f7a43d909822923222"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0b0b57bb93e181c0766094af21e01948e5fc15f7e8e1b7b8449c8588f7c4271"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce5ba2ed810b2d7a8b0c1119ae9fb88e2913a46997803ca59045e1a5fc6b43f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "d519631a323975d9b54c496160541ebb6f9ae17dd02aef6dc5b9098164250edc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "596de82a3498aa48ce6a308aa0c3af55b09bfe5242bb916358bdcd6865db9e52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2cd9a82fc057cbcb2a051e81f4d9feccdfa329ae393a41d720ef68d4ce69b0c"
  end

  depends_on "ocaml" => :build

  conflicts_with cask: "unison-app"

  def install
    system "make"
    system "make", "install", "prefix=#{prefix}"
    bin.install "src/unison"
    bin.install "src/unison-fsmonitor" if OS.linux?
    man1.install "man/unison.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/unison -version")
  end
end
