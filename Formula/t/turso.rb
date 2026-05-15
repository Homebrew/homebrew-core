class Turso < Formula
  desc "Interactive SQL shell for Turso"
  homepage "https://github.com/tursodatabase/turso"
  url "https://github.com/tursodatabase/turso/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "f91b97a8f51fb8b9671822e6b61ef3abc5e860c3abeff4bf581478da9de59365"
  license "MIT"
  head "https://github.com/tursodatabase/turso.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4907b2d7618af9d01efdd54fc6a44b29bae1f26fc344ed7850ae0ff3ee8b38d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75ed1a2218d85b312d285804bf48a03691c8d979d011b94ca278bebb6ea8b65c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65a9da9a59141aa81990aa0e9710c6b63670e634b08db1a6161da099afdec35c"
    sha256 cellar: :any_skip_relocation, sonoma:        "362406c3f148ee27ac89e70a681f07b4de9314b9711d864bbbc5f90e40e98f36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "647daf02035371429bce768e1631b9e02cecff60e7da49722a9e2d18a74a4e6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbd8bad9809105cdff7e0bc2167dd708f7d2979ca86388d66441ca0b8950e03d"
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
