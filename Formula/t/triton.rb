class Triton < Formula
  desc "Joyent Triton CLI"
  homepage "https://www.npmjs.com/package/triton"
  url "https://registry.npmjs.org/triton/-/triton-7.18.0.tgz"
  sha256 "dfbecc0a7ff8ba4ebc3fccabe0db0457e135f4a03e04e653b2e415118ce0d823"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f659094baf39c772a72b10e6c14b525dca623dec1379b659ca83be1671af99dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d91ba4e07dc8385bfebe9d5c620c6e0dc60a5c14b839e5b8004e383441aadd19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6eb63ee8ae2ca6644715482d976f9783884d2f7c5b01be6958f012923ef60aa4"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b19e16266ab18e6ab90bf3aa3672a0cabb7148df781076edf3ecd68fc14fc59"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d46ab480b6e9321c5a1fa43791895e852cf7b36a1d29ee173e23a27b0571698"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5815c9642d4141e9bafa0b1439779bc0f42da92f73146ba0348c8d799775e206"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
    generate_completions_from_executable(bin/"triton", "completion", shells: [:bash])
  end

  test do
    output = shell_output("#{bin}/triton profile ls")
    assert_match(/\ANAME  CURR  ACCOUNT  USER  URL$/, output)
  end
end
