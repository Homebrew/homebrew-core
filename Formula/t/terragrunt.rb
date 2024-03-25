class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.55.20.tar.gz"
  sha256 "8ac07bd48e3dbe566b360a05359ab943eb161cf48dc2199206a95093e85bb7fd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bd21664642aeeccd84e310879274c85c2ae9a69eb70d2c9eb7dcc05900a96ee0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "09e8106ae721b6f2a0f46e316adcf4fc59e16f15e9fece17fba058587005a5f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5eb2e25b40294abd90176e8cc9353acc3ca78edbfc10aec9bef7fe480b11aa2a"
    sha256 cellar: :any_skip_relocation, sonoma:         "5599530c2d666b97690715d298d232ec09299eb211cb1dc8ccc9473247415c7e"
    sha256 cellar: :any_skip_relocation, ventura:        "063990a0e12753e91d79e23a5cae52503edd8189b4d295e7bf99a0920819cae8"
    sha256 cellar: :any_skip_relocation, monterey:       "4fab3d0d4cb68c0d74795618a3a53a6f45a64d25af8419350ac7bc435025759d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4df16ac35d24f5b6dc81ba79d3fa7b53c268e9968757e26916ed7e4d4981747b"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/gruntwork-io/go-commons/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
