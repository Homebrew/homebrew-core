class ServiceWeaver < Formula
  desc "Programming framework for writing and deploying cloud applications"
  homepage "https://serviceweaver.dev/"
  license "Apache-2.0"

  stable do
    url "https://github.com/ServiceWeaver/weaver/archive/refs/tags/v0.24.1.tar.gz"
    sha256 "f14c757d5332101d93e0cbbc58603ee061728ecad8c9b4cf235f1bf314dcfbdd"

    resource "weaver-gke" do
      url "https://github.com/ServiceWeaver/weaver-gke/archive/refs/tags/v0.24.1.tar.gz"
      sha256 "2406968feb00113ed33f11f92ef47c9e8ff54dfb56acaef7b02298369b40ede8"
    end
  end

  # Upstream only creates releases for x.x.0 but said that we should use the
  # latest tagged version, regardless of whether there is a GitHub release.
  # With that in mind, we check the Git tags and ignore whether the version is
  # the "latest" release on GitHub.
  # See: https://github.com/ServiceWeaver/weaver/issues/603#issuecomment-1722048623
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3164b4d147606c3fb39d2c5c5fd7f2e9c63de6b7d31b353e8d14b6ebfb7a93a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e37b9c0852e9cefd296abfa0f565c29eb628b78f985940e53761acf27dd1da7b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "089c74458bd11edec50e98f8c714e8032cfa953d5814d9f5ffad20a4886f2e89"
    sha256 cellar: :any_skip_relocation, sonoma:         "93ad64674ef8ad097b2d31c896480b27c1aeeb61a91168563416100eddd56f59"
    sha256 cellar: :any_skip_relocation, ventura:        "b4ae5e6479409a3b70545efe8b283494d6b5538ea3c1f24147a4244f13d4c0a7"
    sha256 cellar: :any_skip_relocation, monterey:       "2d8425726b4206e2ebaa155911c33ee3d09efce1264991ec3a4283ead9c37dc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37a01872544b6f0aa563be4ade9bae593903272035093efabe88096406d4449e"
  end

  head do
    url "https://github.com/ServiceWeaver/weaver.git", branch: "main"

    resource "weaver-gke" do
      url "https://github.com/ServiceWeaver/weaver-gke.git", branch: "main"
    end
  end

  depends_on "go" => :build

  conflicts_with "weaver", because: "both install a `weaver` binary"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"weaver"), "./cmd/weaver"
    resource("weaver-gke").stage do
      ["weaver-gke", "weaver-gke-local"].each do |f|
        system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/f), "./cmd/#{f}"
      end
    end
  end

  test do
    output = shell_output("#{bin}/weaver single status")
    assert_match "DEPLOYMENTS", output

    gke_output = shell_output("#{bin}/weaver gke status 2>&1", 1)
    assert_match "gcloud not installed", gke_output

    gke_local_output = shell_output("#{bin}/weaver gke-local status 2>&1", 1)
    assert_match "connect: connection refused", gke_local_output
  end
end
