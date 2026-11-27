class WalG < Formula
  desc "Archival restoration tool for databases"
  homepage "https://github.com/wal-g/wal-g"
  url "https://github.com/wal-g/wal-g/archive/refs/tags/v3.0.10.tar.gz"
  sha256 "e7ad190500da1eb7cc7fdbe7e86543ce5b884992e99491042c5b2592caacf5fe"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "a30cdcdccfa4a18f5715d8cb788ed78ea2cf455e50386f42cd4033f52ea6edc7"
    sha256 cellar: :any, arm64_golden_gate: "c5b264e5782f90cf982fecd8854925a6ac91622cd504497f11bea91312bcb2d3"
    sha256 cellar: :any, arm64_tahoe:       "3018cffa57613f9f4031794009d8c12f8323eb7467968f1d8ffef9c735b2bf91"
    sha256 cellar: :any, arm64_sequoia:     "a12f8b663830fdde49cabf7004f82d3cf7bfa7003798e9936496ed228c47be62"
    sha256 cellar: :any, arm64_linux:       "2735077a373582d0d31644a98fc482fae145a1d45d6092a1214857adecd73857"
    sha256 cellar: :any, x86_64_linux:      "652b597b71b70bb966176138149bf833ad1a3618018607240fa1c35c0fb6b498"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "brotli"
  depends_on "libsodium"
  depends_on "lzo"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["GOEXPERIMENT"] = "jsonv2"
    ENV["CGO_ENABLED"] = "1"

    %w[etcd fdb gp mongo mysql pg redis sqlserver].each do |db|
      ldflags = %W[
        -X github.com/wal-g/wal-g/cmd/#{db}.buildDate=#{time.iso8601}
        -X github.com/wal-g/wal-g/cmd/#{db}.gitRevision=#{tap.user}
        -X github.com/wal-g/wal-g/cmd/#{db}.walgVersion=#{version}
      ]
      output = bin/"wal-g-#{db}"
      tags = %w[brotli libsodium lzo]
      system "go", "build", *std_go_args(ldflags:, output:, tags:), "./main/#{db}"
    end
  end

  test do
    ENV["WALG_FILE_PREFIX"] = testpath

    %w[etcd fdb gp mongo mysql pg redis sqlserver].each do |db|
      assert_match version.to_s, shell_output("#{bin}/wal-g-#{db} --version")

      flags = case db
      when "gp"
        "--config #{testpath}"
      when "mongo"
        "--mongodb-uri mongodb://"
      end
      assert_match "No backups found", shell_output("#{bin}/wal-g-#{db} backup-list #{flags} 2>&1")
    end
  end
end
