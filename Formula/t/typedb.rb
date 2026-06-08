class Typedb < Formula
  desc "Strongly-typed database with a rich and logical type system"
  homepage "https://typedb.com/"
  url "https://github.com/typedb/typedb/archive/refs/tags/3.11.5.tar.gz"
  sha256 "adfd2f8c2aeb92cd58352761b87c3c8eff1f7b0c042270e63856ffcd5c1322d6"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f40ab42fb579de0911c8f830f1a517009aa4b58a0eaea8ac8a2b87599c214e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3173ffd56d056751919d07c07dc37fac3e84d964fdd933526945451f3a0edbfc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dbe2b09f5c5dda056a52d1dd06e122cd3e0d86513e9896e28c6b5644e9945394"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8796f3bacf7b4d2299cd1d0acb9117ec58a8a765be3358097afd622965feef3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d85e8384fedd34e621f2df3ab5440ac275e0ed33243991a52c791219f697d348"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c53abcbfd45a6274d921fc934b0b28c9b5dc8bc703d5016561b7f049448569d"
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
    assert_match "Serving:\n  gRPC:  0.0.0.0:#{server_port}", output
    assert_match "TLS: disabled", output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
