class ServiceWeaver < Formula
  desc "Programming framework for writing and deploying cloud applications"
  homepage "https://serviceweaver.dev/"
  license "Apache-2.0"

  stable do
    url "https://github.com/ServiceWeaver/weaver/archive/refs/tags/v0.1.5.tar.gz"
    sha256 "2670182df1025be5892fc0374e4a33cc46b5a16bb9f09d5ebb0dfe2b0f681078"

    resource "weaver-gke" do
      url "https://github.com/ServiceWeaver/weaver-gke/archive/refs/tags/v0.1.5.tar.gz"
      sha256 "0e0a525ac792f61cd5b25eb556fd7bf01a8ff3eea90c291acd2382c774e3f84d"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7de948e5d2b446ce535ad0fd51399fa6b729a333ca5295948c0441c7c796aa97"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c5a8309b6e0ca92b9305fa445f7609f5bd354bd8340414b47373e59dcf7792d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "80bc588ff74c113060766e58130c2821d99353fb89e37c0897e624d5b4dccfe5"
    sha256 cellar: :any_skip_relocation, ventura:        "0778ed68a379db5c49808f0b1b5d33614f541b8640e858860a67c07aeb6d52db"
    sha256 cellar: :any_skip_relocation, monterey:       "316954f5855ecda268de833e857cc78a0ac6f82ec4f77d54fa1081967b3374b3"
    sha256 cellar: :any_skip_relocation, big_sur:        "5b36c6e5cbed6a8cf404b6683a812c9c5107969c37ee60a0fb01de62ddd66e2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5941c05a6eb348db222a7b8437cdcf417da129e04d6a87217f586676e6b6169"
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
