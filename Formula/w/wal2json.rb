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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "710ff8f3b3864341881f87eb09404d769eca2e46b55ee16cb04ba6965a9663be"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e40b5c9a14fbc9201990660af9061bb67c3a14b1354b0f8dbaca18c57667103"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd10e9889a5adf9fe3868ed5b6c66abe196b1541b48cbeccae8fba619df05205"
    sha256 cellar: :any_skip_relocation, sonoma:         "4b5daf478e22769735e816c363e2cbb4663615927d66d1ec069f8dcc3d6d8753"
    sha256 cellar: :any_skip_relocation, ventura:        "7fe8fde86fe3cd826107d4609bb3d62ee495788f3fb045a5662c1cc59ea2890e"
    sha256 cellar: :any_skip_relocation, monterey:       "570e8c65efd211e7354a9d68f8c34d44ab237e1b51db1e5ce6116bc6a3d1f939"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "acdb17c44def80cc1c92841a0c06589c21a7ca7fe73445d93909bc6620a1f9a4"
  end

  depends_on "postgresql@14"

  def postgresql
    Formula["postgresql@14"]
  end

  def install
    system "make", "install", "USE_PGXS=1",
                              "PG_CONFIG=#{postgresql.opt_bin}/pg_config",
                              "pkglibdir=#{lib/postgresql.name}"
  end

  test do
    ENV["LC_ALL"] = "C"
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath/"test"
    (testpath/"test/postgresql.conf").write <<~EOS, mode: "a+"

      shared_preload_libraries = 'wal2json'
      port = #{port}
    EOS
    system pg_ctl, "start", "-D", testpath/"test", "-l", testpath/"log"
    system pg_ctl, "stop", "-D", testpath/"test"
  end
end
