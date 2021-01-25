class Vsh < Formula
  desc "HashiCorp Vault interactive shell"
  homepage "https://github.com/fishi0x01/vsh"
  url "https://github.com/fishi0x01/vsh/archive/v0.7.2.tar.gz"
  sha256 "f20885425a9c6ee04ed447046e6df113585469b37332e02b7a23639b718314a1"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "0af5c38833134db8fa818f6bd7ae6b1b1b94e9984a387b01887d3b8f7aebcda6" => :big_sur
    sha256 "65bc43c8b8ad6a8bb2ddd714990f6391d65478e3556522a38374e0c3704608ce" => :arm64_big_sur
    sha256 "7232f135e336d31e7a8f5d31781e926ddc82abc6463d78d8839694f109a45955" => :catalina
    sha256 "3174e3ea2b7fe1df28581c295eeee44c565cc31f69e6daed434e77f797e145a0" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-X main.vshVersion=v#{version}"
  end

  test do
    version_output = shell_output("#{bin}/vsh -version")
    assert_match version.to_s, version_output
    error_output = shell_output("#{bin}/vsh -c ls 2>&1", 1)
    assert_match "Error initializing vault client | Is VAULT_ADDR properly set?", error_output
  end
end
