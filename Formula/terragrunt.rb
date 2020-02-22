class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt.git",
    :tag      => "v0.22.4",
    :revision => "4ea63775a2d2cc85f8fd80900a2320741c34bb34"

  bottle do
    cellar :any_skip_relocation
    sha256 "630d0878af1060fe85baa39f71c168eb06c3ffe71c958da4320a244d140f7ae7" => :catalina
    sha256 "a85795850f172afc79e3a586144746dee237c25f805b36179a8f1a2c76095c64" => :mojave
    sha256 "b7e0df381fd0dfe0a4c60960e2b166189c49c817b750026d1a97b86d10ef34c6" => :high_sierra
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
