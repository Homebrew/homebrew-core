class Shellz < Formula
  desc "Small utility to track and control custom shellz"
  homepage "https://github.com/evilsocket/shellz"
  url "https://github.com/evilsocket/shellz/archive/v1.6.0.tar.gz"
  sha256 "3a89e3d573563a0c2ccb1831ff41fc0204c8b4efb011c10108ab98451a309b1c"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4e891a0581c95cdbe2b0736a921e97fef50b702fcd445dc9c2c26d6acd529ccd"
    sha256 cellar: :any_skip_relocation, big_sur:       "85f5058492ebd2e7d64347418f3a66267da72800ba6ff94682fbcd23d1c1614e"
    sha256 cellar: :any_skip_relocation, catalina:      "5f0e41d34454419df76d6a4bd7213b4c20297bf0a6732bddbebce8fbfbc2ba5a"
    sha256 cellar: :any_skip_relocation, mojave:        "3200f4361fc2d855b7417d48bf853f16346c14d0745fc831758120a427f81cef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4e845e86d9676386c8afe312c324b8d6f3576e8303bdee84f86f893b822103e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/shellz"
  end

  test do
    output = shell_output("#{bin}/shellz -no-banner -no-effects -path #{testpath}", 1)
    assert_match "creating", output
    assert_predicate testpath/"shells", :exist?
  end
end
