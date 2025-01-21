class Senpai < Formula
  desc "Modern terminal IRC client"
  homepage "https://sr.ht/~delthas/senpai/"
  url "https://git.sr.ht/~delthas/senpai/archive/v0.3.0.tar.gz"
  sha256 "c02f63a7d76ae13ed888fc0de17fa9fd5117dcb3c9edc5670341bf2bf3b88718"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "6a78d94af426d9f72498b278f3669f95cfa6ac2820acd5f27ef70b21a6419b63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2bb02acb8e2a7f36313a9f0fcb3ee751896e569ee419ebcbf7ca544fb3890245"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3fa5c2f51f224cf6d7b50d46a6bc0138779df6893e9bfe99d058605e568904e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59ec7f2e76e79c6273cbab8849b59fe974c4fa161588f0d7aeff0e87efe06acc"
    sha256 cellar: :any_skip_relocation, sonoma:         "8d7dfde2fc46bc11d12f35b5f16c295ccc0f4f58cc2959a35cfd099323d377db"
    sha256 cellar: :any_skip_relocation, ventura:        "60da283f516d23cb7752e82eeb861b05b548728c194f029ca3e7a0c6707b1be4"
    sha256 cellar: :any_skip_relocation, monterey:       "372de45ab8f3bcf13994d5d73f381db02c51ba0f6f275035b4f458d722e7d681"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "815157688d27a419ebfc8b987ecdb654a68399b3774ec3063925bbbe6d386c79"
  end

  depends_on "go" => :build
  depends_on "scdoc" => :build

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    require "pty"

    stdout, _stdin, _pid = PTY.spawn bin/"senpai"
    _ = stdout.readline
    assert_equal "Configuration assistant: senpai will create a configuration file for you.\r\n", stdout.readline
  end
end
