class Wal2json < Formula
  desc "Convert PostgreSQL changesets to JSON format"
  homepage "https://github.com/eulerto/wal2json"
  url "https://github.com/eulerto/wal2json/archive/refs/tags/wal2json_2_7.tar.gz"
  sha256 "e6c12d02dc32e4d610dce33ee52ea85a54e12a563e79c4844508b6c061ff07a1"
  license "BSD-3-Clause"
  revision 1
  compatibility_version 1

  livecheck do
    url :stable
    regex(/(?:wal2json[._-])?v?(\d+(?:[._]\d+)+)/i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| match[0].tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "637660a5479433b8b76554b99aa618c3dee922eb4f4345de7bb01d597dc0ccca"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c0c31107ebfb1aed013ee8f044677f674df810769ed3340ff8e7430a00f9fdfb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d02a290c0ca4e7365d0ab1baeb88638411355867420d2b1b96371df0c3399a95"
    sha256 cellar: :any,                 arm64_linux:       "7803dc0009aa18030a3ab934248344cf589820de418e3dfdfb294d8f795f6e99"
    sha256 cellar: :any,                 x86_64_linux:      "d68797eaa63ea645adeaf219402eb6f138895591982117db71a1944c3feefb05"
  end

  depends_on "postgresql@18" => [:build, :test]
  depends_on "postgresql@19" => [:build, :test]

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
