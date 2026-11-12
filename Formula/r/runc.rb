class Runc < Formula
  desc "CLI tool for spawning and running containers according to the OCI specification"
  homepage "https://github.com/opencontainers/runc"
  url "https://github.com/opencontainers/runc/releases/download/v1.5.3/runc-1.5.3.tar.xz"
  sha256 "b46692550bfd6a6d69e15068d153446dfd401810809eecb767481fba90561b59"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/opencontainers/runc.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_linux:  "f370734f0cf708c1b5054172ede921028533113058ed0458641e613b290a1f3c"
    sha256 cellar: :any, x86_64_linux: "797f36ef3d314f879d8fb837cca98d7bf452ff69a3f22b04e464c53409fc9f95"
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
