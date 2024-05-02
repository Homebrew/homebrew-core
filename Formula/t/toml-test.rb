class TomlTest < Formula
  desc "Language agnostic test suite for TOML parsers"
  homepage "https://github.com/burntsushi/toml-test"
  url "https://github.com/BurntSushi/toml-test/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "3717163777494016243a47261500bbbed6a59c89e232f9f969b3dd849c12db63"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8038b7561bc45ff83022330c7933e11b5d634e0b8152654a134daf8dfd74c1f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8038b7561bc45ff83022330c7933e11b5d634e0b8152654a134daf8dfd74c1f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8038b7561bc45ff83022330c7933e11b5d634e0b8152654a134daf8dfd74c1f2"
    sha256 cellar: :any_skip_relocation, sonoma:         "4a1f31af0b426f36346bcf01973e27772000292947041e4f9e573cec38c9587b"
    sha256 cellar: :any_skip_relocation, ventura:        "4a1f31af0b426f36346bcf01973e27772000292947041e4f9e573cec38c9587b"
    sha256 cellar: :any_skip_relocation, monterey:       "4a1f31af0b426f36346bcf01973e27772000292947041e4f9e573cec38c9587b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80903b80656360a49fa248bcfeb0d8331ae791646d75f7d2d2b553a532c52e94"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/toml-test"
    pkgshare.install "tests"
  end

  test do
    system bin/"toml-test", "-version"
    system bin/"toml-test", "-help"
    (testpath/"stub-decoder").write <<~EOS
      #!/bin/sh
      cat #{pkgshare}/tests/valid/example.json
    EOS
    chmod 0755, testpath/"stub-decoder"
    system bin/"toml-test", "-testdir", pkgshare/"tests",
                            "-run", "valid/example*",
                            "--", testpath/"stub-decoder"
  end
end
