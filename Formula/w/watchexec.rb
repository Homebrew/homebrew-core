class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://watchexec.github.io/"
  url "https://github.com/watchexec/watchexec/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "372def49d02a53864ede5fd821feb6f8de96bbbde8a94dbcd1b77aeed01d4a7b"
  license "Apache-2.0"
  head "https://github.com/watchexec/watchexec.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:cli[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f07d0a48267cddccccec5d2ef32af1c9c5433a57a011f29e7f7e2636922e8af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8f9982b860e55abca3f63d8a249544ab990cd485d4cf1ead9668f5db63825c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3e20c42b54a29d0e53cd76f8a1955c14da9dc0a068852e2f16b37ced3c07568a"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fe9bfdfe5fb63da4affe136d64c19001bba146db5960e3a2544f9ff379408ca"
    sha256 cellar: :any_skip_relocation, ventura:       "7310910c18e0c9d867731634bd0ea4400b6463f3aebea9e787d63d72551f0ac1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69dde0d1d6eaedcd17e4e796f5c68377d6b5e6df713c79a7fd08df00f6e96a96"
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
