class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt.git",
    :tag      => "v0.19.25",
    :revision => "60039badc1ec6cf0e5e960fe1c226b49fbb61f4f"

  bottle do
    cellar :any_skip_relocation
    sha256 "e512fe3975242043c88688bf6434f250487e3b09ae029f9950adf457611ec512" => :mojave
    sha256 "30c9f70f865c06f55febc4c6d13775728779b9214918e6e65c21f58c1ff3039f" => :high_sierra
    sha256 "d66dc885cd177220458803897a69f491f02ee1ef5782769a84aa547c9e364320" => :sierra
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
