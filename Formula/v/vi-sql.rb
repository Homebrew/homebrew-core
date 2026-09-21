class ViSql < Formula
  desc "Terminal UI for SQL databases"
  homepage "https://vi-sql.com"
  url "https://github.com/kopecmaciej/vi-sql/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "1bd04d112fa9a7309dd9a2d9735e770df211d9d8d8d89360bc521bc270ac6b49"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d0a48c86210f9cf3c68b1a7f212dcb34faa90b5c6c24e465929fc8c7d091920b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d0a48c86210f9cf3c68b1a7f212dcb34faa90b5c6c24e465929fc8c7d091920b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d0a48c86210f9cf3c68b1a7f212dcb34faa90b5c6c24e465929fc8c7d091920b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "d0a48c86210f9cf3c68b1a7f212dcb34faa90b5c6c24e465929fc8c7d091920b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "afa50f26b5f2b700749e9b5482fc17739cf2ce5213d2f7f2beef6dd75c00785c"
    sha256 cellar: :any,                 x86_64_linux:      "56f4bca80f7e89e9e6dd2722408e3f0afd992fac162e2493c24679f3fb4ce4d1"
  end

  depends_on "go" => :build

  uses_from_macos "sqlite" => :test

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.com/kopecmaciej/vi-sql/internal/build.Version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vi-sql --version")

    test_db = testpath/"test.db"
    sql = <<~SQL
      create table students (name text, age integer);
      insert into students (name, age) values ('Bob', 14);
      insert into students (name, age) values ('Sue', 12);
      insert into students (name, age) values ('Tim', 13);
      select name from students order by age asc;
    SQL

    assert_match "Tim", pipe_output("sqlite3 #{test_db}", sql)

    ENV["TERM"] = "xterm"
    output_log = testpath/"output.log"

    require "expect"
    require "pty"
    PTY.spawn(bin/"vi-sql", "--reset-master-password", "--connect", "file:#{test_db}", "--jump", "main.students",
              [:out, :err] => output_log.to_s) do |r, w, pid|
      r.expect "SQL Editor Normal", 5
      w.write "\x03"
      sleep 2
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    ensure
      r.close
      w.close
      Process.wait(pid)
    end

    assert_match "Master password is not configured", output_log.read
  end
end
