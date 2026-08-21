class Turso < Formula
  desc "Interactive SQL shell for Turso"
  homepage "https://github.com/tursodatabase/turso"
  url "https://github.com/tursodatabase/turso/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "bf124c80771ff1182c957db904543754b2594cb0222f5505d2d257d4fd852590"
  license "MIT"
  head "https://github.com/tursodatabase/turso.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "96c80b530952c4d5d5aef1c0046a812a654779b8d03c22e0194baeb5d588bfc8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e87de85d87f5962fe9841f9225927d616036d4f22247565e987a676a0de657c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "128b6607f6d5446b33938bce772fbb7ddc37b0f2a7b22bb8cec471983f1cfea9"
    sha256 cellar: :any_skip_relocation, sonoma:        "f280313db40ccf10f223a1e8c255c791d719f5ed917d0baf7d9d31bbea12483f"
    sha256 cellar: :any,                 arm64_linux:   "a69335cf31f3dfaa1d73a0c644f0ee03e3d806a6b844e4c9d2d1b29af3eec150"
    sha256 cellar: :any,                 x86_64_linux:  "2d67dada318a1f24d29d311363939a0159271c630554a80f7908f26daff6dc87"
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
