class VectorcraftCli < Formula
  desc "Headless VectorCraft CLI and MCP server to convert, inspect and script artwork"
  homepage "https://getartcraft.com/apps/vectorcraft"
  url "https://github.com/storytold/vectorcraft/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "d051a395f62511b52e7ad023f3029bfc8846871b5f2f61b19312f71e777c4efe"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/vectorcraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8214e93906fa1a88804455d174ee03dd52cd829f423eba3eabc18e6bdcaeac24"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e50390e159d7f447dfa1c1a364284a2b18804e36f0e8ca56808cd6ad30025d81"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f14f007e3b720739e1b8ff08fb3c2d37d124bf9d18910d6fd314d3b1ca490ab9"
    sha256 cellar: :any,                 arm64_linux:       "31627fa040b3a5ebb6341dae0215d6ea708021c920573d1e96024bf58bc06d3a"
    sha256 cellar: :any,                 x86_64_linux:      "140a418da0c30375e5233d0edb1d9392271f36e49c07d7aeefab7e689b88e711"
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
