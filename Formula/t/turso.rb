class Turso < Formula
  desc "Interactive SQL shell for Turso"
  homepage "https://github.com/tursodatabase/turso"
  url "https://github.com/tursodatabase/turso/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "579efd473e08e3c1fa2ae6f04e216ac98b664479904823f5eb5f813cd9320b55"
  license "MIT"
  head "https://github.com/tursodatabase/turso.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd84f4778a7d9412f62c856728db4ad8fb6861d69320fd688a1ab00c97a4eb74"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd4ad3c5dc7a512f4ce8a77f86742a5aefe1ce681c159b1cffda4b5ae059b494"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc25e3eddf9105f4f652a6a20b5241bafaff52f2f69b1878ddd423f05b41ea17"
    sha256 cellar: :any_skip_relocation, sonoma:        "001011cdb058c3127214feee455aecaa2194fbd9ad9ee74096002162079d47a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f64bc67795e08f22d0ece303145d77cb55283a132294ac9919c934fcdd829190"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b50791436a222276575c03fa82a3ea9f951454bdddc345eaab1dfb906802155b"
  end

  depends_on "rust" => :build
  uses_from_macos "sqlite" => :test

  # Fix to error unsupported option '-mcrypto|-maes' for target 'arm64-apple-macosx'
  # PR ref: https://github.com/tursodatabase/turso/pull/3561
  patch do
    url "https://github.com/tursodatabase/turso/commit/0ef0c7587979ce3f6863599e387c9ef6e93abe75.patch?full_index=1"
    sha256 "788ffb4a456318a16073784b940fe6c10376dc54bc4408ca6d55db068b888303"
  end

  def install
    # Workaround to build `aegis v0.9.3` for arm64 linux without -march `sha3`
    ENV.append_to_cflags "-march=native" if OS.linux? && Hardware::CPU.arm?
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
