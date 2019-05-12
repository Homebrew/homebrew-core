class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.18.5.tar.gz"
  sha256 "838e1c4280c99e49f29198d907ab835bb6e9b48b7a73a292513f3fdc90e174ef"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4fc6e279238bdf7b2173e315954304a294ae3ef149da31294182c13fe5ba6a17" => :mojave
    sha256 "b4655e1cb11707169b9daccd018024f222e2a62a97170cb387d4ab7db61cea99" => :high_sierra
    sha256 "c4a8e2d3243e55b24d4ba259365f60db310baff488fa4bcb76829223281702ed" => :sierra
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
