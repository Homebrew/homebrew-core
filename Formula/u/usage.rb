class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://github.com/jdx/usage/archive/refs/tags/v7.1.0.tar.gz"
  sha256 "843db75f18a441f30fa068473a25b17b77c2a7680150182809a65c0351287509"
  license "MIT"
  compatibility_version 1
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "32f65e3f85af927413ea8fb8bdced6b8c5f0edfa362a4707a57d5b7c90cc9360"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "786714752d124bda8570c3e1d900599fa65197879af222d0061f7b9224bc69db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7dc62feebe070f3e9ee2e548ee1113f07fabdf0b4ce388a88aa181935090b7ab"
    sha256 cellar: :any,                 arm64_linux:       "44df7ac84a287f08988b43443644a03e07e8110a3b312c8dc660fc8bd848c6d4"
    sha256 cellar: :any,                 x86_64_linux:      "7998e2a67ad72eb9d213bfab7f017d3e93d0dd637296ebdcdebd08ae2d1fc38d"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    man1.install "cli/assets/usage.1"
    generate_completions_from_executable(bin/"usage", "--completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/usage --version").chomp
    assert_equal "--foo", shell_output("#{bin}/usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end
