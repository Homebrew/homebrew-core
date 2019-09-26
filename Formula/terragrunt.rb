class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt.git",
    :tag      => "v0.19.27",
    :revision => "61b390169803dd338a3b28aca2a25617ec2e4051"

  bottle do
    cellar :any_skip_relocation
    sha256 "29680fc7304db135801be637bfad59811c9d21bd39c65b0eaae39dd87931249f" => :mojave
    sha256 "72ce311e284c6ef881096735f044af5c6cee458d09a420ffa9b5117a515d24cb" => :high_sierra
    sha256 "462d2ff0dedae55108ddcf39c26d228824c79be9401f4e45190d6565f6f6c9bf" => :sierra
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
