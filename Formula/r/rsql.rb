class Rsql < Formula
  desc "CLI for relational databases and common data file formats"
  homepage "https://theseus-rs.github.io/rsql/rsql_cli/"
  url "https://github.com/theseus-rs/rsql/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "d5e89676f8c172f7e3782232fade71eaeaa3a4f8b823be764b04236579751582"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/theseus-rs/rsql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4aa81270cd942a716e593c5969547919037dc450355b1f4f972036cd40ce5402"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "370688aff3e6650c19c54f335ba5f70e0358189ed548f8a03bad30a23139a2c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "87b7f40d08a67490bbeed96864ff711c897921229dd62fd15fa9ab9ab615ac9c"
    sha256 cellar: :any,                 arm64_linux:       "b42429ea9788d9d3ed074dc78195279914a2ff37b22fbfcf78017035269d2086"
    sha256 cellar: :any,                 x86_64_linux:      "825ba844420236ad6dba89bee3e4911e17dcf9e1943639dd4cf70de83862307c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Fat LTO exceeds the memory available on hosted Linux ARM64 builders.
    github_arm64_linux = OS.linux? && Hardware::CPU.arm? &&
                         ENV["HOMEBREW_GITHUB_ACTIONS"].present? &&
                         ENV["GITHUB_ACTIONS_HOMEBREW_SELF_HOSTED"].blank?
    ENV["CARGO_PROFILE_RELEASE_LTO"] = "thin" if github_arm64_linux

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
