class Tabiew < Formula
  desc "TUI to view and query tabular files (CSV,TSV, Parquet, etc.)"
  homepage "https://github.com/shshemi/tabiew"
  url "https://github.com/shshemi/tabiew/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "88876174a3a008618e5b2a55df5dffa26cc0593ce2dcf6b057900ffc303732a8"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "cb87a123a11233d70c9aa7e14782882a8100d2182e630c2deb65a99c1d03fd5f"
    sha256 cellar: :any, arm64_sequoia: "af95a38dd261b57bc99bce39b3b9334df498c9f3b125debf62449719af82e476"
    sha256 cellar: :any, arm64_sonoma:  "b27719475764134ad5530898d4592287303077c4a9cf041330f69a931512f42f"
    sha256 cellar: :any, sonoma:        "55bb40a1701f9dd99f5fdd11c0b935acde0b2e71f334d46742db26cacb6bb5cd"
    sha256 cellar: :any, arm64_linux:   "4b8e97dffba63a2444a3dc380f0f9198cad6d2aa0b10790bf9905a9cd181ebd4"
    sha256 cellar: :any, x86_64_linux:  "2d0bc86b6ecf2011a1fc251aa5e796b3fa5921242fe37e352a6b17c76aeebc31"
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
      w.write "\e[1;1R\r"
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
