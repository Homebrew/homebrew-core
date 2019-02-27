class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.18.0.tar.gz"
  sha256 "5d5872ac317e42deb99c07b6666d40fa14b76032780ff48e719c4271d868beb8"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b324d3f49f6c2c817365cac24760df475e73d7eeff59cf6ee35a15ecb799b839" => :mojave
    sha256 "a6a168a1a8da7d692381f56e817a635a6251fc66ef922a0226fdc32537ee8ade" => :high_sierra
    sha256 "d090775f701c8a5b942a803d458b7066939b4a6ca391e9247a16e555efc5a55d" => :sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build
  depends_on "terraform"

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/gruntwork-io/terragrunt").install buildpath.children
    cd "src/github.com/gruntwork-io/terragrunt" do
      system "dep", "ensure", "-vendor-only"
      system "go", "build", "-o", bin/"terragrunt", "-ldflags", "-X main.VERSION=v#{version}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
