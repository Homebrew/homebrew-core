class Zf < Formula
  desc "Command-line fuzzy finder that prioritizes matches on filenames"
  homepage "https://github.com/natecraddock/zf"
  # zf requires git submodules for dependencies until the Zig package manager is able
  # to resolve pure Zig dependencies, likely in Zig version 0.11.0
  url "https://github.com/natecraddock/zf.git",
      tag:      "0.8.0",
      revision: "fb66faf9258ebad06ac06c8d2a597b869b72069b"
  license "MIT"
  head "https://github.com/natecraddock/zf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d11d9cff78d3a81fbbe7a00ad8b34404fa9fe34d0a1b0de95acbafcadd317e49"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0632872a8071acbb0a871127e5670fdeeb291d0dabd82efc710f44db95468c9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b03d8f5d14817261ab62c6e3b4d249b458b95bf0302b0261b89ead8a5dbe9f70"
    sha256 cellar: :any_skip_relocation, ventura:        "47beecf5ed2ec41755793faa0f21978e2a58c70882c9a9fe06a466212c8774a3"
    sha256 cellar: :any_skip_relocation, monterey:       "cdf06efa5bdd69792d85932fd97c97360df9e047f7b792b30b30e1dbbba6bace"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a36ff7fbfadb81b615c4c6f01b4e2f7b49e59232d3ac7638e8f9f26774b9eb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fa3eebc130eefb44d09000fe7f7f908bd0d0b38a111775db98e8329ef80527c"
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
