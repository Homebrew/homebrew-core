class Typedb < Formula
  desc "Strongly-typed database with a rich and logical type system"
  homepage "https://typedb.com/"
  url "https://github.com/typedb/typedb/archive/refs/tags/3.8.3.tar.gz"
  sha256 "9034d50417e9cad59edbee47deed54bf376da307b6d73e69846b0e634eb0ffc6"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80b4a776198facebec8cd49f723b8f233338d38bc0d290bb12420524bb3b1635"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c504bf5c1fc9602c3f69b0b401ae7d50536e500c2e374faea203ff7b4d495694"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be9cbb55df28a7a3b07977a70321a4c2808de01925df6e10d5734b1e57750fb1"
    sha256 cellar: :any_skip_relocation, sonoma:        "b5f7fcc3bb428c3f6f1698ba1ba3f46d7ee9c770fc00abf26b0ff3dcdecc0a7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "427b0e252fa7c616c9bf6a93a35a3d561f27d73f36f590f3bc023c23963c2b9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab1aca255d891a8de1f3547e990fe8f377757ed35abc9809fb58f7f711befc42"
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
