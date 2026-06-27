class Turso < Formula
  desc "Interactive SQL shell for Turso"
  homepage "https://github.com/tursodatabase/turso"
  url "https://github.com/tursodatabase/turso/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "0a197b9ed4ecacc5983145c06d927b4945d79a2ceae3f98579a94ceb6db0bb04"
  license "MIT"
  head "https://github.com/tursodatabase/turso.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f5b469e9080541f070883c341869a5cec106cb427c8f47055b1a0b00c498905"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2842e2873af8e96ae5ae9d4668d7543bfd28b4cc377f149cd9f3a34e040fe316"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65d801ba7ec8f29d7eeb2b6149f80a2bf735f4b7c2d4cd94330ed6e0099e96dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0bdfc1e5606d326086540cf5eadee5a3f36633ea64d6634c05569bfffecffd1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da7f9727d1a4b747429f1c7d6e5e8dff58224e19b20ee561a795913d4f35a78d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "811468ee153ba7cecd483957788a420774cc26ddb1b41ff3f846f8e5d40936ac"
  end

  depends_on "rust" => :build
  uses_from_macos "sqlite" => :test

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
