class Typedb < Formula
  desc "Strongly-typed database with a rich and logical type system"
  homepage "https://typedb.com/"
  url "https://github.com/typedb/typedb/archive/refs/tags/3.13.6.tar.gz"
  sha256 "f82deaf3dae13521ca03b72840550afd5a5fddc2fcfe675a44181080e5b214f8"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "90140b71b03e6c769aaa84d76756d5561eb74a27ed7aae9ff5eb066948506948"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9803ce021928a06656ec5766296fea51de0d2d5c09db3344cd8232d0976038a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e5c3d282a8c59713d50671be81b3325956a807301f33e0ef8f3fa7973d8132e6"
    sha256 cellar: :any,                 arm64_linux:       "b7f8df8f0fe86320a9d4483346f32d274e595024bd3a9490ef51cb1f28fe3fe0"
    sha256 cellar: :any,                 x86_64_linux:      "de6e203bef194893c77b9b54b6e3b9936a7ae250ab028d2ae8f1800b902813ab"
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
