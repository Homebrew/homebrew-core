class Vscli < Formula
  desc "CLI/TUI that launches VSCode projects, with a focus on dev containers"
  homepage "https://github.com/michidk/vscli"
  url "https://github.com/michidk/vscli/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "91384db69cf5b32af96178df79634d5707eaffaf3517a567e965d3c5a32f81fb"
  license "MIT"
  head "https://github.com/michidk/vscli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ad8559f49092dd0c2fe1cfddf33097f92cabebb86dec9757a9a9d0766adcf7f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ccb604795d27bcc966a4aa2a33100b1162c808d2ec875a6e1420e8f879e1416"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00054eac8e8afb076cb0fdca4d5ff2eef8523963bf88ccbbb8e2a79c438813ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e8c0b3a54aa8f18e0e3bdf96941855a4641f73374e4c9c282c72b2aba9decb89"
    sha256 cellar: :any_skip_relocation, sonoma:        "367ff1a937fc6b20de3ac0f80feb8626e352bdb543ec0ac8958bd9e58a10d2c3"
    sha256 cellar: :any_skip_relocation, ventura:       "fa1962291453a1152836cd93461515b4eef44d9ae99c70de6f4f204836e7450d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc5eee1bdaa04dd44a7e813abc87e406ec2186f9f638399efeb9fc34b9c08ca3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8e75d6e48da77d6493750ce4d02c5de079d684e62908f7d3db2219477a8c250"
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
