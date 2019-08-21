class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt.git",
    :tag      => "v0.19.21",
    :revision => "165ddfc6ff4632cd506da95df238ce19904f4ad1"

  bottle do
    cellar :any_skip_relocation
    sha256 "efecb89a05bc5229c231882d66f91a33b06ca8e2fd28248af4839afcac8c8e8d" => :mojave
    sha256 "f026027c32e02f074e4d42cf22a6298e5a91bfa9607871d5556529b108be543c" => :high_sierra
    sha256 "1c8f2b72a0e168a6adc6a349d636b5af21d8bba136c45a10a9880f7f420c8b50" => :sierra
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
