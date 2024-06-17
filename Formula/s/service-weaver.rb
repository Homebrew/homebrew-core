class ServiceWeaver < Formula
  desc "Programming framework for writing and deploying cloud applications"
  homepage "https://serviceweaver.dev/"
  license "Apache-2.0"

  stable do
    url "https://github.com/ServiceWeaver/weaver/archive/refs/tags/v0.24.2.tar.gz"
    sha256 "ca1a7a8ac23ee8d1daff3f1f21a7c9c5399c603ac591baf797110349305e4b68"

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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a6817a81bb899f3846d39f2fc785ca7108cf13b136afe85e4284dacb14126100"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dbeb4e16a1396c2c2c03d3387dbb1b213fab7fe8e024fbe6609bbb90655e6dc5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f34793aa6b67d5396ac63aaddad0288497251723319d3972eed9d00a3817e763"
    sha256 cellar: :any_skip_relocation, sonoma:         "721e3f14ad194c307e376c26ad08551227df6ed81ee8780ecc2deb8b1e585073"
    sha256 cellar: :any_skip_relocation, ventura:        "ec66b8daa95606c6289a358cdb07b47bdc4f4e7ee7ab6e529a18b754d082cb82"
    sha256 cellar: :any_skip_relocation, monterey:       "363cc2bef4fea58e2cdafbab06739aa29c87b4bad93f45118388326802fe6150"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c69fd420528965f3fa8a9f3be6f6660c21a99d4d59c70db87706d5d9845a2070"
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
