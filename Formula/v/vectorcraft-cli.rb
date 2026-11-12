class VectorcraftCli < Formula
  desc "Headless VectorCraft CLI and MCP server to convert, inspect and script artwork"
  homepage "https://getartcraft.com/apps/vectorcraft"
  url "https://github.com/storytold/vectorcraft/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "d743fbc772200f934069fe6d918115adf7d355ac78f539301f67acbe49221ed2"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/vectorcraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e450d3548acb16accfafe0191157be0c5cd27c0afeb024793964d08c03250104"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "55750016238cd62ecd0d6aad989c1c9340304d77b5bda0dd645418a41d40b16e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "28a745a01c5983d812ae045d25b1cfe398563ef8b1d2909f97674ebbcdd26e54"
    sha256 cellar: :any,                 arm64_linux:       "b0d1f2818f1ba04f09231d29c74d33fc9f7f2636bff4aa7b5237bde15ad131fb"
    sha256 cellar: :any,                 x86_64_linux:      "072799f5f39397a64c8e5fa7f9075fb92afe39836fbe11bd3df3cf2e499933a8"
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
