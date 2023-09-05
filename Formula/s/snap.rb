class Snap < Formula
  desc "Tool to work with .snap files"
  homepage "https://snapcraft.io/"
  url "https://github.com/snapcore/snapd/releases/download/2.60.3/snapd_2.60.3.vendor.tar.xz"
  version "2.60.3"
  sha256 "c65d6a23288195864ac11997475234b8c15a5e14849f3ab309ccba4832675bc4"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7379f593b6aef734ef469ce7ac30eaee7ce2102590b108fdcfbce87d83a4e8ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "663dee5650b3cfe580498d654e6aeec144a542d15944966bc23aaa9ab29f2753"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e8fab2364c2e781883b2b8e8dd830319e084a034043a0850c1bceadf6f1d6165"
    sha256 cellar: :any_skip_relocation, ventura:        "b6c3181049a17763dddfdd16fdb446c8887f0bc2fdeeb7ec089cbacd708f19ac"
    sha256 cellar: :any_skip_relocation, monterey:       "d72a4910c27ed09b3e40094bc6188207826e92b78c69e2cf86a8c3f332ae5105"
    sha256 cellar: :any_skip_relocation, big_sur:        "25da4709417f8e15ab17e130e05b3aa51f05cca8c566c8bde37c70113b481c4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84137f0dcbed0809b03c67abd6bd4b5eada1cc64db5999b21623cf7fe0a815ed"
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
