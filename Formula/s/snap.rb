class Snap < Formula
  desc "Tool to work with .snap files"
  homepage "https://snapcraft.io/"
  url "https://github.com/canonical/snapd/releases/download/2.77.1/snapd_2.77.1.vendor.tar.xz"
  sha256 "10c824694cd9c9954ba7a826d245458d8fa1006d49937fe480dc9f36b57b1efc"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6e685cad43397b00acdcd01bace349c88b0b898d88fd0c47697c2f279c64620d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6e685cad43397b00acdcd01bace349c88b0b898d88fd0c47697c2f279c64620d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6e685cad43397b00acdcd01bace349c88b0b898d88fd0c47697c2f279c64620d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "6e685cad43397b00acdcd01bace349c88b0b898d88fd0c47697c2f279c64620d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d8b67e525a563e09262d4e7d83b7acff6672779dc8203314cff8bb0350fe7166"
    sha256 cellar: :any,                 x86_64_linux:      "ad30adf44f0d7201c9462b22869bd670403bc935120e365bd8e77492b722a725"
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
