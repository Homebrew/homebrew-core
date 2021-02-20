class Vsh < Formula
  desc "HashiCorp Vault interactive shell"
  homepage "https://github.com/fishi0x01/vsh"
  url "https://github.com/fishi0x01/vsh/archive/v0.9.0.tar.gz"
  sha256 "58d739573e2b3db0bdd5664fe84f7dba432b03f18ddf6a3bb4ae97c4c9668ccd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4507ade970f06698e9f17a5f89832d6189afa2bc0f4a9791a79158dd987957cc"
    sha256 cellar: :any_skip_relocation, big_sur:       "5a7ba43614b9ec55f94cf2c501bb1f6333fafcceb02dd5229787127634335a2e"
    sha256 cellar: :any_skip_relocation, catalina:      "aa1e2c452a132a7fa3661a2c16dd230a1bbe21cffae6c1ff2dbee3970582cc5f"
    sha256 cellar: :any_skip_relocation, mojave:        "af58ffb5a4539134586be5fbd81f9578b925919414b7079f68e1639ea29cc715"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-X main.vshVersion=v#{version}"
  end

  test do
    version_output = shell_output("#{bin}/vsh --version")
    assert_match version.to_s, version_output
    error_output = shell_output("#{bin}/vsh -c ls 2>&1", 1)
    assert_match "Error initializing vault client | Is VAULT_ADDR properly set?", error_output
  end
end
