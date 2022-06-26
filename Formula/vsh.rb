class Vsh < Formula
  desc "HashiCorp Vault interactive shell"
  homepage "https://github.com/fishi0x01/vsh"
  url "https://github.com/fishi0x01/vsh/archive/v0.12.1.tar.gz"
  sha256 "bba0012dda672d1c23e414f6a5da30a241dc8a0a212ff49236f880fcdf68e446"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26eab160879dd577cf97db36ff408bdec104c6c539ec2327dca68a63747ec7f6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "be7c3c523c6569de739931d58efa026a27d0c11eac9f346ba7faf868cf44bef7"
    sha256 cellar: :any_skip_relocation, monterey:       "5f3e7266a0a9490181027542debb58ab4bb80eaf629d8a3bbbdc4af828045608"
    sha256 cellar: :any_skip_relocation, big_sur:        "65d5395f60ec5fd1e9102d7f9e631771a81d0d4c82a21286dc7cd504c8b6a62f"
    sha256 cellar: :any_skip_relocation, catalina:       "a0d65e2cde343394ffa0fc8a83bae0f6e601c84021cead1768d5abab8be510c8"
    sha256 cellar: :any_skip_relocation, mojave:         "e3c6daf68d62eea77e5fd51499cbd7298ace43e98ebf9810a786dd2f89cd825d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9c44954fac3407c4319195d5307124c880005cd4db29639385a5704c31a639f"
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
