class ServiceWeaver < Formula
  desc "Programming framework for writing and deploying cloud applications"
  homepage "https://serviceweaver.dev/"
  license "Apache-2.0"

  stable do
    url "https://github.com/ServiceWeaver/weaver/archive/refs/tags/v0.9.0.tar.gz"
    sha256 "3b20e3ba9d867392bf4ff0fe565c16dd90a5211870acd6349867f72df4571e6a"

    resource "weaver-gke" do
      url "https://github.com/ServiceWeaver/weaver-gke/archive/refs/tags/v0.7.1.tar.gz"
      sha256 "29c46809460184843c824d961aa380aa09f15afecb704d064296c57c30415867"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "05d602b4c5badd5f14f512d8121f0766ba9b4660cd243bad42f0c16c809586e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11329606c30d202a4573e583dde92ac06751802530a78faec92d4ee834b9b906"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "874edbd7bc32dc38bb6ebf8e5e01f1f26dfa25a1e08015fafbf0abb73e03cd36"
    sha256 cellar: :any_skip_relocation, ventura:        "a47da600283aba32e141d86a7a61680bd3b7d25a99371f79d6c4b9ad20a53152"
    sha256 cellar: :any_skip_relocation, monterey:       "e3822ab32b936cf50a5081417f63cfa40887d48d69ea312f626d799c64e69a88"
    sha256 cellar: :any_skip_relocation, big_sur:        "c29814ac301157a706c75e10ecbf74c9e50058b07e1c37665e428377f7e17c26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f27e96c321b3616b140141894298c081f4bc12006eccb55f22336ceed5e73c32"
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
