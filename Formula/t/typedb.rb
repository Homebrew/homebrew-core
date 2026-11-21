class Typedb < Formula
  desc "Strongly-typed database with a rich and logical type system"
  homepage "https://typedb.com/"
  url "https://github.com/typedb/typedb/archive/refs/tags/3.15.0.tar.gz"
  sha256 "a7af244dec329fa6f6979cf5449ec45bc6a00177ef62234c919fe8b6b8212697"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a0e0bbc8b621c2c8676b5b63353a4be893ea13e0448d39bd15e3d0bbba1657da"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "293988d846632c0b7bcb915d63f968deff4cc06e5c1404cb26e7601a15f128bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a0158a50bcd5cc28a78aa0bcccb280ae6138f772fc69ede2dfc4c1bad589aae2"
    sha256 cellar: :any,                 arm64_linux:       "12c9acd8e82127c1ce1be15a3c48bf3cd440fa1b6ce2f16dc24c989b8988ea00"
    sha256 cellar: :any,                 x86_64_linux:      "93ff5013cd83da6f0cb67ce56321efd59082675629df0d9e77ebbf9a6863f29f"
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

    with_test_process(bin/"typedb", "--config", testpath/"config.yml", [:out, :err] => log_path.to_s) do
      sleep 5

      output = log_path.read
      assert_match "Running TypeDB", output
      assert_match(/Serving:\n\s+gRPC:\s+0.0.0.0:#{server_port}/i, output)
      assert_match "TLS: disabled", output
    end
  end
end
