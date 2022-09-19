class TomlTest < Formula
  desc "Language agnostic test suite for TOML parsers"
  homepage "https://github.com/burntsushi/toml-test"
  url "https://github.com/BurntSushi/toml-test/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "33bf4e9c017cd57f3602e72d17f75fb5a7bcc7942541c84f1d98b74c12499846"
  license "MIT"

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
