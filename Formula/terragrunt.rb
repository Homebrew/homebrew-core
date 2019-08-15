class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt.git",
    :tag      => "v0.19.20",
    :revision => "8fa2f715589fcba6c6e0131e4d954b9b4264463d"

  bottle do
    cellar :any_skip_relocation
    sha256 "fe5445a379e6006432922e905808fa016e9433833a7c6883caf322c25d9bd823" => :mojave
    sha256 "deb31f3cbeb98d1afe5171f9f2a7ca3f1369690116d2b4598962a170b3eaae95" => :high_sierra
    sha256 "05107e0e41ab22acdbccc62c1655ab3ed56319f1578ae35b70a9128204bf09da" => :sierra
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
