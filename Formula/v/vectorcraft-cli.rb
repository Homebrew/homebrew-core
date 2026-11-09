class VectorcraftCli < Formula
  desc "Headless VectorCraft CLI and MCP server to convert, inspect and script artwork"
  homepage "https://getartcraft.com/apps/vectorcraft"
  url "https://github.com/storytold/vectorcraft/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "2f895f0a133de4bf9ab5dbdd7f7ad77fa7c9f3c0c2d3f6a60c98cf00e0ea223e"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/vectorcraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "768a439c668beb37bc625db69b8cab82754034d97e1f0d99a9afcc6fa524a9e8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "405d4de1c560969641b98b3ea7bf877933ab77aac3e49f1edaed10f1401a0111"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bc5c3d510536bb6bb5ca8015ea7aee451e7a8aaae4fd344ef8234603508d6af6"
    sha256 cellar: :any,                 arm64_linux:       "11d20456e8f672ab7e800c2d4b18042643bd7ab60b7fcfe48c136c13fd5815ac"
    sha256 cellar: :any,                 x86_64_linux:      "60ec9366d7ad5f5dbf7a095bd5f99bad3f23fa8a86dcbd413c981bbe5000fb55"
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
