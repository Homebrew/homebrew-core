class Semrel < Formula
  desc "Semantic release system with plugin architecture and VSC integration"
  homepage "https://www.semrel.io"
  url "https://github.com/SemRels/semrel/archive/refs/tags/v0.26.2.tar.gz"
  sha256 "39a311f3d7dca10b12fa699494d6509c72afd5eaf339c8a1ed632df6b38a4d91"
  license "Apache-2.0"

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -X github.com/SemRels/semrel/internal/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/semrel"
  end

  test do
    system bin/"semrel", "commitlint", "feat: add new feature"
  end
end
