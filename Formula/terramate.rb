class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://github.com/mineiros-io/terramate"
  url "https://github.com/mineiros-io/terramate/archive/refs/tags/v0.2.13.tar.gz"
  sha256 "e78c7bb52e25f08a655ada23266e4bfa70ed00e0fe836176acdee44449c5fae4"
  license "Apache-2.0"
  head "https://github.com/mineiros-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa383d1fa3fa5710ce5126194342b7766e9bae1265376d6a6876e0ad34821356"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b36823bdf76f3fdf144a197fce0e8a678aea291c80bc0e0ac3a37be2b99ca4b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "938667be372f4ecabf286e3063b579566719d35ef3ec7d1e1135854b7c37d9aa"
    sha256 cellar: :any_skip_relocation, ventura:        "7457c9871fc0dda3e234483cfae406ef47d0f33a1d9ce45de04ecf4a9d60216a"
    sha256 cellar: :any_skip_relocation, monterey:       "815506ab104370b4e33fd5d00d4d480ed0cbb7ef5eb02e003fc3d1a9557264ad"
    sha256 cellar: :any_skip_relocation, big_sur:        "98a01b05554eed16e2b6d5b47ba7508b14e6a627bf78f40f42bf6ba07b30bd82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0954a20a0da61c6d12601ee52ce6ed32edd906a9bf9386b391267e5da0010296"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/terramate"
  end

  test do
    assert_match "project root not found", shell_output("#{bin}/terramate list 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/terramate version")
  end
end
