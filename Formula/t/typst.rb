class Typst < Formula
  desc "Markup-based typesetting system"
  homepage "https://github.com/typst/typst"
  url "https://github.com/typst/typst/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "4b7886e312171b66fb33b7ad49c4df76748231d0047fb96b407c926070a5d9f9"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/typst/typst.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f084ffabb2efbfe7df1ea0668f75655bbfbd9f6a80acc44f40a41c8c2965e5c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b09a9e19898c703b735ac6955db184d0df71adb6351354c5b9de4cc18de11baa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0086ad6f93c1d63c74441fc32c0fa0b26728ea76b91a195ca79df2cc4422564f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "31b0a75f706d0c9bade8fb730d64de8a4ed945e18dfffa5f2c697574ee2cffed"
    sha256 cellar: :any_skip_relocation, sonoma:         "8edd2a386b8238853e9a15e8f8c31dd61e4f559344fd8115be778f8cb51abdef"
    sha256 cellar: :any_skip_relocation, ventura:        "d2e73542a56fd6d324decc34094caaed4e5a882b293a517916b17b1dbcc2c921"
    sha256 cellar: :any_skip_relocation, monterey:       "1dae96138e37da5984cf7889fbee33f36c84c9221d3aad3d90eb411cf7d09c50"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e37fa63e1dcb2f8dc2e1ec775cff0e7b52798aeb8fcdb1541b62dd9a33c91f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a6266fb97405e7202d4caed1b825c335cdbe7e2790cf8aad5f3c22256a8b570"
  end

  depends_on "rust" => :build

  def install
    ENV["TYPST_VERSION"] = version.to_s
    system "cargo", "install", *std_cargo_args(path: "crates/typst-cli")
  end

  test do
    (testpath/"Hello.typ").write("Hello World!")
    system bin/"typst", "compile", "Hello.typ", "Hello.pdf"
    assert_predicate testpath/"Hello.pdf", :exist?

    assert_match version.to_s, shell_output("#{bin}/typst --version")
  end
end
