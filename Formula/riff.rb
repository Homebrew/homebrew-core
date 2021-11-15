require "open3"

class Riff < Formula
  desc "Function As A Service on top of Kubernetes, riff is for functions"
  homepage "https://www.projectriff.io/"
  url "https://github.com/projectriff/cli.git",
      tag:      "v0.5.0",
      revision: "f96cf2f5ca6fddfaf4716c0045f5f142da2d3828"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31e1ab57aad8692a70b9440026597d9ea4b7a630f7819b4e74646055595c8630"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4d5d17c7380e89458c9ec704455ad6c3fdeb77ac9f617bbed3124081fbe56021"
    sha256 cellar: :any_skip_relocation, monterey:       "04af3eae2f4fef3806cadb21764638fe72cef2628f4260f28640ef73e4815da7"
    sha256 cellar: :any_skip_relocation, big_sur:        "c9311c903c7ea70a426435993d2756bb8d75a4d230db6be486f7a7d141a73427"
    sha256 cellar: :any_skip_relocation, catalina:       "cb64974514f8c764d7479cce8f92cd0a2cbc940e96300b823c684f4752d5b734"
    sha256 cellar: :any_skip_relocation, mojave:         "dd08e62ae58c92239ea1c321b7a3eda01b83912660f2769291cb0443fd128f9d"
    sha256 cellar: :any_skip_relocation, high_sierra:    "06f5da9420de8bf9aac4a16f93effeb2e3ceb83fedc44a5d1c375a2a6f9f52a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5556cf3db55be3101150a75d23d26b7ca675bae354bfb2f0024664cc9ad5ce51"
  end

  deprecate! date: "2021-03-15", because: :repo_archived

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    cd buildpath do
      system "make", "build"
      bin.install "riff"
    end
  end

  test do
    stdout, stderr, status = Open3.capture3("#{bin}/riff --kube-config not-a-kube-config-file doctor")

    assert_equal false, status.success?
    assert_equal "", stdout
    assert_match "panic: stat not-a-kube-config-file: no such file or directory", stderr
  end
end
