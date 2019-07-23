class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.19.10.tar.gz"
  sha256 "b1ba991bf53bb87bb2f18612420fd05c22d36fc2681159cabbfd0f04c3452c81"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ed6178cc3ab34719aa88727b5c12f2ec8e23525f08465878d1fc5dee465d564a" => :mojave
    sha256 "193cf74b336e145a6ccecef733cef3fd93781f9263e42918b26c6626b8e1e862" => :high_sierra
    sha256 "842a36f48918f16c3a9ac8f67e4bd7152a4129ad5b6b508ec612f1ed093784ad" => :sierra
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
