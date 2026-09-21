class Typedb < Formula
  desc "Strongly-typed database with a rich and logical type system"
  homepage "https://typedb.com/"
  url "https://github.com/typedb/typedb/archive/refs/tags/3.13.0.tar.gz"
  sha256 "2424648f4c95a75274e133435d4fc106c808fc266663953b933dd315266a94e5"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "568678f058e993f1a4d34e16a1fddc1139e3497a25a90451aa9f0ff9b27448ad"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "eb0c7e33117933ecf7623250b8bdba248f25ec34da75888bd71c2e62fb61cea2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "26e340b390c297c6e8e78fabb4b45570f205ebae47daecc07c9ccb8ddba4b162"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "6eb698e00b9e5b0027bd3a2ce12bff750d0f797c9e0e754f479a1cbc7ead48f7"
    sha256 cellar: :any,                 arm64_linux:       "9c5c342eaad1058539dd454ed7c602a2d786c8b0a5907b1aabeb91a4cf0413b1"
    sha256 cellar: :any,                 x86_64_linux:      "8d5a931e92b95fddc71e2aac37d18a20f06a29f2d24dad350549fc44a2778233"
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
