class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https://github.com/tektoncd/cli"
  url "https://github.com/tektoncd/cli/archive/refs/tags/v0.43.0.tar.gz"
  sha256 "79b602e74aea0363bb9bff8e51fadbd43765c56864207fa9606500c71ba5ffbb"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b5d81112b16e845cc7be2c90b036c572392506db2253166cb2e6dd206ac3e344"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dcbaf894431dce86b992f5d8b35d24df41245c0d73a34e73d2fb6a6c9260a623"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f19ee9251a5a47ef112579d6b4a38a99912c196659b36289ca355e7af138178"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e9289d35373c9baf4ac42bce9ac5946fc95ba4a6885c3f716fc3be39aaf98f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1af6245eba6389dc00cbc4aed9f0e583a20c6c497e7ed31f28f682aebb286b78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1715fc112159d402f1abd1e40e9b50947851bb258fbaf1ad7f97b214868c7cd"
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
