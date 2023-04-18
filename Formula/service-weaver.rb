class ServiceWeaver < Formula
  desc "Programming framework for writing and deploying cloud applications"
  homepage "https://serviceweaver.dev/"
  license "Apache-2.0"

  stable do
    url "https://github.com/ServiceWeaver/weaver/archive/refs/tags/v0.5.0.tar.gz"
    sha256 "e1a027af5a0aad3c88ca602f9bfe099a22c730244692aa4a103ed2b7ca05ba73"

    resource "weaver-gke" do
      url "https://github.com/ServiceWeaver/weaver-gke/archive/refs/tags/v0.5.0.tar.gz"
      sha256 "5ef3730bd77aa0c6967f338678291c9240f3d5480b771a34d69c51728ca3d870"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "37ee0c4c7129ec718dc5ce06fca52204fcad524fadc9af0116684fef6aed0dfc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2e860b4cc4c7e5f5ebc6a470dc31d4102c0fa189cc11b0a048d5dfd0311c72e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a09d9e6441a958ed79a9a053a24cf8cf7991d779ead907a6559edb1ffdf35950"
    sha256 cellar: :any_skip_relocation, ventura:        "b6b6e7b2e4da50e7cf2a9db02e808cfd9049bef38564b19a87ed9f71bcaf4308"
    sha256 cellar: :any_skip_relocation, monterey:       "36b88bca2542cc3bd5fbccde775a931ab9409b08484cc69e660360944bc3e0fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba65e844e131c866edc11e9baed57cd9706283f3e04dcb22d69615a6934e0e98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8218ab9be8f04e40024b608ada893d6a33616463beaa61ca00fa727163e73b68"
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
