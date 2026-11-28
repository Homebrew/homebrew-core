class Rasusa < Formula
  desc "Randomly subsample sequencing reads or alignments"
  homepage "https://doi.org/10.21105/joss.03941"
  url "https://github.com/mbhall88/rasusa/archive/refs/tags/5.1.1.tar.gz"
  sha256 "c9674624e2a24af5924b55709969e761e2b6abb43fe8cf45abfd40d693b65c26"
  license "MIT"
  head "https://github.com/mbhall88/rasusa.git", branch: "main"

  bottle do
    manifest_sha256 "4738d8e82e4085049b03fc321d3ed66bf95f1b15b2a87f31b52d6d97d4852426"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "22c0d94b4a865a2740999e419347f2843c2af59de20329a31fb56e85a7ece02c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "59de844a17e1fa34cf2ad206f62d88cc87741ada720c9088802359ade2e0466a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0d4bc304786eb86795653ec0b680a599b13e6fa42b2c727e799f64b9b084a8c0"
    sha256 cellar: :any,                 arm64_linux:       "01ad876143c7c6be1b816bdfda3accb23e0ded8dabfb8059aa2e3dfe4a028818"
    sha256 cellar: :any,                 x86_64_linux:      "ab7eff2c93a5f7c647f04ed42e6057776fdcf4d5aec9191d470f6d6d9c2ec675"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    pkgshare.install "tests/cases"
  end

  test do
    cp_r pkgshare/"cases/.", testpath
    system bin/"rasusa", "reads", "-n", "5m", "-o", "out.fq", "file1.fq.gz"
    assert_path_exists "out.fq"
  end
end
