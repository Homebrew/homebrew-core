class Rainfrog < Formula
  desc "Database management TUI for Postgres"
  homepage "https://github.com/achristmascarl/rainfrog"
  url "https://github.com/achristmascarl/rainfrog/archive/refs/tags/v0.2.13.tar.gz"
  sha256 "e45c13452026d9fe2f5b5db58053704e2c6846b1d9fe182c0b70a296f09b9dba"
  license "MIT"
  head "https://github.com/achristmascarl/rainfrog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ab4c84882adcc8f6b982300ab6b48a7228948eb68cb8289a59253ab7e74733d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2fb48af3972a6c6f95a6ba9eb55b034dc79cce27cee2792dd582408f8105a775"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "88d34d540ce2e8b84d01b3a2e413de3b63ed12f49fac5d87908ef863ee49c78f"
    sha256 cellar: :any_skip_relocation, sonoma:        "08f7817e3e823c800a2b130168888e25771834988c70f4f84f8491a912efc28a"
    sha256 cellar: :any_skip_relocation, ventura:       "813e6ae0de7609e2bfe704caad40862e77bb636f54b734da3a39dccd83ef3a46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c0b707db98845d9a82d9c445dc7e59f10871bcc31fb64d1b9b284aea2176ed8"
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
