class Typedb < Formula
  desc "Strongly-typed database with a rich and logical type system"
  homepage "https://typedb.com/"
  url "https://github.com/typedb/typedb/archive/refs/tags/3.10.4.tar.gz"
  sha256 "80ced1d1cd0a68422c768c63650dd7676e9fff6fa7a1034414f5bcb8832d3192"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a83a654b7e8c1166a0f0780c0ee8256d0e9f82b39bb7251f48073d8ac36458a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3364b4aa5363dd893fcebaed7aa3a92f1f15d7f52795e46e414ed441825f352"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef4804b053540416c6afc45791f9d1ad7bf0ac6633a18dec815087397813cb0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "38326bc5cc2faea8e374785185cbb41e899295f77138b7b7275f657d447048b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12c51e9611c7f8aa8d8c37d34874000f0709e84e608f3735088194e6a334d9b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ef2c856221090abeb8887d37ff738c68713c3c8d5d4f2becbcdfbdd241d8267"
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
