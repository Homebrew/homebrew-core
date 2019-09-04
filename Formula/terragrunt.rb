class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt.git",
    :tag      => "v0.19.22",
    :revision => "56c45d9ef940399a9ddf67c7a9f8cb5f57b3e0cd"

  bottle do
    cellar :any_skip_relocation
    sha256 "5ea5f40e035d208ec2c99502475e2c6607625a68ed557035f554cecd63a23fda" => :mojave
    sha256 "8db5d0de9cd87e9cee90e06e4ddf133987acc0dab971617348880cd2f8bd9cfb" => :high_sierra
    sha256 "0176881093f6264de5bac672e5cb2b05e07e397b305205de237831d18da50a65" => :sierra
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
