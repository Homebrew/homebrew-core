class Rnr < Formula
  desc "Command-line tool to batch rename files and directories"
  homepage "https://github.com/ismaelgv/rnr"
  url "https://github.com/ismaelgv/rnr/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "af35b5d5afab08b01cab345686d7e7d2d37a33d268fa8827a8001c3164ef4722"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b02c6eb19e40e1f7e4b36bc0faf1d1f77592258b89dcb0ba15563a6aa0d31fdc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "35316f34e9c60a278d5179f0d05d729b2c9ae5cf85bb43223898467b3a41f177"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2264df39b495fb1648d1713ce8948d7a9c6465371b87734d458108a45f2a9c03"
    sha256 cellar: :any,                 arm64_linux:       "fc01a3bf8d09ef3988e800d60ed5d30d44d4201bfc2eabc55c561c7e95c12ef4"
    sha256 cellar: :any,                 x86_64_linux:      "eb115bed9abf5c8d80eb866202660e120eaeedd4d2e63455b291afead6dc3afb"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    deploy_dir = Pathname.glob("target/release/**/rnr.bash").first.dirname
    zsh_completion.install "#{deploy_dir}/_rnr"
    bash_completion.install "#{deploy_dir}/rnr.bash" => "rnr"
    fish_completion.install "#{deploy_dir}/rnr.fish"
  end

  test do
    touch "foo.doc"
    mkdir "one"
    touch "one/foo.doc"

    system bin/"rnr", "regex", "-f", "doc", "txt", "foo.doc", "one/foo.doc"
    refute_path_exists testpath/"foo.doc"
    assert_path_exists testpath/"foo.txt"

    assert_match version.to_s, shell_output("#{bin}/rnr --version")
  end
end
