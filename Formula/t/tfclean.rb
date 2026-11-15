class Tfclean < Formula
  desc "Remove applied moved block, import block, etc"
  homepage "https://github.com/takaishi/tfclean"
  url "https://github.com/takaishi/tfclean/archive/refs/tags/v0.0.20.tar.gz"
  sha256 "b384e1732e1fb77b8552ff65c12123526dbf41854d95518f9574178021fb156e"
  license "MIT"
  head "https://github.com/takaishi/tfclean.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "76413e3c7efc4343047e4658c88bd45fe48b7b4b78e0628c9397244fe9e7f053"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "76413e3c7efc4343047e4658c88bd45fe48b7b4b78e0628c9397244fe9e7f053"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "76413e3c7efc4343047e4658c88bd45fe48b7b4b78e0628c9397244fe9e7f053"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "dacbda5e6dbb41f2d125a06d858fae2f12c836cbff6d01f16eed8d6ad32b6d08"
    sha256 cellar: :any,                 x86_64_linux:      "940fd6ac21d038f33b7dde78fff16184f6cb3a3bb455f14ef53e851a50d1cc6d"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/takaishi/tfclean.Version=#{version}
      -X github.com/takaishi/tfclean.Revision=#{tap.user}
      -X github.com/takaishi/tfclean/cmd/tfclean.Version=#{version}
      -X github.com/takaishi/tfclean/cmd/tfclean.Revision=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/tfclean"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tfclean --version")

    # https://github.com/opentofu/opentofu/blob/main/internal/command/e2etest/testdata/tf-provider/test.tfstate
    (testpath/"test.tfstate").write <<~JSON
      {
        "version": 4,
        "terraform_version": "0.13.0",
        "serial": 1,
        "lineage": "8fab7b5a-511c-d586-988e-250f99c8feb4",
        "outputs": {
          "out": {
            "value": "test",
            "type": "string"
          }
        },
        "resources": []
      }
    JSON

    system bin/"tfclean", testpath, "--tfstate=#{testpath}/test.tfstate"
  end
end
