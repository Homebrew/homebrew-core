class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https://github.com/tektoncd/cli"
  url "https://github.com/tektoncd/cli/archive/refs/tags/v0.39.0.tar.gz"
  sha256 "95469fa9e2eedb7c882a5a2cac424a8ec06c7436bca4722d2efc70acca9a2dd6"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a03ef564a59e5041c5b6ac0664b218f7aa3f19962054870a32dccd72eda2c62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de231cba4806d83262ad3756ef7aaf95e034df60f4ab90e229fda0ebd8ada7ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "64525304de280d308e1931f2871cd032cd397ac7768d5a399f9cfa0a4d05c3df"
    sha256 cellar: :any_skip_relocation, sonoma:        "9292b5878b409602473e34d40378b4d2a4e8395b3ee982b8a65af00a947421fa"
    sha256 cellar: :any_skip_relocation, ventura:       "c8f78186f46c7d99c702b2f6bbdd5ced272149d2ca77f28c4e9525c569f395ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dda005f3d38e3102a4cdad1e57172c51412f93cc5371646f726870d66baa39c8"
  end

  depends_on "go" => :build

  def install
    system "make", "bin/tkn"
    bin.install "bin/tkn" => "tkn"

    generate_completions_from_executable(bin/"tkn", "completion")
  end

  test do
    output = shell_output("#{bin}/tkn pipelinerun describe homebrew-formula 2>&1", 1)
    assert_match "Error: Couldn't get kubeConfiguration namespace", output
  end
end
