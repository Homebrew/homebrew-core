class Snap < Formula
  desc "Tool to work with .snap files"
  homepage "https://snapcraft.io/"
  url "https://github.com/snapcore/snapd/releases/download/2.59.5/snapd_2.59.5.vendor.tar.xz"
  version "2.59.5"
  sha256 "d2d9efbc2db7fa79edf0c73286320ab5ba039ae30874e88725ef326c618ae5df"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "90f3dc076da75cfc8d1887602aa3f8f08fafd837b3e1fb09ef6a4ba30a29e1b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90f3dc076da75cfc8d1887602aa3f8f08fafd837b3e1fb09ef6a4ba30a29e1b9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "90f3dc076da75cfc8d1887602aa3f8f08fafd837b3e1fb09ef6a4ba30a29e1b9"
    sha256 cellar: :any_skip_relocation, ventura:        "d29d4c12c01ada992c0758b86384944b663398f940843308ebc446ee84cd7f36"
    sha256 cellar: :any_skip_relocation, monterey:       "d29d4c12c01ada992c0758b86384944b663398f940843308ebc446ee84cd7f36"
    sha256 cellar: :any_skip_relocation, big_sur:        "d29d4c12c01ada992c0758b86384944b663398f940843308ebc446ee84cd7f36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fbf7b458fc761186b58606f7ee9a20a079982a82dc00b0c2f24b6b9ec32d979"
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
