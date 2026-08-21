class WalG < Formula
  desc "Archival restoration tool for databases"
  homepage "https://github.com/wal-g/wal-g"
  url "https://github.com/wal-g/wal-g/archive/refs/tags/v3.0.9.tar.gz"
  sha256 "b06bc26c4865c07d0c269101910f63c7eedd03790b7c054a7da0980a7a9cc31d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8d22f5c8956cabb8e23479b4a5e7b9709d63d541deb1757917eee0d4668e132f"
    sha256 cellar: :any, arm64_sequoia: "ebfd98ba9b3c93d0b13212d89e35b37fb98c5f3e702eafaaf08ee587efd3ad89"
    sha256 cellar: :any, arm64_sonoma:  "a17bd9cb46debe8e4b1a52abae8f1cd6e64bd16864f6076030a1669eb107439e"
    sha256 cellar: :any, sonoma:        "51f755172790b0c249861849c6ec048a2ca1bcd120f55577e1d3287b2cdf0417"
    sha256 cellar: :any, arm64_linux:   "d9a621e96aa82c373c34f4a0ae6498c6b60c3275eb6d1675d29e0abba6a354cd"
    sha256 cellar: :any, x86_64_linux:  "479932ba6762c8c77c4b74fa4bb947d137c5e6cc30a3df51b2175edc26734639"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "brotli"
  depends_on "libsodium"
  depends_on "lzo"

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
