class Snap < Formula
  desc "Tool to work with .snap files"
  homepage "https://snapcraft.io/"
  url "https://github.com/canonical/snapd/releases/download/2.78/snapd_2.78.vendor.tar.xz"
  sha256 "197d5e5870ae7f3681276cea37339d5ee528ddfaf47f53509f858fdad46e4aed"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "112d74d57a132f26cc59d79dde3d0692c011c6f30730c54749f4623cd0a4980d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "112d74d57a132f26cc59d79dde3d0692c011c6f30730c54749f4623cd0a4980d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "112d74d57a132f26cc59d79dde3d0692c011c6f30730c54749f4623cd0a4980d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7642a16c28ab449a9994175f6fa1955ba0d85a950d609385ac293ba6c04fe35b"
    sha256 cellar: :any,                 x86_64_linux:      "6a6843b0b9758a1dbf2d0e08adc27cefa332dcd999af79f90f5e18437b5d6532"
  end

  depends_on "go" => :build
  depends_on "squashfs"

  deny_network_access!

  def fetch
    work_dir = File.directory?("snapd-#{version}") ? "snapd-#{version}" : "."
    system "go", "mod", "download", "-C", work_dir
  end

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
