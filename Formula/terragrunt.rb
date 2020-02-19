class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt.git",
    :tag      => "v0.22.3",
    :revision => "ac89420f986fbdb9d1aa2fd3e061a27ebe848ae3"

  bottle do
    cellar :any_skip_relocation
    sha256 "0af1e2b79cb3b578ac35ea74ec22fae2583d60a8031755aadeb127d8f5d76895" => :catalina
    sha256 "f24bfd4a33cae208b4d5a0b0bf3eaaa1c35169ddf78b70310dc5925f0708869a" => :mojave
    sha256 "056ee0de7497faa3cade3a15a1a8e123fe58fdc79448363a11c828e54057ab85" => :high_sierra
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
