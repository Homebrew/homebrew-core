class Snap < Formula
  desc "Tool to work with .snap files"
  homepage "https://snapcraft.io/"
  url "https://github.com/snapcore/snapd/releases/download/2.63/snapd_2.63.vendor.tar.xz"
  version "2.63"
  sha256 "2f0083d2c4e087c29f48cd1abb8a92eb2e63cf04cd433256c86fac05d0b28cab"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b88b62f11f16b5e6d649aae10125d8c48c8d60f738f864883f2826b50f6c1c27"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "27662255bc64b50490e53dd28104a8d48275c21a9ec72d617a67d97c7cd0866e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a4ba7f434be6f082de5545a427a5662c6a93a01fc93d46275f8a3f6954d24ac"
    sha256 cellar: :any_skip_relocation, sonoma:         "4a1fe1d570861cf20e982612c669d9d48685ae09cd97b135e93e1149223bde31"
    sha256 cellar: :any_skip_relocation, ventura:        "0c428cf681c7b9944debe444a32e8d75fe5d62eed04bcd52c94daa0e27ea510c"
    sha256 cellar: :any_skip_relocation, monterey:       "0195e1f59ebe8bd55fbc137fa6fbef84b0385a99197c43adf982856d9c8bf2f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ee57d1b96b71e18ccc13669c75abe3c53c77d8b19a7aff7ca69edfe0be24f83"
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
