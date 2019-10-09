class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt.git",
    :tag      => "v0.19.31",
    :revision => "710809af4f0c261e34bd9a30761f4101f4cd565d"

  bottle do
    cellar :any_skip_relocation
    sha256 "93f2949946cf5d7fca37cd1d301cb5a50a65c9b320c1ab042812aeec8395b4af" => :catalina
    sha256 "2fa0f12970917c5adb52d20d0928a0dbc59b211ff2048a54a79198d3ad01233b" => :mojave
    sha256 "11990d0a4a838d4c9e5db5d22a4dfdd0b48339ee6ee463c1071f5359d75840e8" => :high_sierra
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
