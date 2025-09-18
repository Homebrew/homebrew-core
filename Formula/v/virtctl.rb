class Virtctl < Formula
  desc "Allows for using more advanced kubevirt features"
  homepage "https://kubevirt.io/"
  url "https://github.com/kubevirt/kubevirt/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "a23d22f61918b4fce69a5e01ed7c586e1c255bcf8ba0c43ac7cc02b9a9414d04"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a6b962d4fa337b58c4f694f846ad52ad1578c17fb5d64c8d47b011774a6f8a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20afa306418ca19e23437c5ea247d963205c8764faa2c1883ae2109c696d4467"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20afa306418ca19e23437c5ea247d963205c8764faa2c1883ae2109c696d4467"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "20afa306418ca19e23437c5ea247d963205c8764faa2c1883ae2109c696d4467"
    sha256 cellar: :any_skip_relocation, sonoma:        "9333e71ebd86abc005315d8276fd8e18bf813493cbe7c68e71196c990ef78f23"
    sha256 cellar: :any_skip_relocation, ventura:       "9333e71ebd86abc005315d8276fd8e18bf813493cbe7c68e71196c990ef78f23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "278e7d8191f6522f203ffc4ffebdee90be7df95360689b91fd3c51755560eb16"
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
