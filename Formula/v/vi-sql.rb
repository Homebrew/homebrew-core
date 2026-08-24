class ViSql < Formula
  desc "Terminal UI for SQL databases"
  homepage "https://vi-sql.com"
  url "https://github.com/kopecmaciej/vi-sql/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "e62b4a5beb99eb803d80d434a05e0bd201192b03a0f6859f10806c4ec3b0e21b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "418fd8a60f5350fb9be4988d99df436b4ff37045f62fb71ba7034474284d2c0f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "418fd8a60f5350fb9be4988d99df436b4ff37045f62fb71ba7034474284d2c0f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "418fd8a60f5350fb9be4988d99df436b4ff37045f62fb71ba7034474284d2c0f"
    sha256 cellar: :any_skip_relocation, sonoma:        "68c6d789b2648feb6dd348b91a279b5a6b0007dda7367cf7314075d1a5980791"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "886150016cd8b1e6e410b8173fdeb7b478c3cb5fa4409623a45b4e0d7163ed38"
    sha256 cellar: :any,                 x86_64_linux:  "298189d66179ee57de651764272a78d96ac87978044bce02ec453b4a9bff1e63"
  end

  depends_on "go" => :build

  uses_from_macos "sqlite" => :test

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
