class TomlTest < Formula
  desc "Language agnostic test suite for TOML parsers"
  homepage "https://github.com/toml-lang/toml-test"
  url "https://github.com/toml-lang/toml-test/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "fdab2779b3902eb08030f389a5d53e95c5b49404149ac6f2eda5227a5363c232"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7af4042ad74ce2aea27d3ca24b0dba2519f2a74ace4549addf0bd502afec023c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7af4042ad74ce2aea27d3ca24b0dba2519f2a74ace4549addf0bd502afec023c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7af4042ad74ce2aea27d3ca24b0dba2519f2a74ace4549addf0bd502afec023c"
    sha256 cellar: :any_skip_relocation, sonoma:        "99d22c7090692bb2f4995dd2a64fdbe5118a8a9ddfd18cb3cc3c6e8a8947d4e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65cc6f41d6a823a30cf3b6c9712a69d5703b127775d92b766f0d0b388edb2adf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e496138f50bc24d70d70ae3f5acca3bf36fb7604f27296d9b3e293aac529470"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/toml-test"
    pkgshare.install "tests"
  end

  test do
    system bin/"toml-test", "version"
    system bin/"toml-test", "help"

    (testpath/"stub-decoder").write <<~SH
      #!/bin/sh
      cat #{pkgshare}/tests/valid/example.json
    SH

    chmod 0755, testpath/"stub-decoder"
    system bin/"toml-test", "test", "-decoder", testpath/"stub-decoder", "-run", "valid/example*"
  end
end
