class Somo < Formula
  desc "Human-friendly alternative to netstat for socket and port monitoring"
  homepage "https://github.com/theopfr/somo"
  url "https://github.com/theopfr/somo/archive/refs/tags/v1.3.4.tar.gz"
  sha256 "3181a1bdc990bd26d7efe3e546d411cc9464203ca85b683e0b3647ba893cf7ab"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "795a20eb59a3862bd6c23d29352d13c17f2c4f76391ae9dd12e098626f9823e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d003d8a50846d0ada9c59ac6cd07c7678cd1b8200ef39667dc4a45485219cc39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3e025f45fe5b3c4b3befa6a64330df40615f0a3e7e9d140c117dad546eae89f"
    sha256 cellar: :any_skip_relocation, sonoma:        "8800e43f677e5ff0c1ed0130b00b42340dc21c0bd1dbddde2d390503bb05c784"
    sha256 cellar: :any,                 arm64_linux:   "3f50f849cd0eb7175a17e8aa5949e3b3e92259e2dc816ab1014069bb54d9593c"
    sha256 cellar: :any,                 x86_64_linux:  "1e2edeb09000c90f3b1e45f25a5b8b42f7abb3754bda23247da9e715b47a9fde"
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
