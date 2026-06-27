class Runc < Formula
  desc "CLI tool for spawning and running containers according to the OCI specification"
  homepage "https://github.com/opencontainers/runc"
  url "https://github.com/opencontainers/runc/releases/download/v1.5.0/runc-1.5.0.tar.xz"
  sha256 "12a3c1c97483e105d7b9bfe9c9e7186c94c9dec59b820a6c31934f522f2557cb"
  license "Apache-2.0"
  head "https://github.com/opencontainers/runc.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_linux:  "0e73a2c47dc91563d76d57372a774bd9b8ffa46f428b72ac1e416dce1cf36d64"
    sha256 cellar: :any, x86_64_linux: "aa378bd3b68e139355dabd79f98366fbfa3effbe5097fd2d1a1438869507662a"
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
