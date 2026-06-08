class TransifexCli < Formula
  desc "Transifex command-line client"
  homepage "https://github.com/transifex/cli"
  url "https://github.com/transifex/cli/archive/refs/tags/v1.6.17.tar.gz"
  sha256 "759320acd621991046533089bb77320202853cc97b860ab7783040d0e4d5e34f"
  license "Apache-2.0"
  head "https://github.com/transifex/cli.git", branch: "devel"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ed869c364c5d0c78fc99f6d243968d9106496cdfe6f2988d8b5896d84ef7844"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ed869c364c5d0c78fc99f6d243968d9106496cdfe6f2988d8b5896d84ef7844"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ed869c364c5d0c78fc99f6d243968d9106496cdfe6f2988d8b5896d84ef7844"
    sha256 cellar: :any_skip_relocation, sonoma:        "88495caac47931836b2734fa283c70c9e626928e457c713d2e32c49ba82d3765"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5dedde2fcec03377ae340910d75567b9cc7605060b69ef4b7a64fd4dcd05b42a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c1f1bf58470b3681c9b6252c8062cd8200a832d701c81f65132f5b9548470eb"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/transifex/cli/internal/txlib.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"tx")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tx --version")
    assert_match "Successful creation of '.tx/config' file", shell_output("#{bin}/tx init")
    assert_match "https://app.transifex.com", (testpath/".tx/config").read
  end
end
