class Spack < Formula
  desc "Package manager that builds multiple versions and configurations of software"
  homepage "https://spack.io"
  url "https://github.com/spack/spack/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "a0160ae5e84adc81ac7832562a65ad79053d5c135996815dbb0d2eee6b2fca1c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/spack/spack.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5b9d292cf251fbbd0995691c36c9771913a67cc80647bd94dd95ceb94e49bea9"
  end

  uses_from_macos "python"

  skip_clean "var/spack/junit-report"

  def install
    # Remove Windows files
    rm Dir["bin/*.bat", "bin/*.ps1", "bin/haspywin.py"]
    # Build an `:all` bottle by removing test files
    rm_r "lib/spack/spack/test"

    prefix.install Dir["*"]
    (prefix/"var/spack/junit-report").mkpath
  end

  test do
    ENV["SPACK_USER_CONFIG_PATH"] = testpath
    (testpath/"config.yaml").write <<~YAML
      config:
        install_tree:
          root: #{testpath}/opt/spack
    YAML

    system bin/"spack", "--version"
    assert_match "zlib", shell_output("#{bin}/spack info zlib")
    system bin/"spack", "compiler", "find"
    expected = OS.mac? ? "clang" : "gcc"
    assert_match expected, shell_output("#{bin}/spack compiler list")
  end
end
