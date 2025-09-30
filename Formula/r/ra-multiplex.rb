class RaMultiplex < Formula
  desc "Share one rust-analyzer instance between multiple LSP clients to save resources"
  homepage "https://github.com/pr2502/ra-multiplex"
  url "https://github.com/pr2502/ra-multiplex/archive/refs/tags/v0.2.5.tar.gz"
  sha256 "c24a7e277adce9bbfb86641905d75f166e46459cf4e5b5f3aaa7456b052392dc"
  license "MIT"
  head "https://github.com/pr2502/ra-multiplex.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "caef414f28ae5416c4527c7ae9b703370b0ba60fa57e7b2ca3e9f013b86ce987"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e50b9bbf819cb3d63e167b26f8eaf81b455383223a918c1de2d8f95847b34591"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3368801066ec9a6af29b02b91b4d94d5ab518bafef2e43b6b6bb124ddf0219be"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b4c694cbe6cbcd8eed58c68e0bacc0711b4ee407b9b27f188d555774997768b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d1b275cbd97cb722b65047ac00e0ef68272e6334127b3e76e8239416dc0cb5d"
    sha256 cellar: :any_skip_relocation, ventura:       "6e7171999fb2b27b47ca7b1ff5672dc716f79b87a1d0e8c5fea79e627ffad620"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e4bb0024328d5472dd733aa22f06e37d583413e6a62f736160b002c06dc7443"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fa3b594fcdab0a99ba159c74def4f4a14d2e7f79f4909a0e9c4f907da45d198"
  end

  depends_on "rust" => :build
  depends_on "rust-analyzer"

  def install
    system "cargo", "install", *std_cargo_args
  end

  service do
    run [opt_bin/"ra-multiplex", "server"]
    keep_alive true
    error_log_path var/"log/ra-multiplex.log"
    log_path var/"log/ra-multiplex.log"

    # Need cargo and rust-analyzer in PATH
    environment_variables PATH: std_service_path_env
  end

  def rpc(json)
    "Content-Length: #{json.size}\r\n" \
      "\r\n" \
      "#{json}"
  end

  test do
    input = rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "id":1,
        "method":"initialize",
        "params": {
          "rootUri": null,
          "initializationOptions": {},
          "capabilities": {}
        }
      }
    JSON

    input += rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "method":"initialized",
        "params": {}
      }
    JSON

    input += rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "id": 2,
        "method":"shutdown",
        "params": null
      }
    JSON

    input += rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "method":"exit",
        "params": {}
      }
    JSON

    output = /Content-Length: \d+\r\n\r\n/

    begin
      pid = spawn bin/"ra-multiplex", "server"
      assert_match output, pipe_output(bin/"ra-multiplex", input, 0)
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
