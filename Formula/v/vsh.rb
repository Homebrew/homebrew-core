class Vsh < Formula
  desc "HashiCorp Vault interactive shell"
  homepage "https://github.com/fishi0x01/vsh"
  url "https://github.com/fishi0x01/vsh/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "466e90137244b13c44befef8fc534f158c4ebe601bc20a66f0e8eabd9fbf9b27"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "bfb05cd63316f9a7785b2f0bec45c313c0db18f2b1c3f862ae6a3794c10c068a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1eddab680208703797754eac3642e5a2a37ae1f38f1ccaa508b19c1708c911c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "223c2d94808d93148a39f0c878979d2356368d0f027a81481f6ecc278f1b07e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1d07760031eaf0abf803b3c6fe8b9efe8e0fa7bdb42787654a4ba8de46ac099"
    sha256 cellar: :any_skip_relocation, sonoma:         "cdec21235359d1c5b1d8994b8419faf2419be227d386c2e3f047747ac43da588"
    sha256 cellar: :any_skip_relocation, ventura:        "b3fbdf3f8c844c4825a63389eb3d557919e2385c09bed4b7df28a0fda61e2179"
    sha256 cellar: :any_skip_relocation, monterey:       "9b7f2bbc2ed69620455f4f47ce1b4bee19ecf7786a740297aa978780633036b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c453531f19e7cdca825575fad38ae6c88c30adcca557becd656aa1e21e1a89a5"
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
