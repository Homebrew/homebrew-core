class Turso < Formula
  desc "Interactive SQL shell for Turso"
  homepage "https://github.com/tursodatabase/turso"
  url "https://github.com/tursodatabase/turso/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "3674566ce7115dc6ba4f3598fa9c204e229098a16388eb7ec9079451c96a2dd8"
  license "MIT"
  head "https://github.com/tursodatabase/turso.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ae08978ce47f890d4f5e13735403a6bfee8f94189ec94801210a246c2c19579"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "765fc00f10416b748e2096f1f90550d72851614fe2c08007068adac798c37959"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a065feab5f0d76386cd0309ec9015e77b667ca5e811dcab669c023b5f1233bd6"
    sha256 cellar: :any_skip_relocation, sonoma:        "976151d81c68f1a14d6cf1f273d4b538d2b8320da0a00f6252eda107a3bea114"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0627092923d5bc935901833dfa0992313819658f57889c89cfcf5b8f330ec921"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61dcddf68cd1a17fe21dc7179d61253b0fd98cadbc6302cf51cec616192cf1fe"
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
