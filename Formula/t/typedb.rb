class Typedb < Formula
  desc "Strongly-typed database with a rich and logical type system"
  homepage "https://typedb.com/"
  url "https://github.com/typedb/typedb/archive/refs/tags/3.8.1.tar.gz"
  sha256 "3bbbaac93a331ca0f2496b5ab157a387393648d959dcdbbb919a59357727adcd"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d18441f5f7d2057de82ee4f22ae48c5c7fac1d602bad26469630a1cc1e81df47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba3b7f1920fbe1cada278118b2c0ab6f465b2e07cdec376adffc94695b5b537f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00ea1556bf1b6fff58a0cf0480b7de3ad0b79d425a39d7d7fb5ea378206c599b"
    sha256 cellar: :any_skip_relocation, sonoma:        "c94b6b2f663a25861501c8a15581c7f59368377ed0557729f692b6a1cffbbcd3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c97dfd89761690fdece00d16498896efcd9dcc7c203c9f1252418cbefdf61851"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b845e18b2db55d53e3f2a6b0fa1d5acd0c178c315fe21ab40a9ca0968628fe8e"
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
