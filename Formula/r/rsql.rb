class Rsql < Formula
  desc "CLI for relational databases and common data file formats"
  homepage "https://github.com/theseus-rs/rsql"
  url "https://github.com/theseus-rs/rsql/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "9d7a3450f0e883c1ca14719c3ed69e63c7dc1066cf3fc98ac025ae2d9b76e68a"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/theseus-rs/rsql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea669ada67646a584f8e2710050903185e7a81f977df63ffc17b01e9c8c13843"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aed527eb81dad75fae3883db1b60760f2793622aea6ba9fd55d205232a373f76"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3e3abb78b28b21eebba40d8c5f06bb4d0446080cc36fb2d77c55eb75aa70a9ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "302b943217f5ddf884acca6d92ae2eca70e182d903355cdd905613fb3ecfdc94"
    sha256 cellar: :any_skip_relocation, ventura:       "04eab41ab71c7ce385c5c40e289570d4358ec3f44d1dd5b432deef6a6ebe8834"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ffe4a802abd454a57a07ab75d0db92ffb9b76574820abd3a39ccb32683a8538"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad1cfd407f2020aa2afa33c07c4b8e397eff3a84e68fbc4214fe1c01518acf66"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "rsql_cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rsql --version")

    # Create a sample CSV file
    (testpath/"data.csv").write <<~CSV
      name,age
      Alice,30
      Bob,25
      Charlie,35
    CSV

    query = "SELECT * FROM data WHERE age > 30"
    assert_match "Charlie", shell_output("#{bin}/rsql --url 'csv://#{testpath}/data.csv' -- '#{query}'")
  end
end
