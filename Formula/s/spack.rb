class Spack < Formula
  desc "Package manager that builds multiple versions and configurations of software"
  homepage "https://spack.io"
  url "https://github.com/spack/spack/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "518474f546e87723c43b80143d83a51c065a8d54333c8140da6f48bc7d9e50c1"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/spack/spack.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8c8c171fcc01b16779749d9b5e3f664bf56435a8f63f4eb51486f8df62ea8a6b"
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
