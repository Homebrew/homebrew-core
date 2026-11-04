class Typedb < Formula
  desc "Strongly-typed database with a rich and logical type system"
  homepage "https://typedb.com/"
  url "https://github.com/typedb/typedb/archive/refs/tags/3.14.2.tar.gz"
  sha256 "60ce1fe64d221be05ea7e5455f60e85f79be0b488f61bcb40266b1dfec32f1b4"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3082d78ea6c37a6a3d62e3d0edc2f3ce2d734854f23844a01949ecc525b42e3b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ff398ebe840e9e94039471e3d908a70cbe49f6fa7971c6236578834af56b98f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d6cb3ca6c3bad3fb5e1b9bbbd48659dc698cf89fe77b7117f1be731c72afd271"
    sha256 cellar: :any,                 arm64_linux:       "f6b688f85e6e9631123f0982546e62ba62d9abad29bd0b91cac9e747d4a84996"
    sha256 cellar: :any,                 x86_64_linux:      "ab657e8433213bd7f393ec101b27f8a3bd4f8a340a3ec2db49b0a83b4560cac5"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
    assert_match(/Serving:\n\s+gRPC:\s+0.0.0.0:#{server_port}/i, output)
    assert_match "TLS: disabled", output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
