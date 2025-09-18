class Volta < Formula
  desc "JavaScript toolchain manager for reproducible environments"
  homepage "https://volta.sh"
  url "https://github.com/volta-cli/volta/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "0e93d17c36fb79222b10881d6c67d667483f85b19a0498eacfc535ef31894dbe"
  license "BSD-2-Clause"
  head "https://github.com/volta-cli/volta.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "60e950c599630d46e928ddbd6f9cf4494dcbd5a7781e116c0890aa156de912ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "acfec2a99f0b9365f89152d6796918fab98839f43a7f16a3a180417e2082f5fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb744499c855e7fc137088663ef45db348e20727549a20c5822ef5887b896205"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "92156fa743a1700648c3ac10594c042c94ceb2b415ff800054d1a13777d49019"
    sha256 cellar: :any_skip_relocation, sonoma:        "8cf25e1f75d7f3b228a79a986e81817c0690feb96f253b5d11309311166189a0"
    sha256 cellar: :any_skip_relocation, ventura:       "1c41e466e6b4ce60d13addb1cb792785d4ecaef3c768491f062771603252d523"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a116be251ad88fcb927346f510bff705183f8922cb287533d014acdb83031f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0eede98248c0b47f51645f2a7c051549913fcb207f48364f446611f542845ae"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"volta", "completions")

    bin.each_child do |f|
      basename = f.basename
      next if basename.to_s == "volta-shim"

      (libexec/"bin").install f
      (bin/basename).write_env_script libexec/"bin"/basename, VOLTA_INSTALL_DIR: opt_prefix/"bin"
    end
  end

  test do
    system bin/"volta", "install", "node@19.0.1"
    node = shell_output("#{bin}/volta which node").chomp
    assert_match "19.0.1", shell_output("#{node} --version")
    path = testpath/"test.js"
    path.write "console.log('hello');"
    output = shell_output("#{testpath}/.volta/bin/node #{path}").strip
    assert_equal "hello", output
  end
end
