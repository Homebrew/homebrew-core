class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt.git",
    :tag      => "v0.21.6",
    :revision => "7be8eeda754fa1449265cd48356ec732c879ad90"

  bottle do
    cellar :any_skip_relocation
    sha256 "ec2971d6f1f3c4835263eb3d67dcbd8a52dafbc42a51f831fcd7aaf08124277f" => :catalina
    sha256 "2e089cb9b5cfda3f9c023f91338fdb4ee2e92d770a147e8b789cdbb4efef1f00" => :mojave
    sha256 "7c40aeeaac92a84b6fb1104621ca028c427e57112a4fccc55f6e8012d57a2fe2" => :high_sierra
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
