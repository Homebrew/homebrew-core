class Ripgrep < Formula
  desc "Search tool like grep and The Silver Searcher"
  homepage "https://github.com/BurntSushi/ripgrep"
  url "https://github.com/BurntSushi/ripgrep/archive/refs/tags/16.0.0.tar.gz"
  sha256 "17e7a1a0db80ed9618a0963c7ae4aecb8fce25c70cf7ebed514daf2b38a0d153"
  license "Unlicense"
  compatibility_version 1
  head "https://github.com/BurntSushi/ripgrep.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "9821a1856c58b7883c49081519e78f21008e656095e986bc478caa050515cf99"
    sha256 cellar: :any, arm64_golden_gate: "2a271df3360bfd5faea4a128f3db751f663d7eb00c8b0a7291b559ddff47bcc0"
    sha256 cellar: :any, arm64_tahoe:       "15e2b23e8774d6876b857705bb8bc2ac94d8694aaea8dd61895e4a66b4d4a319"
    sha256 cellar: :any, arm64_sequoia:     "466909c89cbf077281bacc1167bb95be35c5f59af75c34585f91cb1e2d98bbbe"
    sha256 cellar: :any, arm64_linux:       "537d00273767baca9ee5a4bd66b59e47bfcd498ea5dc36036dddbfc25c3a5bbb"
    sha256 cellar: :any, x86_64_linux:      "862724e6e257ef757dcdcd7c7484eca6c2ca8ca11575d600cdbf54a5dc1e757d"
  end

  depends_on "asciidoctor" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "pcre2"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(features: "pcre2")

    generate_completions_from_executable(bin/"rg", "--generate", shell_parameter_format: "complete-")
    (man1/"rg.1").write Utils.safe_popen_read(bin/"rg", "--generate", "man")
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    system bin/"rg", "Hello World!", testpath
  end
end
