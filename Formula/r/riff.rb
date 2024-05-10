class Riff < Formula
  desc "Diff filter highlighting which line parts have changed"
  homepage "https://github.com/walles/riff"
  url "https://github.com/walles/riff/archive/refs/tags/3.1.3.tar.gz"
  sha256 "eb244bb50a26af9d9cbaf3fd91b07e91ee8dc24057f079d4efeadd27345c9b48"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f1c09b46165ccd5e395aec2846221d5997607beb7f534da9bc86aea00c23a526"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "65fae237f11d5f256ee6d814691c64c8f664a58d78e4916071e346e6fcf12448"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5efc5ba56772808e645a16f8c97bbf44cbfc6892884a8d2937d6f0fd3ab88ba0"
    sha256 cellar: :any_skip_relocation, sonoma:         "42ea2cd776f268643c8642b314febcd244e69e8060be9a9ea304ea91d99bb1ae"
    sha256 cellar: :any_skip_relocation, ventura:        "d4738b5ac3159b5337f4ec9955bfcf6dad5b9f882768aee3814195d489b40fcb"
    sha256 cellar: :any_skip_relocation, monterey:       "7d0cbe5954aac92ccd2c489aae448ee9dc567679c6abe14af1228c66211e3595"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dda2948c3fa109b3ec8887c2ffad9f33c27e176e6f3f5008e356c1510df6e62f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_empty shell_output("#{bin}/riff /etc/passwd /etc/passwd")
    assert_match version.to_s, shell_output("#{bin}/riff --version")
  end
end
