class Zf < Formula
  desc "Command-line fuzzy finder that prioritizes matches on filenames"
  homepage "https://github.com/natecraddock/zf"
  # zf requires git submodules for dependencies until the Zig package manager is able
  # to resolve pure Zig dependencies, likely in Zig version 0.11.0
  url "https://github.com/natecraddock/zf.git",
      tag:      "0.7.0",
      revision: "2999185c7f8a5bf1ffffadb57498a603d8fd582d"
  license "MIT"
  head "https://github.com/natecraddock/zf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7278b238e8e38906bdeabfbce7214006f84b8a29b9c678c26f4f2365f17bdd60"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72620d95127c63275cccf7de501f1924da4b667db4e04c7d1a06cafc6c243bda"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "70d3e0ccebed851eea89ee44294594b0ca7080e0fb8a925d6cb88395b2b12417"
    sha256 cellar: :any_skip_relocation, ventura:        "0791312fd2e627237401569a256bf7373cba4aeec6bda8bcfe7477d310dffd56"
    sha256 cellar: :any_skip_relocation, monterey:       "13ea8aca1b4b47971c5a5aebaad08cabe38da86380e41c4b993ab2448a302408"
    sha256 cellar: :any_skip_relocation, big_sur:        "133b1ce82d92865e044ddf43edb3a3a896ce0c565bff95588be938f54b910454"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1311f35bc50e40822f8352938daac626a930fa188f0036e3975585f775b5d2a5"
  end

  depends_on "zig" => :build

  def install
    system "zig", "build", "-Drelease-fast=true"

    bin.install "zig-out/bin/zf"
    man1.install "doc/zf.1"
    bash_completion.install "complete/zf"
    fish_completion.install "complete/zf.fish"
    zsh_completion.install "complete/_zf"
  end

  test do
    assert_equal "zig", pipe_output("#{bin}/zf -f zg", "take\off\every\nzig").chomp
  end
end
