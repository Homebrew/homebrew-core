class Vsh < Formula
  desc "HashiCorp Vault interactive shell"
  homepage "https://github.com/fishi0x01/vsh"
  url "https://github.com/fishi0x01/vsh/archive/v0.12.0.tar.gz"
  sha256 "59387d8512c7c2f9fe9a99508e2c913fcff6c5d8422ae90ba19c2c95895d2a3e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "395434d77f8be0aea32de54f9830c2e4cc492832d2ef5adb890d156af1e2070c"
    sha256 cellar: :any_skip_relocation, big_sur:       "071228bd8b0015e7f5589c85047b2bab1e13e08183b9f3490f629e4cc2808382"
    sha256 cellar: :any_skip_relocation, catalina:      "21b2b865533d7ec601a3ea80718b9da6d0f2b634efc9beffeb06a216a2b6258b"
    sha256 cellar: :any_skip_relocation, mojave:        "be78aad5e819aea94785ff0ce734a9ca673df656e2b0141b40da3d8d80f377f1"
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
