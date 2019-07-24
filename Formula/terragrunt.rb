class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.19.11.tar.gz"
  sha256 "8b87fb836720be885ef806092c750db7d9a2d73d7de97631c4b8c97b64390029"
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
