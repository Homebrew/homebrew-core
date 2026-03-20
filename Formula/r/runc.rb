class Runc < Formula
  desc "CLI tool for spawning and running containers according to the OCI specification"
  homepage "https://github.com/opencontainers/runc"
  url "https://github.com/opencontainers/runc/releases/download/v1.4.1/runc.tar.xz"
  sha256 "9772626f44a7b94e1da98355ec2e0fa37d6b600951ed890716f93d77d1e806c8"
  license "Apache-2.0"
  head "https://github.com/opencontainers/runc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "b623db23f0619d16bec5e640563e3588e1fff902f903e3cfa76682a99b0d606c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b5b40ad1737c4783f42903deb1bd6f3f2bb2c1461f3315546a33c229e511197f"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build
  depends_on "pkgconf" => :build
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
