class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt.git",
    :tag      => "v0.19.29",
    :revision => "c5d252a82e47e5508455452ec93ac8dd516ed46d"

  bottle do
    cellar :any_skip_relocation
    sha256 "730c42bb518b0134a62e8f2c9b0906f3f68a97b4d0c5474520e265e17cb0e260" => :catalina
    sha256 "9211ce0fbec56905046f1ff748b47d556e322efc651d567f861bbde35b7d560f" => :mojave
    sha256 "26432b8a23aa65631792298f709c65cfbbcb98ea5fd48c828fcd9e141f9dcb7b" => :high_sierra
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
