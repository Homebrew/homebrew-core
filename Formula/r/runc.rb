class Runc < Formula
  desc "CLI tool for spawning and running containers according to the OCI specification"
  homepage "https://github.com/opencontainers/runc"
  url "https://github.com/opencontainers/runc/releases/download/v1.5.1/runc-1.5.1.tar.xz"
  sha256 "db743b39fd7de8da88adce5a61a54529a494928cd59227fffb622f5cb4ba6ef9"
  license "Apache-2.0"
  head "https://github.com/opencontainers/runc.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_linux:  "ccd6721a4423a730165676eaebe6a398ceca37d182728dbbbeebdad8bda309d9"
    sha256 cellar: :any, x86_64_linux: "e400d154e3cff5ed439860ae797a30c85c0f5e45b2b499c0ff20801b85203f2b"
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
