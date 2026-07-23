class Typedb < Formula
  desc "Strongly-typed database with a rich and logical type system"
  homepage "https://typedb.com/"
  url "https://github.com/typedb/typedb/archive/refs/tags/3.12.1.tar.gz"
  sha256 "eb66c19acd43851f9ac8b07a8d06622967c8f4351baafe5d121c6041464a361f"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0935d33c703291458e9439422e372dce46a20b8858ea333fed8e78b62f717f9a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6786f4ff2592f38bd5e256cb7ac0d4232e39e141be43265f1398b98897ab74a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb8f424c26fb1c4d038aa4317bcf53ea011632245e613867968ae55d5c935e99"
    sha256 cellar: :any_skip_relocation, sonoma:        "63e71527daf0b08321796af6728d4e210f2e97e5dc0507e3beb74a4b95f49e52"
    sha256 cellar: :any,                 arm64_linux:   "bc63a2519f74b1ebcad40bdfc1189dc0d2d2c4a63451899c05a45c1ea3ff41dd"
    sha256 cellar: :any,                 x86_64_linux:  "b549ab6b042596e75752411caf78019dea68485f07fe2706c767834c95140dac"
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
    assert_match(/Serving:\n\s+gRPC:\s+0.0.0.0:#{server_port}/i, output)
    assert_match "TLS: disabled", output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
