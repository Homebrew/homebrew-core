class Yeet < Formula
  desc "Packaging tool that lets you declare build instructions in JavaScript"
  homepage "https://github.com/TecharoHQ/yeet"
  url "https://github.com/TecharoHQ/yeet/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "b793d07304071c07dde135c656aa6effd5b3bc1d38623a72a3510e5c611672a8"
  license "MIT"
  head "https://github.com/TecharoHQ/yeet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a64ebe364abe919c485ae2c45b8b907d6608d79c26c195c98e2b451f0d79502"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a64ebe364abe919c485ae2c45b8b907d6608d79c26c195c98e2b451f0d79502"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a64ebe364abe919c485ae2c45b8b907d6608d79c26c195c98e2b451f0d79502"
    sha256 cellar: :any_skip_relocation, sonoma:        "16ba4cd6fc30270de1613de4b6a51a1c6c5cd0d4af1fc06fffc4a0843d2189c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22266d8460064c82256e4196987b72c77b056cac9a2db4f9c0bff8baf38a81fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6d294ff56054ff457e2da59d46ec8adfcb2fce71572a3a9b67e403947fc3cf8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/TecharoHQ/yeet.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/yeet"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yeet -version")

    output = "open yeetfile.js: no such file or directory"
    assert_match output, shell_output("#{bin}/yeet 2>&1", 1)
  end
end
