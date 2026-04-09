class Vsh < Formula
  desc "HashiCorp Vault interactive shell"
  homepage "https://github.com/fishi0x01/vsh"
  url "https://github.com/fishi0x01/vsh/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "cf9350c3adb5cd0df031f3f44e58f040300dd8e3ad798f6c1583dc6902f7935f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b7a734a15409fb61ec222ec5716e9f6969e02fb46b517fe61dda4e1df48f656"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f8b53244f2ef6156f7b8bc917c9ecd86baca799a2ea791415ce2f9b84e825e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f8b53244f2ef6156f7b8bc917c9ecd86baca799a2ea791415ce2f9b84e825e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8f8b53244f2ef6156f7b8bc917c9ecd86baca799a2ea791415ce2f9b84e825e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5909bc9d4463dce38dabfa0238cd0dae7a60c451d9ce83cdde4350aca6cc43c"
    sha256 cellar: :any_skip_relocation, ventura:       "d5909bc9d4463dce38dabfa0238cd0dae7a60c451d9ce83cdde4350aca6cc43c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1840008cbb5e34dc3de6f5ad429ee45dc1ad00ba537d3999a65de0f623e3fe88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efcf0ec78b552d792483b5f77b6e6bd69bdb1dc02ab8221d2acf8a4662ed933b"
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
