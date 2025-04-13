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

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bcc21d71656c35c2fce9354192edb11f0751ef87d0fd7fae94563f7ef93ed4d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f741ff41281dbdcdc41cfcbc1004c0bc3d8b5ef190e69d501cfa107ce1fb0674"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f081f8897511dfd9356f81771d9f3c718394168d1c084d6b9dfd6bf77281e7cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e612eab3899197b94085261aba06aa6c7e7f7d367d23bf2afccbe834b95f644"
    sha256 cellar: :any_skip_relocation, ventura:       "813aafead423b3172a1b94c0289b9e48a40e6d0c83752657aac4018cce9ad8d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "873358b516a1d0d4d702d5d67acc60ffc6e83f55b4962e717cecd331cd6da08a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fc466f8f161e0a625d123f989a6aeb91b8ef1bb29dd489c4ae55a967a46582f"
  end

  depends_on "postgresql@14" => [:build, :test]
  depends_on "postgresql@17" => [:build, :test]

  def postgresqls
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("postgresql@") }
  end

  def install
    postgresqls.each do |postgresql|
      system "make", "install", "PG_CONFIG=#{postgresql.opt_bin}/pg_config",
                                "pkglibdir=#{lib/postgresql.name}",
                                "datadir=#{share/postgresql.name}",
                                "docdir=#{doc}"
      system "make", "clean"
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
