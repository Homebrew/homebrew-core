class Wal2json < Formula
  desc "Convert PostgreSQL changesets to JSON format"
  homepage "https://github.com/eulerto/wal2json"
  url "https://github.com/eulerto/wal2json/archive/refs/tags/wal2json_2_6.tar.gz"
  sha256 "18b4bdec28c74a8fc98a11c72de38378a760327ef8e5e42e975b0029eb96ba0d"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/(?:wal2json[._-])?v?(\d+(?:[._]\d+)+)/i)
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6df07eb3b4c76fd3a26aabbd3d9512f2018ca40991a213805b3d97a359e6bbea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0cd88f515f6d34e3aeb5ecbf7ef5a869639b032373512e8eb6d68b58e9b3b2af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79300555385707acce8e526b38f75d91445f7bf43ad8dcc4b3d51083edd29a82"
    sha256 cellar: :any_skip_relocation, sonoma:        "1bd372e6fe5bf4532c35eea95a8da392cca051f40fb43eb2721a6d8669375eb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98ff83a1fd6e9730c36c443fd57824831f83b48d426836a33e6a98e94b70647b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b73b0d8f8d95d485c6a5b8e9bc0ccf357292d8ca232ca6708cba79cb0875a7e9"
  end

  depends_on "postgresql@17" => [:build, :test]
  depends_on "postgresql@18" => [:build, :test]

  def postgresqls
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("postgresql@") }
  end

  def install
    odie "Too many postgresql dependencies!" if postgresqls.count > 2

    postgresqls.each do |postgresql|
      system "make", "install", "USE_PGXS=1",
                                "PG_CONFIG=#{postgresql.opt_bin}/pg_config",
                                "pkglibdir=#{lib/postgresql.name}"
      system "make", "clean"
    end
  end

  test do
    ENV["LC_ALL"] = "C"
    postgresqls.each do |postgresql|
      pg_ctl = postgresql.opt_bin/"pg_ctl"
      port = free_port

      datadir = testpath/postgresql.name
      system pg_ctl, "initdb", "-D", datadir
      (datadir/"postgresql.conf").write <<~EOS, mode: "a+"

        shared_preload_libraries = 'wal2json'
        port = #{port}
      EOS
      system pg_ctl, "start", "-D", datadir, "-l", testpath/"log-#{postgresql.name}"
      system pg_ctl, "stop", "-D", datadir
    end
  end
end
