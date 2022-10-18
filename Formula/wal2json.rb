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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d6e1da3ff100ef985fcfd0ce5b9ad4095209c9625447a33764f73383e0174f6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "14407a5bc84e8db3b3a73555b31e7a27f229376bc449b51a62d936020f7c525d"
    sha256 cellar: :any_skip_relocation, monterey:       "257d8f5d6803fe88f3c0635aea44c1d67ea1c77a45ce064ba2e3f361e7c98642"
    sha256 cellar: :any_skip_relocation, big_sur:        "ec66adbf5d0932d50f6a3e75bb44ae8c051e49d14e312c9b171614b252297e3e"
    sha256 cellar: :any_skip_relocation, catalina:       "22010d68d3ae9e7c2f021666e9b245fd6d61e237d37ffe0152dbf6d61eceb7cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2e6b41d55bf757d3554f9c199c8be44d2edc422864aa224395fbe0573f6c817"
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
