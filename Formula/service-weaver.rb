class ServiceWeaver < Formula
  desc "Programming framework for writing and deploying cloud applications"
  homepage "https://serviceweaver.dev/"
  license "Apache-2.0"

  stable do
    url "https://github.com/ServiceWeaver/weaver/archive/refs/tags/v0.16.1.tar.gz"
    sha256 "20c2441b5a03fc74b398cfb80a978b1e6abd814b8d747c1adde31764fe98ebf0"

    resource "weaver-gke" do
      url "https://github.com/ServiceWeaver/weaver-gke/archive/refs/tags/v0.15.0.tar.gz"
      sha256 "67ca3badb91d27586113661fdabbb262947c9ab7ceb19107bcd47b149212fb21"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f0ed2873abd5af87ba3cb77a8b86ccd1e66887cf5c3b6b17b0f26ac47c01a7c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62e1da98bf75fc94c258c54e7c3e33416d8b329962cc0eba5ee4e338d2e49089"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1ba52a75b6be7a916c748ba9872495dc780cb0579d1733699f6e747be334e270"
    sha256 cellar: :any_skip_relocation, ventura:        "5d1da5afc184bfb91b0aef2a1f890ef04c0806b5bb352d640056d6e22d754f1d"
    sha256 cellar: :any_skip_relocation, monterey:       "0ed2e64006fb6054ac57ed3c9695615f837726ac863a69f83c2b673bb87e87cb"
    sha256 cellar: :any_skip_relocation, big_sur:        "0b1b3eda7cb189396a5f2b63f92e01822a5c6b8c398331509454d26fbf4f43f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "695083c36b80f210f48e9d7052875bd26ff97a50ad36e68f330b2e6f4bfb120d"
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
