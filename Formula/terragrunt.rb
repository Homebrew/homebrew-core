class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.19.3.tar.gz"
  sha256 "30655bbbe889261acab7c3ea9a3d36300d2064210ca04759c6c932d2c449f0af"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2f2f33c30519e4a9bfc6ec9586d4879133f9131083966064b71c506b6063ec74" => :mojave
    sha256 "4fdbef408dd14eb399e397687f73a01cd00732daa10881efcef798538603c1e5" => :high_sierra
    sha256 "b7df75876abfe3a764b91ed52c8756df3430c033404354d8d3c29378d6d9daa9" => :sierra
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
