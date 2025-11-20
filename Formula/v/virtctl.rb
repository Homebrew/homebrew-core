class Virtctl < Formula
  desc "Allows for using more advanced kubevirt features"
  homepage "https://kubevirt.io/"
  url "https://github.com/kubevirt/kubevirt/archive/refs/tags/v1.6.3.tar.gz"
  sha256 "9d41ac421d7af1c25a2b5c370dc597b67e6fc2762ab03ddf4745f71cad5fb4e2"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26287256ee3bfb9778a8ded72174001cf19ca7d140d882c8975bff79bae814be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26287256ee3bfb9778a8ded72174001cf19ca7d140d882c8975bff79bae814be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26287256ee3bfb9778a8ded72174001cf19ca7d140d882c8975bff79bae814be"
    sha256 cellar: :any_skip_relocation, sonoma:        "35acd68b3eddb83d1761df25c2a4176c892e5f1034f983f7129f628fe5ed642c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47eab56252d67e6f252aacac057701f9cd549b13945af346723f38473bb7c35f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56da4cbaaece1dee175625066c9e01a62b655480ea04427a896178436fac121f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X kubevirt.io/client-go/version.gitVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/virtctl"

    generate_completions_from_executable(bin/"virtctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/virtctl version -c")
    assert_match "connection refused", shell_output("#{bin}/virtctl userlist myvm 2>&1", 1)
  end
end
