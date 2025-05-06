class Zigup < Formula
  desc "Download and manage zig compilers"
  homepage "https://github.com/marler8997/zigup"
  url "https://github.com/marler8997/zigup/archive/refs/tags/v2025_04_20.tar.gz"
  sha256 "3fabc75f05c7a80a9a19f7d79f3529c208db6303ffd1b3b0328e070fc6703654"
  license "MIT-0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fbbb4b50999dc78dca0c38195270ccb205272e8d24a47aa342faadf4caa758a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa86de4771e1e9b782f74c005c404d1b41eb423b894f52fb0317e67b05bf30e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b8f8dd7eefb7342b1def1656f3c6380abb91b8b4e1f469118a58a43a1b837aee"
    sha256 cellar: :any_skip_relocation, sonoma:        "8edbdf7b144575c359e1ba382cd17aa67427d370be0a62a56b6f993cec99dada"
    sha256 cellar: :any_skip_relocation, ventura:       "ce938b80961b25a3fd6833330bccebdf013ccd82986caae1542e13c6c2d3c79f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96cd73a58e60d4f12db26151a139a00c81fd10166905c0bf2f5e065211b8ae0b"
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
      --summary all
      -fno-rosetta
    ]
    args << "-Dcpu=#{cpu}" if build.bottle?
    system "zig", "build", *args
  end

  test do
    system bin/"zigup", "fetch-index"
    assert_match "install directory", shell_output("#{bin}/zigup list 2>&1")
  end
end
