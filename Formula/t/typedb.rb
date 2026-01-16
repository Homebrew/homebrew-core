class Typedb < Formula
  desc "Strongly-typed database with a rich and logical type system"
  homepage "https://typedb.com/"
  url "https://github.com/typedb/typedb/archive/refs/tags/3.7.3.tar.gz"
  sha256 "43bd8479b088373af807d4cb250847c7d8c732d10dfaae20c01453aec069aebb"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dab7cdd230615584ddf75d8e4a8690dbc3bdc2d3e2e008778a886bc79b7e6250"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "113ea6e33a440f4a7dcbb66267c51dc5f15a5f609c2f9e7739ff8dfb656243a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1dc33e62898605ae0832fa2fb2daa2b67a4be4e9bd89a43ab5b3da2625683b7f"
    sha256 cellar: :any_skip_relocation, sonoma:        "2fcea91bb478abe7862ba58990b859a04a1c69bcfb36b70897ca3d6c0492fe9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92b7a4420bb018d03c21d9c9fb89ef033a170c1c67fc4b38e264c941e47e31b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58d46c49692e91af00617bb8b94cc1b292ef72931cf7195458f37fbc7ef86f4a"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang

  def install
    system "cargo", "install", *std_cargo_args
    bin.install_symlink "typedb_server_bin" => "typedb"

    inreplace "server/config.yml" do |s|
      s.gsub!(/data-directory: .+$/, "data-directory: \"#{var}/typedb\"")
      s.gsub!(/directory: .+$/, "directory: \"#{var}/log/typedb\"")
    end
    (etc/"typedb").install "server/config.yml"
  end

  service do
    run [opt_bin/"typedb", "--config", etc/"typedb/config.yml"]
    keep_alive true
    working_dir var/"typedb"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/typedb --version")

    server_port = free_port
    log_path = testpath/"typedb.log"

    (testpath/"config.yml").write <<~YAML
      server:
        address: 0.0.0.0:#{server_port}
        http:
            enabled: false
            address: 0.0.0.0:#{free_port}
        authentication:
            token-expiration-seconds: 5000
        encryption:
            enabled: false

      storage:
          data-directory: "#{testpath}/data"

      logging:
          directory: "#{testpath}/log"
    YAML

    pid = spawn bin/"typedb", "--config", testpath/"config.yml", [:out, :err] => log_path.to_s
    sleep 5

    output = log_path.read
    assert_match "Running TypeDB", output
    assert_match "Serving gRPC on 0.0.0.0:#{server_port} without TLS.", output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
