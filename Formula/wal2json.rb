class Wal2json < Formula
  desc "Convert PostgreSQL changesets to JSON format"
  homepage "https://github.com/eulerto/wal2json"
  url "https://github.com/eulerto/wal2json/archive/wal2json_2_5.tar.gz"
  sha256 "b516653575541cf221b99cf3f8be9b6821f6dbcfc125675c85f35090f824f00e"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/(?:wal2json[._-])?v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c9dec0653716cd5dcb63a76150b399252776bfa0013dfabdfbc0a2f3e700e89"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e49db0bc27c9bb9355f9c9c6a032b5dd56b4e70ec03950355367c809e54088d"
    sha256 cellar: :any_skip_relocation, monterey:       "9c340985060a45681159a662d4fe4ff6a19fdf6735c28d2c67f9ae38a052ef20"
    sha256 cellar: :any_skip_relocation, big_sur:        "e961f33e907f86ced624dbbddfabc25e66007a83cc89f9e2f6c1a83e440f9e43"
    sha256 cellar: :any_skip_relocation, catalina:       "3438e2f5355834993c39f5a9488138643be8e88ec643420647a38a83d65ac4ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6cec39726b0b3dc1f51319d2831875716e1dec9e5a50a27981f7cee77db1447"
  end

  depends_on "postgresql@14"

  def postgresql
    Formula["postgresql@14"]
  end

  def install
    ENV["PG_CONFIG"] = postgresql.opt_bin/"pg_config"

    mkdir "stage"
    system "make", "install", "USE_PGXS=1", "DESTDIR=#{buildpath}/stage"

    stage_path = File.join("stage", HOMEBREW_PREFIX)
    lib.install (buildpath/stage_path/"lib").children
  end

  test do
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
