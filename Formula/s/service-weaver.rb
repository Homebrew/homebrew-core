class ServiceWeaver < Formula
  desc "Programming framework for writing and deploying cloud applications"
  homepage "https://serviceweaver.dev/"
  license "Apache-2.0"

  stable do
    url "https://github.com/ServiceWeaver/weaver/archive/refs/tags/v0.21.2.tar.gz"
    sha256 "369a487cbaa57fe96ca9b6354b8157a028c91ff28850742f51cfaf4fc4b99f07"

    resource "weaver-gke" do
      url "https://github.com/ServiceWeaver/weaver-gke/archive/refs/tags/v0.20.0.tar.gz"
      sha256 "c4a3b143f1d1c45679257fd7805c2f708bb746e3ec8486eef68e73d19bd21676"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "da46beacbd0af7ec3fd41b9422473fb35c7694b401536fffd89a3b579541e29e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11975d7675906f1779ed4ce34becaf74b5257ca5c0aa5e328c2f38c83583b301"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fec94bb5b9646fe5f236638d181e01a14298f3bec4e0b5825d64fe1db8510352"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e6f18720084ffee61f184481bfdd14559a9797c6fd74b8201bf7c0fe56b13cbb"
    sha256 cellar: :any_skip_relocation, sonoma:         "1dd7b3364f9e889b24bcd022205cb2c88dc02fafb8693f12f1c7745a34e15fad"
    sha256 cellar: :any_skip_relocation, ventura:        "603733f2e660f322b6997c0863e5a7687ef10cc082354cfa85051231b667bd20"
    sha256 cellar: :any_skip_relocation, monterey:       "f62c27ac4b38ceb1344ff01fa5f1e68459e7948c5773aa542c1fc299f6f8326c"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ba130f5e28b89ce5b84635394018fa8c302efe055bbc8c55dd57cf4801f09a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0740843730e823c24852045e7f1aef1f49d341d4b85b0c22828d0c9bcdb629c"
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
