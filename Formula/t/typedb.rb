class Typedb < Formula
  desc "Strongly-typed database with a rich and logical type system"
  homepage "https://typedb.com/"
  url "https://github.com/typedb/typedb/archive/refs/tags/3.12.3.tar.gz"
  sha256 "a942b753d4f28528eb5942f08ceb0cfbcd972bad7935eafb2f0ad49c6c734724"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ea5ba239ae3f6cb66e6783c7668fa1267be8c801b277177009a01db0005b117"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eafd7f6fcb7e4dd8491606012b36b06ebec042ba4b938dc4ba065c80a7b50920"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce990ad8568c665d673eb2fd9d65ead905ed2df09c061422e1d18e713a69b0e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff4e2d1e53db25d26f12e73cb831e3b429a18de5474aa074c06dedb743067c74"
    sha256 cellar: :any,                 arm64_linux:   "afa84a8b372a111a2a0afbb6e43c32900f7b52c797e547318beebb260b3a9f78"
    sha256 cellar: :any,                 x86_64_linux:  "51ac2b03b99ae9e1f5099b18fcc3f813a837a45a3456f7cb8d0fadbdc9d1ef29"
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
