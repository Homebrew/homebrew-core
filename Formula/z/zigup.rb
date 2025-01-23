class Zigup < Formula
  desc "Download and manage zig compilers"
  homepage "https://github.com/marler8997/zigup"
  url "https://github.com/marler8997/zigup/archive/refs/tags/v2025_01_02.tar.gz"
  sha256 "0b92de2a3afcecbf086102733215640189d744c4a17064b7492059ac198dd7f6"
  license "MIT-0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c25f67a7e31386412f2ccb35a272bcf8336cf7847e91b7e969173c86303a60fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd61e56910342c7082eddb20243706399c7e93c0703fe52c2252322f486805f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "026867113683fd389e85e661a0bd89edc91c702131fd7ca7047353dbb1422ba7"
    sha256 cellar: :any_skip_relocation, sonoma:        "17ed54e2a73b6ceaf9819aa7a632036f4427a2abfa8c63f6117c116c51354441"
    sha256 cellar: :any_skip_relocation, ventura:       "c3750e42c79b673f322668d1ad17dfad633c3dae6dbb67491158d47c039d1213"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ca46f69d73efc8b983487dffe691a03841bf9a347e0de3d4681ab1eb31c16e4"
  end

  depends_on "zig" => :build

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case Hardware.oldest_cpu
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    else Hardware.oldest_cpu
    end

    args = %W[
      --prefix #{prefix}
      -Doptimize=ReleaseSafe
    ]

    args << "-Dcpu=#{cpu}" if build.bottle?
    system "zig", "build", *args
  end

  test do
    system bin/"zigup", "fetch-index"
    assert_match "install directory", shell_output("#{bin}/zigup list 2>&1")
  end
end
