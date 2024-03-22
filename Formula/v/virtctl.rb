class Virtctl < Formula
  desc "Allows for using more advanced kubevirt features"
  homepage "https://kubevirt.io/"
  url "https://github.com/kubevirt/kubevirt/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "da63ee052939a68e54dca37084234ebd7a86233f2087bc13cb7d63fc24d356e3"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "08d5586a3d69ea76c6ede249d2fdca6e95170dd13c4b6195c5966c0b5f6c57db"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce967417de23a838c8064785ce626d1ef664c68a3beb66775d3fd83090d36795"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba4549123195ac1e3c30313f95ffb6ed1bf867b80af72d67da9c21103caaf31d"
    sha256 cellar: :any_skip_relocation, sonoma:         "d5a788c0fb0a60b8226d1b4192be58786753c514e9a8b4a680f0963a2f091739"
    sha256 cellar: :any_skip_relocation, ventura:        "bb62ce40020ab7b412189659c8b2749aa25d69252c82730fe98b21a37f2486a7"
    sha256 cellar: :any_skip_relocation, monterey:       "8da1f1373ea543315e80189ae66eaee4781fdb598c80d576b3f8e5b332f5ad3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d7570fe1ced142e9e45baaf183e98df3515cd7916ab6ebffa80831430013fc3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X 'kubevirt.io/client-go/version.gitVersion=#{version}'"
    system "go", "build", *std_go_args(ldflags:), "./cmd/virtctl"

    generate_completions_from_executable(bin/"virtctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/virtctl version -c")
    assert_match "connection refused", shell_output("#{bin}/virtctl userlist myvm", 1)
  end
end
