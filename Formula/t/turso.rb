class Turso < Formula
  desc "Interactive SQL shell for Turso"
  homepage "https://github.com/tursodatabase/turso"
  url "https://github.com/tursodatabase/turso/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "2fa500d7ad88e7c19178acad9c32acd638128f63be7ad1d30c9d5978fa6dd081"
  license "MIT"
  head "https://github.com/tursodatabase/turso.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0a9e107b8654eed1bbe24505d4c559d6d674fe157a9f1337d4cefa84279a22c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e174861159e33a3987964b34d687e1e8cb4fa6c85692bbad553d2a2971c8b0d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e54d934960a4f9280b051d4c2027bd909799e03ef3ec4f2a7c5f95a49e5a52d"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae98e7e8db455ce58cc711db567955d352b3401bcc6dc4990c81354f21acc875"
    sha256 cellar: :any,                 arm64_linux:   "e19eed13a5d4966f41cdea178246c18f896534728f99a45a9ed824b33747ea8c"
    sha256 cellar: :any,                 x86_64_linux:  "e4f73fa5af7a58ee57aa49e014251c3a9e9d892f186dab9346f0130e40fb4173"
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
