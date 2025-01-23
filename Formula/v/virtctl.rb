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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78075b8fd1aa7747b1d357cb14cffe03793e6648942d0684dd2c0931a922355f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78075b8fd1aa7747b1d357cb14cffe03793e6648942d0684dd2c0931a922355f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "78075b8fd1aa7747b1d357cb14cffe03793e6648942d0684dd2c0931a922355f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a17b30e2c68f899131a9674b291e448c593a5bbe4bfd5700371c298a1d2e7691"
    sha256 cellar: :any_skip_relocation, ventura:       "a17b30e2c68f899131a9674b291e448c593a5bbe4bfd5700371c298a1d2e7691"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57f9cf26e82d97a82eaea0d35f85a34fbbfe6959d0c148352ada0bcc88f8485d"
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
