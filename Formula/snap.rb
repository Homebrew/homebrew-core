class Snap < Formula
  desc "Tool to work with .snap files"
  homepage "https://snapcraft.io/"
  url "https://github.com/snapcore/snapd/releases/download/2.58/snapd_2.58.vendor.tar.xz"
  version "2.58"
  sha256 "ef3905ba1b27cae409e961db9d5fdfeba17a9b97196e2fe936a9af096561265a"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f5b5202316f386025faa4597d6147638c10879745316fd31d5f4de4a741f183"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42883639b3ca9ce24583a7074756812b6c555bec8d451a289e862d2b5ecb0d1c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bacafde29ea2203e2a0e3a0edf00358fefc3a1dbd2db80b0617e6acdd6ffdbae"
    sha256 cellar: :any_skip_relocation, ventura:        "e70765023eed068557d8ca0d4ac7362affe0324f9902f0c447fd2136c67c2a7d"
    sha256 cellar: :any_skip_relocation, monterey:       "6fbb0dae4e7c2262af2904b4ccb868a5a95d70b9eae46d310d165b311196bef6"
    sha256 cellar: :any_skip_relocation, big_sur:        "91ea1b600a34537e9271487636dc689631cbba4f0a6ac3541d73e46526ce70ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7cc80ed950eb2c1f12df6fdead87e8d9b787322159b2cf319d772eca9475120f"
  end

  depends_on "go" => :build
  depends_on "squashfs"

  def install
    system "./mkversion.sh", version
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
