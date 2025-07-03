class Turso < Formula
  desc "Interactive SQL shell for Turso"
  homepage "https://github.com/tursodatabase/turso"
  url "https://github.com/tursodatabase/turso/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "04ea555053f6d2a85cbf07e9f8eccd4dcbdeeb0e0c914941783db59513ec1ded"
  license "MIT"
  head "https://github.com/tursodatabase/turso.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "adf17a27a75e91f3cee9810e0cc85df0d5c3ea1032769db1b45f7fbb74223be1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3abae2e50975c53a3a5b1bcf9399c83f59b60e6f1219e89d796db7a6b331588"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cf206b169bc8e29a9a528eddf20023f0e98d71dfa1dfac79ceb82f0676811e88"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd6791981bdeaa67724ba9ceb2262b14f6ad1d828f232ebc734f1f3dd37b24e6"
    sha256 cellar: :any_skip_relocation, ventura:       "cd5c5925aa23b1f594bff07bc6b38729dfcf1ec074a23e2ff56d8ee7d82fa528"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99bca00b7f40809781a226800b82e252548e56e9bd5f1027a0c28d1a3891f962"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1e057d64a70bb50d64fe5e512c87d3fe0207a95a86e8b0700d7ad4528dea30b"
  end

  depends_on "rust" => :build
  uses_from_macos "sqlite" => :test

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tursodb --version")

    # Fails in Linux CI with "Error: I/O error: Operation not permitted (os error 1)"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    data = %w[Bob 14 Sue 12 Tim 13]
    create = "create table students (name text, age integer);\n"
    data.each_slice(2) do |n, a|
      create << "insert into students (name, age) values ('#{n}', '#{a}');\n"
    end
    pipe_output("sqlite3 school.sqlite", create, 0)

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"tursodb", "school.sqlite", [:out, :err] => output_log.to_s
      sleep 2
      assert_match "\".help\" for usage hints.", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
