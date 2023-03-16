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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "713e710f3ecf95e95df3272eab592e935493165cf3198a801f018bc79b1c1306"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb781275589173f619d9ae98c0f517a1298fece5cb58339d3264e742ee0368ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c575bab052d1be9f37b4d8f7c5e34965f202ca21c0dd568813b07722041b50c5"
    sha256 cellar: :any_skip_relocation, ventura:        "ffd75e1a5b851cc3dd1252c1d2b364c6566e2ed74ace5135e5df02d2d3a28f2e"
    sha256 cellar: :any_skip_relocation, monterey:       "c9ac2b07624b011d4da7aaac2aa159f62208d917fa68e5cd5fb9bd3a49cbffe4"
    sha256 cellar: :any_skip_relocation, big_sur:        "55f3af891bbcfa16d9c33f8c60d11a85a02169d57f7b8f471d43ff2b36425816"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69259f00bf41230d361f77f366b0b814483e3aa5d17547097a73dbc4e9bb9bc1"
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
