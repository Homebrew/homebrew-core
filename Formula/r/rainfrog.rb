class Rainfrog < Formula
  desc "Database management TUI for PostgreSQL/MySQL/SQLite"
  homepage "https://github.com/achristmascarl/rainfrog"
  url "https://github.com/achristmascarl/rainfrog/archive/refs/tags/v0.4.4.tar.gz"
  sha256 "ae30413b7f13fc153698f950414b62deb327e504ae0f706d9dc5d69f14091782"
  license "MIT"
  head "https://github.com/achristmascarl/rainfrog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "210990928b9e59add48512320edbc32d5af653e5497200d8b51e8efb1ffebfc5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fac4af841387ec7276abb4683c0088b2c7a99e1d15257251a805f30bca7cb765"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9adfa8fee8f5e2d42f428bccac6a8ebce9d05adebd4cb3bf5110281e16526296"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e5f60697fb99c26d69a268f01c023acecd90fe5a32b3e5f6b75c5e14e5c003f"
    sha256 cellar: :any,                 arm64_linux:   "4e5e68ff861c22458782893686c793981bd9dd0b77a1b83423a8922c7e004861"
    sha256 cellar: :any,                 x86_64_linux:  "fc918bef960651ca03d9e7034e14399a71de655684f2e675e61fef0a862dfa91"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # rainfrog is a TUI application
    assert_match version.to_s, shell_output("#{bin}/rainfrog --version")
  end
end
