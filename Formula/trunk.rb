class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https://github.com/thedodd/trunk"
  url "https://github.com/thedodd/trunk/archive/v0.9.1.tar.gz"
  sha256 "c3cc98ebbfccbc0c5dba7202abfd7a47a75960b3705a98f8037c489c56da3218"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/thedodd/trunk.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5681ee98f5bbb90a26ab603130eeeb0450b8799f89ebed0decf1499c995f5f4e"
    sha256 cellar: :any_skip_relocation, big_sur:       "ba3a3cd4fb1fc0c7bc312257acf87db1ace68e09ba19d6372e07b91e8262d411"
    sha256 cellar: :any_skip_relocation, catalina:      "c26c486e6d94f5951f6003be3ab6a461f49abb94dc92183363a6ae912a696b76"
    sha256 cellar: :any_skip_relocation, mojave:        "c9a313b1ed7344008478809ae58fd21a1a3ddc9f583309f9bc8e2d2f8516843e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "ConfigOpts {\n", shell_output("#{bin}/trunk config show")
  end
end
