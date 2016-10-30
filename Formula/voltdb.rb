class Voltdb < Formula
  desc "Horizontally-scalable, in-memory SQL RDBMS"
  homepage "https://github.com/VoltDB/voltdb"
  url "https://github.com/VoltDB/voltdb/archive/voltdb-6.6.tar.gz"
  sha256 "300d06c8f5a1cc4a3537f216ea105d5ccc8987b10bad2c676a40543c8903d72e"
  head "https://github.com/VoltDB/voltdb.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "963b5a8050e0be1cd4901a56ecbf405a65a784511cc90253d14d100fb17b7b89" => :sierra
    sha256 "dfa015f19e3507403eb161476b7f8536b7ed3d45214225997cd187cb013cbc42" => :el_capitan
    sha256 "2bc7a5322b2b2afaa9d6d83651d922f3240d66eb690a8d389ef23ce56c0de463" => :yosemite
  end

  depends_on :ant => :build
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
