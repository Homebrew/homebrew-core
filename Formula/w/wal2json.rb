class Wal2json < Formula
  desc "Convert PostgreSQL changesets to JSON format"
  homepage "https://github.com/eulerto/wal2json"
  url "https://github.com/eulerto/wal2json/archive/refs/tags/wal2json_2_7.tar.gz"
  sha256 "e6c12d02dc32e4d610dce33ee52ea85a54e12a563e79c4844508b6c061ff07a1"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/(?:wal2json[._-])?v?(\d+(?:[._]\d+)+)/i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| match[0].tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0bee9e50cc7a4beee7e0058c0c9e51fadfa69092812f7f7db6f1645618a47f9c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b81ba84ad33472f553470645b65010d3b2b3aa85bc6a6ac86bb0edd5b4a5a2e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "baa6d3e26166c5c47f4328542074d4cdc2fc26d5c7292e4ec63d09ab176250df"
    sha256 cellar: :any,                 arm64_linux:       "320a93e54dfef073cc62276d968cc717129e292eba211d54dbaf6f7d6952a5d3"
    sha256 cellar: :any,                 x86_64_linux:      "1a517efd74ab3202c425fb49d5f07633189e16f2bf0cb05c2c73c878c699d481"
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
      (datadir/"postgresql.conf").write <<~CONF, mode: "a+"

        shared_preload_libraries = 'wal2json'
        port = #{port}
      CONF
      system pg_ctl, "start", "-D", datadir, "-l", testpath/"log-#{postgresql.name}"
      system pg_ctl, "stop", "-D", datadir
    end
  end
end
