class ServiceWeaver < Formula
  desc "Programming framework for writing and deploying cloud applications"
  homepage "https://serviceweaver.dev/"
  license "Apache-2.0"

  stable do
    url "https://github.com/ServiceWeaver/weaver/archive/refs/tags/v0.24.6.tar.gz"
    sha256 "15b34f1539b6a84f8783009a2e8ce98bb12c9a0c0ba70b4ff055e4a8a3406e10"

    resource "weaver-gke" do
      url "https://github.com/ServiceWeaver/weaver-gke/archive/refs/tags/v0.24.4.tar.gz"
      sha256 "97e2bd35b997bc65f824fb1b2eb6500f8ba97d444cc7565be80e61005c462848"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc49ca39bcb55555be333c8ab54c3649cb989e82d04e3d743b1fcc690f26c867"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76c861065b7ebf0afb19189eda629198c7f2626911edc540aae08660f06a1345"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4bf175089ed43e869e3553de0ae5a3b498e9cc796745ce14fa9e2b919273413"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d58a390f9b42bc7dcd1444399ed11b9a23a2b78c29e62caaf0a0a5963a45d858"
    sha256 cellar: :any_skip_relocation, sonoma:        "29cb9c8dca107487aaa3edd171d34dce80b9f0e71ac04dd060c2d7b82677e292"
    sha256 cellar: :any_skip_relocation, ventura:       "258db33d6cf2b2cf520150d3ece5dfffb0a77c325e5248bf0a1886f6627e0719"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1211e7bf0e83aa596d397fe4e152b7ecf289248ef27bb82b27b7f06c9bbd3f9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "385c13a006f40c24d42c8b2f33d1035143f9625b0b08349284a92e71df6972d0"
  end

  head do
    url "https://github.com/ServiceWeaver/weaver.git", branch: "main"

    resource "weaver-gke" do
      url "https://github.com/ServiceWeaver/weaver-gke.git", branch: "main"
    end
  end

  # upstream announcement, https://github.com/ServiceWeaver/weaver/pull/804
  deprecate! date: "2025-06-14", because: :unmaintained

  depends_on "go@1.23" => :build

  conflicts_with "weaver", because: "both install a `weaver` binary"

  def install
    # Workaround to avoid patchelf corruption when cgo is required (for go-sqlite3)
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

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
