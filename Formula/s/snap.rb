class Snap < Formula
  desc "Tool to work with .snap files"
  homepage "https://snapcraft.io/"
  url "https://github.com/canonical/snapd/releases/download/2.77/snapd_2.77.vendor.tar.xz"
  sha256 "e74fc1a761f8ac1b80f2df0e634f14f729ee5cee17b7724619d6b1c5be52d264"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71fac7969d5748b5d9698be9c0b27b26cbde53a44796ace7d6cde72ce244cf6d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71fac7969d5748b5d9698be9c0b27b26cbde53a44796ace7d6cde72ce244cf6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71fac7969d5748b5d9698be9c0b27b26cbde53a44796ace7d6cde72ce244cf6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ac3f7d654c6fac685f88445a8b41a1c014bb17c7517ff4f75f9002aca06036b"
    sha256 cellar: :any,                 x86_64_linux:  "4f299e48a5ff0599dd8dcb7e1ad77d1363961f252dddf1f509c52d909a0ee562"
  end

  depends_on "go" => :build
  depends_on "squashfs"

  def install
    # 2.77's vendor tarball wraps the source in an extra directory, unlike the packing scripts
    work_dir = File.directory?("snapd-#{version}") ? "snapd-#{version}" : "."

    cd work_dir do
      # TODO: Drop when a release tarball ships a `vendor` synced with `go.mod`.
      inreplace "mkversion.sh", "MOD=-mod=vendor", "MOD=-mod=mod"

      system "./mkversion.sh", version.to_s
      tags = OS.mac? ? "nosecboot" : ""

      system "go", "build", "-mod=mod", *std_go_args(tags:), "./cmd/snapd"

      bash_completion.install "data/completion/bash/snap"
      zsh_completion.install "data/completion/zsh/_snap"
    end

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
