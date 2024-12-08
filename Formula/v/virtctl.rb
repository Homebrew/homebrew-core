class Virtctl < Formula
  desc "Allows for using more advanced kubevirt features"
  homepage "https://kubevirt.io/"
  url "https://github.com/kubevirt/kubevirt/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "19d6624f4f7268062b38f535a0315674f3e6f37550a4a0af9861b7a146dbe0f1"
  license "Apache-2.0"
  head "https://github.com/kubevirt/kubevirt.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef4702d5fdd0f8e2e9caff7101ea484064a5e96150097c5617cbb6e68dde0454"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef4702d5fdd0f8e2e9caff7101ea484064a5e96150097c5617cbb6e68dde0454"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ef4702d5fdd0f8e2e9caff7101ea484064a5e96150097c5617cbb6e68dde0454"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6bea392c4cf124d2663fc07e9015ac7ddfe087256d3222331ba6ca98f17e4ff"
    sha256 cellar: :any_skip_relocation, ventura:       "f6bea392c4cf124d2663fc07e9015ac7ddfe087256d3222331ba6ca98f17e4ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f27534285a9d7c7ab91b3781edc796d4e7947f1d72a9966a0fd25e7d06cdcf3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X kubevirt.io/client-go/version.gitVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/virtctl"

    generate_completions_from_executable(bin/"virtctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/virtctl version -c")
    assert_match "connection refused", shell_output("#{bin}/virtctl userlist myvm", 1)
  end
end
