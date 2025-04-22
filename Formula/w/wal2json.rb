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

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec43557186dc322d7e038dbc6a9d2062296a13f8830952bbdb0c72d154c8a70b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d9b4650f924f544a650ba786967a754b29a4971868b3dbd5ba9f47abd44f6cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "03a5c4a6e4048d088a5a23aed0251a4cf05f86d271eb23f8c681c139f6336672"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e53de38eccaf3a9a23587ea164b8723f68648c84d3c3017d362823daaacd113"
    sha256 cellar: :any_skip_relocation, ventura:       "1ac11a6eb237df8ffab44e8a903925e0896628a3ba78b31b919ea6a61d1b54e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d86989d3fc89bd67beea43908aeff1306132d88234f93e24aa2a9a952dd9ba33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44d6b43deefc69fbd0cb1df19957d8f827d74f49693d43ddd2df058ebb3bfb1f"
  end

  depends_on "postgresql@14" => [:build, :test]
  depends_on "postgresql@17" => [:build, :test]

  def postgresqls
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("postgresql@") }
  end

  def install
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
