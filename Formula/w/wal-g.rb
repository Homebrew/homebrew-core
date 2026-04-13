class WalG < Formula
  desc "Archival restoration tool for databases"
  homepage "https://github.com/wal-g/wal-g"
  url "https://github.com/wal-g/wal-g/archive/refs/tags/v3.0.8.tar.gz"
  sha256 "336c829714023d2f3fcfe9b3cab50bb76bc829229e33e87c859f43a21883e271"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b51f4142cdcea4c4a43cc6f8f1773f69523cbe72b5283e6e30d8a3a9a6835c21"
    sha256 cellar: :any,                 arm64_sequoia: "d8df29e624956a3d1ea567bb5b1f11d6a331c2bda4c1ca9521043b1860a4a786"
    sha256 cellar: :any,                 arm64_sonoma:  "1784ead186775c161c507026e4166b6df1aeaa17f0122ebefc81505b04eb5cc6"
    sha256 cellar: :any,                 sonoma:        "ce4e3e6f90e8ce94b9649f623020565b95836cde1b7d6a8e63c32626b5456262"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4038b929fb7ab597d0c1ecf1eb828097e4ed7b35d5f2d4d3bc671fed33e9da7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35fd271cdc3f2c241e2ba68b7e8c44f1ce49f54293e27c9fc0ac139689df45cd"
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
