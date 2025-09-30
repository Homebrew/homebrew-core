class Tundra < Formula
  desc "Code build system that tries to be fast for incremental builds"
  homepage "https://github.com/deplinenoise/tundra"
  url "https://github.com/deplinenoise/tundra/archive/refs/tags/v2.17.1.tar.gz"
  sha256 "8cc16bf466b1006b089c132e46373fa651ed9fc5ef60d147a5af689f40686396"
  license "MIT"

  # Upstream has tagged some versions without creating a GitHub release, so we
  # have to check GitHub releases until we can correctly identify the latest
  # version from the Git tags. However, the latest release on GitHub is simply
  # "latest" instead of a version, so we have to use the `GithubReleases`
  # strategy until `GithubLatest` works again.
  livecheck do
    url :stable
    strategy :github_releases
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e1bb8df7048132f46b74c03364a0b546e27f608eb9868ddfe780678001ab5b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b2b5072ea820f8d6c1d44cad48800a2e1df21bf2591587016627e8a945a460f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b3926c1298ab41348fd6ac3a6a1f50b7418a3651c8d8ce36a4fd17c58d7287a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4de7c173c546e24d82c32c49cdd38a6c5b171f31e265b60c31754688a6597fde"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f50ea8f6274c56342341da47ba040fbbca36e7f3985c85754f22c22cf46ed5c"
    sha256 cellar: :any_skip_relocation, ventura:       "b7d16f6a49ea3f46004c2bd81f06db5b1bd3e61a623c7f74d32ccf0956e0bd7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "498d5c53b38c42f02714f86ad03052b2a901189cb92e0731c5ba7074488e1cca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fad1cea39ec00029ac59d256942a16e6e1d7fca077ad817e312257335bf32858"
  end

  depends_on "googletest" => :build

  def install
    ENV.append "CFLAGS", "-I#{Formula["googletest"].opt_include}/googletest/googletest"
    inreplace "Makefile", "c++11", "c++17"

    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~'C'
      #include <stdio.h>
      int main() {
        printf("Hello World\n");
        return 0;
      }
    C

    os, cc = if OS.mac?
      ["macosx", "clang"]
    else
      ["linux", "gcc"]
    end

    (testpath/"tundra.lua").write <<~LUA
      Build {
        Units = function()
          local test = Program {
            Name = "test",
            Sources = { "test.c" },
          }
          Default(test)
        end,
        Configs = {
          {
            Name = "#{os}-#{cc}",
            DefaultOnHost = "#{os}",
            Tools = { "#{cc}" },
          },
        },
      }
    LUA
    system bin/"tundra2"
    system "./t2-output/#{os}-#{cc}-debug-default/test"
  end
end
