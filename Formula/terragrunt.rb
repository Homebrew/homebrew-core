class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.29.3.tar.gz"
  sha256 "e52401d7cbfdf915e654e3e5f843508ab66749e70318f54be5f4c4bdf7e1e622"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d1f01a168e65d03a2208fd372ec69ec4735772885c24dc2ff50b84ad27f16d96"
    sha256 cellar: :any_skip_relocation, big_sur:       "b9d501ab44507337716bd8b7efa1fe8f4432c9c3667391c05920fad3b6fd4d0b"
    sha256 cellar: :any_skip_relocation, catalina:      "e0a3c66646ac8186321b0a515419ea70b3d5e5f82585fdb548e0e6ae32c126ff"
    sha256 cellar: :any_skip_relocation, mojave:        "8e82855978f221a2f4d10e1c8bd47c6c8ee6df524c85beca9a046da56ef377df"
  end

  depends_on "go" => :build
  depends_on "terraform"

  def install
    system "go", "build", "-ldflags", "-s -w -X main.VERSION=v#{version}", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
