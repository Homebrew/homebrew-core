class Wassette < Formula
  desc "Security-oriented runtime that runs WebAssembly Components via MCP"
  homepage "https://github.com/microsoft/wassette"
  url "https://github.com/microsoft/wassette/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "7eee8ad6b10e693007ea148a96268c974df90b69262dadf0e6ef3e39eb83b412"
  license "MIT"
  head "https://github.com/microsoft/wassette.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d6dc0309b190be507bb09c5782c388704ac42ec54b871fd94b142ee1351263d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a30d40172b5706ac74f0405afc8bf265ce4c90aa8229f558d7a828530dc8c5eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "929c294ae3b67142901ac405e46b90698c17af21a0894a8497b3d83eca183492"
    sha256 cellar: :any_skip_relocation, sonoma:        "27f17ed257248c0d675879ecf86f0b37766ed8bb140efaf871c6f87c3c259a8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05562a30e674e53d0f482b58ea18d0c2f4e7addbcca91369e258815b4ccba6c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3a04545887eee5996961ab226b0fd2a668ccb00e5fc41a058921f75a88907dc"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wassette --version")

    output = shell_output("#{bin}/wassette component list")
    assert_equal "0", JSON.parse(output)["total"].to_s
  end
end
