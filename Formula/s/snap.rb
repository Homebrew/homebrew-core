class Snap < Formula
  desc "Tool to work with .snap files"
  homepage "https://snapcraft.io/"
  url "https://github.com/snapcore/snapd/releases/download/2.60.4/snapd_2.60.4.vendor.tar.xz"
  version "2.60.4"
  sha256 "205873c2a16c9d3e60230d543d16ee4acf1a3c34cf6aeb1a1367341f64cced3a"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5520998dc2b76ca018634eeec0061fbf577dd0922740ed7fce80ad9138dfefe7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d735dc3fa8668a0c36ce79ebf204d0e5ccffaca9ed701462d264c09c0f51f85"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "33a9f0228ecf4b25788aa11abcde1a512cc3b54dd46106cde2b484b17bc211da"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6933ad0b4085ac7c643a902d5c6878e232ba774e17d52fd005db6f758300ce8d"
    sha256 cellar: :any_skip_relocation, sonoma:         "196f996a4f48279ec5869c1f9c9fee4eb982e732e36de86e2826d0cccd73b5eb"
    sha256 cellar: :any_skip_relocation, ventura:        "eee036ab7bf4d3566716f29ad2a1a457c96dd7ea79c3fc5c7b264a0a354437bc"
    sha256 cellar: :any_skip_relocation, monterey:       "7ac99365093c320f119c4a49010742bf31da8a13e04c86420abf7eec7aa8befb"
    sha256 cellar: :any_skip_relocation, big_sur:        "d885f73fe9afd6a0ab9c4c62b7f37a6db0ff9d53b2cdb0c9f6dffa3995ae295f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ca3e426acd7f06f67f0703fcae7c6350b719d2c88cf5cbd08ee394c5f44ca50"
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
