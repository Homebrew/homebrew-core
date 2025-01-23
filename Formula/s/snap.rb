class Snap < Formula
  desc "Tool to work with .snap files"
  homepage "https://snapcraft.io/"
  url "https://github.com/snapcore/snapd/releases/download/2.67/snapd_2.67.vendor.tar.xz"
  version "2.67"
  sha256 "8c069713bb3a62201d64cec795c247e006673914f92b0bef3add0e5ff379716f"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "896c9540e3bee132ff2f6a58de91fa212e8a7d44a5d5ecccb1a0aacb0e2c297f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "896c9540e3bee132ff2f6a58de91fa212e8a7d44a5d5ecccb1a0aacb0e2c297f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "896c9540e3bee132ff2f6a58de91fa212e8a7d44a5d5ecccb1a0aacb0e2c297f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9ea8df0aae43c8a78e15ab84544e2554ee6219d52a34b9a87608d986d965d4d"
    sha256 cellar: :any_skip_relocation, ventura:       "a9ea8df0aae43c8a78e15ab84544e2554ee6219d52a34b9a87608d986d965d4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0461900f8e74f4b8edc5d86615fa5412772b780151b7be99d4b4ce069d8ac6b5"
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
