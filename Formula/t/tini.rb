class Tini < Formula
  desc "Tiny but valid init for containers"
  homepage "https://github.com/krallin/tini"
  url "https://github.com/krallin/tini/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "0fd35a7030052acd9f58948d1d900fe1e432ee37103c5561554408bdac6bbf0d"
  license "MIT"
  head "https://github.com/krallin/tini.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "98e1acab93b214ac0868c19198d76251a733e0e9fe6bb7f5ed8b233eb2a84bd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9ca9b3fab3fee8f2083f628d7efd73899455e873d6dd2e25dc87f1dc27c8581e"
  end

  depends_on "cmake" => :build
  depends_on :linux

  def install
    args = if build.stable? && version > "0.19.0"
      odie "Remove CMake compatibility workaround"
    else
      # https://github.com/krallin/tini/pull/233
      ["-DCMAKE_POLICY_VERSION_MINIMUM=3.5"]
    end
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    # docker-engine uses docker-init for `docker run --init`.
    # The binary has to be strictly static, as it is mounted inside a container.
    bin.install_symlink "tini-static" => "docker-init"
  end

  test do
    # Verify the version
    assert_match version.to_s, shell_output("#{bin}/tini --version")
    # Verify tini spawns a child and captures its output
    assert_equal "hello\n", shell_output("#{bin}/tini -- echo hello")
    # Verify tini forwards a non-zero exit code from the child
    shell_output("#{bin}/tini -- false", 1)
    # Verify tini-static (used as docker-init) also works
    assert_equal "hello\n", shell_output("#{bin}/tini-static -- echo hello")
  end
end
