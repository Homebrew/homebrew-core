class Vsh < Formula
  desc "HashiCorp Vault interactive shell"
  homepage "https://github.com/fishi0x01/vsh"
  url "https://github.com/fishi0x01/vsh/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "567ced47700cf36e0a542867e2b92f816757b62e149cc62002dc561ab2312cfd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b6a4b735a04e0640e21c9a4ba1e437384658430260303ed1e787de595aceb1e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6a4b735a04e0640e21c9a4ba1e437384658430260303ed1e787de595aceb1e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6a4b735a04e0640e21c9a4ba1e437384658430260303ed1e787de595aceb1e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "a60059f373f2d4df7c70cb4576b62d54dac59a0a76ce46f230ad7120e764d37e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8560fff87d237aaea02e3c852f3d173710b119471980b474898ece4278cbc122"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b95abefde4d37025a3c52cb70280d1c2ec09f519c31ce38437ad05fc92769599"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.vshVersion=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    version_output = shell_output("#{bin}/vsh --version")
    assert_match version.to_s, version_output
    error_output = shell_output("#{bin}/vsh -c ls 2>&1", 1)
    assert_match "Error initializing vault client | Is VAULT_ADDR properly set?", error_output
  end
end
