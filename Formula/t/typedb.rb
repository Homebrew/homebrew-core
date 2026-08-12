class Typedb < Formula
  desc "Strongly-typed database with a rich and logical type system"
  homepage "https://typedb.com/"
  url "https://github.com/typedb/typedb/archive/refs/tags/3.12.2.tar.gz"
  sha256 "e4be59685c4cc2f7a56f140702aa35c987c5bee1a7913daa174f918b2b98f7b5"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "149476681189f903a5ecbb64de90a59eadaf32312b1ed77c73b39cb4fa9980d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0e9c8ea7e226f0f3b5b65eeb3666217dd847b32fc3a370d1feb148ca40a0679"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97c02cc39b60331fa27e015943c037d154b9c1a9f27c0c570a8550783391f664"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a4f209ec257f113be4a8224add742a429c8350b5f3ca5b86d6094ab11b44249"
    sha256 cellar: :any,                 arm64_linux:   "26884a0fbab837654132a0583daaf757f0abbca8e1c3316d16f9f6c7b8159a95"
    sha256 cellar: :any,                 x86_64_linux:  "9fc80d84b4d85384c0e0e06a3070474c372b58eec55c626e00a2efe3f7000b84"
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
