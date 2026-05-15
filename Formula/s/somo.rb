class Somo < Formula
  desc "Human-friendly alternative to netstat for socket and port monitoring"
  homepage "https://github.com/theopfr/somo"
  url "https://github.com/theopfr/somo/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "011ff1fe6e4e973c59526fd5c50d2cdd040d1517f26a321e21807b658047377a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef01038be1ee8c5452f0fa68445d00ec96711d5d352d11da24132c162c0fa4a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa162c6300f8ea7e9d7da424a2a4f42bbe495726c22c0a8de52df104425296c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d428ae775005c5011bf7268e594c25feca21fe4e90b511878d4407e461c9596"
    sha256 cellar: :any_skip_relocation, sonoma:        "417817d218be58597a62871b5f48edf2dfad9467d2348ba1c3416a2e130cf123"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cca798d71b1102e80716a71cdd186ad17f09ffb3d226ffc57085260ffaa0967e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb10e51aed123acad3aabff2e6383d114bcb706ea5d17fb3d874df6394e6ab83"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"somo", "generate-completions")
  end

  test do
    port = free_port
    TCPServer.open("localhost", port) do |_server|
      output = JSON.parse(shell_output("#{bin}/somo --json --port #{port}"))
      assert_equal port.to_s, output.first["local_port"]
    end
  end
end
