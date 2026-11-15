class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://github.com/apollographql/rover/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "224cdfdd705856d703187a9ee09911cb499177394ec5f3b993d7abc127754e1e"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0000020cc190f7c81e00eb72a0d968fd9e1ee119799e17961ac523bc024e1214"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5954d0972fd599b19bddab2d080be5b589380f7e8e9b159b1c2d259712907435"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "329b4bef6482a76db691346c96a66d5e51448bbb334c9c48ae4bdae1026959e6"
    sha256 cellar: :any,                 arm64_linux:       "e0a4a09f1c3c7558f20aba8310ab631fff23310effe78ce4c676a835b5136e65"
    sha256 cellar: :any,                 x86_64_linux:      "5d0ada0ffb0191d60ffa6b4e4b8b7adc654bb0cd0791bbf7de4b8002b7317f0c"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"rover", "completion", shells: [:bash, :zsh])
  end

  test do
    output = shell_output("#{bin}/rover graph introspect https://graphqlzero.almansi.me/api")
    assert_match "directive @specifiedBy", output

    assert_match version.to_s, shell_output("#{bin}/rover --version")
  end
end
