class Turso < Formula
  desc "Interactive SQL shell for Turso"
  homepage "https://github.com/tursodatabase/turso"
  url "https://github.com/tursodatabase/turso/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "9bcb9bcd9248ded3e066dd95f2d8a7b138a695bac43a392f719002b108820495"
  license "MIT"
  head "https://github.com/tursodatabase/turso.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "79a87c7858f161b533070b946b8f849367ace0e6b1518f85d9ee57bafbd22137"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5c1438c8bc6492c9acac6ff3b741cf9a0966ff2c509bceb893450f9f6cfacf0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3881e2e3e6f944ae8b7468c2018c36d0f40b1547544630ab25774f353fd65adc"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4d27763582b2fc3b1c2a79d064cf8185bcd54e29211449364ba91de78845952"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "335ebeae7e44424fd52de456b87904c96b34ff8d1a081b60b50d8abe5a28fe76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3733f0eedca65b6bb37470ce4450ca6f4a3d6dc78bc6c334f02c8509a9a6416"
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
