class Virtctl < Formula
  desc "Allows for using more advanced kubevirt features"
  homepage "https://kubevirt.io/"
  url "https://github.com/kubevirt/kubevirt/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "1f6c12ca3345086b2991cd3313cc78f87f9c85984e8414087245a4f5e895ccd6"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b898c25477b18a8366c79e47d01e47251b9b6fed49ef022be056d2e5d5adeee9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b898c25477b18a8366c79e47d01e47251b9b6fed49ef022be056d2e5d5adeee9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b898c25477b18a8366c79e47d01e47251b9b6fed49ef022be056d2e5d5adeee9"
    sha256 cellar: :any_skip_relocation, sonoma:        "0584ab52cd755069b32cf65ab162a6de2f56b32933d157aa0a754cbdb96d1751"
    sha256 cellar: :any_skip_relocation, ventura:       "0584ab52cd755069b32cf65ab162a6de2f56b32933d157aa0a754cbdb96d1751"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a28560be7e31eadc605f25f34777462c146981fa41004dab1f02b6370a440765"
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
