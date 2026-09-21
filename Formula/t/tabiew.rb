class Tabiew < Formula
  desc "TUI to view and query tabular files (CSV,TSV, Parquet, etc.)"
  homepage "https://github.com/shshemi/tabiew"
  url "https://github.com/shshemi/tabiew/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "20d2c3e83b0f27fbe48c9ac0be95533361d29897bff1e3c5ce498ff46ae84580"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8318867603e95b6d694a2c23f432055c5b37e7d1a9dfb8602d74883ccfda467e"
    sha256 cellar: :any, arm64_tahoe:       "0b750691f1af2ccb2ddb26d1d5096ce1f80e3c57f0ce18102a2e41e981a5be2d"
    sha256 cellar: :any, arm64_sequoia:     "9e1121b1b971845d23ed0f2c548d5f7dcd403c21c6f6a6b715a60476d71567a6"
    sha256 cellar: :any, arm64_sonoma:      "35614cb655ce53f077141407b805d16d4a885d44fb902fcf69a43d368d1911a0"
    sha256 cellar: :any, arm64_linux:       "73115dbe8153076859769ffa7d8602822273f69d2a67e8c5490d7ffdebf0819d"
    sha256 cellar: :any, x86_64_linux:      "f44f27c5da942e36f718ef7aa9248abea9e537b8d769c6aed41732feae05a77b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  conflicts_with "watcher", because: "both install `tw` binaries"

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")
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
