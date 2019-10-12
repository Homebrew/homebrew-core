class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt.git",
    :tag      => "v0.20.3",
    :revision => "54f09ca195ad97e8f21a66369cfdf8413862d720"

  bottle do
    cellar :any_skip_relocation
    sha256 "c3792190500cb6cbc445c3def71ce39125afacfb74dbe4137b52c7d27bf80206" => :catalina
    sha256 "de04fd943aab9477b212b1f18d391006e17f03a5e04a6264196131516ab0e721" => :mojave
    sha256 "377c622f2c17f622debb7f6a714777ebcb5bf6a1d0d0ec6a625ffcfc3f009296" => :high_sierra
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
