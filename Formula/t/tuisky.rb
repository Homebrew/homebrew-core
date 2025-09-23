class Tuisky < Formula
  desc "TUI client for bluesky"
  homepage "https://github.com/sugyan/tuisky"
  url "https://github.com/sugyan/tuisky/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "b87e50c8483624a2ccb4beeceb0503c3ad1f0a7ff3ac20a6da92eb952752c85d"
  license "MIT"
  head "https://github.com/sugyan/tuisky.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3598e2757c0abf6877e3263a5256b21f08973a5afaf9cfe96030c85169686ccd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b34ae115c6eec39e76460e02f3bb6756d12715293f45979205c44f5d775f019f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58424b63780eb01f0eccbc9aef4e75120b18b8b7616dc60d12c4c04033502196"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "00bdf438a3637643b47f76f00eab585301fad00c9259fd37f524a4538f0608e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "28edebdbb9dafc02fe03363746e2469db444a4bb7890bdbe9dd26fbcedfcfe2e"
    sha256 cellar: :any_skip_relocation, ventura:       "2f0f1a04028c894d1a914b5ccf8a270005f8fa67b09327a53f45470ad413248f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf2ca0fca8f43e3f2281cdb30d8dd6224496e6bcdd64702b310bc1334b065c8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59d75761a312d19428ef28dbba6eae4a03cbb60c50975689470e16a795b458b4"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args

    pkgetc.install "config/example.config.toml" => "config.toml"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tuisky --version")

    # Fails in Linux CI with `No such device or address (os error 6)`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"tuisky", [:out, :err] => output_log.to_s
      sleep 1
      assert_match "https://bsky.social", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
