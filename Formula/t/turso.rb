class Turso < Formula
  desc "Interactive SQL shell for Turso"
  homepage "https://github.com/tursodatabase/turso"
  url "https://github.com/tursodatabase/turso/archive/refs/tags/v0.4.4.tar.gz"
  sha256 "24b737c2a04c27f0c2b7676d324bff2517a5b3f2de9e63fab9832d2c8bec5733"
  license "MIT"
  head "https://github.com/tursodatabase/turso.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc5e3e8aac35d9105bc440e98687183db6675d278b64ace7c3166a5e81dd0aa5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd250a10d44546aaaac1295863b5ccec4f4c90133fcc4f944a80cefce7dbee8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0cfa7e34b3ca0fb70fc3e4f537624ebefc0c391d3cdd0fd5a03cbfbb748ce8b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed114d732ed0d19e41b45f2e87d13f8875cd5c0a3cdc391a57271fa87ce28692"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7914211397bc7f5f36594eadbc1f0f2235f913af7e4bc984512622189fff6c8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "156bbb1a940f4b1eef827bbb3113f1535525d3b83bcf38a730913eabbd4c831a"
  end

  depends_on "rust" => :build
  uses_from_macos "sqlite" => :test

  on_arm do
    on_linux do
      depends_on "llvm" => :build
    end

    fails_with :gcc do
      version "12"
      cause "error: inlining failed in call to 'always_inline' 'veor3q_u8'"
    end
  end

  def install
    ENV.llvm_clang if OS.linux? && Hardware::CPU.arm?
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
