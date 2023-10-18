class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.52.3.tar.gz"
  sha256 "4fb787fdd7f1572f65ca584c8f6f6d79f0cf2a28377f1e081e891fed0ac010a8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "75a34501eb37575c213c23bd86083c7e302d10ecec5c799d8d663ac05c04477b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c340011b3733e177aeba4d5cde34cd2ef0fee8b42413a4651e2b62f2b4a4cd7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8a5ab65e5672dcc66af691344071f52f7f1e8fc93055a1f228e082c395f43bb"
    sha256 cellar: :any_skip_relocation, sonoma:         "298e325cb9035e1e9d5fcfc6e9f561e9639333ae8445fd1ece18c5e7515920a3"
    sha256 cellar: :any_skip_relocation, ventura:        "265da065771b25e31fdacaa7b91af133ea47f69410997727214eba6056febad6"
    sha256 cellar: :any_skip_relocation, monterey:       "d44eae908dd2d10a9088e92bff7464cfedd8fa9aefe47d088ab28fb0646ee394"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42a2bd196f95bbd60687830d2ce513757f7b4f204c63d1391ebb0e27d3a97b22"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/gruntwork-io/go-commons/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
