class TemporalTables < Formula
  desc "Temporal Tables PostgreSQL Extension"
  homepage "https://pgxn.org/dist/temporal_tables/"
  url "https://github.com/arkhipov/temporal_tables/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "85517266748a438ab140147cb70d238ca19ad14c5d7acd6007c520d378db662e"
  license "BSD-2-Clause"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "961c3574dee3785c6a4a2d5dfee3fc55c758b09b06df2dc106a6f20caf555c18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2be633c14e63c4523d088fd0caadba5c804d7b2d9683f6a78e56f3e5111596d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f35985639da76876dd1f2a903d24d2339eab09eb9e2885a01227a78c5016cc5f"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a3a851746ab81698051d7d408bcb4ebb38948aa5135f49480a62e8ac42c1acb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c361513b78e4984086bb63776a72ecb2d2b44fb4c086cffa269652eefecafc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41bcf18a2b6d4abee03cd3f87ddcceb820fee5410d2442ad1613075f7fc97c92"
  end

  depends_on "postgresql@17" => [:build, :test]
  depends_on "postgresql@18" => [:build, :test]

  def postgresqls
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("postgresql@") }
  end

  def install
    odie "Too many postgresql dependencies!" if postgresqls.count > 2

    postgresqls.each do |postgresql|
      args = %W[
        PG_CONFIG=#{postgresql.opt_bin}/pg_config
        pkglibdir=#{lib/postgresql.name}
        datadir=#{share/postgresql.name}
        docdir=#{doc}
      ]
      system "make", "install", *args
      system "make", "clean", *args
    end
  end

  test do
    ENV["LC_ALL"] = "C"
    postgresqls.each do |postgresql|
      pg_ctl = postgresql.opt_bin/"pg_ctl"
      psql = postgresql.opt_bin/"psql"
      port = free_port

      datadir = testpath/postgresql.name
      system pg_ctl, "initdb", "-D", datadir
      (datadir/"postgresql.conf").write <<~EOS, mode: "a+"

        shared_preload_libraries = 'temporal_tables'
        port = #{port}
      EOS
      system pg_ctl, "start", "-D", datadir, "-l", testpath/"log-#{postgresql.name}"
      begin
        system psql, "-p", port.to_s, "-c", "CREATE EXTENSION \"temporal_tables\";", "postgres"
      ensure
        system pg_ctl, "stop", "-D", datadir
      end
    end
  end
end
