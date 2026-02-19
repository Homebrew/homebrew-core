class Typedb < Formula
  desc "Strongly-typed database with a rich and logical type system"
  homepage "https://typedb.com/"
  url "https://github.com/typedb/typedb/archive/refs/tags/3.8.0.tar.gz"
  sha256 "60975170967383c11e478d87cea43496a8b9ff1f2932b64fc352137318831b6f"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3bd2391480deaeb9c82f54cde779d686b3eb908afd14fede104b7f9e8ce6dffc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "856ace4ad7c9d0413c706bf630209e2a3bbc147cf305ffd10082c7f7b8718ba6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a135d6c05223ee67722c6205aec74e9f2a866853c2cb2b49906394309669ccb"
    sha256 cellar: :any_skip_relocation, sonoma:        "13d82dad5f24833b7cd5dcb0f8331654b9d40623038a4b5799cc684860888760"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "686fff92043ffc969f353a858057c2f38da643adbe627d596d1bfcf38ec39361"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b0c3149f0e4e1e8c6daf5d3dc4eb8263cbfbe06ee1ab8ef3c7d3b8eb3c43b51"
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
