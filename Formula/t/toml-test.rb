class TomlTest < Formula
  desc "Language agnostic test suite for TOML parsers"
  homepage "https://github.com/toml-lang/toml-test"
  url "https://github.com/toml-lang/toml-test/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "79ee1f9edef786e28cc54504179672071dbc7bad24d73348e8e7d7e766068abc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d0f52af8f042c94662189576a844d1f8d5d5e238609afac58b4061f4007e1f66"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41dedc807934ac3a07fec76dfd5b281ce8545e7c53b2ce4820578840d78710b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41dedc807934ac3a07fec76dfd5b281ce8545e7c53b2ce4820578840d78710b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "41dedc807934ac3a07fec76dfd5b281ce8545e7c53b2ce4820578840d78710b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9b3b7fce7698c7e0f0302fefa8e243ab1592b879c4cbb910ab32716ae5dde20"
    sha256 cellar: :any_skip_relocation, ventura:       "f9b3b7fce7698c7e0f0302fefa8e243ab1592b879c4cbb910ab32716ae5dde20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00ce205eb7bca140cb56d9fdddfcab657890587bf0f63bd48c78e433634df458"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa6601c9403bb864f502aa08e3df84a74688d6033a2c56f6dcbc6dc1a7c3d040"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/toml-test"
    pkgshare.install "tests"
  end

  test do
    system bin/"toml-test", "-version"
    system bin/"toml-test", "-help"
    (testpath/"stub-decoder").write <<~SH
      #!/bin/sh
      cat #{pkgshare}/tests/valid/example.json
    SH
    chmod 0755, testpath/"stub-decoder"
    system bin/"toml-test", "-testdir", pkgshare/"tests",
                            "-run", "valid/example*",
                            "--", testpath/"stub-decoder"
  end
end
