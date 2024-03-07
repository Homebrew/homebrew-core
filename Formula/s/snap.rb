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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3b0f833485e49e8ba9e0aaf615aa32e51d2456205cc618276706c3a75ceb5aac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c3033a868245b5b7c6456396db4088160c3a7f3e8b22578cb5d3868b2347c1e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85efbec5d5210d34733f628dd1c7ba3437113abc9dd5a270c2d8249acc14c759"
    sha256 cellar: :any_skip_relocation, sonoma:         "7be2ad4cdb885a5db18d5acfeff524747c2cd9963484c695741cadf4ee292f4f"
    sha256 cellar: :any_skip_relocation, ventura:        "f80aa2fb514436f9b9eb12de99e17a9a6819eec49c34173344939e6e58c16557"
    sha256 cellar: :any_skip_relocation, monterey:       "c523f118cd1b0c32e957cd4d5078ead8206e5d790ba507b873b1e0f28df862fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cae6876f836121d3b4f876993e5b09e6ecd7d6046782bb62ca57344254d116df"
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
