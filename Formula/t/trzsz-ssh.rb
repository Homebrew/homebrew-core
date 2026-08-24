class TrzszSsh < Formula
  desc "Highly OpenSSH-compatible client with extended features"
  homepage "https://trzsz.github.io/tssh"
  url "https://github.com/trzsz/trzsz-ssh/archive/refs/tags/v0.1.26.tar.gz"
  sha256 "67c9082543e1785ece3f5ab09f6299cd655e3657593d55cc85751c097c1bb381"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "25d9347e231161ded28bd30b6372f1af327148c753a803b8fb4c87689ccead52"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25d9347e231161ded28bd30b6372f1af327148c753a803b8fb4c87689ccead52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25d9347e231161ded28bd30b6372f1af327148c753a803b8fb4c87689ccead52"
    sha256 cellar: :any_skip_relocation, sonoma:        "d11fa6e154eca29b481906cf219ed5660964e21867ba1412b1d322f18f7cb563"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0485e744eb41a00e334e8e9d1c456bd94ec40cab1d1a2510b36b77904aea389"
    sha256 cellar: :any,                 x86_64_linux:  "6b6d164a14fcade3738be4672279032468e2ea521bbf86fb661bae2477bc82c0"
  end

  depends_on "go" => :build

  conflicts_with "tssh", because: "both install `tssh` binaries"

  def install
    system "go", "build", *std_go_args(output: bin/"tssh"), "./cmd/tssh"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tssh -v")

    assert_match "invalid option", shell_output("#{bin}/tssh -o abc 2>&1", 11)
    assert_match "invalid bind specification", shell_output("#{bin}/tssh -D xyz 2>&1", 11)
    assert_match "invalid forwarding specification", shell_output("#{bin}/tssh -L 123 2>&1", 11)
  end
end
