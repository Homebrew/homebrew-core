class Vsh < Formula
  desc "HashiCorp Vault interactive shell"
  homepage "https://github.com/fishi0x01/vsh"
  url "https://github.com/fishi0x01/vsh/archive/v0.12.0.tar.gz"
  sha256 "59387d8512c7c2f9fe9a99508e2c913fcff6c5d8422ae90ba19c2c95895d2a3e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "014123ef3db65ca6c5ef44607b85f15d33456475161f0ba9a66654c6c9fabd87"
    sha256 cellar: :any_skip_relocation, big_sur:       "4d616d613324f4289d5ab4d51fe8fe4cbc44d676399f20c945a83e1b0291fdf3"
    sha256 cellar: :any_skip_relocation, catalina:      "b63300d4db50898209cc4322973f692c49efb0670df5b72a816660e3941f9654"
    sha256 cellar: :any_skip_relocation, mojave:        "9ac7a12b169868af589a1c4044db817b1ad1df20266299203f80f7135450313f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de5c2cde166c22abb15d2579d0d6be19454652eaf2563f8aa4270adfb26f6407"
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
