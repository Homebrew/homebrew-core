class Virtctl < Formula
  desc "Allows for using more advanced kubevirt features"
  homepage "https://kubevirt.io/"
  url "https://github.com/kubevirt/kubevirt/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "71bc21163ada3e39c55c19f88c057ad0194e97043441d471f2bfd51782550a2f"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17ce8dc50ceafbb57d9e81bcbde5895e237220c92c911e7bb348f1d52fea56a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb3cf89ecc52d5489b18a611a463f974e1a69f95fdb2c0b480a3bc4f6fe2870f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c115a2212bd10628f6b426b51ed402fdeec2f497f0e42e88e8b5b87d35989a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "57d0c0b6842f45586eedc236040a56b820ef7cc1d298e0839af753e11b534889"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c926412df85cdc9493630a7aa414ba96f94fb94ca1b4fc180bcd0eafa25e1b80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcb0457cec7d329f1cad8f2d371a62511bea01bbb28652729e4a9ad180a1783d"
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
