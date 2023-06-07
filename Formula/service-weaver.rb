class ServiceWeaver < Formula
  desc "Programming framework for writing and deploying cloud applications"
  homepage "https://serviceweaver.dev/"
  license "Apache-2.0"

  stable do
    url "https://github.com/ServiceWeaver/weaver/archive/refs/tags/v0.13.0.tar.gz"
    sha256 "86b4897ff75c94e7d256e6cdde90b693e838d674d8c8c82068e9f2a5c21894f7"

    resource "weaver-gke" do
      url "https://github.com/ServiceWeaver/weaver-gke/archive/refs/tags/v0.13.0.tar.gz"
      sha256 "bb34cdad729d842b398ab04363f8f5907c68a68e2cccba63538adf9ef29c139b"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "64ece75cdf698fd7380f1093362f84a5f2d4ccfb06ecc224ba3128d225aa195d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5e031527e69a35c8bb85ad240ecd41656aec00ca36367dd23540ad51b86821f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e82f642028320b0e2a88da7d98af41c8892b076488138dba116e54f0de14b647"
    sha256 cellar: :any_skip_relocation, ventura:        "5681c8e540ea9db93a54d0cd79591003eba142b4b80f8a7636e00ac7a1853ccb"
    sha256 cellar: :any_skip_relocation, monterey:       "e15965041529dde321d56ec1f09be9e7affc6796e4af3d84e35f4fc91f64e507"
    sha256 cellar: :any_skip_relocation, big_sur:        "ed9f35e7e604f8de46ca2e23e76f2762db842bb966d6eb3ed47357238b842b25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c5b88dcc9eec54bf8bf5fe46bcbb4e3966ff2146e8cdc5d11ce105e93c48855"
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
