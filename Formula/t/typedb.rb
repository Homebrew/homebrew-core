class Typedb < Formula
  desc "Strongly-typed database with a rich and logical type system"
  homepage "https://typedb.com/"
  url "https://github.com/typedb/typedb/archive/refs/tags/3.12.0.tar.gz"
  sha256 "c414a4d5f79fdd176648f0a9ef458d93670a75da02fefe124df1fc1a7e85dbf9"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e81274debb1cbeac11716913de13ddb433ac4a9edeb1adfab0775cda99abf662"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74f40eb3fdffb103f39f429b753bb5c4733a892dcfa82f43629c9d38dab33e81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8571c462484e93e633bb2e40525a016ab0f51a21c28dcb0a3fd9630bc4b5258"
    sha256 cellar: :any_skip_relocation, sonoma:        "603e6b8894252584ea9a02ac0764fae04ff50d72bbce1d0357b3b4656e8a3ceb"
    sha256 cellar: :any,                 arm64_linux:   "5f59933d3e621c9cea15bbdfe07392671aa7462e78fd1b617ca132da19b9f9de"
    sha256 cellar: :any,                 x86_64_linux:  "8e0cbf937a83052fbff1a915af2856898440dabbda949e1bc5df136e1a34ada4"
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
