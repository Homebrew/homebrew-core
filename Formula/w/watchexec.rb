class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://watchexec.github.io/"
  url "https://github.com/watchexec/watchexec/archive/refs/tags/v2.1.2.tar.gz"
  sha256 "500b886038ccd553559fe19914e1a502728cfeb8ee9d81f3db448b05e5a890ec"
  license "Apache-2.0"
  head "https://github.com/watchexec/watchexec.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:cli[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "dfa3be338b5b0015ec7d18489aba334bb068e4b21a1870a93f393ee2941af532"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "20f4dfbd8c6119f7e150bd60f8235899b25fd5d0ccf3a7d3364139754f82b06b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1cbb35219912da7329b1f5461b47028d55b134b3fce321b8b18a8918827fe417"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb290152092cbb8bbddc1a01eb5e817e2951a3ed8f3aa3c0f53001c714742958"
    sha256 cellar: :any_skip_relocation, sonoma:         "faf1b93ef67ba69433d22554d2ea769fd9084d757897660934bde8c7afe89068"
    sha256 cellar: :any_skip_relocation, ventura:        "238ea0d418ad29f50d218ddd92a4c25f31c7397a6ee672813aa89057ca84b8ce"
    sha256 cellar: :any_skip_relocation, monterey:       "851d07ff925a6c554770dcccb742b1f35b2af2612c3c01da8f64e8443b967ec5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a01dd6432d33d741c8e491860918c8f782d74c0053109947ca074155897fb2a8"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")

    generate_completions_from_executable(bin/"watchexec", "--completions")
    man1.install "doc/watchexec.1"
  end

  test do
    o = IO.popen("#{bin}/watchexec -1 --postpone -- echo 'saw file change'")
    sleep 15
    touch "test"
    sleep 15
    Process.kill("TERM", o.pid)
    assert_match "saw file change", o.read

    assert_match version.to_s, shell_output("#{bin}/watchexec --version")
  end
end
