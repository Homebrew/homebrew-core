class Snap < Formula
  desc "Tool to work with .snap files"
  homepage "https://snapcraft.io/"
  url "https://github.com/snapcore/snapd/releases/download/2.68.4/snapd_2.68.4.vendor.tar.xz"
  version "2.68.4"
  sha256 "8c6ad7ee2c2a4cb5b59f836a74843cf8337e692dddd33b85c17418e7a6837e80"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d00577e7b065d60a904fd3d2440d0f828f71383328d58c753d79b126b26be6a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d00577e7b065d60a904fd3d2440d0f828f71383328d58c753d79b126b26be6a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d00577e7b065d60a904fd3d2440d0f828f71383328d58c753d79b126b26be6a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed7559f5fa50c1d060831bbf90aad89d8fcfec654a05270c5b4579940d11fca6"
    sha256 cellar: :any_skip_relocation, ventura:       "ed7559f5fa50c1d060831bbf90aad89d8fcfec654a05270c5b4579940d11fca6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4642c82c0bd41d83f84178722d542686ed5ceea89ceb3f10d38acbce9433a6d8"
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
    (testpath/"pkg/meta/snap.yaml").write <<~YAML
      name: test-snap
      version: 1.0.0
      summary: simple summary
      description: short description
    YAML
    system bin/"snap", "pack", "pkg"
    system bin/"snap", "version"
  end
end
