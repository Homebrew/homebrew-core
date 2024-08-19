class ServiceWeaver < Formula
  desc "Programming framework for writing and deploying cloud applications"
  homepage "https://serviceweaver.dev/"
  license "Apache-2.0"

  stable do
    url "https://github.com/ServiceWeaver/weaver/archive/refs/tags/v0.24.3.tar.gz"
    sha256 "14a04ff8db1aeeeb9b38401fa70d1e2a2cb12c122fe1f8c8328eb53812b935d6"

    resource "weaver-gke" do
      url "https://github.com/ServiceWeaver/weaver-gke/archive/refs/tags/v0.24.3.tar.gz"
      sha256 "ce009b862259fcf550c1a36faf3ae53f77289126bdd50b9d67cb880f216ed7e4"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1f9ccf8020607a0466a5e146f104f787f6b206c91d64cd96e3e0fd6b3c934f41"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ebb13fa1407af9903c5cf75d1b6c99cb63fdcaacabe69d44d509f538d116b6e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cabfcc86d386fc67c4e656ba30b9598a0ac0542cfd0fe4cd71fa2aae616f8d46"
    sha256 cellar: :any_skip_relocation, sonoma:         "5cae9e1f6ad983666ae2a529b61275699bdccd9bc56d535cb3162fd124dbd5d5"
    sha256 cellar: :any_skip_relocation, ventura:        "4bb99d7c3a0c2f3333510196a2967acb33f074a2b08db010580eac5ebddbd7dd"
    sha256 cellar: :any_skip_relocation, monterey:       "95e6e699a0110b48a18cd0aaca15504c9f97736e2e9e4b9b025f10fbc625c4af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd36b1ca4e6cf4c2c9978543e943b0c382fdcbba38cc18a30134e9df8b729907"
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
