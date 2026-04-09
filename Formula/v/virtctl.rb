class Virtctl < Formula
  desc "Allows for using more advanced kubevirt features"
  homepage "https://kubevirt.io/"
  url "https://github.com/kubevirt/kubevirt/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "93049ef39ed557ea7d38b5ff14948405540b44c94dc8b3ba1b377e5dd57c2f02"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "043e7012a62df2f7b20b004f67b1119ac2eacef1c170d3cf750301b77c791db4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1ca1e29b38cb6e1cac8bfc5eebb5bcd429fad956cd828d1947a3895aa4596cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e996603adbf046a287f9494010b19cf8255afaab6e1b061d764ef0df11dca045"
    sha256 cellar: :any_skip_relocation, sonoma:        "021ec53de625a9a187decb1fb607e7190305ccbba200e5697a539ecf0d0f2c66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79764ca0c4782562d2277afbc0c0d9c303e8e63f2e63c80a515b4fff70163808"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c746eb8a173e9c57045885db269e8a81eb31095383a42b29d1a8669900e6ad2"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X kubevirt.io/client-go/version.gitVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/virtctl"

    generate_completions_from_executable(bin/"virtctl", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/virtctl version -c")
    assert_match "connection refused", shell_output("#{bin}/virtctl userlist myvm 2>&1", 1)
  end
end
