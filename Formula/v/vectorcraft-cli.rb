class VectorcraftCli < Formula
  desc "Headless VectorCraft CLI and MCP server to convert, inspect and script artwork"
  homepage "https://getartcraft.com/apps/vectorcraft"
  url "https://github.com/storytold/vectorcraft/archive/refs/tags/v0.21.1.tar.gz"
  sha256 "6735d662f8545c843bb671daa20f4378b405afa5e2aa681b3bf40f1e2c3abf58"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/vectorcraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1f33fa19f0d41f15dc2cfcec6136fd9909971a6cb8af13b77fdb6bce009be370"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "af10614eb0f279d0a7216b2e85388782d96cdc7625919698cd3a5463810f43a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7704f3b552e32f62b972901ded2b59e494c68fe980df5e2a2a7868a8feec0bf0"
    sha256 cellar: :any,                 arm64_linux:       "faf9e50b6fc676d12e23b64f3d2496aa8aa390a5bcc65579646c820e13f9e9be"
    sha256 cellar: :any,                 x86_64_linux:      "7ef6420f8f760bdbcf6d062037a63a0880ea8ce63bd76c3ab39c67ca953fa743"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/vectorcraft-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vectorcraft-cli --version")

    system bin/"vectorcraft-cli", "run", "--cmd", "file.new", "--params", '{"width":64,"height":48,"units":"Pixels"}',
           "--cmd", "shape.rectangle", "--params", '{"x":4,"y":4,"width":24,"height":16}',
           "--cmd", "shape.star", "--params", '{"cx":44,"cy":30,"radius1":12,"radius2":6}',
           "--export", "test.vectorcraft"
    info = JSON.parse(shell_output("#{bin}/vectorcraft-cli info test.vectorcraft"))
    assert_equal [0, 0, 64, 48], info["artboards"].first["rect"]
    assert_equal({ "Layer" => 1, "Path" => 1, "Rectangle" => 1 }, info["kinds"])

    system bin/"vectorcraft-cli", "convert", "test.vectorcraft", "test.svg"
    assert_match '<rect x="4" y="4" width="24" height="16"', (testpath/"test.svg").read

    system bin/"vectorcraft-cli", "convert", "test.vectorcraft", "test.png", "--scale", "2"
    png = (testpath/"test.png").binread(24)
    assert_equal "\x89PNG".b, png[0, 4]
    assert_equal [128, 96], png[16, 8].unpack("NN")
  end
end
