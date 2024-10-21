class Wush < Formula
  desc "Transfer files between computers via WireGuard"
  homepage "https://github.com/coder/wush"
  url "https://github.com/coder/wush/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "7385e338e7cab3b065d805ee22ccbce9d09d16976425cfb3a4d1f29ca6bec263"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4a1ebf5c12249512709b8a6613cc19383aa439411193fed978eb9217dc0d776"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62bcaa27edcdf2be7ec935aed7fb00f176dfa6080f0a3f6e2738ac04c9d2157e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dae5012663a80421d7547f081b43707e834061e88fa364f91868294b3935c0be"
    sha256 cellar: :any_skip_relocation, sonoma:        "f72f4d368c12f9686b741a645cc4bf81b8438e8f2fc065fb156cb1480f5d429d"
    sha256 cellar: :any_skip_relocation, ventura:       "214009d3ddc68513f38725f64df7ccd3d781b054e750b122408d6c2cfc862c72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2098fe216d129cfc02d23be885c0dfeeb9e2cba9071cf77a9d799746b215bc3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/wush"
  end

  test do
    read, write = IO.pipe

    pid = fork do
      exec bin/"wush", "serve", out: write, err: write
    end

    output = read.gets
    assert_includes output, "Picked DERP region"
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end
