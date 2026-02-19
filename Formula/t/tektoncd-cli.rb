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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9bc9ac74ad61b93bc1cedf9a62ca877cb8dc9a77f9d92d763b257cacde2b0e78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf6eda0825027c670d76902ffa49106940d03f910d20e32d55e5228daf32dffb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "308df02ca4ab15a9dc0c695ba76d22207aa2f8d59c7446a6a4db69abf8b744ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "c07d413a8e34efcbaa4c1d20b56ccc329119b25a13f1d83f90df1465cfa26730"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "070a5333d68d95c8ba40301d572ea138e4a3a3cbfd95aadb1680b9bf5850e50f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3961abece37fd68476161a8c5fd427521ce30cbe033d2ad388f348d2688c4a6"
  end

  depends_on "go" => :build

  def install
    system "make", "bin/tkn"
    bin.install "bin/tkn" => "tkn"

    generate_completions_from_executable(bin/"tkn", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/tkn pipelinerun describe homebrew-formula 2>&1", 1)
    assert_match "Error: Couldn't get kubeConfiguration namespace", output
  end
end
