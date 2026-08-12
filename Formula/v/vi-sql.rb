class ViSql < Formula
  desc "Terminal UI for SQL databases"
  homepage "https://vi-sql.com"
  url "https://github.com/kopecmaciej/vi-sql/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "99321f8db75ab0f6932e59b5a5ffd871a99b654649ea56f8246986cf31e9c62e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e80279f457a615e09512754fe1ababc6ffbd09a28c4cc0aecb49e945938b85c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e80279f457a615e09512754fe1ababc6ffbd09a28c4cc0aecb49e945938b85c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e80279f457a615e09512754fe1ababc6ffbd09a28c4cc0aecb49e945938b85c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "07a4e2fa244382f040bdc59e9971ea0ab382bbca1fc6bc2ec9dc72400afb0513"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "116f6f54d83a48bf00ff90449d55a9d3022516c17d985553ddff194ee88716b9"
    sha256 cellar: :any,                 x86_64_linux:  "9970f7fdd18ef426edc387b2e51df4123104498a913ae495e83b58b73969752d"
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
