class ServiceWeaver < Formula
  desc "Programming framework for writing and deploying cloud applications"
  homepage "https://serviceweaver.dev/"
  license "Apache-2.0"

  stable do
    url "https://github.com/ServiceWeaver/weaver/archive/refs/tags/v0.23.1.tar.gz"
    sha256 "b7025fc124ab20d7a50be4eb437bd6989139d68e0f1bc4ccc2552dbaa5ef6c6c"

    resource "weaver-gke" do
      url "https://github.com/ServiceWeaver/weaver-gke/archive/refs/tags/v0.23.5.tar.gz"
      sha256 "23758eeb2629f484fd62fddbc81005ddf324f99a0f892b33c456e5ba07e2dd10"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0b869b7f228893c6e6cf7ff5aa5847bb04c5a2ef9e40696e4ea78117b573fff4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d66d39cfe1d75b4064d7dd3484263e1a479e8c0797ee4d395130c4cfb85b5dd4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b051e9fbe5e6226ba7ab3010bac3a2835a67f475b9a544007fb3342ca01b452c"
    sha256 cellar: :any_skip_relocation, sonoma:         "a0939b7db39b37ee1b4c423f6adea8d8262bdd6a178459394f01dd779e766746"
    sha256 cellar: :any_skip_relocation, ventura:        "35d2e024d1ae649126ec8e8e76ca80aba28351c397867aed882b06061a89faa3"
    sha256 cellar: :any_skip_relocation, monterey:       "17c459f8d2024b90200294af9466657cc241c299bbd7735ea6a49e9534080483"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd5bdf4f8b330670047e9869d0433d4a07b3f96bb5c0ef421615d01a226ae6ea"
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
