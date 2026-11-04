class Typedb < Formula
  desc "Strongly-typed database with a rich and logical type system"
  homepage "https://typedb.com/"
  url "https://github.com/typedb/typedb/archive/refs/tags/3.14.2.tar.gz"
  sha256 "60ce1fe64d221be05ea7e5455f60e85f79be0b488f61bcb40266b1dfec32f1b4"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1f0bd6a1d4aecb4b81611f5eaa6b4adc183a9a0f71c8786a677d99b52beff352"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1a82b35c46836409c163417e8a324544918a0d540e97fbf5f7ed0489235f1afe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4ca324425ea7f2f24de54b8b4b835034a30b8de7de77b6c6837ac87965ede8af"
    sha256 cellar: :any,                 arm64_linux:       "6da8cd8ec4cc4ca4aaba76bb6086cb11803cf60a6aed2101e129548fa2aefe09"
    sha256 cellar: :any,                 x86_64_linux:      "83506a490f8ccf8167bfd7c8460699df7c1695158c83b78c397a6ffa2604a7f5"
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
