class Virtctl < Formula
  desc "Allows for using more advanced kubevirt features"
  homepage "https://kubevirt.io/"
  url "https://github.com/kubevirt/kubevirt/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "46727930fcf14b3985f072369e79de1c1e61d0b9d2b52e5905e0f172f814fe5c"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f49513422a200108079f8c307368ed6ed55cb56d9faa8ce1582b80a02964b9d3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "23960112fbd3a58e6c9f44d6631935257468df2921e048bf950cbbbb7c2f6110"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b857df2db1875d42fb0aa96413a306f46af664b097459b3c5cf73a98652d0a9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ad7bffed32d39d7979af3500b2cf3a43cda699a1e09f3190843b922d3af07922"
    sha256 cellar: :any,                 x86_64_linux:      "ebc979032a2014a47065d2bb98c8011c44ceee375904d8d1487ab3c072e59cdb"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X kubevirt.io/client-go/version.gitVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/virtctl"

    generate_completions_from_executable(bin/"virtctl", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/virtctl version -c")
    assert_match "connection refused", shell_output("#{bin}/virtctl userlist myvm 2>&1", 1)
  end
end
