class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://terramate.io/docs/cli/"
  url "https://github.com/terramate-io/terramate/archive/refs/tags/v0.4.5.tar.gz"
  sha256 "7a0a8272e64c28e0a046d9b5757afb42f50fe7c5e1cae4328c12cd13b5607273"
  license "MPL-2.0"
  head "https://github.com/terramate-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8f530e8f4f3d932cf10d091c8b26cb4a5549c2d023f96aa1d926e49593d7dcc5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9877f1f8c88141d1a512786d15b2c2817da8c943d70e2fc383ad3c8bc8265030"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f277183e784cbba71d4a5b27af3ff1987afbcc4a23d2112e2c4b34508b418e2"
    sha256 cellar: :any_skip_relocation, sonoma:         "056f626df30f9b267c12dfc85dea68f82bc6931f4f2c6fc2f7c7e8a2b6456a0e"
    sha256 cellar: :any_skip_relocation, ventura:        "5bf478db56e3305a1b25e36f87f3ee93eea14c9cdbdedb7bd3f50374cfd9e32d"
    sha256 cellar: :any_skip_relocation, monterey:       "6e5ffeb8ab7d02ab874ba0465f23173f72820f4b477b7230f4e49c5e10f64526"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4b92a68a2a1c0703de67cfbc3b2feeff7c8f3e6fee2fadbc3e3f48ab5d16017"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"terramate", ldflags: "-s -w"), "./cmd/terramate"
    system "go", "build", *std_go_args(output: bin/"terramate-ls", ldflags: "-s -w"), "./cmd/terramate-ls"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terramate version")
    assert_match version.to_s, shell_output("#{bin}/terramate-ls -version")
  end
end
