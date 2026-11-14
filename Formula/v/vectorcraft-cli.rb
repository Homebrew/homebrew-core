class VectorcraftCli < Formula
  desc "Headless VectorCraft CLI and MCP server to convert, inspect and script artwork"
  homepage "https://getartcraft.com/apps/vectorcraft"
  url "https://github.com/storytold/vectorcraft/archive/refs/tags/v0.24.1.tar.gz"
  sha256 "529bbf6a3ee7349fef75c4d04a5db2dca78b6116d2fa42cf1caa5d95677f1292"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/vectorcraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "892bdaba363ab198c9310511168a40191817c290c8aeac4c35c127949b1156c8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ee39028594da829168c0da159a0073da0bbbefb35516dd9f6bc4dc1e20c98543"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7d7aebd371866e9f15c3916776bfd52dde85495d9897a3ab727d44c750561509"
    sha256 cellar: :any,                 arm64_linux:       "5e689eb20596b7571d48360066032abfbaa79280812193c28430f0ca7f839069"
    sha256 cellar: :any,                 x86_64_linux:      "8ed9c0b2eee0b7eb7b6aeafb5b1452746498e759268468cc83d0c35cf8d733b0"
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
