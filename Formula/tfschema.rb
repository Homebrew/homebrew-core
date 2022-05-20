class Tfschema < Formula
  desc "Schema inspector for Terraform providers"
  homepage "https://github.com/minamijoyo/tfschema"
  url "https://github.com/minamijoyo/tfschema/archive/v0.7.2.tar.gz"
  sha256 "6954fbb10dbc0d730d2ee1fba4ff59f74d0961bc6ff9f1de2e04e81eb24dc493"
  license "MIT"
  head "https://github.com/minamijoyo/tfschema.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eab942aa977bc2759216c2962df77001ea87c333e45c0128f1dffb80ee417cf8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cb4b686fa0fbe684e0a85db4227f6bc65b8109ce12f32931faabc95c22e65d02"
    sha256 cellar: :any_skip_relocation, monterey:       "d8f4dda6d1b45caed55bcc4275b0205b90591baabed13932254df7bbfdc6131d"
    sha256 cellar: :any_skip_relocation, big_sur:        "20de1692f2b62be283e15c59cb73969d0e84736949ba5aa02000a5934c37f09d"
    sha256 cellar: :any_skip_relocation, catalina:       "ddf3a5a98a16911320c7c7b48b29b4d15c23b3cf5d666ac9fe55f54330190bc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "650cf107f261ae4343d968e6f6569618a21b448b359c223a3ee5e8a8febb6654"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build
  depends_on "terraform" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"provider.tf").write "provider \"aws\" {}"
    system Formula["terraform"].bin/"terraform", "init"
    assert_match "permissions_boundary", shell_output("#{bin}/tfschema resource show aws_iam_user")

    assert_match version.to_s, shell_output("#{bin}/tfschema --version")
  end
end
