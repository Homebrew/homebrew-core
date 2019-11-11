class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt.git",
    :tag      => "v0.21.5",
    :revision => "d31069b1ecfd5f60337246334668d081ada4d23b"

  bottle do
    cellar :any_skip_relocation
    sha256 "4a8a03a322876317ebe2de99d0a65811e61d97fbabf8e56383127e851b569782" => :catalina
    sha256 "8510552bb242d2df098c32e5b01d35ada46dd9c1bdb9dfe5e2b557d79f64b965" => :mojave
    sha256 "9bdf9957f926e735644c935845f3596a339ab76b2799d9931ab19a5249948652" => :high_sierra
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
