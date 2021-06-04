class Shellz < Formula
  desc "Small utility to track and control custom shellz"
  homepage "https://github.com/evilsocket/shellz"
  url "https://github.com/evilsocket/shellz/archive/v1.5.1.tar.gz"
  sha256 "ff7d5838fd0f8385a700bd882eab9f6e5da023899458c9215e36e2244cc11bfd"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4e891a0581c95cdbe2b0736a921e97fef50b702fcd445dc9c2c26d6acd529ccd"
    sha256 cellar: :any_skip_relocation, big_sur:       "85f5058492ebd2e7d64347418f3a66267da72800ba6ff94682fbcd23d1c1614e"
    sha256 cellar: :any_skip_relocation, catalina:      "5f0e41d34454419df76d6a4bd7213b4c20297bf0a6732bddbebce8fbfbc2ba5a"
    sha256 cellar: :any_skip_relocation, mojave:        "3200f4361fc2d855b7417d48bf853f16346c14d0745fc831758120a427f81cef"
  end

  depends_on "go" => :build

  # remove in next release
  patch do
    url "https://github.com/chenrui333/shellz/commit/10bd430.patch?full_index=1"
    sha256 "c23d375e7ea2b20e3c2c0fec39adda384a0ce34482c7d97f8aa63c1526bf80f3"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/shellz"
  end

  test do
    output = shell_output("#{bin}/shellz -no-banner -no-effects -path #{testpath}", 1)
    assert_match "creating", output
    assert_predicate testpath/"shells", :exist?
  end
end
