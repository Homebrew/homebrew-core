class Snap < Formula
  desc "Tool to work with .snap files"
  homepage "https://snapcraft.io/"
  url "https://github.com/canonical/snapd/releases/download/2.70/snapd_2.70.vendor.tar.xz"
  version "2.70"
  sha256 "208c4356e17e96f25f8e5d4cc9c5494157099d15c091a530bb4f260aae9cf88b"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18888d9d87394533c589d566614faf24470207baf4bad96ed9cb048050704d0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18888d9d87394533c589d566614faf24470207baf4bad96ed9cb048050704d0d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "18888d9d87394533c589d566614faf24470207baf4bad96ed9cb048050704d0d"
    sha256 cellar: :any_skip_relocation, sonoma:        "31773df5e4cb9ba3472a985d7e244a48c61e795efae8a239d9db058b03b25d0d"
    sha256 cellar: :any_skip_relocation, ventura:       "31773df5e4cb9ba3472a985d7e244a48c61e795efae8a239d9db058b03b25d0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "813ea89ec7f1009d04175647e0d119285e1ed0872c07c90c406ca6f19ea6dcbf"
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
