class VectorcraftCli < Formula
  desc "Headless VectorCraft CLI and MCP server to convert, inspect and script artwork"
  homepage "https://getartcraft.com/apps/vectorcraft"
  url "https://github.com/storytold/vectorcraft/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "a6b69244a4aeeb159b6ea21bac0ef6e9e51030fcd4a31acd49f9c994152c3ee4"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/vectorcraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "22acd4c86f334a815833dbc43ee85d840a1b3e13132f3faea4a6f0ed510e55a4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "714f5d5e09c373050942decd352fb24e9adffbcc811166ad7d074f4077f3d7c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "68f46f0d7b1fcea3a0fb5870864d40cd27ddc6a6cb70f1a7f51b4eaafcba5e37"
    sha256 cellar: :any,                 arm64_linux:       "627ac6ebf1ba3a9b03711b83c3deb7ec9025d5b545f034b4141518cfdc231d17"
    sha256 cellar: :any,                 x86_64_linux:      "0cfc868a39af0b73bd6c2ca72d4d6092a6eca2ada9945e7fbaf8e73426aa2319"
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
