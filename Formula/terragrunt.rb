class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt.git",
    :tag      => "v0.22.4",
    :revision => "4ea63775a2d2cc85f8fd80900a2320741c34bb34"

  bottle do
    cellar :any_skip_relocation
    sha256 "5b83589bda9658771fd51cfadf5418218b24317c426c3c15513bb5e8f75d3176" => :catalina
    sha256 "71d26c64865034c9808e5cb1255b51187c639fe4fb2cb1ae40b57a7394cfcc70" => :mojave
    sha256 "41aee94e128a0672f1216e39642f0ff7eda56e76fe1996de7fbc7479f403b047" => :high_sierra
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
