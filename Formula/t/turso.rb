class Turso < Formula
  desc "Interactive SQL shell for Turso"
  homepage "https://github.com/tursodatabase/turso"
  url "https://github.com/tursodatabase/turso/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "c4d19a5106041499bd541b4306ee025c4719f8b2b937adad2cb49f408bb1343c"
  license "MIT"
  head "https://github.com/tursodatabase/turso.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e8ffc562725a1bccd73d67669cb643d471ebef197169e7ba720a34e2c09f9006"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aeba638b3d17c916d1cb13ca9c53f06575e076fa2ac8dfe2717590a82e6c2eb5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "059b5d41f1a0c4d412f8718e1cd0912ebb8c7d2a6349cec3f68a70c006985de3"
    sha256 cellar: :any_skip_relocation, sonoma:        "6698a99013c2689f07253a63ebb061e4553cea5dd389bd1a24286ab069527d6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb50bc3a5ea694c1e1466ef3eda57a47cfddd7bb486634aecd522957d01451b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55752d81cc764a164a92600423d75ef301241aaa598da784c61f61a3ff521545"
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
