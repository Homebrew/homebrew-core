class Runc < Formula
  desc "CLI tool for spawning and running containers according to the OCI specification"
  homepage "https://github.com/opencontainers/runc"
  url "https://github.com/opencontainers/runc/releases/download/v1.6.0/runc-1.6.0.tar.xz"
  sha256 "c83a737790643178e9c758df18fa5f92aa5678b210bbc148f3ebd32fbacf8e48"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/opencontainers/runc.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "c031930e71880abb06faa00e88d6115fe647d0a536abf452e45a1773b51a607f"
    sha256 cellar: :any, arm64_linux:  "be5cd92eac812d6aae25109193ef42eda3a00c9a8ae58e7a3a7f39662a71ca0f"
    sha256 cellar: :any, x86_64_linux: "e3b1b7015793a40956ff83f5bcf849a7564b3e4d0aa84af6fd994bb45e18cc00"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build
  depends_on "pkgconf" => :build
  depends_on "libpathrs"
  depends_on "libseccomp"
  depends_on :linux

  def install
    ENV.O0 # https://github.com/Homebrew/brew/issues/14763
    system "make"
    system "make", "install", "install-man", "PREFIX=#{prefix}"
    bash_completion.install "contrib/completions/bash/runc"
  end

  test do
    system sbin/"runc", "spec", "--bundle", testpath
    assert_path_exists testpath/"config.json"
  end
end
