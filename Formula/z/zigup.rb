class Zigup < Formula
  desc "Download and manage zig compilers"
  homepage "https://github.com/marler8997/zigup"
  url "https://github.com/marler8997/zigup/archive/refs/tags/v2025_05_24.tar.gz"
  sha256 "d88e6d9c9629c88aba78c3bae2fb89ae4bea11f2818911f6d5559e7e79bcae69"
  license "MIT-0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16c4178d9b12aa6c296b91ad53873f04fb3ff1268ddde646680d0a73138c1e44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a07d469fe63e935bff6bbe5502525da60bb68c5e868384a0e85faa44dd006781"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cc1d0f528842803f809f7a0e839c9dfcd5147deb7e4e6def2e4fc1b95fdd8fad"
    sha256 cellar: :any_skip_relocation, sonoma:        "fce4755ad806a00dfc9b9a209459ce9536546c5ec22ad4ebce90716d9c010321"
    sha256 cellar: :any_skip_relocation, ventura:       "e4f3ca166c66192939bc9c6b59ecf1d9c10a19662d8d5e532e96b5b479e3aa78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "439dd70b4af2e1dca1d755c3a724b400c717cd12b5cd20569abfea58e9d732a4"
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
