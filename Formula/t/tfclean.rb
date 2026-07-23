class Tfclean < Formula
  desc "Remove applied moved block, import block, etc"
  homepage "https://github.com/takaishi/tfclean"
  url "https://github.com/takaishi/tfclean/archive/refs/tags/v0.0.19.tar.gz"
  sha256 "c49a21e2e5dbf06a2e0c7e93877ea37912e92411ca84a0caca5ea3282e70ef5d"
  license "MIT"
  head "https://github.com/takaishi/tfclean.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a2fa526bf9a8f1faf86841f84bfcee807367ed89f05fd0305af18ef05240147"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a2fa526bf9a8f1faf86841f84bfcee807367ed89f05fd0305af18ef05240147"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a2fa526bf9a8f1faf86841f84bfcee807367ed89f05fd0305af18ef05240147"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ee0966de818daba7cc80b949cac85c37ac26c3caf37d652846f180451ab5b73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44f0d465285c58b4b2a4ccad1770592344d9e8511e41f3e85f663b6fac124d11"
    sha256 cellar: :any,                 x86_64_linux:  "ceda94a41cad829ff09f3e95db72fddd8387c03eaf9dcc6d5e97eeb7332416f5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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
