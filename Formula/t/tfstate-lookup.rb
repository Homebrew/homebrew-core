class TfstateLookup < Formula
  desc "Lookup resource attributes in tfstate"
  homepage "https://github.com/fujiwara/tfstate-lookup"
  url "https://github.com/fujiwara/tfstate-lookup/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "b09a4f07744c5dde32904be3fdb1184cfe5087d7715c473f7b111e30a66ce503"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52ecbf8e2fc461cf8b0d831e4ec2fa744d9e6e62c1e390c6e6b76b0c5e59ecdd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52ecbf8e2fc461cf8b0d831e4ec2fa744d9e6e62c1e390c6e6b76b0c5e59ecdd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52ecbf8e2fc461cf8b0d831e4ec2fa744d9e6e62c1e390c6e6b76b0c5e59ecdd"
    sha256 cellar: :any_skip_relocation, sonoma:        "5433d18708b3010f6dad7d13646032021ce422ef9c5fac69deecbad80ac66491"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd38299a8e27120296d3e63b508dcf6f613d01c318af130573f711a1f7ae390e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f1aab88211780c3f07c3b6f10766adedfb4152c2adebb870347e869df2c7744"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/tfstate-lookup"
  end

  test do
    (testpath/"terraform.tfstate").write <<~EOS
      {
        "version": 4,
        "terraform_version": "1.7.2",
        "resources": []
      }
    EOS

    output = shell_output("#{bin}/tfstate-lookup -dump")
    assert_match "{}", output
  end
end
