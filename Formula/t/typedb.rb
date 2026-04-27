class Typedb < Formula
  desc "Strongly-typed database with a rich and logical type system"
  homepage "https://typedb.com/"
  url "https://github.com/typedb/typedb/archive/refs/tags/3.10.3.tar.gz"
  sha256 "ec396edb1bf75318e4c891b7fc7946506ebc280be350586416a1097b3416103f"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d15653dc39c2482d1f3fb4429b54889e33df9f169b2c9610a3b148e82893f2f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "197e3daefba4d246085be013c859df620c2263194d1f88ccd880a2c0c0b6e906"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4455d42f4a7177a3aa540d63e50d66109ace520f443428a845de96bb31b1441"
    sha256 cellar: :any_skip_relocation, sonoma:        "237770162aab20cbbd32323d9829b8f41edaa3cf883e2eded0b277cea06dd07f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29e9fc8ecd6b89cbc998120c4be5ed6919d92e86e6fef7f413c63f7422febe39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "085741482e28d0ebaa32c3683f31d274fa4ed670765a33cee84a08fe8ba1ffd5"
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
