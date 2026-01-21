class WalG < Formula
  desc "Archival restoration tool for databases"
  homepage "https://github.com/wal-g/wal-g"
  url "https://github.com/wal-g/wal-g/archive/refs/tags/v3.0.7.tar.gz"
  sha256 "69368316b90fae7c040e489ad540f6018d0f00963c5bc94d262d530e83bdd4ce"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8aa6dcd7b9a17e0d53a37d54c020c88602e7e4e64712c6aeec5acd30047c4fa7"
    sha256 cellar: :any,                 arm64_sequoia: "c64d5ad15282efaf311ca082f96e4b190b0dd3f26df838c430f343ec00236356"
    sha256 cellar: :any,                 arm64_sonoma:  "aee2c57633ed2939227c23d119a6f398345da14bd3f894ececdfb12218dd8853"
    sha256 cellar: :any,                 sonoma:        "8c1cccbeff937880545db272acf046cc328ef1021e73d1d6694a9dbf06ccad3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38f2f7a5933676604e10dd476adc3ba2d4770ea081c973dd79a5e15971a8fd81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6f9f6d8dae5a52ba674f4bf21190df5e62dbc75222419da9e67b3c62213c781"
  end

  depends_on "go" => :build
  depends_on "brotli"
  depends_on "libsodium"
  depends_on "lzo"

  def install
    %w[etcd fdb gp mongo mysql pg redis sqlserver].each do |db|
      ldflags = %W[
        -s -w
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
