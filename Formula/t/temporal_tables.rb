class TemporalTables < Formula
  desc "Temporal Tables PostgreSQL Extension"
  homepage "https://pgxn.org/dist/temporal_tables/"
  url "https://github.com/arkhipov/temporal_tables/archive/v1.2.1.tar.gz"
  sha256 "e3711797aa5def8f4974215bb5557204b2bc8e5e94201167eb95246a112b8138"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25de5d67758c7f706666c46b444f41d90750c34154f37818996e7a8e587fed24"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c598c7ce24e74d75192a0f288e6999f9469a39cdbd527200cd49f148ac6212c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bde5bd8f74dcb385b456d8b3b41cd091ec2c3c8b14bd547673e15b88fbc98d8e"
    sha256 cellar: :any_skip_relocation, ventura:        "0f95f0a9ac21073ff6b19cb755107230557c219049d616fe06bcce3bbcdc661b"
    sha256 cellar: :any_skip_relocation, monterey:       "b927ea034755f45d616ede60bee3143b2f99eb73aed0a59b56bd678f2604e372"
    sha256 cellar: :any_skip_relocation, big_sur:        "59a11c3b8ab038ce163126367041ff0e36ccfa34feb0c2069b4ac2518fac45cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebd8118d7b3a00ead2834ac1dde9550553606e004b2fb02fc53e61438260da6b"
  end

  depends_on "postgresql@14"

  def postgresql
    Formula["postgresql@14"]
  end

  def install
    ENV["PG_CONFIG"] = postgresql.opt_bin/"pg_config"

    # Use stage directory to prevent installing to pg_config-defined dirs,
    # which would not be within this package's Cellar.
    mkdir "stage"
    system "make", "install", "DESTDIR=#{buildpath}/stage"

    stage_path = File.join("stage", HOMEBREW_PREFIX)
    lib.install (buildpath/stage_path/"lib").children
    share.install (buildpath/stage_path/"share").children
  end

  test do
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    psql = postgresql.opt_bin/"psql"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath/"test"
    (testpath/"test/postgresql.conf").write <<~EOS, mode: "a+"

      shared_preload_libraries = 'temporal_tables'
      port = #{port}
    EOS
    system pg_ctl, "start", "-D", testpath/"test", "-l", testpath/"log"
    begin
      system psql, "-p", port.to_s, "-c", "CREATE EXTENSION \"temporal_tables\";", "postgres"
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end
