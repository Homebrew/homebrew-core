class Snap < Formula
  desc "Tool to work with .snap files"
  homepage "https://snapcraft.io/"
  url "https://github.com/canonical/snapd/releases/download/2.72/snapd_2.72.vendor.tar.xz"
  version "2.72"
  sha256 "53d74e663527bae667a254da8a029aa4b0b8f559ca515d214da8dbb29dc6ccc7"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "86dc875741ee770bd69ab163a4136a2c5473583bdf0aacf3a2b499a8333d67b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86dc875741ee770bd69ab163a4136a2c5473583bdf0aacf3a2b499a8333d67b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86dc875741ee770bd69ab163a4136a2c5473583bdf0aacf3a2b499a8333d67b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "570b5ae1a3b9cce1573b40577579b3e9152432f3db910ed9f9a360dacf17d87e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "afb2682fd94c0b3a524f772a6ffd0f5e4226a05a95e3a694e2c51ffd788a6cb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "041b2f5e10b2d2bf8b4717c9ec8a1ad4db373fe66924b9c74ab88ef579eb8320"
  end

  depends_on "go" => :build
  depends_on "squashfs"

  def install
    system "./mkversion.sh", version.to_s
    tags = OS.mac? ? "nosecboot" : ""
    system "go", "build", *std_go_args(ldflags: "-s -w", tags:), "./cmd/snap"

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
