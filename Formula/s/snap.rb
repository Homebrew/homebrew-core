class Snap < Formula
  desc "Tool to work with .snap files"
  homepage "https://snapcraft.io/"
  url "https://github.com/canonical/snapd/releases/download/2.75.2/snapd_2.75.2.vendor.tar.xz"
  version "2.75.2"
  sha256 "b59998e0e7f2b683d04999d968ef29f9b9933cdb2c85ffc83cf1505bc3efccf1"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d42cf3a64a210e39c5b7dfd0899b9367930642e9e28093f81ca817c6c1609e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d42cf3a64a210e39c5b7dfd0899b9367930642e9e28093f81ca817c6c1609e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d42cf3a64a210e39c5b7dfd0899b9367930642e9e28093f81ca817c6c1609e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "f574d6d95a3e4ca73611a6efb6295e89e43d3abc427a19ff92101ec6a38ef4e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da54b1d720f372214c4ff3535a03a173df302c06fe600563b8337d010f864811"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01b6de90fa78de68808e738fb06f389494d32200cba8f87bf713684b7e090b80"
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
