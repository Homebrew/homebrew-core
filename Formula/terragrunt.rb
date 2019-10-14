class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt.git",
    :tag      => "v0.20.4",
    :revision => "0dcbc14aca6ed85b46c518bc16585651a3db4d6e"

  bottle do
    cellar :any_skip_relocation
    sha256 "954ba337fb4395a30129e90147986aef9a84ef7efd1f2e2da9207e5a2042ceae" => :catalina
    sha256 "7b327f1aadf6f89b1c9bd4257a756961524878cbec7928a206c66a34a8d77323" => :mojave
    sha256 "dffedf429b0996bfcc444f35091099c0bcc5f0e899287c385a3deb52baf21e1c" => :high_sierra
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
