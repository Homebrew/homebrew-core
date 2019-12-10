class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt.git",
    :tag      => "v0.21.9",
    :revision => "4fe8220a487b28e1f8ae16f697c65a085e1da3df"

  bottle do
    cellar :any_skip_relocation
    sha256 "2b3c9f4b72416576af3aea43e5e4d4c6098ab462435582f572418ddc8a92246d" => :catalina
    sha256 "87df4854399fc6a67dd7c1f35f36a7c004781b3d4e5f25d3bd34887860ade1dd" => :mojave
    sha256 "18323a1b3c3bcba677c9234cada05cd843aabefe6be4dda879c717838bab3175" => :high_sierra
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
