class Snap < Formula
  desc "Tool to work with .snap files"
  homepage "https://snapcraft.io/"
  url "https://github.com/snapcore/snapd/releases/download/2.61.3/snapd_2.61.3.vendor.tar.xz"
  version "2.61.3"
  sha256 "90d427ca0a0e1306e647c6091176fba678522e2af04228aa274a34d011c82123"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3dc902ced8a73872806ff3da46a728e96a0f0ddb41581ad120a58e08f8847fe5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "42f8c51ccc42bfb2ceaec708016facf3e2992f2c2d97cb1855a7c3bf3d7b6ecb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "539ac01a7fff548f57d1ced1c118e10be820ddd3fdbf825b04774a49692849a2"
    sha256 cellar: :any_skip_relocation, sonoma:         "a16e3b5d6e988356824fa45cf98882fb776a80d2d03dacd026a465a55f046b7c"
    sha256 cellar: :any_skip_relocation, ventura:        "2eb4b5b78c76fbfa72cae2de3f422c043b8b4b26fad1bbbd38a1da876ebc0db8"
    sha256 cellar: :any_skip_relocation, monterey:       "be86f37010aa21011462084c0bb47333998d8081ff27522f3677b2961cbe645a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef4f425ba237aadb6ad8d3e330cf8529fb74c3b371ae3ec4bdfba4a8289435c0"
  end

  depends_on "go" => :build
  depends_on "squashfs"

  def install
    system "./mkversion.sh", version.to_s
    tags = OS.mac? ? ["-tags=nosecboot"] : []
    system "go", "build", *std_go_args(ldflags: "-s -w"), *tags, "./cmd/snap"

    bash_completion.install "data/completion/bash/snap"
    zsh_completion.install "data/completion/zsh/_snap"

    (man8/"snap.8").write Utils.safe_popen_read(bin/"snap", "help", "--man")
  end

  test do
    (testpath/"pkg/meta").mkpath
    (testpath/"pkg/meta/snap.yaml").write <<~EOS
      name: test-snap
      version: 1.0.0
      summary: simple summary
      description: short description
    EOS
    system bin/"snap", "pack", "pkg"
    system bin/"snap", "version"
  end
end
