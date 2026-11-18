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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "584f0253e580efc3cbed8943901993ae9ae1d1d4b9c3d272674a27d3a373d6b7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e67537c2b3cbb2cd7afa2c01f41ea045e9be21246b20705b1ff649924c421021"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8f9258ec95ca46965617962fdd18c174d84627defa0daf92cfd9692f7dec6e5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d7bbf839df9240c76373a48b8801b370b157c36f7abfcad8f48c9f2aa52df092"
    sha256 cellar: :any,                 x86_64_linux:      "389320579bfd81f14ac7ee2137dfbd57a32af703aaa86d9fc1a8c6dcbc545023"
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
