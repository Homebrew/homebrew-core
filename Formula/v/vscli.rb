class Vscli < Formula
  desc "CLI/TUI that launches VSCode projects, with a focus on dev containers"
  homepage "https://github.com/michidk/vscli"
  url "https://github.com/michidk/vscli/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "af089ab9ccf80b24399575d1cea3014974d04ab73a4688259c53a2525da11d0d"
  license "MIT"
  head "https://github.com/michidk/vscli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2273f8d6dc3e13c957790a6998f02a7d833b99db3b068923da6ded29d0b89817"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22b01724115be58e091a1944af0e8f8a3b4a663a29e5a3a7ca994cd90842ae4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac9796e0c0ac9e59e1939e44138470380f150eb2def5b10d60f4625bbb74db86"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d47361b0293b964768ac61816149744584184c6e441bc4229a187f6cb8e43df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e6e8f7c90afd4354a42e678dd887adb959a9e0eb6e756aa3a00da1b90b5218c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b42485a36a1a3586d9873cb8ef5fb3e0dfe6e00c1d04148d712d3064a56be218"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vscli --version")

    output = shell_output("#{bin}/vscli open --dry-run 2>&1", 1)
    assert_match "No dev container found, opening on host system with Visual Studio Code...", output
  end
end
