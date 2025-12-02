class Timoni < Formula
  desc "Package manager for Kubernetes, powered by CUE and inspired by Helm"
  homepage "https://timoni.sh/"
  url "https://github.com/stefanprodan/timoni/archive/refs/tags/v0.25.2.tar.gz"
  sha256 "b7c98986ceec18f40a6ce96845c125f042e84668dc765c306dcebe7e3b87fb64"
  license "Apache-2.0"
  head "https://github.com/stefanprodan/timoni.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40b5542812caf38e60ef89831ff1f98dd253c6d5d2feae3a88fb75b6e43d8947"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6f35266b3464bc3a4410cc5da4e89cef32cbcfcc471bdef2fb1b6c2e85ec799"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ead36e09083dd9e732ef5c3bd628d3329fc1c2aab1e684a0bdd430e466cbddf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "466250b8c24a0b0a9b5d0af25ec47faa821b84278d8053b9b4a8a588de78a209"
    sha256 cellar: :any_skip_relocation, sonoma:        "15b711a8bcdf50b7eaa73a64940fc853bdf6848ba6972dc9726371b9f04c8eff"
    sha256 cellar: :any_skip_relocation, ventura:       "3d4633b3db46ec196beaa366c8ff06555835796f7c0886c7d28dc8fd746b817f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2087e64f4390c6d82ad504f3366f21a6b81725ff885e9de38505724a596ca710"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f72b67e94145d5b8457de29f699b358f2b86e5c84fc8c22764a653db3a2d30a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=#{version}"), "./cmd/timoni"

    generate_completions_from_executable(bin/"timoni", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/timoni version")

    system bin/"timoni", "mod", "init", "test-mod", "--namespace", "test"
    assert_path_exists testpath/"test-mod/timoni.cue"
    assert_path_exists testpath/"test-mod/values.cue"

    output = shell_output("#{bin}/timoni mod vet test-mod 2>&1")
    assert_match "INF timoni.sh/test-mod valid module", output
  end
end
