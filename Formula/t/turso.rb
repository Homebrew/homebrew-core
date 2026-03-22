class Turso < Formula
  desc "Interactive SQL shell for Turso"
  homepage "https://github.com/tursodatabase/turso"
  url "https://github.com/tursodatabase/turso/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "a2d9ab254cfe8aa92b35335dbff699fe6e94519f9ea4c0260b44842551169462"
  license "MIT"
  head "https://github.com/tursodatabase/turso.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "32a68187241a6f71a4fec0201a1ff60cd6839bdfba56cd30d5906f552aaf54f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4525f199372c4de9daa22c2c1b4c6762b74ae3d5d1994fc1f28f7df731040731"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63726154ea4e3797ca0eced83524847a3adde44ea3c2802d4d8e66554a4b98d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6034cb5bc5f1f3756c03f12964c948482641942562a24fb0fa229de8437b47d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b39bf98e58c8a16f8db16bbbec0e3e1234276f8680e13b41c0434e9206a685f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7434e670fca5f209f5621cdcfa0f0258e5cd3109b8e1c39081c9f6938976cff4"
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
