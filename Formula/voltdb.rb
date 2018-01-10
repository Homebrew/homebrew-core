class Voltdb < Formula
  desc "Horizontally-scalable, in-memory SQL RDBMS"
  homepage "https://github.com/VoltDB/voltdb"
  url "https://github.com/VoltDB/voltdb/archive/voltdb-6.9.tar.gz"
  sha256 "e3e1167681a151178d39293961cbb2e7e17d2c756ca6c3568b1fd49585069bb0"
  head "https://github.com/VoltDB/voltdb.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "81419cf29821d4d6051dec794e663bd76b6494eb7355bff2e9365c0610b32ae3" => :sierra
    sha256 "ee6ee32c112cb64f772ed3791140350cd5a0cf13e66a6e5a05530d074043defa" => :el_capitan
    sha256 "6762c49081ec4e08f96b738b1772a651e77165b124a2a28fe5a37820c4213561" => :yosemite
  end

  depends_on "ant" => :build
  depends_on "cmake" => :build

  def install
    system "ant"

    # Edit VOLTDB_LIB variable in bash scripts to match homebrew's folder structure. Python scripts work without
    # changes and are excluded here.
    inreplace Dir["bin/*"] - ["bin/voltadmin", "bin/voltdb", "bin/rabbitmqloader", "bin/voltdeploy", "bin/voltenv"],
      %r{VOLTDB_LIB=\$VOLTDB_HOME\/lib}, "VOLTDB_LIB=$VOLTDB_HOME/lib/voltdb"

    inreplace "bin/voltenv" do |s|
      # voltenv location detection is different than in other bash scripts.
      s.gsub! /VOLTDB_VOLTDB="\$VOLTDB_LIB"/, "VOLTDB_VOLTDB=\"$VOLTDB_BASE/voltdb\""

      # Remove voltenv installed as link check
      # Upstream PR https://github.com/VoltDB/voltdb/pull/3973
      s.gsub! /if \[ "\$\{0\}" = "\$SOURCE" \]; then/, "if [ \"${0}\" = \"${BASH_SOURCE[0]}\" ]; then"
    end

    (lib/"voltdb").install Dir["lib/*"]
    lib.install_symlink lib/"voltdb/python"
    prefix.install "bin", "tools", "voltdb", "version.txt", "doc"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/voltdb --version")
  end
end
