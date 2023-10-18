class ServiceWeaver < Formula
  desc "Programming framework for writing and deploying cloud applications"
  homepage "https://serviceweaver.dev/"
  license "Apache-2.0"

  stable do
    url "https://github.com/ServiceWeaver/weaver/archive/refs/tags/v0.22.0.tar.gz"
    sha256 "d3a5354377ac4b72f577659ae21ba4e984f11fb594e999a5a6c1c398414dd0cf"

    resource "weaver-gke" do
      url "https://github.com/ServiceWeaver/weaver-gke/archive/refs/tags/v0.21.0.tar.gz"
      sha256 "3741f827ddd8e4f1c84410a5b11647781510078cb6271064892468fc32f751f1"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b9428d4052c247f9251e57a354803b2c5d224be8110b8b620d9b5e4d6025b836"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "35192abfd1938ead2e4ee5a647ec18955cf3c78d437f06eb2306702edd7e5a5a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb2769873ba7a600b6bd6eb5d7236dfad725c3c30ffc6bef57b9e16f08bba4bd"
    sha256 cellar: :any_skip_relocation, sonoma:         "2d46234029379b0cc02bb3f1b3239b626457ebb3ee3fa2d264c568348c6598bd"
    sha256 cellar: :any_skip_relocation, ventura:        "d289e1f0a45cb34222240469fcaa7524cd679ec66993c170fbf38d6ee9450115"
    sha256 cellar: :any_skip_relocation, monterey:       "8910c99b095b4b8d686af1a11ae63a4a068c70a315836c47e62570732e9e9249"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e82ff16ddf003255f60b9f1d221192b76ce3338fa67864e8cb96d70c634366a"
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
