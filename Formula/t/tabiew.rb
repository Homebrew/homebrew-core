class Tabiew < Formula
  desc "TUI to view and query tabular files (CSV,TSV, Parquet, etc.)"
  homepage "https://github.com/shshemi/tabiew"
  url "https://github.com/shshemi/tabiew/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "e90301e79d0f0e6416e85204ed78d9e80752ca9fff76f9456f3edb9e8de6b8b4"
  license "MIT"
  head "https://github.com/shshemi/tabiew.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b59474a2591256ae50667a83c3d447b629b1eec31643cf761e2cb4b2df44044f"
    sha256 cellar: :any, arm64_tahoe:       "c02c30f78ceb8f751645ec8dfa778f3ae8b533a268ecf3eaf6ba3a7a2762894d"
    sha256 cellar: :any, arm64_sequoia:     "4a3f135a4f55fac03083770d7ebc184157792ca1d8f562b5bf9878dcc5f392c7"
    sha256 cellar: :any, arm64_linux:       "03f8a836204a491fec13261d645fe4cdf7a905dfb7fcafa63b04d9fd77e17cb1"
    sha256 cellar: :any, x86_64_linux:      "5b9197b043b2238211c7adc646c6ef5417f867a6477e591c8735434f7d8fdf18"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  conflicts_with "watcher", because: "both install `tw` binaries"

  deny_network_access!

  def openssl = deps.map(&:name).find { |d| d.match?(/^openssl(@\d+(\.\d+)*)?$/) }

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix(openssl)
    system "cargo", "install", *std_cargo_args

    man1.install "target/manual/tabiew.1" => "tw.1"
    bash_completion.install "target/completion/tw.bash" => "tw"
    zsh_completion.install "target/completion/_tw"
    fish_completion.install "target/completion/tw.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tw --version")

    (testpath/"test.csv").write <<~CSV
      time,tide,wait
      1,42,"no man"
      7,11,"you think?"
    CSV

    require "pty"
    require "expect"
    require "io/console"

    PTY.spawn(bin/"tw", testpath/"test.csv") do |r, w, pid|
      r.winsize = [80, 130]
      r.set_encoding("UTF-8")
      refute_nil r.expect(/\e\[6n/, 10), "expected cursor position query"
      w.write "\e[1;1R"
      refute_nil r.expect("you think?", 30), "expected the CSV to render"
      w.write ":Query\r"
      w.write "select wait from test where tide < 40\r"
      refute_nil r.expect("you think?", 10), "expected the query result"
      sleep 1
      w.write ":Quit\r"
      w.close
      r.close
    ensure
      Process.kill "KILL", pid
      Process.wait pid
    end
  end
end
