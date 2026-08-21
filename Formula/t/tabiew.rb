class Tabiew < Formula
  desc "TUI to view and query tabular files (CSV,TSV, Parquet, etc.)"
  homepage "https://github.com/shshemi/tabiew"
  url "https://github.com/shshemi/tabiew/archive/refs/tags/v0.14.2.tar.gz"
  sha256 "20e1d8c101d8882860f52d3fa5106382544ff1441d57565824dce65c091e8360"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "778bb2729869b8c824e9f38a6e9d7f7c45e5d216aa0d22e2ee596c89eed845b5"
    sha256 cellar: :any, arm64_sequoia: "947cbddcd80d4cb8a49efeffdf3c8281838e9f8cff3017b394edbc7e240b4fe2"
    sha256 cellar: :any, arm64_sonoma:  "25f6db107858ec79ade9185b08d713baa41ab531d74f7bf036844b42cba7ac56"
    sha256 cellar: :any, sonoma:        "4c1cf6e1d2d015bdeea198c12423af2bd87dc862f12f059e59ffabcbb73ac135"
    sha256 cellar: :any, arm64_linux:   "76119ed39335e3596ffdd0efdffee9e4a40c0f2ca8776f7e3c41421a5f63f895"
    sha256 cellar: :any, x86_64_linux:  "a61885ec93d6fea35b441256bacaf402a0024455ac37da36b2ee4bda7ff43a23"
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
