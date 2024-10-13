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

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "16c372c08c2e4af836b3fe1049d1403cc956063a54fb4b90771fe4f3ecdacfc1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "97e3dbdb0bb7c8637549458c91cb09054fd13968ef65afbbb0f3e082adba7d08"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4d9f2cd1374c20ef1da7e252042d44e65b5ad84c5c91c6e6cac714a583725f58"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0953e51bb22a0616db2bc8ad0cc1bd6f61b316b16ff7e5381c46f37ec4023d94"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a182719c47859df3ee2fab4e95532cc80f8fc7e709d20abf923351c688d23f3a"
    sha256 cellar: :any_skip_relocation, sonoma:         "c5300da7c39ff7ae2738c8e4d151457b41b794eeb6d423afe5ae7635a4eb0a68"
    sha256 cellar: :any_skip_relocation, ventura:        "fef8b9004f15f9d78de74bad24584c2d23689f4ba570d67ae672cb564a9f66bd"
    sha256 cellar: :any_skip_relocation, monterey:       "87fe83996c49084606a9cc2d2e7d337a3f23b15be64ce1f9aadba477d666ea6d"
    sha256 cellar: :any_skip_relocation, big_sur:        "53b654296a0c03b4b7f2280c068071ce9727fb788840534d1e66abfb041ba8a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d6d953026b3e555729ca74533db71a97dc60dfd56d89d185070051d321916ee"
  end

  depends_on "googletest" => :build

  def install
    ENV.append "CFLAGS", "-I#{Formula["googletest"].opt_include}/googletest/googletest"
    inreplace "Makefile", "c++11", "c++17"

    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~'EOS'
      #include <stdio.h>
      int main() {
        printf("Hello World\n");
        return 0;
      }
    EOS

    os, cc = if OS.mac?
      ["macosx", "clang"]
    else
      ["linux", "gcc"]
    end

    (testpath/"tundra.lua").write <<~EOS
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
    EOS
    system bin/"tundra2"
    system "./t2-output/#{os}-#{cc}-debug-default/test"
  end
end
