class ServiceWeaver < Formula
  desc "Programming framework for writing and deploying cloud applications"
  homepage "https://serviceweaver.dev/"
  license "Apache-2.0"

  stable do
    url "https://github.com/ServiceWeaver/weaver/archive/refs/tags/v0.14.0.tar.gz"
    sha256 "ef8d715b8188b0987f79e255c1f9f1f2b4862cc05ca8c03678050ff4a712309e"

    resource "weaver-gke" do
      url "https://github.com/ServiceWeaver/weaver-gke/archive/refs/tags/v0.13.0.tar.gz"
      sha256 "bb34cdad729d842b398ab04363f8f5907c68a68e2cccba63538adf9ef29c139b"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6dd85fd377d56df5abfd5f970db7a9a2368cc1011d5ec8751a69938f76bedbe9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39c03d71362b350dc39ba60ebd632f1350c04a96347ed898afeaa8e4f8540c13"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c112076fbb7f603165964f7915f20457f1c9cf1f2bb3824d74ae4c1b3a749b23"
    sha256 cellar: :any_skip_relocation, ventura:        "9e66b39101306c66a6c6d0e6861666b575b95dab3f2eb531305f1fdc1de1dc08"
    sha256 cellar: :any_skip_relocation, monterey:       "2a396f24720aff72bf78831936e1f11d439a8b0e5896868013238318ef78c893"
    sha256 cellar: :any_skip_relocation, big_sur:        "b3caff93bb2d2d86a3b47396cb2cb93372e19f6beb2022081bdc1c93efa47d42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9daa8c9cf4109d872b54c7b16bd74aabecedb29ffd0f9be79d7878a648bad6a2"
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
