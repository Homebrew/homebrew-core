class Turso < Formula
  desc "Interactive SQL shell for Turso"
  homepage "https://github.com/tursodatabase/turso"
  url "https://github.com/tursodatabase/turso/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "18912d5142b3d4abe29aeeb771ccbbdb4c819105627833d2232d746013d9cd0a"
  license "MIT"
  head "https://github.com/tursodatabase/turso.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "47a0890fdb028897e341dacabb91b07e5f3484751c1b33250491ac12c965ea3a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "67efadc00266071e8fc9b037ab61445c7754dff0818a326cdb56bcd09a724f99"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "99561b3c357353314453bf05568c5c3abab90332f1d5dbc050da3b92e993222a"
    sha256 cellar: :any,                 arm64_linux:       "576bc4d735a57baa6592c44780384d17b23d4a335419decf755c0b72e6747848"
    sha256 cellar: :any,                 x86_64_linux:      "1e608dff13ccf307732081dfa1f5cbd9e8a1f4eee8ff112999173e1c3bcd87d9"
  end

  depends_on "rust" => :build
  uses_from_macos "sqlite" => :test

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tursodb --version")

    data = %w[Bob 14 Sue 12 Tim 13]
    create = "create table students (name text, age integer);\n"
    data.each_slice(2) do |n, a|
      create << "insert into students (name, age) values ('#{n}', '#{a}');\n"
    end
    pipe_output("sqlite3 school.sqlite", create, 0)

    begin
      output_log = testpath/"output.log"
      if OS.mac?
        pid = spawn bin/"tursodb", "school.sqlite", [:out, :err] => output_log.to_s
      else
        require "pty"
        r, _w, pid = PTY.spawn bin/"tursodb", "school.sqlite", [:out, :err] => output_log.to_s
        r.winsize = [80, 43]
      end
      sleep 2
      assert_match "\".help\" for usage hints.", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
