class Spack < Formula
  desc "Package manager that builds multiple versions and configurations of software"
  homepage "https://spack.io"
  url "https://github.com/spack/spack/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "ed39d08bc295571cdec23a4566cbd8aa7ef4ebd582013d43874471a2b1257bf5"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/spack/spack.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c0e8b50cec114b263a4b2afecdfd0157cb667fd78388fcec44eed4a5deeafc98"
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
